library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level_radix2_baseline is
    port (
        clock           : in  std_logic;
        limpa           : in  std_logic;
        carrega_amostra : in  std_logic;
        indice_amostra  : in  std_logic_vector(3 downto 0);
        entrada_re      : in  std_logic_vector(15 downto 0);
        entrada_im      : in  std_logic_vector(15 downto 0);
        indice_saida    : in  std_logic_vector(3 downto 0);
        saida_re        : out std_logic_vector(15 downto 0);
        saida_im        : out std_logic_vector(15 downto 0);
        saida_valida    : out std_logic
    );
end entity;

architecture Behavioral of top_level_radix2_baseline is

    component top_level_design is
        generic ( WIDTH: integer := 16 );
        port (
            clock           : in  std_logic;
            limpa           : in  std_logic;
            carrega_amostra : in  std_logic;
            indice_amostra  : in  std_logic_vector(3 downto 0);
            entrada_re      : in  std_logic_vector(WIDTH-1 downto 0);
            entrada_im      : in  std_logic_vector(WIDTH-1 downto 0);
            indice_saida    : in  std_logic_vector(3 downto 0);
            saida_re        : out std_logic_vector(WIDTH-1 downto 0);
            saida_im        : out std_logic_vector(WIDTH-1 downto 0);
            saida_valida    : out std_logic
        );
    end component;

    component FF_D1 is
        port (
            clk   : in  std_logic;
            rst_n : in  std_logic;
            d     : in  std_logic;
            q     : out std_logic
        );
    end component;

    component FF_D4 is
        port (
            clk   : in  std_logic;
            rst_n : in  std_logic;
            d     : in  std_logic_vector(3 downto 0);
            q     : out std_logic_vector(3 downto 0)
        );
    end component;

    component FF_D16 is
        port (
            clk   : in  std_logic;
            rst_n : in  std_logic;
            d     : in  std_logic_vector(15 downto 0);
            q     : out std_logic_vector(15 downto 0)
        );
    end component;

    signal rst_n              : std_logic;
    signal carrega_amostra_reg : std_logic;
    signal indice_amostra_reg  : std_logic_vector(3 downto 0);
    signal entrada_re_reg      : std_logic_vector(15 downto 0);
    signal entrada_im_reg      : std_logic_vector(15 downto 0);
    signal indice_saida_reg    : std_logic_vector(3 downto 0);
    signal saida_re_raw        : std_logic_vector(15 downto 0);
    signal saida_im_raw        : std_logic_vector(15 downto 0);
    signal saida_valida_raw    : std_logic;
    signal saida_re_reg        : std_logic_vector(15 downto 0);
    signal saida_im_reg        : std_logic_vector(15 downto 0);
    signal saida_valida_reg    : std_logic;

begin

    rst_n <= limpa;

    ff_carrega_amostra : FF_D1
        port map (clk => clock, rst_n => rst_n, d => carrega_amostra, q => carrega_amostra_reg);

    ff_indice_amostra : FF_D4
        port map (clk => clock, rst_n => rst_n, d => indice_amostra, q => indice_amostra_reg);

    ff_entrada_re : FF_D16
        port map (clk => clock, rst_n => rst_n, d => entrada_re, q => entrada_re_reg);

    ff_entrada_im : FF_D16
        port map (clk => clock, rst_n => rst_n, d => entrada_im, q => entrada_im_reg);

    ff_indice_saida : FF_D4
        port map (clk => clock, rst_n => rst_n, d => indice_saida, q => indice_saida_reg);

    u_fft : top_level_design
        generic map (WIDTH => 16)
        port map (
            clock           => clock,
            limpa           => limpa,
            carrega_amostra => carrega_amostra_reg,
            indice_amostra  => indice_amostra_reg,
            entrada_re      => entrada_re_reg,
            entrada_im      => entrada_im_reg,
            indice_saida    => indice_saida_reg,
            saida_re        => saida_re_raw,
            saida_im        => saida_im_raw,
            saida_valida    => saida_valida_raw
        );

    ff_saida_re : FF_D16
        port map (clk => clock, rst_n => rst_n, d => saida_re_raw, q => saida_re_reg);

    ff_saida_im : FF_D16
        port map (clk => clock, rst_n => rst_n, d => saida_im_raw, q => saida_im_reg);

    ff_saida_valida : FF_D1
        port map (clk => clock, rst_n => rst_n, d => saida_valida_raw, q => saida_valida_reg);

    saida_re <= saida_re_reg;
    saida_im <= saida_im_reg;
    saida_valida <= saida_valida_reg;

end Behavioral;
