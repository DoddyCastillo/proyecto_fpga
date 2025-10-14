library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ppm_servo is
  Port (
    CLK100MHZ : in  std_logic;
    SW        : in  std_logic_vector(1 downto 0);
    SERVO_OUT : out std_logic;
    PPM_OUT   : out std_logic
  );
end ppm_servo;

architecture Behavioral of ppm_servo is
  signal ppm_sig : std_logic := '0';
  signal rst     : std_logic := '0';
begin
  -- Generador PPM
  GEN: entity work.ppm_generator
    port map (
      clk     => CLK100MHZ,
      rst     => rst,
      sw      => SW,          -- usa directamente el puerto externo
      ppm_out => ppm_sig
    );

  -- Receptor PPM ? PWM
  RX: entity work.ppm_receiver
    port map (
      clk        => CLK100MHZ,
      rst        => rst,
      ppm_in     => ppm_sig,
      servo_out     => SERVO_OUT
    );
    PPM_OUT <= ppm_sig;
end Behavioral;