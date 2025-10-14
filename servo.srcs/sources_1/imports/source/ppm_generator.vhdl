library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ppm_generator is
  Port (
    clk      : in  std_logic;  -- 100 MHz
    rst      : in  std_logic;
    sw       : in  std_logic_vector(1 downto 0);
    ppm_out  : out std_logic
  );
end ppm_generator;

architecture Behavioral of ppm_generator is
  constant US_TICKS     : integer := 100;     -- 1 µs = 100 ciclos (a 100 MHz)
  constant FRAME_PERIOD : integer := 20000;   -- 20 ms (50 Hz)
  constant PULSE_WIDTH  : integer := 300;     -- 300 µs

  signal clk_cnt  : integer range 0 to US_TICKS-1 := 0;
  signal us_cnt   : integer range 0 to FRAME_PERIOD := 0;
  signal pos_us   : integer range 1000 to 2000 := 1500;
  signal ppm_sig  : std_logic := '0';
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        clk_cnt <= 0;
        us_cnt  <= 0;
        pos_us  <= 1500;
        ppm_sig <= '0';
      else
        ---------------------------------------------------------------------
        -- Mapeo directo del switch a la posición, con impresión de depuración
        ---------------------------------------------------------------------
        case sw is
          when "01" => pos_us <= 1000;
          when "10" => pos_us <= 2000;
          when others => pos_us <= 1500;
        end case;

        -- Mensaje de depuración (solo simulación)

        ---------------------------------------------------------------------
        -- Divisor 100 MHz ? 1 MHz (1 µs tick)
        ---------------------------------------------------------------------
        if clk_cnt = US_TICKS-1 then
          clk_cnt <= 0;

          if us_cnt = FRAME_PERIOD then
            us_cnt <= 0;
          else
            us_cnt <= us_cnt + 1;
          end if;

          -------------------------------------------------------------------
          -- Pulso corto de 300 µs desplazado según pos_us
          -------------------------------------------------------------------
          if (us_cnt >= pos_us) and (us_cnt < pos_us + PULSE_WIDTH) then
            ppm_sig <= '1';
          else
            ppm_sig <= '0';
          end if;

        else
          clk_cnt <= clk_cnt + 1;
        end if;
      end if;
    end if;
  end process;

  ppm_out <= ppm_sig;
end Behavioral;