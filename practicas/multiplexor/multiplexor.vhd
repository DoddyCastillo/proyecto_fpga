library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexor is
	port(
		p0: in STD_LOGIC;
		p1: in STD_LOGIC;
		sel: in STD_LOGIC;
		ps: out STD_LOGIC
	);
end multiplexor;

architecture multiplexor_arq of multiplexor is
begin 
	ps <= (p0 and (not sel)) or (p1 and sel);
end multiplexor_arq;