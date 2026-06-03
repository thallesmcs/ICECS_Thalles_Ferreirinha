library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux8inputs is
generic ( WIDTH: integer := 16 );
  port (
    sel : in  std_logic_vector(2 downto 0);
    A0  : in  std_logic_vector( WIDTH-1 downto 0);
    A1  : in  std_logic_vector( WIDTH-1 downto 0);
    A2  : in  std_logic_vector( WIDTH-1 downto 0);
    A3  : in  std_logic_vector( WIDTH-1 downto 0);
    A4  : in  std_logic_vector( WIDTH-1 downto 0);
    A5  : in  std_logic_vector( WIDTH-1 downto 0);
    A6  : in  std_logic_vector( WIDTH-1 downto 0);
    A7  : in  std_logic_vector( WIDTH-1 downto 0);
    Y   : out std_logic_vector( WIDTH-1 downto 0)
  );
end entity;

architecture rtl of mux8inputs is
begin
  process(sel, A0, A1, A2, A3, A4, A5, A6, A7)
  begin
    Y <= (others => '0');
    case to_integer(unsigned(sel)) is
      when 0 => Y <= A0;
      when 1 => Y <= A1;
      when 2 => Y <= A2;
      when 3 => Y <= A3;
      when 4 => Y <= A4;
      when 5 => Y <= A5;
      when 6 => Y <= A6;
      when 7 => Y <= A7;
      when others => Y <= (others => '0');
    end case;
	end process;
end architecture;
