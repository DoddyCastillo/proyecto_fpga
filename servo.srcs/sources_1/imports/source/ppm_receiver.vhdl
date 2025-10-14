library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ppm_receiver is
    Port (
        clk        : in  std_logic;   -- 100 MHz system clock
        rst        : in  std_logic;
        ppm_in     : in  std_logic;   -- señal PPM de entrada
        servo_out  : out std_logic    -- señal PWM de salida (1-2 ms)
    );
end ppm_receiver;

architecture Behavioral of ppm_receiver is
    -------------------------------------------------------------------------
    -- Constantes
    -------------------------------------------------------------------------
    constant US_TICKS     : integer := 100;      -- 1 µs = 100 ciclos (a 100 MHz)
    constant FRAME_PERIOD : integer := 20000;    -- 20 ms = 50 Hz
    constant MIN_PULSE    : integer := 1000;     -- 1.0 ms
    constant MAX_PULSE    : integer := 2000;     -- 2.0 ms
    constant OFFSET_CORR  : integer := 300;      -- corrección de retardo (~300 µs)

    -------------------------------------------------------------------------
    -- Señales internas
    -------------------------------------------------------------------------
    signal clk_div      : integer range 0 to US_TICKS-1 := 0;
    signal tick_1us     : std_logic := '0';
    signal ppm_sync     : std_logic_vector(2 downto 0) := (others => '0');
    signal counter_us   : integer range 0 to FRAME_PERIOD := 0;
    signal pulse_pwm_us : integer range MIN_PULSE to MAX_PULSE := 1500;

    -- PWM generator
    signal pwm_cnt_us   : integer range 0 to FRAME_PERIOD := 0;
    signal servo_sig    : std_logic := '0';
begin
    -------------------------------------------------------------------------
    -- Divisor: genera tick de 1 µs a partir de 100 MHz
    -------------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if clk_div = US_TICKS-1 then
                clk_div  <= 0;
                tick_1us <= '1';
            else
                clk_div  <= clk_div + 1;
                tick_1us <= '0';
            end if;
        end if;
    end process;

    -------------------------------------------------------------------------
    -- Detección del pulso PPM y medición de su posición dentro del frame
    -------------------------------------------------------------------------
    process(clk)
        variable corrected_us : integer;
    begin
        if rising_edge(clk) then
            ppm_sync <= ppm_sync(1 downto 0) & ppm_in;

            if rst = '1' then
                counter_us   <= 0;
                pulse_pwm_us <= 1500;

            else
                -- Contador de microsegundos del frame
                if tick_1us = '1' then
                    counter_us <= counter_us + 1;
                    if counter_us >= FRAME_PERIOD then
                        counter_us <= 0;
                    end if;
                end if;

                -- Flanco ascendente detectado (inicio del pulso PPM)
                if (ppm_sync(2) = '1' and ppm_sync(1) = '0') then
                    -- Compensar el retardo del pulso (?300 µs)
                    corrected_us := counter_us - OFFSET_CORR;

                    -- Limitar a rango válido
                    if corrected_us < MIN_PULSE then
                        pulse_pwm_us <= MIN_PULSE;
                    elsif corrected_us > MAX_PULSE then
                        pulse_pwm_us <= MAX_PULSE;
                    else
                        pulse_pwm_us <= corrected_us;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -------------------------------------------------------------------------
    -- Generador PWM (50 Hz) basado en el valor medido
    -------------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                pwm_cnt_us <= 0;
                servo_sig  <= '0';
            elsif tick_1us = '1' then
                if pwm_cnt_us = FRAME_PERIOD then
                    pwm_cnt_us <= 0;
                else
                    pwm_cnt_us <= pwm_cnt_us + 1;
                end if;

                if pwm_cnt_us < pulse_pwm_us then
                    servo_sig <= '1';
                else
                    servo_sig <= '0';
                end if;
            end if;
        end if;
    end process;

    servo_out <= servo_sig;

end Behavioral;