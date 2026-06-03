library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_design is
generic ( WIDTH: integer := 16 );
port (
clock          : in  std_logic;
limpa          : in  std_logic;
carrega_amostra: in  std_logic;
indice_amostra : in  std_logic_vector(3 downto 0);
entrada_re     : in  std_logic_vector(WIDTH-1 downto 0);
entrada_im     : in  std_logic_vector(WIDTH-1 downto 0);
indice_saida   : in  std_logic_vector(3 downto 0);
saida_re       : out std_logic_vector(WIDTH-1 downto 0);
saida_im       : out std_logic_vector(WIDTH-1 downto 0);
saida_valida   : out std_logic
);
end entity;

architecture fft_16 of top_level_design is

component rom is
generic ( WIDTH: integer := 16 );
port (
	adress: in integer range 0 to 7;
	wr:  out std_logic_vector( WIDTH-1 downto 0);
	wi:  out std_logic_vector( WIDTH-1 downto 0)
);
end component;

component registrador is
generic ( WIDTH: integer := 16 );
port (
clk   : in  std_logic;
limpa : in  std_logic;
D     : in  std_logic_vector( WIDTH-1 downto 0);
Q     : out std_logic_vector( WIDTH-1 downto 0)
);
end component;

component mux2inputs is
generic ( WIDTH: integer := 16 );
port (
	sel : in  std_logic;
	A0  : in  std_logic_vector( WIDTH-1 downto 0);
	A1  : in  std_logic_vector( WIDTH-1 downto 0);
	Y   : out std_logic_vector( WIDTH-1 downto 0)
);
end component;

component mux8inputs is
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
end component;

component fsm is
port (
clock: in std_logic;
limpa: in std_logic;
temp1: out std_logic;
temp3r1,temp3r2: out std_logic_vector (2 downto 0);
temp4r1,temp4r2: out std_logic;
temp5r1,temp5r2: out std_logic;
endereco_rom: out integer range 0 to 7;
hab: out std_logic_vector(15 downto 0)
);
end component;

component radix2_32out is
port (
	Ar     : in  std_logic_vector(15 downto 0);
	Ai     : in  std_logic_vector(15 downto 0);
	Br     : in  std_logic_vector(15 downto 0);
	Bi     : in  std_logic_vector(15 downto 0);
	Wr     : in  std_logic_vector(15 downto 0);
	Wi     : in  std_logic_vector(15 downto 0);
	Cr     : out std_logic_vector(31 downto 0);
	Dr     : out std_logic_vector(31 downto 0);
	Ci     : out std_logic_vector(31 downto 0);
	Di     : out std_logic_vector(31 downto 0);
	ap_rst : in  std_logic
);
end component;

signal temp1: std_logic;
signal temp3r1,temp3r2: std_logic_vector(2 downto 0);
signal temp4r1,temp4r2: std_logic;
signal temp5r1,temp5r2: std_logic;
signal endereco_rom: integer range 0 to 7;
signal hab: std_logic_vector(15 downto 0);

signal Xr0,Xr1,Xr2,Xr3,Xr4,Xr5,Xr6,Xr7,Xr8,Xr9,Xr10,Xr11,Xr12,Xr13,Xr14,Xr15: std_logic_vector(WIDTH-1 downto 0);
signal Xi0,Xi1,Xi2,Xi3,Xi4,Xi5,Xi6,Xi7,Xi8,Xi9,Xi10,Xi11,Xi12,Xi13,Xi14,Xi15: std_logic_vector(WIDTH-1 downto 0);
signal Re0,Re1,Re2,Re3,Re4,Re5,Re6,Re7,Re8,Re9,Re10,Re11,Re12,Re13,Re14,Re15: std_logic_vector(WIDTH-1 downto 0);
signal Im0,Im1,Im2,Im3,Im4,Im5,Im6,Im7,Im8,Im9,Im10,Im11,Im12,Im13,Im14,Im15: std_logic_vector(WIDTH-1 downto 0);
signal Tr0,Tr1,Tr2,Tr3,Tr4,Tr5,Tr6,Tr7,Tr8,Tr9,Tr10,Tr11,Tr12,Tr13,Tr14,Tr15: std_logic_vector(WIDTH-1 downto 0);
signal Ti0,Ti1,Ti2,Ti3,Ti4,Ti5,Ti6,Ti7,Ti8,Ti9,Ti10,Ti11,Ti12,Ti13,Ti14,Ti15: std_logic_vector(WIDTH-1 downto 0);
signal Tra0,Tra1,Tra2,Tra3,Tra4,Tra5,Tra6,Tra7,Tra8,Tra9,Tra10,Tra11,Tra12,Tra13,Tra14,Tra15: std_logic_vector(WIDTH-1 downto 0);
signal Tia0,Tia1,Tia2,Tia3,Tia4,Tia5,Tia6,Tia7,Tia8,Tia9,Tia10,Tia11,Tia12,Tia13,Tia14,Tia15: std_logic_vector(WIDTH-1 downto 0);

