library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is
port (
    clock       : in  std_logic;
    limpa       : in  std_logic;
    temp1       : out std_logic;
    temp3r1     : out std_logic_vector(2 downto 0);
    temp3r2     : out std_logic_vector(2 downto 0);
    temp4r1     : out std_logic;
    temp4r2     : out std_logic;
    temp5r1     : out std_logic;
    temp5r2     : out std_logic;
    endereco_rom: out integer range 0 to 7;
    hab         : out std_logic_vector(15 downto 0)
);
end entity;

architecture maquina of fsm is

type estados is (n0, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32);
signal state : estados;

begin

sincrono: process(clock, limpa)
begin
    if limpa = '0' then
        state <= n0;
    elsif rising_edge(clock) then
        case state is
            when n0 => state <= n1;
            when n1 => state <= n2;
            when n2 => state <= n3;
            when n3 => state <= n4;
            when n4 => state <= n5;
            when n5 => state <= n6;
            when n6 => state <= n7;
            when n7 => state <= n8;
            when n8 => state <= n9;
            when n9 => state <= n10;
            when n10 => state <= n11;
            when n11 => state <= n12;
            when n12 => state <= n13;
            when n13 => state <= n14;
            when n14 => state <= n15;
            when n15 => state <= n16;
            when n16 => state <= n17;
            when n17 => state <= n18;
            when n18 => state <= n19;
            when n19 => state <= n20;
            when n20 => state <= n21;
            when n21 => state <= n22;
            when n22 => state <= n23;
            when n23 => state <= n24;
            when n24 => state <= n25;
            when n25 => state <= n26;
            when n26 => state <= n27;
            when n27 => state <= n28;
            when n28 => state <= n29;
            when n29 => state <= n30;
            when n30 => state <= n31;
            when n31 => state <= n32;
            when n32 => state <= n0;
            when others => state <= n0;
        end case;
    end if;
end process;

