library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
use std.env.all;
use IEEE.std_logic_textio.all;

entity tb_top_level_design_serial_csv is
end entity;

architecture sim of tb_top_level_design_serial_csv is

    constant WIDTH      : integer := 16;
    constant CLK_PERIOD : time := 6666 ps;

    constant INPUT_DIR  : string := "F:/github_projects/FFT_Completa_Ferreirinha/entradas_tb/inputs/";
    constant OUTPUT_CSV : string := "F:/github_projects/Codigos ICECS FFT/FFT_Completa_Ferreirinha/testbenchs/FFT_RTL_outputs.csv";

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

    constant MAX_FRAMES : integer := 450;

    subtype word16_t is std_logic_vector(WIDTH-1 downto 0);
    type frame_t is array (0 to 15) of word16_t;

    signal clock           : std_logic := '0';
    signal limpa           : std_logic := '0';
    signal carrega_amostra : std_logic := '0';
    signal indice_amostra  : std_logic_vector(3 downto 0) := (others => '0');
    signal entrada_re      : word16_t := (others => '0');
    signal entrada_im      : word16_t := (others => '0');
    signal indice_saida    : std_logic_vector(3 downto 0) := (others => '0');
    signal saida_re        : word16_t;
    signal saida_im        : word16_t;
    signal saida_valida    : std_logic;

    signal Xr_mem : frame_t := (others => (others => '0'));
    signal Xi_mem : frame_t := (others => (others => '0'));

    file csv_out : text open write_mode is OUTPUT_CSV;

    function binstr_to_slv(s : string) return word16_t is
        variable result : word16_t := (others => '0');
        variable idx    : integer := 0;
        variable pos    : integer := s'high;
    begin
        while pos >= s'low loop
            if s(pos) = '0' then
                if idx < WIDTH then
                    result(idx) := '0';
                    idx := idx + 1;
                end if;
            elsif s(pos) = '1' then
                if idx < WIDTH then
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
        variable l      : line;
        variable idx    : integer := 0;
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
                value := binstr_to_slv(l.all);
                ok := true;
                exit;
            end if;
            idx := idx + 1;
        end loop;

        file_close(f);
    end procedure;

    procedure load_real_frame(
        constant frame : in integer;
        signal Xr      : out frame_t;
        variable ok_all: out boolean
    ) is
        variable ok  : boolean;
        variable tmp : word16_t;
    begin
        ok_all := true;

        read_value_from_file(INPUT_0R, frame, tmp, ok);
        Xr(0) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_1R, frame, tmp, ok);
        Xr(1) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_2R, frame, tmp, ok);
        Xr(2) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_3R, frame, tmp, ok);
        Xr(3) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_4R, frame, tmp, ok);
        Xr(4) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_5R, frame, tmp, ok);
        Xr(5) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_6R, frame, tmp, ok);
        Xr(6) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_7R, frame, tmp, ok);
        Xr(7) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_8R, frame, tmp, ok);
        Xr(8) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_9R, frame, tmp, ok);
        Xr(9) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_10R, frame, tmp, ok);
        Xr(10) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_11R, frame, tmp, ok);
        Xr(11) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_12R, frame, tmp, ok);
        Xr(12) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_13R, frame, tmp, ok);
        Xr(13) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_14R, frame, tmp, ok);
        Xr(14) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_15R, frame, tmp, ok);
        Xr(15) <= tmp;
        if not ok then ok_all := false; end if;
    end procedure;

    procedure load_imag_frame(
        constant frame : in integer;
        signal Xi      : out frame_t;
        variable ok_all: out boolean
    ) is
        variable ok  : boolean;
        variable tmp : word16_t;
    begin
        ok_all := true;

        read_value_from_file(INPUT_0I, frame, tmp, ok);
        Xi(0) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_1I, frame, tmp, ok);
        Xi(1) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_2I, frame, tmp, ok);
        Xi(2) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_3I, frame, tmp, ok);
        Xi(3) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_4I, frame, tmp, ok);
        Xi(4) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_5I, frame, tmp, ok);
        Xi(5) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_6I, frame, tmp, ok);
        Xi(6) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_7I, frame, tmp, ok);
        Xi(7) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_8I, frame, tmp, ok);
        Xi(8) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_9I, frame, tmp, ok);
        Xi(9) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_10I, frame, tmp, ok);
        Xi(10) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_11I, frame, tmp, ok);
        Xi(11) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_12I, frame, tmp, ok);
        Xi(12) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_13I, frame, tmp, ok);
        Xi(13) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_14I, frame, tmp, ok);
        Xi(14) <= tmp;
        if not ok then ok_all := false; end if;

        read_value_from_file(INPUT_15I, frame, tmp, ok);
        Xi(15) <= tmp;
        if not ok then ok_all := false; end if;
    end procedure;