signal ar,ai,br,bi: std_logic_vector(WIDTH-1 downto 0);
signal wr,wi: std_logic_vector(WIDTH-1 downto 0);
signal cr,ci,dr,di: std_logic_vector(WIDTH-1 downto 0);
signal cr32,ci32,dr32,di32: std_logic_vector(31 downto 0);
signal p0r,p1r,p0i,p1i: std_logic_vector(WIDTH-1 downto 0);
signal varR1,varR2,varI1,varI2: std_logic_vector(WIDTH-1 downto 0);

type vetor_pontos is array (0 to 15) of std_logic_vector(WIDTH-1 downto 0);

signal saida_re_mem: vetor_pontos;
signal saida_im_mem: vetor_pontos;
signal captura_saida_pendente: std_logic;
signal resultado_valido: std_logic;
signal fim_fft: std_logic;

begin

entrada_serial: process(clock)
begin
	if rising_edge(clock) then
		if carrega_amostra = '1' then
			case to_integer(unsigned(indice_amostra)) is
				when 0 =>
					Xr0 <= entrada_re;
					Xi0 <= entrada_im;
				when 1 =>
					Xr1 <= entrada_re;
					Xi1 <= entrada_im;
				when 2 =>
					Xr2 <= entrada_re;
					Xi2 <= entrada_im;
				when 3 =>
					Xr3 <= entrada_re;
					Xi3 <= entrada_im;
				when 4 =>
					Xr4 <= entrada_re;
					Xi4 <= entrada_im;
				when 5 =>
					Xr5 <= entrada_re;
					Xi5 <= entrada_im;
				when 6 =>
					Xr6 <= entrada_re;
					Xi6 <= entrada_im;
				when 7 =>
					Xr7 <= entrada_re;
					Xi7 <= entrada_im;
				when 8 =>
					Xr8 <= entrada_re;
					Xi8 <= entrada_im;
				when 9 =>
					Xr9 <= entrada_re;
					Xi9 <= entrada_im;
				when 10 =>
					Xr10 <= entrada_re;
					Xi10 <= entrada_im;
				when 11 =>
					Xr11 <= entrada_re;
					Xi11 <= entrada_im;
				when 12 =>
					Xr12 <= entrada_re;
					Xi12 <= entrada_im;
				when 13 =>
					Xr13 <= entrada_re;
					Xi13 <= entrada_im;
				when 14 =>
					Xr14 <= entrada_re;
					Xi14 <= entrada_im;
				when 15 =>
					Xr15 <= entrada_re;
					Xi15 <= entrada_im;
				when others =>
					null;
			end case;
		end if;
	end if;
end process;

fim_fft <= '1' when hab(14) = '1' and hab(15) = '1' and endereco_rom = 7 else '0';

