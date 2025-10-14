library ieee;
use ieee.std_logic_1164.all;

entity sumador_1b is
  port (
    a_in   : in std_logic;
    b_in   : in std_logic;
    ci_in  : in std_logic;
    s_out  : out std_logic;
    co_out : out std_logic
  );
end entity;

architecture behavior of sumador_1b is
begin
  s_out  <= a_in xor b_in xor ci_in;
  co_out <= (a_in and b_in) or (ci_in and (a_in xor b_in));

end;