begin

    clock <= not clock after CLK_PERIOD/2;

    dut : entity work.top_level_design
        generic map (
            WIDTH => WIDTH
        )
        port map (
            clock => clock,
            limpa => limpa,
            carrega_amostra => carrega_amostra,
            indice_amostra => indice_amostra,
            entrada_re => entrada_re,
            entrada_im => entrada_im,
            indice_saida => indice_saida,
            saida_re => saida_re,
            saida_im => saida_im,
            saida_valida => saida_valida
        );

    stimulus : process
        variable ok_real          : boolean;
        variable ok_imag          : boolean;
        variable csv_line         : line;
        variable timeout_counter  : integer;
        variable processed_frames : integer := 0;
    begin
        write(csv_line, string'("frame,k,outRe_hex,outIm_hex"));
        writeline(csv_out, csv_line);

        limpa <= '0';
        carrega_amostra <= '0';
        indice_amostra <= (others => '0');
        indice_saida <= (others => '0');
        entrada_re <= (others => '0');
        entrada_im <= (others => '0');
        wait for 3 * CLK_PERIOD;

        for frame in 0 to MAX_FRAMES - 1 loop
            limpa <= '0';
            carrega_amostra <= '0';
            wait until rising_edge(clock);

            load_real_frame(frame, Xr_mem, ok_real);
            load_imag_frame(frame, Xi_mem, ok_imag);
            wait for 0 ns;

            if not ok_real or not ok_imag then
                report "Fim dos arquivos ou erro de leitura no frame " & integer'image(frame) severity warning;
                exit;
            end if;

            for k in 0 to 15 loop
                indice_amostra <= std_logic_vector(to_unsigned(k, indice_amostra'length));
                entrada_re <= Xr_mem(k);
                entrada_im <= Xi_mem(k);
                carrega_amostra <= '1';
                wait until rising_edge(clock);
            end loop;

            carrega_amostra <= '0';
            entrada_re <= (others => '0');
            entrada_im <= (others => '0');

            limpa <= '1';
            wait until rising_edge(clock);

            timeout_counter := 0;
            while saida_valida /= '1' and timeout_counter < 80 loop
                wait until rising_edge(clock);
                timeout_counter := timeout_counter + 1;
            end loop;

            assert saida_valida = '1'
                report "Timeout esperando saida_valida no frame " & integer'image(frame)
                severity failure;

            for k in 0 to 15 loop
                indice_saida <= std_logic_vector(to_unsigned(k, indice_saida'length));
                wait for 1 ns;

                write(csv_line, frame);
                write(csv_line, string'(","));
                write(csv_line, k);
                write(csv_line, string'(","));
                hwrite(csv_line, saida_re);
                write(csv_line, string'(","));
                hwrite(csv_line, saida_im);
                writeline(csv_out, csv_line);
            end loop;

            processed_frames := processed_frames + 1;
            report "Frame " & integer'image(frame) & " gravado no CSV.";
        end loop;

        report "Simulacao finalizada. Frames processados=" & integer'image(processed_frames);
        stop;
        wait;
    end process;

end architecture;
