library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FF_D1 is
    port (
        clk   : in  std_logic;
        rst_n : in  std_logic;
        d     : in  std_logic;
        q     : out std_logic
    );
end entity;

architecture rtl of FF_D1 is
begin
    process (clk, rst_n)
    begin
        if rst_n = '0' then
            q <= '0';
        elsif rising_edge(clk) then
            q <= d;
        end if;
    end process;
end architecture;