delta: process(state)
begin
    temp1 <= '0';
    temp3r1 <= "000";
    temp3r2 <= "000";
    temp4r1 <= '0';
    temp4r2 <= '1';
    temp5r1 <= '0';
    temp5r2 <= '1';
    hab <= (others => '0');
    endereco_rom <= 0;

    case state is
        when n0 =>
            temp1 <= '0';
            temp3r1 <= "000";
            temp3r2 <= "000";
            temp4r1 <= '0';
            temp4r2 <= '1';
            temp5r1 <= '0';
            temp5r2 <= '1';
            hab <= (others => '1');
            endereco_rom <= 0;
        when n1 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(0) <= '1';
            hab(8) <= '1';
            temp3r1 <= "000";
            temp3r2 <= "000";
            temp4r1 <= '0';
            temp4r2 <= '1';
            temp5r1 <= '0';
            temp5r2 <= '1';
            endereco_rom <= 0;
        when n2 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(4) <= '1';
            hab(12) <= '1';
            temp3r1 <= "001";
            temp3r2 <= "001";
            temp4r1 <= '1';
            temp4r2 <= '0';
            temp5r1 <= '1';
            temp5r2 <= '0';
            endereco_rom <= 0;
        when n3 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(2) <= '1';
            hab(10) <= '1';
            temp3r1 <= "010";
            temp3r2 <= "010";
            temp4r1 <= '1';
            temp4r2 <= '0';
            temp5r1 <= '1';
            temp5r2 <= '0';
            endereco_rom <= 0;
        when n4 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(6) <= '1';
            hab(14) <= '1';
            temp3r1 <= "011";
            temp3r2 <= "011";
            temp4r1 <= '0';
            temp4r2 <= '1';
            temp5r1 <= '0';
            temp5r2 <= '1';
            endereco_rom <= 0;
        when n5 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(1) <= '1';
            hab(9) <= '1';
            temp3r1 <= "100";
            temp3r2 <= "100";
            temp4r1 <= '1';
            temp4r2 <= '0';
            temp5r1 <= '1';
            temp5r2 <= '0';
            endereco_rom <= 0;
        when n6 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(5) <= '1';
            hab(13) <= '1';
            temp3r1 <= "101";
            temp3r2 <= "101";
            temp4r1 <= '0';
            temp4r2 <= '1';
            temp5r1 <= '0';
            temp5r2 <= '1';
            endereco_rom <= 0;
        when n7 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(3) <= '1';
            hab(11) <= '1';
            temp3r1 <= "110";
            temp3r2 <= "110";
            temp4r1 <= '0';
            temp4r2 <= '1';
            temp5r1 <= '0';
            temp5r2 <= '1';
            endereco_rom <= 0;
        when n8 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(7) <= '1';
            hab(15) <= '1';
            temp3r1 <= "111";
            temp3r2 <= "111";
            temp4r1 <= '1';
            temp4r2 <= '0';
            temp5r1 <= '1';
            temp5r2 <= '0';
            endereco_rom <= 0;
        when n9 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(0) <= '1';
            hab(4) <= '1';
            temp3r1 <= "000";
            temp3r2 <= "001";
            temp4r1 <= '0';
            temp4r2 <= '1';
            temp5r1 <= '0';
            temp5r2 <= '1';
            endereco_rom <= 0;
        when n10 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(8) <= '1';
            hab(12) <= '1';
            temp3r1 <= "001";
            temp3r2 <= "000";
            temp4r1 <= '1';
            temp4r2 <= '0';
            temp5r1 <= '1';
            temp5r2 <= '0';
            endereco_rom <= 4;
        when n11 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(2) <= '1';
            hab(6) <= '1';
            temp3r1 <= "011";
            temp3r2 <= "010";
            temp4r1 <= '1';
            temp4r2 <= '0';
            temp5r1 <= '1';
            temp5r2 <= '0';
            endereco_rom <= 0;
        when n12 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(10) <= '1';
            hab(14) <= '1';
            temp3r1 <= "010";
            temp3r2 <= "011";
            temp4r1 <= '0';
            temp4r2 <= '1';
            temp5r1 <= '0';
            temp5r2 <= '1';
            endereco_rom <= 4;
        when n13 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(1) <= '1';
            hab(5) <= '1';
            temp3r1 <= "101";
            temp3r2 <= "100";
            temp4r1 <= '1';
            temp4r2 <= '0';
            temp5r1 <= '1';
            temp5r2 <= '0';
            endereco_rom <= 0;
        when n14 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(9) <= '1';
            hab(13) <= '1';
            temp3r1 <= "100";
            temp3r2 <= "101";
            temp4r1 <= '0';
            temp4r2 <= '1';
            temp5r1 <= '0';
            temp5r2 <= '1';
            endereco_rom <= 4;
        when n15 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(3) <= '1';
            hab(7) <= '1';
            temp3r1 <= "110";
            temp3r2 <= "111";
            temp4r1 <= '0';
            temp4r2 <= '1';
            temp5r1 <= '0';
            temp5r2 <= '1';
            endereco_rom <= 0;
        when n16 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(11) <= '1';
            hab(15) <= '1';
            temp3r1 <= "111";
            temp3r2 <= "110";
            temp4r1 <= '1';
            temp4r2 <= '0';
            temp5r1 <= '1';
            temp5r2 <= '0';
            endereco_rom <= 4;
        when n17 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(0) <= '1';
            hab(2) <= '1';
            temp3r1 <= "000";
            temp3r2 <= "010";
            temp4r1 <= '0';
            temp4r2 <= '1';
            temp5r1 <= '0';
            temp5r2 <= '1';
            endereco_rom <= 0;
        when n18 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(8) <= '1';
            hab(10) <= '1';
            temp3r1 <= "010";
            temp3r2 <= "000";
            temp4r1 <= '1';
            temp4r2 <= '0';
            temp5r1 <= '1';
            temp5r2 <= '0';
            endereco_rom <= 2;
        when n19 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(4) <= '1';
            hab(6) <= '1';
            temp3r1 <= "011";
            temp3r2 <= "001";
            temp4r1 <= '1';
            temp4r2 <= '0';
            temp5r1 <= '1';
            temp5r2 <= '0';
            endereco_rom <= 4;
        when n20 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(12) <= '1';
            hab(14) <= '1';
            temp3r1 <= "001";
            temp3r2 <= "011";
            temp4r1 <= '0';
            temp4r2 <= '1';
            temp5r1 <= '0';
            temp5r2 <= '1';
            endereco_rom <= 6;
        when n21 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(1) <= '1';
            hab(3) <= '1';
            temp3r1 <= "110";
            temp3r2 <= "100";
            temp4r1 <= '1';
            temp4r2 <= '0';
            temp5r1 <= '1';
            temp5r2 <= '0';
            endereco_rom <= 0;
        when n22 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(9) <= '1';
            hab(11) <= '1';
            temp3r1 <= "100";
            temp3r2 <= "110";
            temp4r1 <= '0';
            temp4r2 <= '1';
            temp5r1 <= '0';
            temp5r2 <= '1';
            endereco_rom <= 2;
        when n23 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(5) <= '1';
            hab(7) <= '1';
            temp3r1 <= "101";
            temp3r2 <= "111";
            temp4r1 <= '0';
            temp4r2 <= '1';
            temp5r1 <= '0';
            temp5r2 <= '1';
            endereco_rom <= 4;
        when n24 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(13) <= '1';
            hab(15) <= '1';
            temp3r1 <= "111";
            temp3r2 <= "101";
            temp4r1 <= '1';
            temp4r2 <= '0';
            temp5r1 <= '1';
            temp5r2 <= '0';
            endereco_rom <= 6;
        when n25 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(0) <= '1';
            hab(1) <= '1';
            temp3r1 <= "000";
            temp3r2 <= "100";
            temp4r1 <= '0';
            temp4r2 <= '1';
            temp5r1 <= '0';
            temp5r2 <= '1';
            endereco_rom <= 0;
        when n26 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(8) <= '1';
            hab(9) <= '1';
            temp3r1 <= "100";
            temp3r2 <= "000";
            temp4r1 <= '1';
            temp4r2 <= '0';
            temp5r1 <= '1';
            temp5r2 <= '0';
            endereco_rom <= 1;
        when n27 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(4) <= '1';
            hab(5) <= '1';
            temp3r1 <= "101";
            temp3r2 <= "001";
            temp4r1 <= '1';
            temp4r2 <= '0';
            temp5r1 <= '1';
            temp5r2 <= '0';
            endereco_rom <= 2;
        when n28 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(12) <= '1';
            hab(13) <= '1';
            temp3r1 <= "001";
            temp3r2 <= "101";
            temp4r1 <= '0';
            temp4r2 <= '1';
            temp5r1 <= '0';
            temp5r2 <= '1';
            endereco_rom <= 3;
        when n29 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(2) <= '1';
            hab(3) <= '1';
            temp3r1 <= "110";
            temp3r2 <= "010";
            temp4r1 <= '1';
            temp4r2 <= '0';
            temp5r1 <= '1';
            temp5r2 <= '0';
            endereco_rom <= 4;
        when n30 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(10) <= '1';
            hab(11) <= '1';
            temp3r1 <= "010";
            temp3r2 <= "110";
            temp4r1 <= '0';
            temp4r2 <= '1';
            temp5r1 <= '0';
            temp5r2 <= '1';
            endereco_rom <= 5;
        when n31 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(6) <= '1';
            hab(7) <= '1';
            temp3r1 <= "011";
            temp3r2 <= "111";
            temp4r1 <= '0';
            temp4r2 <= '1';
            temp5r1 <= '0';
            temp5r2 <= '1';
            endereco_rom <= 6;
        when n32 =>
            temp1 <= '1';
            hab <= (others => '0');
            hab(14) <= '1';
            hab(15) <= '1';
            temp3r1 <= "111";
            temp3r2 <= "011";
            temp4r1 <= '1';
            temp4r2 <= '0';
            temp5r1 <= '1';
            temp5r2 <= '0';
            endereco_rom <= 7;
        when others =>
            temp1 <= '0';
            temp3r1 <= "000";
            temp3r2 <= "000";
            temp4r1 <= '0';
            temp4r2 <= '1';
            temp5r1 <= '0';
            temp5r2 <= '1';
            hab <= (others => '0');
            endereco_rom <= 0;
    end case;
end process;

end architecture maquina;
