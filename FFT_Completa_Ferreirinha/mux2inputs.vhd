library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2inputs is
generic ( WIDTH: integer := 16 );
  port (
    sel : in  std_logic;
    A0  : in  std_logic_vector( WIDTH-1 downto 0);
    A1  : in  std_logic_vector( WIDTH-1 downto 0);
    Y   : out std_logic_vector( WIDTH-1 downto 0)
  );
end entity;

architecture rtl of mux2inputs is
begin
  process(sel, A0, A1)
  begin
    Y <= (others => '0');
    case sel is
      when '0' => Y <= A0;
      when '1' => Y <= A1;
      when others => Y <= (others => '0');
    end case;
	end process;
end architecture;
