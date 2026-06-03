library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity borboleta is
generic ( WIDTH: integer := 16 );
port(
    clk                   : in  std_logic;
    limpa                 : in  std_logic;
    Ar, Ai, Br, Bi, Wr, Wi : in  std_logic_vector(WIDTH-1 downto 0);
    Cr, Ci, Dr, Di         : out std_logic_vector(WIDTH-1 downto 0)
);
end entity;

architecture radix2 of borboleta is

component compressor_42_16bits is
port (
    A, B, C, D : in  std_logic_vector(15 downto 0);
    SOMA       : out std_logic_vector(17 downto 0)
);
end component;

constant MUL_W : integer := 2*WIDTH;

signal m1, m2, m3, m4 : signed(MUL_W-1 downto 0);

signal op1, op2, op3, op4 : std_logic_vector(MUL_W-1 downto 0);

signal t_op1, t_op2, t_op3, t_op4 : std_logic_vector(WIDTH-1 downto 0);

signal ar_r, ai_r, br_r, bi_r, wr_r, wi_r : std_logic_vector(WIDTH-1 downto 0);
signal t_op1_r, t_op2_r, t_op3_r, t_op4_r : std_logic_vector(WIDTH-1 downto 0);
signal ar_sum_r, ai_sum_r : std_logic_vector(WIDTH-1 downto 0);

signal nt_op1, nt_op2, nt_op3, nt_op4 : std_logic_vector(WIDTH-1 downto 0);

signal cr_temp, dr_temp, ci_temp, di_temp : std_logic_vector(17 downto 0);

begin

pipeline_regs: process(clk, limpa)
begin
    if limpa = '0' then
        ar_r <= (others => '0');
        ai_r <= (others => '0');
        br_r <= (others => '0');
        bi_r <= (others => '0');
        wr_r <= (others => '0');
        wi_r <= (others => '0');
        t_op1_r <= (others => '0');
        t_op2_r <= (others => '0');
        t_op3_r <= (others => '0');
        t_op4_r <= (others => '0');
        ar_sum_r <= (others => '0');
        ai_sum_r <= (others => '0');
    elsif rising_edge(clk) then
        ar_r <= Ar;
        ai_r <= Ai;
        br_r <= Br;
        bi_r <= Bi;
        wr_r <= Wr;
        wi_r <= Wi;
        t_op1_r <= t_op1;
        t_op2_r <= t_op2;
        t_op3_r <= t_op3;
        t_op4_r <= t_op4;
        ar_sum_r <= ar_r;
        ai_sum_r <= ai_r;
    end if;
end process;

-- ============================================================
-- Multiplicações complexas
-- ============================================================
-- m1 = Br * Wr
-- m2 = Bi * Wi
-- m3 = Br * Wi
-- m4 = Bi * Wr

m1 <= signed(br_r) * signed(wr_r);
m2 <= signed(bi_r) * signed(wi_r);
m3 <= signed(br_r) * signed(wi_r);
m4 <= signed(bi_r) * signed(wr_r);

op1 <= std_logic_vector(m1);
op2 <= std_logic_vector(m2);
op3 <= std_logic_vector(m3);
op4 <= std_logic_vector(m4);

-- ============================================================
-- Truncamento / realinhamento para WIDTH bits
-- bit de sinal: MUL_W-1
-- bits úteis  : MUL_W-4 downto 14
--
-- Para WIDTH = 16 e MUL_W = 32:
-- sinal = bit 31
-- dados = bits 28 downto 14
-- ============================================================

t_op1 <= op1(MUL_W-1) & op1(MUL_W-4 downto 14); -- Br*Wr
t_op2 <= op2(MUL_W-1) & op2(MUL_W-4 downto 14); -- Bi*Wi
t_op3 <= op3(MUL_W-1) & op3(MUL_W-4 downto 14); -- Br*Wi
t_op4 <= op4(MUL_W-1) & op4(MUL_W-4 downto 14); -- Bi*Wr

-- ============================================================
-- Versões negativas dos termos truncados
-- ============================================================

nt_op1 <= std_logic_vector(-signed(t_op1_r)); -- -Br*Wr
nt_op2 <= std_logic_vector(-signed(t_op2_r)); -- -Bi*Wi
nt_op3 <= std_logic_vector(-signed(t_op3_r)); -- -Br*Wi
nt_op4 <= std_logic_vector(-signed(t_op4_r)); -- -Bi*Wr

