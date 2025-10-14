library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity sumador_restador_4b is
  port (
    sr_in  : in std_logic;
    a_in   : in std_logic_vector(3 downto 0);
    b_in   : in std_logic_vector(3 downto 0);
    ci_in  : in std_logic;
    s_out  : out std_logic_vector(3 downto 0);
    co_out : out std_logic
  );
end entity sumador_restador_4b;

architecture sumador_restador_4b_arq of sumador_restador_4b is

  signal b_xor : std_logic_vector(3 downto 0);

  component sumador_4b
    port (
      a_in   : in std_logic_vector(3 downto 0);
      b_in   : in std_logic_vector(3 downto 0);
      ci_in  : in std_logic;
      s_out  : out std_logic_vector(3 downto 0);
      co_out : out std_logic
    );
  end component;

begin
  b_xor <= b_in xor (3 downto 0 => sr_in);
  sumador_restador_4b_gen : sumador_4b
  port map
  (
    a_in   => a_in,
    b_in   => b_xor,
    ci_in  => sr_in,
    s_out  => s_out,
    co_out => co_out
  );

end architecture;