captura_saida: process(clock, limpa)
begin
	if limpa = '0' then
		for i in 0 to 15 loop
			saida_re_mem(i) <= (others => '0');
			saida_im_mem(i) <= (others => '0');
		end loop;
		captura_saida_pendente <= '0';
		resultado_valido <= '0';
	elsif rising_edge(clock) then
		if captura_saida_pendente = '1' then
			saida_re_mem(0) <= Re0;
			saida_im_mem(0) <= Im0;
			saida_re_mem(1) <= Re8;
			saida_im_mem(1) <= Im8;
			saida_re_mem(2) <= Re4;
			saida_im_mem(2) <= Im4;
			saida_re_mem(3) <= Re12;
			saida_im_mem(3) <= Im12;
			saida_re_mem(4) <= Re2;
			saida_im_mem(4) <= Im2;
			saida_re_mem(5) <= Re10;
			saida_im_mem(5) <= Im10;
			saida_re_mem(6) <= Re6;
			saida_im_mem(6) <= Im6;
			saida_re_mem(7) <= Re14;
			saida_im_mem(7) <= Im14;
			saida_re_mem(8) <= Re1;
			saida_im_mem(8) <= Im1;
			saida_re_mem(9) <= Re9;
			saida_im_mem(9) <= Im9;
			saida_re_mem(10) <= Re5;
			saida_im_mem(10) <= Im5;
			saida_re_mem(11) <= Re13;
			saida_im_mem(11) <= Im13;
			saida_re_mem(12) <= Re3;
			saida_im_mem(12) <= Im3;
			saida_re_mem(13) <= Re11;
			saida_im_mem(13) <= Im11;
			saida_re_mem(14) <= Re7;
			saida_im_mem(14) <= Im7;
			saida_re_mem(15) <= Re15;
			saida_im_mem(15) <= Im15;
			resultado_valido <= '1';
		end if;

		captura_saida_pendente <= fim_fft;
	end if;
end process;

saida_re <= saida_re_mem(to_integer(unsigned(indice_saida)));
saida_im <= saida_im_mem(to_integer(unsigned(indice_saida)));
saida_valida <= resultado_valido;

