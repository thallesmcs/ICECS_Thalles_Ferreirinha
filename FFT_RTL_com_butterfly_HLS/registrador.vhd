library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador is
generic ( WIDTH: integer := 16 );
  port (
    clk   : in  std_logic;
    limpa : in  std_logic;
    D     : in  std_logic_vector( WIDTH-1 downto 0);
    Q     : out std_logic_vector( WIDTH-1 downto 0)
  );
end entity;

architecture reg of registrador is
begin
  process(clk, limpa)
  begin
    if limpa = '0' then
      Q <= (others => '0');
    elsif rising_edge(clk) then
      Q <= D;
    end if;
  end process;
end architecture;
