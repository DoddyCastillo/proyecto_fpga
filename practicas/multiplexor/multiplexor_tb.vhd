library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexor_tb is
end multiplexor_tb;

architecture multiplexor_tb_arq of multiplexor_tb is
	signal p0_tb  :  STD_LOGIC;
	signal p1_tb  :  STD_LOGIC;
	signal sel_tb :  STD_LOGIC;
	signal ps_tb  :  STD_LOGIC;
begin

	p0_tb <= '1' after 100 ns, '0' after 200 ns, '1' after 300 ns, '0' after 400 ns;
	p1_tb <= '0' after 100 ns, '1' after 200 ns, '0' after 300 ns, '1' after 400 ns;
	sel_tb <= '0' after 100 ns, '1' after 200 ns;

	multiplxor_arq_inst: entity work.multiplexor
	port map(
		p0 => p0_tb,
		p1 => p1_tb,
		sel => sel_tb,
		ps => ps_tb
	);
end architecture;