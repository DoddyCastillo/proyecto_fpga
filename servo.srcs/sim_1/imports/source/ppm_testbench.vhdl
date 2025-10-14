library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ppm_servo_check_v93 is
end tb_ppm_servo_check_v93;

architecture Behavioral of tb_ppm_servo_check_v93 is
  signal CLK100MHZ : std_logic := '0';
  signal SW        : std_logic_vector(1 downto 0) := "00";
  signal SERVO_OUT : std_logic;
  signal PPM_OUT   : std_logic;

  constant CLK_PERIOD : time := 10 ns;  -- 100 MHz

  -- Función auxiliar: ns ? µs
  impure function ns_to_us(ns_val : integer) return real is
  begin
    return real(ns_val) / 1000.0;
  end function;

  ------------------------------------------------------------------
  -- Procedimiento genérico para medir y verificar pulsos del servo
  ------------------------------------------------------------------
  procedure medir(constant label_txt : string) is
    variable t_rise1, t_fall1, t_rise2 : time;
    variable high_ns, period_ns        : integer;
    variable high_us, period_us        : real;
    constant TOL_US : real := 50.0;
  begin
    -- Primer flanco ascendente
    wait until rising_edge(SERVO_OUT);
    t_rise1 := now;

    -- Flanco descendente (fin del pulso alto)
    wait until falling_edge(SERVO_OUT);
    t_fall1 := now;

    -- Siguiente flanco ascendente (inicio del siguiente período)
    wait until rising_edge(SERVO_OUT);
    t_rise2 := now;

    -- Cálculo de duraciones
    high_ns   := integer((t_fall1 - t_rise1) / 1 ns);
    period_ns := integer((t_rise2 - t_rise1) / 1 ns);

    high_us   := ns_to_us(high_ns);
    period_us := ns_to_us(period_ns);

    report label_txt & "  HIGH=" & real'image(high_us) &
           " us,  PERIOD=" & real'image(period_us) & " us";

    -- Validar periodo (~20 ms)
    assert abs(period_us - 20000.0) <= 200.0
      report "Periodo fuera de rango: " & real'image(period_us) & " us"
      severity error;

    -- Validar ancho del pulso según posición del switch
    if SW = "01" then
      assert abs(high_us - 1000.0) <= TOL_US
        report "Pulso deberia ser ~1000 us, medido=" & real'image(high_us) & " us"
        severity error;
    elsif SW = "10" then
      assert abs(high_us - 2000.0) <= TOL_US
        report "Pulso deberia ser ~2000 us, medido=" & real'image(high_us) & " us"
        severity error;
    else -- "00" o "11"
      assert abs(high_us - 1500.0) <= TOL_US
        report "Pulso deberia ser ~1500 us, medido=" & real'image(high_us) & " us"
        severity error;
    end if;
  end procedure;

begin
  ------------------------------------------------------------------
  -- Dispositivo bajo prueba: generador + receptor integrados
  ------------------------------------------------------------------
  DUT: entity work.ppm_servo
    port map (
      CLK100MHZ => CLK100MHZ,
      SW        => SW,
      SERVO_OUT => SERVO_OUT,
      PPM_OUT   => PPM_OUT
    );

  ------------------------------------------------------------------
  -- Reloj de 100 MHz
  ------------------------------------------------------------------
  clk_gen : process
  begin
    while true loop
      CLK100MHZ <= '0'; wait for CLK_PERIOD/2;
      CLK100MHZ <= '1'; wait for CLK_PERIOD/2;
    end loop;
  end process;

  ------------------------------------------------------------------
  -- Estímulos y mediciones automáticas
  ------------------------------------------------------------------
  stim : process
  begin
    wait for 5 ms;

    SW <= "00"; report "SW=00 (centro)";  medir("SW=00");
    SW <= "01"; report "SW=01 (min)";     medir("SW=01");
    SW <= "10"; report "SW=10 (max)";     medir("SW=10");
    SW <= "11"; report "SW=11 (centro)";  medir("SW=11");

    report "? Simulación OK" severity note;
    wait;
  end process;
end Behavioral;