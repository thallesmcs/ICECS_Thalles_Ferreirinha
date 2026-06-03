library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level_fft16_hls is
    port (
        ap_clk : in  std_logic;
        ap_rst : in  std_logic;
        ap_start : in  std_logic;
        ap_done : out std_logic;
        ap_idle : out std_logic;
        ap_ready : out std_logic;
        Xr_address0 : out std_logic_vector(3 downto 0);
        Xr_ce0 : out std_logic;
        Xr_q0 : in  std_logic_vector(15 downto 0);
        Xr_address1 : out std_logic_vector(3 downto 0);
        Xr_ce1 : out std_logic;
        Xr_q1 : in  std_logic_vector(15 downto 0);
        Xi_address0 : out std_logic_vector(3 downto 0);
        Xi_ce0 : out std_logic;
        Xi_q0 : in  std_logic_vector(15 downto 0);
        Xi_address1 : out std_logic_vector(3 downto 0);
        Xi_ce1 : out std_logic;
        Xi_q1 : in  std_logic_vector(15 downto 0);
        outRe_address0 : out std_logic_vector(3 downto 0);
        outRe_ce0 : out std_logic;
        outRe_we0 : out std_logic;
        outRe_d0 : out std_logic_vector(15 downto 0);
        outRe_address1 : out std_logic_vector(3 downto 0);
        outRe_ce1 : out std_logic;
        outRe_we1 : out std_logic;
        outRe_d1 : out std_logic_vector(15 downto 0);
        outIm_address0 : out std_logic_vector(3 downto 0);
        outIm_ce0 : out std_logic;
        outIm_we0 : out std_logic;
        outIm_d0 : out std_logic_vector(15 downto 0);
        outIm_address1 : out std_logic_vector(3 downto 0);
        outIm_ce1 : out std_logic;
        outIm_we1 : out std_logic;
        outIm_d1 : out std_logic_vector(15 downto 0)
    );
end entity;

