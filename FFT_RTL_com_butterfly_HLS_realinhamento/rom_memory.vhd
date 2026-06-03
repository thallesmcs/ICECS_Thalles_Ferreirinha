library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
generic ( WIDTH: integer := 16 );
port (
	adress: in integer range 0 to 7;
	wr:  out std_logic_vector( WIDTH-1 downto 0);
	wi:  out std_logic_vector( WIDTH-1 downto 0)
);
end entity;

architecture memoria of rom is

type vetor is array (0 to 7) of std_logic_vector(31 downto 0);

constant memory : vetor := (
0 => "01000000000000000000000000000000",
1 => "00111011001000011110011110000010",
2 => "00101101010000011101001010111111",
3 => "00011000011111101100010011011111",
4 => "00000000000000001100000000000000",
5 => "11100111100000101100010011011111",
6 => "11010010101111111101001010111111",
7 => "11000100110111111110011110000010"
);

begin

wr <= memory(adress)( 2*WIDTH-1 downto WIDTH);
wi <= memory(adress)( WIDTH-1 downto 0);
end architecture memoria;
