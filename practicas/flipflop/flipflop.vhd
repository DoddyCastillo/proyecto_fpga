library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flipflop is 
	port(
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		D  : in std_logic;
		Q	: out std_logic
	);
end flipflop;

architecture flipflop_arq of flipflop is
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				Q <= '0';
			elsif ena = '1' then
				Q <= D;
			end if;
		end if;
	end process;
		
end flipflop_arq;