library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
use IEEE.std_logic_textio.all;

entity tb_fft16_hls_audio_inputs_csv is
end entity;

architecture sim of tb_fft16_hls_audio_inputs_csv is

    constant CLK_PERIOD : time := 10 ns;

    constant INPUT_DIR    : string := "F:/github_projects/codigo_modificado_c_ferreirinha/entradas_tb/inputs/";

    constant INPUT_0R  : string := INPUT_DIR & "inputs_0r.txt";
    constant INPUT_1R  : string := INPUT_DIR & "inputs_1r.txt";
    constant INPUT_2R  : string := INPUT_DIR & "inputs_2r.txt";
    constant INPUT_3R  : string := INPUT_DIR & "inputs_3r.txt";
    constant INPUT_4R  : string := INPUT_DIR & "inputs_4r.txt";
    constant INPUT_5R  : string := INPUT_DIR & "inputs_5r.txt";
    constant INPUT_6R  : string := INPUT_DIR & "inputs_6r.txt";
    constant INPUT_7R  : string := INPUT_DIR & "inputs_7r.txt";
    constant INPUT_8R  : string := INPUT_DIR & "inputs_8r.txt";
    constant INPUT_9R  : string := INPUT_DIR & "inputs_9r.txt";
    constant INPUT_10R : string := INPUT_DIR & "inputs_10r.txt";
    constant INPUT_11R : string := INPUT_DIR & "inputs_11r.txt";
    constant INPUT_12R : string := INPUT_DIR & "inputs_12r.txt";
    constant INPUT_13R : string := INPUT_DIR & "inputs_13r.txt";
    constant INPUT_14R : string := INPUT_DIR & "inputs_14r.txt";
    constant INPUT_15R : string := INPUT_DIR & "inputs_15r.txt";

    constant INPUT_0I  : string := INPUT_DIR & "inputs_0i.txt";
    constant INPUT_1I  : string := INPUT_DIR & "inputs_1i.txt";
    constant INPUT_2I  : string := INPUT_DIR & "inputs_2i.txt";
    constant INPUT_3I  : string := INPUT_DIR & "inputs_3i.txt";
    constant INPUT_4I  : string := INPUT_DIR & "inputs_4i.txt";
    constant INPUT_5I  : string := INPUT_DIR & "inputs_5i.txt";
    constant INPUT_6I  : string := INPUT_DIR & "inputs_6i.txt";
    constant INPUT_7I  : string := INPUT_DIR & "inputs_7i.txt";
    constant INPUT_8I  : string := INPUT_DIR & "inputs_8i.txt";
    constant INPUT_9I  : string := INPUT_DIR & "inputs_9i.txt";
    constant INPUT_10I : string := INPUT_DIR & "inputs_10i.txt";
    constant INPUT_11I : string := INPUT_DIR & "inputs_11i.txt";
    constant INPUT_12I : string := INPUT_DIR & "inputs_12i.txt";
    constant INPUT_13I : string := INPUT_DIR & "inputs_13i.txt";
    constant INPUT_14I : string := INPUT_DIR & "inputs_14i.txt";
    constant INPUT_15I : string := INPUT_DIR & "inputs_15i.txt";
    constant NUM_FRAMES   : integer := 450;

    subtype word16_t is std_logic_vector(15 downto 0);
    type mem16_t is array (0 to 15) of word16_t;

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

    signal clear_outputs : std_logic := '0';

    signal current_frame : integer := 0;
    signal wr_re0_valid  : std_logic := '0';
    signal wr_re1_valid  : std_logic := '0';
    signal wr_im0_valid  : std_logic := '0';
    signal wr_im1_valid  : std_logic := '0';

    signal wr_re0_addr : integer range 0 to 15 := 0;
    signal wr_re1_addr : integer range 0 to 15 := 0;
    signal wr_im0_addr : integer range 0 to 15 := 0;
    signal wr_im1_addr : integer range 0 to 15 := 0;

    signal wr_re0_data : std_logic_vector(15 downto 0) := (others => '0');
    signal wr_re1_data : std_logic_vector(15 downto 0) := (others => '0');
    signal wr_im0_data : std_logic_vector(15 downto 0) := (others => '0');
    signal wr_im1_data : std_logic_vector(15 downto 0) := (others => '0');

    file csv_out : text open write_mode is "F:/github_projects/Codigos ICECS FFT/hls_modificado_butterfly_RTL/testbenchs/FFT_hls_butterfly_RTL_outputs.csv";

    

    function is_clean(v : std_logic_vector) return boolean is
    begin
        for i in v'range loop
            if not (v(i) = '0' or v(i) = '1') then
                return false;
            end if;
        end loop;
        return true;
    end function;

    function slv_to_int(v : std_logic_vector(15 downto 0)) return integer is
    begin
        if is_clean(v) then
            return to_integer(signed(v));
        else
            return -99999;
        end if;
    end function;

    function binstr_to_slv(s : string) return word16_t is
        variable result : word16_t := (others => '0');
        variable idx    : integer := 0;
        variable pos    : integer := s'high;
    begin
        while pos >= s'low loop
            if s(pos) = '0' then
                if idx < 16 then
                    result(idx) := '0';
                    idx := idx + 1;
                end if;
            elsif s(pos) = '1' then
                if idx < 16 then
                    result(idx) := '1';
                    idx := idx + 1;
                end if;
            end if;

            pos := pos - 1;
        end loop;

        return result;
    end function;

    procedure read_value_from_file(
        constant filename   : in string;
        constant line_index : in integer;
        variable value      : out word16_t;
        variable ok         : out boolean
    ) is
        file f : text;
        variable status : file_open_status;
        variable l : line;
        variable idx : integer := 0;
        variable found : boolean := false;
        variable parsed : word16_t := (others => '0');
    begin
        ok := false;
        value := (others => '0');

        file_open(status, f, filename, read_mode);
        if status /= open_ok then
            return;
        end if;

        while not endfile(f) loop
            readline(f, l);
            if idx = line_index then
                parsed := binstr_to_slv(l.all);
                value := parsed;
                found := true;
                exit;
            end if;
            idx := idx + 1;
        end loop;

        file_close(f);
        ok := found;
    end procedure;

    procedure load_real_frame(
        constant frame : in integer;
        signal Xr_mem : out mem16_t;
        variable ok_all : out boolean
    ) is
        variable ok  : boolean;
        variable tmp : word16_t;
    begin
        ok_all := true;

        read_value_from_file(INPUT_0R, frame, tmp, ok);
        Xr_mem(0) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_1R, frame, tmp, ok);
        Xr_mem(1) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_2R, frame, tmp, ok);
        Xr_mem(2) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_3R, frame, tmp, ok);
        Xr_mem(3) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_4R, frame, tmp, ok);
        Xr_mem(4) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_5R, frame, tmp, ok);
        Xr_mem(5) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_6R, frame, tmp, ok);
        Xr_mem(6) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_7R, frame, tmp, ok);
        Xr_mem(7) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_8R, frame, tmp, ok);
        Xr_mem(8) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_9R, frame, tmp, ok);
        Xr_mem(9) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_10R, frame, tmp, ok);
        Xr_mem(10) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_11R, frame, tmp, ok);
        Xr_mem(11) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_12R, frame, tmp, ok);
        Xr_mem(12) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_13R, frame, tmp, ok);
        Xr_mem(13) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_14R, frame, tmp, ok);
        Xr_mem(14) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_15R, frame, tmp, ok);
        Xr_mem(15) <= tmp;
        if not ok then ok_all := false; end if;
    end procedure;

    procedure load_imag_frame(
        constant frame : in integer;
        signal Xi_mem : out mem16_t;
        variable ok_all : out boolean
    ) is
        variable ok  : boolean;
        variable tmp : word16_t;
    begin
        ok_all := true;

        read_value_from_file(INPUT_0I, frame, tmp, ok);
        Xi_mem(0) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_1I, frame, tmp, ok);
        Xi_mem(1) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_2I, frame, tmp, ok);
        Xi_mem(2) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_3I, frame, tmp, ok);
        Xi_mem(3) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_4I, frame, tmp, ok);
        Xi_mem(4) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_5I, frame, tmp, ok);
        Xi_mem(5) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_6I, frame, tmp, ok);
        Xi_mem(6) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_7I, frame, tmp, ok);
        Xi_mem(7) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_8I, frame, tmp, ok);
        Xi_mem(8) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_9I, frame, tmp, ok);
        Xi_mem(9) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_10I, frame, tmp, ok);
        Xi_mem(10) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_11I, frame, tmp, ok);
        Xi_mem(11) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_12I, frame, tmp, ok);
        Xi_mem(12) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_13I, frame, tmp, ok);
        Xi_mem(13) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_14I, frame, tmp, ok);
        Xi_mem(14) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_15I, frame, tmp, ok);
        Xi_mem(15) <= tmp;
        if not ok then ok_all := false; end if;
    end procedure;

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

    capture_outputs : process(ap_clk)
    begin
        if falling_edge(ap_clk) then
            wr_re0_valid <= '0';
            wr_re1_valid <= '0';
            wr_im0_valid <= '0';
            wr_im1_valid <= '0';

            if clear_outputs = '1' then
                outRe_mem <= (others => (others => '0'));
                outIm_mem <= (others => (others => '0'));
            else
                if outRe_ce0 = '1' and outRe_we0 = '1' and is_clean(outRe_address0) and is_clean(outRe_d0) then
                    outRe_mem(to_integer(unsigned(outRe_address0))) <= outRe_d0;
                    wr_re0_valid <= '1';
                    wr_re0_addr  <= to_integer(unsigned(outRe_address0));
                    wr_re0_data  <= outRe_d0;
                end if;

                if outRe_ce1 = '1' and outRe_we1 = '1' and is_clean(outRe_address1) and is_clean(outRe_d1) then
                    outRe_mem(to_integer(unsigned(outRe_address1))) <= outRe_d1;
                    wr_re1_valid <= '1';
                    wr_re1_addr  <= to_integer(unsigned(outRe_address1));
                    wr_re1_data  <= outRe_d1;
                end if;

                if outIm_ce0 = '1' and outIm_we0 = '1' and is_clean(outIm_address0) and is_clean(outIm_d0) then
                    outIm_mem(to_integer(unsigned(outIm_address0))) <= outIm_d0;
                    wr_im0_valid <= '1';
                    wr_im0_addr  <= to_integer(unsigned(outIm_address0));
                    wr_im0_data  <= outIm_d0;
                end if;

                if outIm_ce1 = '1' and outIm_we1 = '1' and is_clean(outIm_address1) and is_clean(outIm_d1) then
                    outIm_mem(to_integer(unsigned(outIm_address1))) <= outIm_d1;
                    wr_im1_valid <= '1';
                    wr_im1_addr  <= to_integer(unsigned(outIm_address1));
                    wr_im1_data  <= outIm_d1;
                end if;
            end if;
        end if;
    end process;

    stimulus : process
        variable ok_val : boolean;
        variable tmp_value : word16_t;
        variable ok_real : boolean;
        variable ok_imag : boolean;
        variable csv_line : line;
    begin
        write(csv_line, string'("frame,k,outRe_hex,outIm_hex"));
        writeline(csv_out, csv_line);

        ap_rst   <= '1';
        ap_start <= '0';
        wait for 5 * CLK_PERIOD;
        ap_rst <= '0';
        wait for 2 * CLK_PERIOD;

        for frame in 0 to NUM_FRAMES - 1 loop
            current_frame <= frame;

            load_real_frame(frame, Xr_mem, ok_real);
            load_imag_frame(frame, Xi_mem, ok_imag);

            if not ok_real or not ok_imag then
                report "Fim dos arquivos ou erro de leitura no frame " & integer'image(frame) severity warning;
                exit;
            end if;

            wait until rising_edge(ap_clk);

            clear_outputs <= '1';
            wait until falling_edge(ap_clk);
            clear_outputs <= '0';

            ap_rst   <= '1';
            ap_start <= '0';
            wait for 5 * CLK_PERIOD;
            ap_rst <= '0';
            wait for 2 * CLK_PERIOD;

            wait until rising_edge(ap_clk);
            ap_start <= '1';
            wait until rising_edge(ap_clk);
            ap_start <= '0';

            wait until ap_done = '1';
            wait for 20 * CLK_PERIOD;

            for k in 0 to 15 loop
                write(csv_line, current_frame);
                write(csv_line, string'(","));
                write(csv_line, k);
                write(csv_line, string'(","));
                hwrite(csv_line, outRe_mem(k));
                write(csv_line, string'(","));
                hwrite(csv_line, outIm_mem(k));
                writeline(csv_out, csv_line);
            end loop;

            report "===== RESULTADO FFT16 - FRAME " & integer'image(frame) & " =====";
            for i in 0 to 15 loop
                report "k=" & integer'image(i) &
                       " outRe=" & integer'image(slv_to_int(outRe_mem(i))) &
                       " outIm=" & integer'image(slv_to_int(outIm_mem(i)));
            end loop;
        end loop;

        report "Simulacao finalizada. Frames processados=" & integer'image(NUM_FRAMES);
        assert false report "Fim da simulacao." severity failure;
    end process;

end architecture;
