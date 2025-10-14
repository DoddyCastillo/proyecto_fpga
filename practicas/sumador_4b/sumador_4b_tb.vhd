library ieee;
use ieee.std_logic_1164.all;

entity sumador_4b_tb is
end sumador_4b_tb;

architecture sumador_4b_tb_arch of sumador_4b_tb is

  signal a_tb  : std_logic_vector(3 downto 0) := "0011";
  signal b_tb  : std_logic_vector(3 downto 0) := "0101";
  signal ci_tb : std_logic                    := '0';
  signal s_tb  : std_logic_vector(3 downto 0);
  signal co_tb : std_logic;

begin
  sumador_4b_inst : entity work.sumador_4b
    port map
    (
      a_in   => a_tb,
      b_in   => b_tb,
      ci_in  => ci_tb,
      s_out  => s_tb,
      co_out => co_tb
    );

end architecture;