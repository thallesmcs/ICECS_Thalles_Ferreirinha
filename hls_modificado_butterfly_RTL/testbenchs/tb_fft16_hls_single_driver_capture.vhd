library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_fft16_hls_single_driver_capture is
end entity;

architecture sim of tb_fft16_hls_single_driver_capture is

    constant CLK_PERIOD : time := 10 ns;

    type mem16_t is array (0 to 15) of std_logic_vector(15 downto 0);

    signal ap_clk   : std_logic := '0';
    signal ap_rst   : std_logic := '0';
    signal ap_start : std_logic := '0';
    signal ap_done  : std_logic;
    signal ap_idle  : std_logic;
    signal ap_ready : std_logic;

    signal Xr_address0 : std_logic_vector(3 downto 0);
    signal Xr_ce0      : std_logic;
    signal Xr_q0       : std_logic_vector(15 downto 0) := (others => '0');
    signal Xr_address1 : std_logic_vector(3 downto 0);
    signal Xr_ce1      : std_logic;
    signal Xr_q1       : std_logic_vector(15 downto 0) := (others => '0');

    signal Xi_address0 : std_logic_vector(3 downto 0);
    signal Xi_ce0      : std_logic;
    signal Xi_q0       : std_logic_vector(15 downto 0) := (others => '0');
    signal Xi_address1 : std_logic_vector(3 downto 0);
    signal Xi_ce1      : std_logic;
    signal Xi_q1       : std_logic_vector(15 downto 0) := (others => '0');

    signal outRe_address0 : std_logic_vector(3 downto 0);
    signal outRe_ce0      : std_logic;
    signal outRe_we0      : std_logic;
    signal outRe_d0       : std_logic_vector(15 downto 0);
    signal outRe_address1 : std_logic_vector(3 downto 0);
    signal outRe_ce1      : std_logic;
    signal outRe_we1      : std_logic;
    signal outRe_d1       : std_logic_vector(15 downto 0);

    signal outIm_address0 : std_logic_vector(3 downto 0);
    signal outIm_ce0      : std_logic;
    signal outIm_we0      : std_logic;
    signal outIm_d0       : std_logic_vector(15 downto 0);
    signal outIm_address1 : std_logic_vector(3 downto 0);
    signal outIm_ce1      : std_logic;
    signal outIm_we1      : std_logic;
    signal outIm_d1       : std_logic_vector(15 downto 0);

    signal Xr_mem    : mem16_t := (others => (others => '0'));
    signal Xi_mem    : mem16_t := (others => (others => '0'));
    signal outRe_mem : mem16_t := (others => (others => '0'));
    signal outIm_mem : mem16_t := (others => (others => '0'));

    -- Sinais de depuracao no waveform.
    signal wr_re0_valid : std_logic := '0';
    signal wr_re1_valid : std_logic := '0';
    signal wr_im0_valid : std_logic := '0';
    signal wr_im1_valid : std_logic := '0';

    signal wr_re0_addr  : integer range 0 to 15 := 0;
    signal wr_re1_addr  : integer range 0 to 15 := 0;
    signal wr_im0_addr  : integer range 0 to 15 := 0;
    signal wr_im1_addr  : integer range 0 to 15 := 0;

    signal wr_re0_data  : std_logic_vector(15 downto 0) := (others => '0');
    signal wr_re1_data  : std_logic_vector(15 downto 0) := (others => '0');
    signal wr_im0_data  : std_logic_vector(15 downto 0) := (others => '0');
    signal wr_im1_data  : std_logic_vector(15 downto 0) := (others => '0');

    function is_clean(v : std_logic_vector) return boolean is
    begin
        for i in v'range loop
            if not (v(i) = '0' or v(i) = '1') then
                return false;
            end if;
        end loop;
        return true;
    end function;

    function addr_to_int(a : std_logic_vector(3 downto 0)) return integer is
    begin
        if is_clean(a) then
            return to_integer(unsigned(a));
        else
            return 0;
        end if;
    end function;

    function slv_to_int(v : std_logic_vector(15 downto 0)) return integer is
    begin
        if is_clean(v) then
            return to_integer(signed(v));
        else
            return -99999;
        end if;
    end function;

