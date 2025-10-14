library ieee;
use ieee.std_logic_1164.all;

entity sumador_restador_4b_tb is
end sumador_restador_4b_tb;

architecture sumador_restador_4b_tb_arch of sumador_restador_4b_tb is

  signal sr_in  : std_logic                    := '1';
  signal a_in   : std_logic_vector(3 downto 0) := "0101";
  signal b_in   : std_logic_vector(3 downto 0) := "0011";
  signal ci_in  : std_logic                    := '1';
  signal s_out  : std_logic_vector(3 downto 0);
  signal co_out : std_logic;

begin
  sumador_restador_4b_inst : entity work.sumador_restador_4b
    port map
    (
      sr_in  => sr_in,
      a_in   => a_in,
      b_in   => b_in,
      ci_in  => ci_in,
      s_out  => s_out,
      co_out => co_out
    );

end architecture;