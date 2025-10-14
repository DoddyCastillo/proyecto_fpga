library ieee;
use ieee.std_logic_1164.all;

entity sumador_1b_tb is
end entity;

architecture sumador_1b_tb_arq of sumador_1b_tb is
  signal a_tb  : std_logic := '0';
  signal b_tb  : std_logic := '0';
  signal ci_tb : std_logic := '0';
  signal s_tb  : std_logic;
  signal co_tb : std_logic;
begin

  a_tb  <= '1' after 100 ns, '0' after 200 ns, '1' after 300 ns, '0' after 400 ns;
  b_tb  <= '0' after 100 ns, '1' after 200 ns, '0' after 300 ns, '1' after 400 ns;
  ci_tb <= '0' after 100 ns, '0' after 200 ns;

  sumador_1b_inst : entity work.sumador_1b
    port map
    (
      a_in   => a_tb,
      b_in   => b_tb,
      ci_in  => ci_tb,
      s_out  => s_tb,
      co_out => co_tb
    );

end architecture;