architecture Behavioral of top_level_fft16_hls is

    component fft16_hls is
        port (
            ap_clk : in  std_logic;
            ap_rst : in  std_logic;
            ap_start : in  std_logic;
            ap_done : out std_logic;
            ap_idle : out std_logic;
            ap_ready : out std_logic;
            Xr_address0 : out std_logic_vector(3 downto 0);
            Xr_ce0 : out std_logic;
            Xr_q0 : in  std_logic_vector(15 downto 0);
            Xr_address1 : out std_logic_vector(3 downto 0);
            Xr_ce1 : out std_logic;
            Xr_q1 : in  std_logic_vector(15 downto 0);
            Xi_address0 : out std_logic_vector(3 downto 0);
            Xi_ce0 : out std_logic;
            Xi_q0 : in  std_logic_vector(15 downto 0);
            Xi_address1 : out std_logic_vector(3 downto 0);
            Xi_ce1 : out std_logic;
            Xi_q1 : in  std_logic_vector(15 downto 0);
            outRe_address0 : out std_logic_vector(3 downto 0);
            outRe_ce0 : out std_logic;
            outRe_we0 : out std_logic;
            outRe_d0 : out std_logic_vector(15 downto 0);
            outRe_address1 : out std_logic_vector(3 downto 0);
            outRe_ce1 : out std_logic;
            outRe_we1 : out std_logic;
            outRe_d1 : out std_logic_vector(15 downto 0);
            outIm_address0 : out std_logic_vector(3 downto 0);
            outIm_ce0 : out std_logic;
            outIm_we0 : out std_logic;
            outIm_d0 : out std_logic_vector(15 downto 0);
            outIm_address1 : out std_logic_vector(3 downto 0);
            outIm_ce1 : out std_logic;
            outIm_we1 : out std_logic;
            outIm_d1 : out std_logic_vector(15 downto 0)
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

    component FF_D4 is
        port (
            clk   : in  std_logic;
            rst_n : in  std_logic;
            d     : in  std_logic_vector(3 downto 0);
            q     : out std_logic_vector(3 downto 0)
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

    signal rst_n : std_logic;

    signal ap_start_reg : std_logic;
    signal Xr_q0_reg : std_logic_vector(15 downto 0);
    signal Xr_q1_reg : std_logic_vector(15 downto 0);
    signal Xi_q0_reg : std_logic_vector(15 downto 0);
    signal Xi_q1_reg : std_logic_vector(15 downto 0);

    signal ap_done_raw : std_logic;
    signal ap_idle_raw : std_logic;
    signal ap_ready_raw : std_logic;
    signal Xr_address0_raw : std_logic_vector(3 downto 0);
    signal Xr_ce0_raw : std_logic;
    signal Xr_address1_raw : std_logic_vector(3 downto 0);
    signal Xr_ce1_raw : std_logic;
    signal Xi_address0_raw : std_logic_vector(3 downto 0);
    signal Xi_ce0_raw : std_logic;
    signal Xi_address1_raw : std_logic_vector(3 downto 0);
    signal Xi_ce1_raw : std_logic;
    signal outRe_address0_raw : std_logic_vector(3 downto 0);
    signal outRe_ce0_raw : std_logic;
    signal outRe_we0_raw : std_logic;
    signal outRe_d0_raw : std_logic_vector(15 downto 0);
    signal outRe_address1_raw : std_logic_vector(3 downto 0);
    signal outRe_ce1_raw : std_logic;
    signal outRe_we1_raw : std_logic;
    signal outRe_d1_raw : std_logic_vector(15 downto 0);
    signal outIm_address0_raw : std_logic_vector(3 downto 0);
    signal outIm_ce0_raw : std_logic;
    signal outIm_we0_raw : std_logic;
    signal outIm_d0_raw : std_logic_vector(15 downto 0);
    signal outIm_address1_raw : std_logic_vector(3 downto 0);
    signal outIm_ce1_raw : std_logic;
    signal outIm_we1_raw : std_logic;
    signal outIm_d1_raw : std_logic_vector(15 downto 0);

    signal ap_done_reg : std_logic;
    signal ap_idle_reg : std_logic;
    signal ap_ready_reg : std_logic;
    signal Xr_address0_reg : std_logic_vector(3 downto 0);
    signal Xr_ce0_reg : std_logic;
    signal Xr_address1_reg : std_logic_vector(3 downto 0);
    signal Xr_ce1_reg : std_logic;
    signal Xi_address0_reg : std_logic_vector(3 downto 0);
    signal Xi_ce0_reg : std_logic;
    signal Xi_address1_reg : std_logic_vector(3 downto 0);
    signal Xi_ce1_reg : std_logic;
    signal outRe_address0_reg : std_logic_vector(3 downto 0);
    signal outRe_ce0_reg : std_logic;
    signal outRe_we0_reg : std_logic;
    signal outRe_d0_reg : std_logic_vector(15 downto 0);
    signal outRe_address1_reg : std_logic_vector(3 downto 0);
    signal outRe_ce1_reg : std_logic;
    signal outRe_we1_reg : std_logic;
    signal outRe_d1_reg : std_logic_vector(15 downto 0);
    signal outIm_address0_reg : std_logic_vector(3 downto 0);
    signal outIm_ce0_reg : std_logic;
    signal outIm_we0_reg : std_logic;
    signal outIm_d0_reg : std_logic_vector(15 downto 0);
    signal outIm_address1_reg : std_logic_vector(3 downto 0);
    signal outIm_ce1_reg : std_logic;
    signal outIm_we1_reg : std_logic;
    signal outIm_d1_reg : std_logic_vector(15 downto 0);

begin

    rst_n <= not ap_rst;

    ff_ap_start : FF_D1
        port map (clk => ap_clk, rst_n => rst_n, d => ap_start, q => ap_start_reg);

    ff_xr_q0 : FF_D16
        port map (clk => ap_clk, rst_n => rst_n, d => Xr_q0, q => Xr_q0_reg);

    ff_xr_q1 : FF_D16
        port map (clk => ap_clk, rst_n => rst_n, d => Xr_q1, q => Xr_q1_reg);

    ff_xi_q0 : FF_D16
        port map (clk => ap_clk, rst_n => rst_n, d => Xi_q0, q => Xi_q0_reg);

    ff_xi_q1 : FF_D16
        port map (clk => ap_clk, rst_n => rst_n, d => Xi_q1, q => Xi_q1_reg);

    u_fft16_hls : fft16_hls
        port map (
            ap_clk => ap_clk,
            ap_rst => ap_rst,
            ap_start => ap_start_reg,
            ap_done => ap_done_raw,
            ap_idle => ap_idle_raw,
            ap_ready => ap_ready_raw,
            Xr_address0 => Xr_address0_raw,
            Xr_ce0 => Xr_ce0_raw,
            Xr_q0 => Xr_q0_reg,
            Xr_address1 => Xr_address1_raw,
            Xr_ce1 => Xr_ce1_raw,
            Xr_q1 => Xr_q1_reg,
            Xi_address0 => Xi_address0_raw,
            Xi_ce0 => Xi_ce0_raw,
            Xi_q0 => Xi_q0_reg,
            Xi_address1 => Xi_address1_raw,
            Xi_ce1 => Xi_ce1_raw,
            Xi_q1 => Xi_q1_reg,
            outRe_address0 => outRe_address0_raw,
            outRe_ce0 => outRe_ce0_raw,
            outRe_we0 => outRe_we0_raw,
            outRe_d0 => outRe_d0_raw,
            outRe_address1 => outRe_address1_raw,
            outRe_ce1 => outRe_ce1_raw,
            outRe_we1 => outRe_we1_raw,
            outRe_d1 => outRe_d1_raw,
            outIm_address0 => outIm_address0_raw,
            outIm_ce0 => outIm_ce0_raw,
            outIm_we0 => outIm_we0_raw,
            outIm_d0 => outIm_d0_raw,
            outIm_address1 => outIm_address1_raw,
            outIm_ce1 => outIm_ce1_raw,
            outIm_we1 => outIm_we1_raw,
            outIm_d1 => outIm_d1_raw
        );

    ff_ap_done : FF_D1
        port map (clk => ap_clk, rst_n => rst_n, d => ap_done_raw, q => ap_done_reg);

    ff_ap_idle : FF_D1
        port map (clk => ap_clk, rst_n => rst_n, d => ap_idle_raw, q => ap_idle_reg);

    ff_ap_ready : FF_D1
        port map (clk => ap_clk, rst_n => rst_n, d => ap_ready_raw, q => ap_ready_reg);

    ff_xr_address0 : FF_D4
        port map (clk => ap_clk, rst_n => rst_n, d => Xr_address0_raw, q => Xr_address0_reg);

    ff_xr_ce0 : FF_D1
        port map (clk => ap_clk, rst_n => rst_n, d => Xr_ce0_raw, q => Xr_ce0_reg);

    ff_xr_address1 : FF_D4
        port map (clk => ap_clk, rst_n => rst_n, d => Xr_address1_raw, q => Xr_address1_reg);

    ff_xr_ce1 : FF_D1
        port map (clk => ap_clk, rst_n => rst_n, d => Xr_ce1_raw, q => Xr_ce1_reg);

    ff_xi_address0 : FF_D4
        port map (clk => ap_clk, rst_n => rst_n, d => Xi_address0_raw, q => Xi_address0_reg);

    ff_xi_ce0 : FF_D1
        port map (clk => ap_clk, rst_n => rst_n, d => Xi_ce0_raw, q => Xi_ce0_reg);

    ff_xi_address1 : FF_D4
        port map (clk => ap_clk, rst_n => rst_n, d => Xi_address1_raw, q => Xi_address1_reg);

    ff_xi_ce1 : FF_D1
        port map (clk => ap_clk, rst_n => rst_n, d => Xi_ce1_raw, q => Xi_ce1_reg);

    ff_outre_address0 : FF_D4
        port map (clk => ap_clk, rst_n => rst_n, d => outRe_address0_raw, q => outRe_address0_reg);

    ff_outre_ce0 : FF_D1
        port map (clk => ap_clk, rst_n => rst_n, d => outRe_ce0_raw, q => outRe_ce0_reg);

    ff_outre_we0 : FF_D1
        port map (clk => ap_clk, rst_n => rst_n, d => outRe_we0_raw, q => outRe_we0_reg);

    ff_outre_d0 : FF_D16
        port map (clk => ap_clk, rst_n => rst_n, d => outRe_d0_raw, q => outRe_d0_reg);

    ff_outre_address1 : FF_D4
        port map (clk => ap_clk, rst_n => rst_n, d => outRe_address1_raw, q => outRe_address1_reg);

    ff_outre_ce1 : FF_D1
        port map (clk => ap_clk, rst_n => rst_n, d => outRe_ce1_raw, q => outRe_ce1_reg);

    ff_outre_we1 : FF_D1
        port map (clk => ap_clk, rst_n => rst_n, d => outRe_we1_raw, q => outRe_we1_reg);

    ff_outre_d1 : FF_D16
        port map (clk => ap_clk, rst_n => rst_n, d => outRe_d1_raw, q => outRe_d1_reg);

    ff_outim_address0 : FF_D4
        port map (clk => ap_clk, rst_n => rst_n, d => outIm_address0_raw, q => outIm_address0_reg);

    ff_outim_ce0 : FF_D1
        port map (clk => ap_clk, rst_n => rst_n, d => outIm_ce0_raw, q => outIm_ce0_reg);

    ff_outim_we0 : FF_D1
        port map (clk => ap_clk, rst_n => rst_n, d => outIm_we0_raw, q => outIm_we0_reg);

    ff_outim_d0 : FF_D16
        port map (clk => ap_clk, rst_n => rst_n, d => outIm_d0_raw, q => outIm_d0_reg);

    ff_outim_address1 : FF_D4
        port map (clk => ap_clk, rst_n => rst_n, d => outIm_address1_raw, q => outIm_address1_reg);

    ff_outim_ce1 : FF_D1
        port map (clk => ap_clk, rst_n => rst_n, d => outIm_ce1_raw, q => outIm_ce1_reg);

    ff_outim_we1 : FF_D1
        port map (clk => ap_clk, rst_n => rst_n, d => outIm_we1_raw, q => outIm_we1_reg);

    ff_outim_d1 : FF_D16
        port map (clk => ap_clk, rst_n => rst_n, d => outIm_d1_raw, q => outIm_d1_reg);

    ap_done <= ap_done_reg;
    ap_idle <= ap_idle_reg;
    ap_ready <= ap_ready_reg;
    Xr_address0 <= Xr_address0_reg;
    Xr_ce0 <= Xr_ce0_reg;
    Xr_address1 <= Xr_address1_reg;
    Xr_ce1 <= Xr_ce1_reg;
    Xi_address0 <= Xi_address0_reg;
    Xi_ce0 <= Xi_ce0_reg;
    Xi_address1 <= Xi_address1_reg;
    Xi_ce1 <= Xi_ce1_reg;
    outRe_address0 <= outRe_address0_reg;
    outRe_ce0 <= outRe_ce0_reg;
    outRe_we0 <= outRe_we0_reg;
    outRe_d0 <= outRe_d0_reg;
    outRe_address1 <= outRe_address1_reg;
    outRe_ce1 <= outRe_ce1_reg;
    outRe_we1 <= outRe_we1_reg;
    outRe_d1 <= outRe_d1_reg;
    outIm_address0 <= outIm_address0_reg;
    outIm_ce0 <= outIm_ce0_reg;
    outIm_we0 <= outIm_we0_reg;
    outIm_d0 <= outIm_d0_reg;
    outIm_address1 <= outIm_address1_reg;
    outIm_ce1 <= outIm_ce1_reg;
    outIm_we1 <= outIm_we1_reg;
    outIm_d1 <= outIm_d1_reg;

end Behavioral;
