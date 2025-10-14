library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity sumador_4b is
  port (
    a_in   : in std_logic_vector(3 downto 0);
    b_in   : in std_logic_vector(3 downto 0);
    ci_in  : in std_logic;
    s_out  : out std_logic_vector(3 downto 0);
    co_out : out std_logic
  );
end sumador_4b;

architecture sumador_4b_arq of sumador_4b is

  signal aux : unsigned(4 downto 0);
  component sumador_1b
    port (
      a_in   : in std_logic;
      b_in   : in std_logic;
      ci_in  : in std_logic;
      s_out  : out std_logic;
      co_out : out std_logic
    );
  end component;
begin

  sumador_4b_gen : for i in 0 to 3 generate
    u : sumador_1b
    port map
    (
      a_in   => a_in(i),
      b_in   => b_in(i),
      ci_in  => aux(i),
      s_out  => s_out(i),
      co_out => aux(i + 1)
    );
  end generate;

  aux(0) <= ci_in;
  co_out <= aux(4);

end sumador_4b_arq;