estagio_1_Re0: mux2inputs port map (temp1, Xr0, p0r,Tr0);
estagio_2_Re0: mux2inputs port map (hab(0), Re0, Tr0, Tra0);
estagio_3_Re0: registrador port map (clock,limpa,Tra0,Re0);
estagio_1_Im0: mux2inputs port map (temp1, Xi0, p0i,Ti0);
estagio_2_Im0: mux2inputs port map (hab(0), Im0, Ti0, Tia0);
estagio_3_Im0: registrador port map (clock,limpa,Tia0,Im0);
estagio_1_Re1: mux2inputs port map (temp1, Xr1, p1r,Tr1);
estagio_2_Re1: mux2inputs port map (hab(1), Re1, Tr1, Tra1);
estagio_3_Re1: registrador port map (clock,limpa,Tra1,Re1);
estagio_1_Im1: mux2inputs port map (temp1, Xi1, p1i,Ti1);
estagio_2_Im1: mux2inputs port map (hab(1), Im1, Ti1, Tia1);
estagio_3_Im1: registrador port map (clock,limpa,Tia1,Im1);
estagio_1_Re2: mux2inputs port map (temp1, Xr2, p1r,Tr2);
estagio_2_Re2: mux2inputs port map (hab(2), Re2, Tr2, Tra2);
estagio_3_Re2: registrador port map (clock,limpa,Tra2,Re2);
estagio_1_Im2: mux2inputs port map (temp1, Xi2, p1i,Ti2);
estagio_2_Im2: mux2inputs port map (hab(2), Im2, Ti2, Tia2);
estagio_3_Im2: registrador port map (clock,limpa,Tia2,Im2);
estagio_1_Re3: mux2inputs port map (temp1, Xr3, p0r,Tr3);
estagio_2_Re3: mux2inputs port map (hab(3), Re3, Tr3, Tra3);
estagio_3_Re3: registrador port map (clock,limpa,Tra3,Re3);
estagio_1_Im3: mux2inputs port map (temp1, Xi3, p0i,Ti3);
estagio_2_Im3: mux2inputs port map (hab(3), Im3, Ti3, Tia3);
estagio_3_Im3: registrador port map (clock,limpa,Tia3,Im3);
estagio_1_Re4: mux2inputs port map (temp1, Xr4, p1r,Tr4);
estagio_2_Re4: mux2inputs port map (hab(4), Re4, Tr4, Tra4);
estagio_3_Re4: registrador port map (clock,limpa,Tra4,Re4);
estagio_1_Im4: mux2inputs port map (temp1, Xi4, p1i,Ti4);
estagio_2_Im4: mux2inputs port map (hab(4), Im4, Ti4, Tia4);
estagio_3_Im4: registrador port map (clock,limpa,Tia4,Im4);
estagio_1_Re5: mux2inputs port map (temp1, Xr5, p0r,Tr5);
estagio_2_Re5: mux2inputs port map (hab(5), Re5, Tr5, Tra5);
estagio_3_Re5: registrador port map (clock,limpa,Tra5,Re5);
estagio_1_Im5: mux2inputs port map (temp1, Xi5, p0i,Ti5);
estagio_2_Im5: mux2inputs port map (hab(5), Im5, Ti5, Tia5);
estagio_3_Im5: registrador port map (clock,limpa,Tia5,Im5);
estagio_1_Re6: mux2inputs port map (temp1, Xr6, p0r,Tr6);
estagio_2_Re6: mux2inputs port map (hab(6), Re6, Tr6, Tra6);
estagio_3_Re6: registrador port map (clock,limpa,Tra6,Re6);
estagio_1_Im6: mux2inputs port map (temp1, Xi6, p0i,Ti6);
estagio_2_Im6: mux2inputs port map (hab(6), Im6, Ti6, Tia6);
estagio_3_Im6: registrador port map (clock,limpa,Tia6,Im6);
estagio_1_Re7: mux2inputs port map (temp1, Xr7, p1r,Tr7);
estagio_2_Re7: mux2inputs port map (hab(7), Re7, Tr7, Tra7);
estagio_3_Re7: registrador port map (clock,limpa,Tra7,Re7);
estagio_1_Im7: mux2inputs port map (temp1, Xi7, p1i,Ti7);
estagio_2_Im7: mux2inputs port map (hab(7), Im7, Ti7, Tia7);
estagio_3_Im7: registrador port map (clock,limpa,Tia7,Im7);
estagio_1_Re8: mux2inputs port map (temp1, Xr8, p1r,Tr8);
estagio_2_Re8: mux2inputs port map (hab(8), Re8, Tr8, Tra8);
estagio_3_Re8: registrador port map (clock,limpa,Tra8,Re8);
estagio_1_Im8: mux2inputs port map (temp1, Xi8, p1i,Ti8);
estagio_2_Im8: mux2inputs port map (hab(8), Im8, Ti8, Tia8);
estagio_3_Im8: registrador port map (clock,limpa,Tia8,Im8);
estagio_1_Re9: mux2inputs port map (temp1, Xr9, p0r,Tr9);
estagio_2_Re9: mux2inputs port map (hab(9), Re9, Tr9, Tra9);
estagio_3_Re9: registrador port map (clock,limpa,Tra9,Re9);
estagio_1_Im9: mux2inputs port map (temp1, Xi9, p0i,Ti9);
estagio_2_Im9: mux2inputs port map (hab(9), Im9, Ti9, Tia9);
estagio_3_Im9: registrador port map (clock,limpa,Tia9,Im9);
estagio_1_Re10: mux2inputs port map (temp1, Xr10, p0r,Tr10);
estagio_2_Re10: mux2inputs port map (hab(10), Re10, Tr10, Tra10);
estagio_3_Re10: registrador port map (clock,limpa,Tra10,Re10);
estagio_1_Im10: mux2inputs port map (temp1, Xi10, p0i,Ti10);
estagio_2_Im10: mux2inputs port map (hab(10), Im10, Ti10, Tia10);
estagio_3_Im10: registrador port map (clock,limpa,Tia10,Im10);
estagio_1_Re11: mux2inputs port map (temp1, Xr11, p1r,Tr11);
estagio_2_Re11: mux2inputs port map (hab(11), Re11, Tr11, Tra11);
estagio_3_Re11: registrador port map (clock,limpa,Tra11,Re11);
estagio_1_Im11: mux2inputs port map (temp1, Xi11, p1i,Ti11);
estagio_2_Im11: mux2inputs port map (hab(11), Im11, Ti11, Tia11);
estagio_3_Im11: registrador port map (clock,limpa,Tia11,Im11);
estagio_1_Re12: mux2inputs port map (temp1, Xr12, p0r,Tr12);
estagio_2_Re12: mux2inputs port map (hab(12), Re12, Tr12, Tra12);
estagio_3_Re12: registrador port map (clock,limpa,Tra12,Re12);
estagio_1_Im12: mux2inputs port map (temp1, Xi12, p0i,Ti12);
estagio_2_Im12: mux2inputs port map (hab(12), Im12, Ti12, Tia12);
estagio_3_Im12: registrador port map (clock,limpa,Tia12,Im12);
estagio_1_Re13: mux2inputs port map (temp1, Xr13, p1r,Tr13);
estagio_2_Re13: mux2inputs port map (hab(13), Re13, Tr13, Tra13);
estagio_3_Re13: registrador port map (clock,limpa,Tra13,Re13);
estagio_1_Im13: mux2inputs port map (temp1, Xi13, p1i,Ti13);
estagio_2_Im13: mux2inputs port map (hab(13), Im13, Ti13, Tia13);
estagio_3_Im13: registrador port map (clock,limpa,Tia13,Im13);
estagio_1_Re14: mux2inputs port map (temp1, Xr14, p1r,Tr14);
estagio_2_Re14: mux2inputs port map (hab(14), Re14, Tr14, Tra14);
estagio_3_Re14: registrador port map (clock,limpa,Tra14,Re14);
estagio_1_Im14: mux2inputs port map (temp1, Xi14, p1i,Ti14);
estagio_2_Im14: mux2inputs port map (hab(14), Im14, Ti14, Tia14);
estagio_3_Im14: registrador port map (clock,limpa,Tia14,Im14);
estagio_1_Re15: mux2inputs port map (temp1, Xr15, p0r,Tr15);
estagio_2_Re15: mux2inputs port map (hab(15), Re15, Tr15, Tra15);
estagio_3_Re15: registrador port map (clock,limpa,Tra15,Re15);
estagio_1_Im15: mux2inputs port map (temp1, Xi15, p0i,Ti15);
estagio_2_Im15: mux2inputs port map (hab(15), Im15, Ti15, Tia15);
estagio_3_Im15: registrador port map (clock,limpa,Tia15,Im15);