-- ============================================================
-- Estágios usando compressor 4:2
-- ============================================================
-- Tr = Br*Wr - Bi*Wi = t_op1 - t_op2
-- Ti = Br*Wi + Bi*Wr = t_op3 + t_op4
--
-- Cr = Ar + Tr = Ar + t_op1 - t_op2
-- Dr = Ar - Tr = Ar - t_op1 + t_op2
-- Ci = Ai + Ti = Ai + t_op3 + t_op4
-- Di = Ai - Ti = Ai - t_op3 - t_op4
-- ============================================================

estagio1_Cr : compressor_42_16bits
port map (
    A    => ar_sum_r,
    B    => t_op1_r,
    C    => nt_op2,
    D    => (others => '0'),
    SOMA => cr_temp
);

estagio2_Dr : compressor_42_16bits
port map (
    A    => ar_sum_r,
    B    => nt_op1,
    C    => t_op2_r,
    D    => (others => '0'),
    SOMA => dr_temp
);

estagio3_Ci : compressor_42_16bits
port map (
    A    => ai_sum_r,
    B    => t_op3_r,
    C    => t_op4_r,
    D    => (others => '0'),
    SOMA => ci_temp
);

estagio4_Di : compressor_42_16bits
port map (
    A    => ai_sum_r,
    B    => nt_op3,
    C    => nt_op4,
    D    => (others => '0'),
    SOMA => di_temp
);

-- ============================================================
-- Redução de 18 bits para 16 bits
-- ============================================================

Cr <= cr_temp(17) & cr_temp(WIDTH-2 downto 0);
Ci <= ci_temp(17) & ci_temp(WIDTH-2 downto 0);
Dr <= dr_temp(17) & dr_temp(WIDTH-2 downto 0);
Di <= di_temp(17) & di_temp(WIDTH-2 downto 0);

end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture hls_stage of borboleta is

component compressor_42_16bits is
port (
    A, B, C, D : in  std_logic_vector(15 downto 0);
    SOMA       : out std_logic_vector(17 downto 0)
);
end component;

constant MUL_W : integer := 2*WIDTH;

signal m1, m2, m3, m4 : signed(MUL_W-1 downto 0);

signal op1, op2, op3, op4 : std_logic_vector(MUL_W-1 downto 0);
signal t_op1, t_op2, t_op3, t_op4 : std_logic_vector(WIDTH-1 downto 0);
signal nt_op1, nt_op2, nt_op3, nt_op4 : std_logic_vector(WIDTH-1 downto 0);

signal cr_temp, dr_temp, ci_temp, di_temp : std_logic_vector(17 downto 0);

begin

m1 <= signed(Br) * signed(Wr);
m2 <= signed(Bi) * signed(Wi);
m3 <= signed(Br) * signed(Wi);
m4 <= signed(Bi) * signed(Wr);

op1 <= std_logic_vector(m1);
op2 <= std_logic_vector(m2);
op3 <= std_logic_vector(m3);
op4 <= std_logic_vector(m4);

t_op1 <= op1(MUL_W-1) & op1(MUL_W-4 downto 14);
t_op2 <= op2(MUL_W-1) & op2(MUL_W-4 downto 14);
t_op3 <= op3(MUL_W-1) & op3(MUL_W-4 downto 14);
t_op4 <= op4(MUL_W-1) & op4(MUL_W-4 downto 14);

nt_op1 <= std_logic_vector(-signed(t_op1));
nt_op2 <= std_logic_vector(-signed(t_op2));
nt_op3 <= std_logic_vector(-signed(t_op3));
nt_op4 <= std_logic_vector(-signed(t_op4));

estagio1_Cr : compressor_42_16bits
port map (
    A    => Ar,
    B    => t_op1,
    C    => nt_op2,
    D    => (others => '0'),
    SOMA => cr_temp
);

estagio2_Dr : compressor_42_16bits
port map (
    A    => Ar,
    B    => nt_op1,
    C    => t_op2,
    D    => (others => '0'),
    SOMA => dr_temp
);

estagio3_Ci : compressor_42_16bits
port map (
    A    => Ai,
    B    => t_op3,
    C    => t_op4,
    D    => (others => '0'),
    SOMA => ci_temp
);

estagio4_Di : compressor_42_16bits
port map (
    A    => Ai,
    B    => nt_op3,
    C    => nt_op4,
    D    => (others => '0'),
    SOMA => di_temp
);

Cr <= (others => '0') when limpa = '0' else cr_temp(17) & cr_temp(WIDTH-2 downto 0);
Ci <= (others => '0') when limpa = '0' else ci_temp(17) & ci_temp(WIDTH-2 downto 0);
Dr <= (others => '0') when limpa = '0' else dr_temp(17) & dr_temp(WIDTH-2 downto 0);
Di <= (others => '0') when limpa = '0' else di_temp(17) & di_temp(WIDTH-2 downto 0);

end architecture;