begin

    ap_clk <= not ap_clk after CLK_PERIOD/2;

    dut : entity work.fft16_hls
        port map (
            ap_clk => ap_clk,
            ap_rst => ap_rst,
            ap_start => ap_start,
            ap_done => ap_done,
            ap_idle => ap_idle,
            ap_ready => ap_ready,

            Xr_address0 => Xr_address0,
            Xr_ce0 => Xr_ce0,
            Xr_q0 => Xr_q0,
            Xr_address1 => Xr_address1,
            Xr_ce1 => Xr_ce1,
            Xr_q1 => Xr_q1,

            Xi_address0 => Xi_address0,
            Xi_ce0 => Xi_ce0,
            Xi_q0 => Xi_q0,
            Xi_address1 => Xi_address1,
            Xi_ce1 => Xi_ce1,
            Xi_q1 => Xi_q1,

            outRe_address0 => outRe_address0,
            outRe_ce0 => outRe_ce0,
            outRe_we0 => outRe_we0,
            outRe_d0 => outRe_d0,
            outRe_address1 => outRe_address1,
            outRe_ce1 => outRe_ce1,
            outRe_we1 => outRe_we1,
            outRe_d1 => outRe_d1,

            outIm_address0 => outIm_address0,
            outIm_ce0 => outIm_ce0,
            outIm_we0 => outIm_we0,
            outIm_d0 => outIm_d0,
            outIm_address1 => outIm_address1,
            outIm_ce1 => outIm_ce1,
            outIm_we1 => outIm_we1,
            outIm_d1 => outIm_d1
        );

    ------------------------------------------------------------------------
    -- Modelo de memoria de entrada SINCRONA, com 1 ciclo de latencia.
    -- Esse modelo combina melhor com a interface ap_memory/BRAM gerada pelo HLS.
    ------------------------------------------------------------------------
    input_mem_read : process(ap_clk)
    begin
        if rising_edge(ap_clk) then
            if ap_rst = '1' then
                Xr_q0 <= (others => '0');
                Xr_q1 <= (others => '0');
                Xi_q0 <= (others => '0');
                Xi_q1 <= (others => '0');
            else
                if Xr_ce0 = '1' and is_clean(Xr_address0) then
                    Xr_q0 <= Xr_mem(to_integer(unsigned(Xr_address0)));
                end if;

                if Xr_ce1 = '1' and is_clean(Xr_address1) then
                    Xr_q1 <= Xr_mem(to_integer(unsigned(Xr_address1)));
                end if;

                if Xi_ce0 = '1' and is_clean(Xi_address0) then
                    Xi_q0 <= Xi_mem(to_integer(unsigned(Xi_address0)));
                end if;

                if Xi_ce1 = '1' and is_clean(Xi_address1) then
                    Xi_q1 <= Xi_mem(to_integer(unsigned(Xi_address1)));
                end if;
            end if;
        end if;
    end process;

    ------------------------------------------------------------------------
    -- Captura das escritas de saida.
    -- IMPORTANTE: a captura e feita na borda de descida para evitar corrida
    -- com os sinais de saida gerados pelo VHDL do HLS na borda de subida.
    -- Se capturar na mesma borda de subida, o TB pode guardar valores antigos
    -- ou X antes de out*_address e out*_d estabilizarem.
    ------------------------------------------------------------------------
    capture_outputs : process(ap_clk)
    begin
        if falling_edge(ap_clk) then
            wr_re0_valid <= '0';
            wr_re1_valid <= '0';
            wr_im0_valid <= '0';
            wr_im1_valid <= '0';

            if outRe_ce0 = '1' and outRe_we0 = '1' then
                if is_clean(outRe_address0) and is_clean(outRe_d0) then
                    outRe_mem(to_integer(unsigned(outRe_address0))) <= outRe_d0;
                    wr_re0_valid <= '1';
                    wr_re0_addr  <= to_integer(unsigned(outRe_address0));
                    wr_re0_data  <= outRe_d0;
                else
                    assert false report "ERRO: outRe porta 0 contem X durante escrita valida." severity warning;
                end if;
            end if;

            if outRe_ce1 = '1' and outRe_we1 = '1' then
                if is_clean(outRe_address1) and is_clean(outRe_d1) then
                    outRe_mem(to_integer(unsigned(outRe_address1))) <= outRe_d1;
                    wr_re1_valid <= '1';
                    wr_re1_addr  <= to_integer(unsigned(outRe_address1));
                    wr_re1_data  <= outRe_d1;
                else
                    assert false report "ERRO: outRe porta 1 contem X durante escrita valida." severity warning;
                end if;
            end if;

            if outIm_ce0 = '1' and outIm_we0 = '1' then
                if is_clean(outIm_address0) and is_clean(outIm_d0) then
                    outIm_mem(to_integer(unsigned(outIm_address0))) <= outIm_d0;
                    wr_im0_valid <= '1';
                    wr_im0_addr  <= to_integer(unsigned(outIm_address0));
                    wr_im0_data  <= outIm_d0;
                else
                    assert false report "ERRO: outIm porta 0 contem X durante escrita valida." severity warning;
                end if;
            end if;

            if outIm_ce1 = '1' and outIm_we1 = '1' then
                if is_clean(outIm_address1) and is_clean(outIm_d1) then
                    outIm_mem(to_integer(unsigned(outIm_address1))) <= outIm_d1;
                    wr_im1_valid <= '1';
                    wr_im1_addr  <= to_integer(unsigned(outIm_address1));
                    wr_im1_data  <= outIm_d1;
                else
                    assert false report "ERRO: outIm porta 1 contem X durante escrita valida." severity warning;
                end if;
            end if;
        end if;
    end process;

    stimulus : process
    begin
        Xr_mem    <= (others => x"0000");
        Xi_mem    <= (others => x"0000");
        -- As memorias de saida NAO sao zeradas aqui.
        -- Elas sao dirigidas apenas pelo processo capture_outputs.
        -- Isso evita multiplos drivers em outRe_mem/outIm_mem, que geram X.

        -- Impulso unitario.
        Xr_mem(0) <= x"0001";

        ap_rst   <= '1';
        ap_start <= '0';
        wait for 5 * CLK_PERIOD;

        ap_rst <= '0';
        wait for 2 * CLK_PERIOD;

        ap_start <= '1';
        wait for CLK_PERIOD;
        ap_start <= '0';

        wait until ap_done = '1';
        wait for 5 * CLK_PERIOD;

        report "===== RESULTADO FFT16 - IMPULSO - SINGLE DRIVER =====";
        for i in 0 to 15 loop
            report "k=" & integer'image(i) &
                   " outRe=" & integer'image(slv_to_int(outRe_mem(i))) &
                   " outIm=" & integer'image(slv_to_int(outIm_mem(i)));
        end loop;

        for i in 0 to 15 loop
            assert outRe_mem(i) = x"0001"
                report "ERRO: outRe(" & integer'image(i) & ") deveria ser 1 no teste de impulso."
                severity warning;

            assert outIm_mem(i) = x"0000"
                report "ERRO: outIm(" & integer'image(i) & ") deveria ser 0 no teste de impulso."
                severity warning;
        end loop;

        report "Simulacao finalizada.";
        assert false report "Fim da simulacao." severity failure;
    end process;

end architecture;