estagioROM: rom port map(endereco_rom,wr,wi);

estagio_4_Ar: mux8inputs port map(temp3r1,Re0,Re12,Re10,Re6,Re9,Re5,Re3,Re15,varR1);
estagio_4_Br: mux8inputs port map(temp3r2,Re8,Re4,Re2,Re14,Re1,Re13,Re11,Re7,varR2);
estagio_4_Ai: mux8inputs port map(temp3r1,Im0,Im12,Im10,Im6,Im9,Im5,Im3,Im15,varI1);
estagio_4_Bi: mux8inputs port map(temp3r2,Im8,Im4,Im2,Im14,Im1,Im13,Im11,Im7,varI2);

estagio_5_Ar: mux2inputs port map (temp4r1,varR1,varR2,ar);
estagio_5_Br: mux2inputs port map (temp4r2,varR1,varR2,br);
estagio_5_Ai: mux2inputs port map (temp4r1,varI1,varI2,ai);
estagio_5_Bi: mux2inputs port map (temp4r2,varI1,varI2,bi);

estagio_6_radix2_32out: radix2_32out
	port map (
		Ar     => ar,
		Ai     => ai,
		Br     => br,
		Bi     => bi,
		Wr     => wr,
		Wi     => wi,
		Cr     => cr32,
		Dr     => dr32,
		Ci     => ci32,
		Di     => di32,
		ap_rst => not limpa
	);

cr <= cr32(WIDTH-1 downto 0);
ci <= ci32(WIDTH-1 downto 0);
dr <= dr32(WIDTH-1 downto 0);
di <= di32(WIDTH-1 downto 0);

estagio7_Ar: mux2inputs port map (temp5r1,cr,dr,p0r);
estagio7_Br: mux2inputs port map (temp5r2,cr,dr,p1r);
estagio7_Ai: mux2inputs port map (temp5r1,ci,di,p0i);
estagio7_Bi: mux2inputs port map (temp5r2,ci,di,p1i);

estagio8_FSM: fsm port map(clock,limpa,temp1,temp3r1,temp3r2,temp4r1,temp4r2,temp5r1,temp5r2,endereco_rom,hab);






end architecture;
