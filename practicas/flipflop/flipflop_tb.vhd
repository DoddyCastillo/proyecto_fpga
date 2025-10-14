library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flipflop_tb is 
end flipflop_tb;


architecture flipflop_tb_aqr of flipflop_tb is
	
	signal clk_tb: std_logic := '0';
	signal rst_tb: std_logic := '0';
	signal ena_tb: std_logic := '1';
	signal d_tb  : std_logic := '0';
	signal q_tb  : std_logic;
	
begin

	clk_tb <= not clk_tb after 10 ns;
	d_tb <= '1' after 60 ns, '0' after 100 ns, '1' after 145 ns;
	ena_tb <= '0' after 105 ns, '1' after 129 ns;
	rst_tb <= '1' after 155 ns;

	flipflop_inst: entity work.flipflop
		port map(
			clk => clk_tb,
			rst => rst_tb,
			ena => ena_tb,
			D  =>  d_tb,
			Q	=>  q_tb
		);

end;