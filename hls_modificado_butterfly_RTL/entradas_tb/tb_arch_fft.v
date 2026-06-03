`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module tst;

reg clock=1'b0;
reg limpa=1'b0;
reg  [15:0] Xr0,Xi0,Xr1,Xi1,Xr2,Xi2,Xr3,Xi3,Xr4,Xi4,Xr5,Xi5,Xr6,Xi6,Xr7,Xi7,Xr8,Xi8,Xr9,Xi9,Xr10,Xi10,Xr11,Xi11,Xr12,Xi12,Xr13,Xi13,Xr14,Xi14,Xr15,Xi15;
wire [15:0] sair0 ,saii0,sair1 ,saii1,sair2 ,saii2,sair3 ,saii3,sair4 ,saii4,sair5 ,saii5,sair6 ,saii6,sair7 ,saii7,sair8 ,saii8,sair9 ,saii9,sair10,saii10,sair11,saii11,sair12,saii12,sair13,saii13,sair14,saii14,sair15,saii15;

parameter CLOCK_PERIOD =6.666; // 10 time units
// Clock generation
 always begin
 #(CLOCK_PERIOD / 2);
 clock = ~clock;
 end

reg [15:0] read_data_0i [0:448];
reg [15:0] read_data_1i [0:448];
reg [15:0] read_data_2i [0:448];
reg [15:0] read_data_3i [0:448];
reg [15:0] read_data_4i [0:448];
reg [15:0] read_data_5i [0:448];
reg [15:0] read_data_6i [0:448];
reg [15:0] read_data_7i [0:448];
reg [15:0] read_data_8i [0:448];
reg [15:0] read_data_9i [0:448];
reg [15:0] read_data_10i [0:448];
reg [15:0] read_data_11i [0:448];
reg [15:0] read_data_12i [0:448];
reg [15:0] read_data_13i [0:448];
reg [15:0] read_data_14i [0:448];
reg [15:0] read_data_15i [0:448];

reg [15:0] read_data_0r [0:448];
reg [15:0] read_data_1r [0:448];
reg [15:0] read_data_2r [0:448];
reg [15:0] read_data_3r [0:448];
reg [15:0] read_data_4r [0:448];
reg [15:0] read_data_5r [0:448];
reg [15:0] read_data_6r [0:448];
reg [15:0] read_data_7r [0:448];
reg [15:0] read_data_8r [0:448];
reg [15:0] read_data_9r [0:448];
reg [15:0] read_data_10r [0:448];
reg [15:0] read_data_11r [0:448];
reg [15:0] read_data_12r [0:448];
reg [15:0] read_data_13r [0:448];
reg [15:0] read_data_14r [0:448];
reg [15:0] read_data_15r [0:448];

integer i;
initial
begin

	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_0i.txt",read_data_0i);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_1i.txt",read_data_1i);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_2i.txt",read_data_2i);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_3i.txt",read_data_3i);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_4i.txt",read_data_4i);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_5i.txt",read_data_5i);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_6i.txt",read_data_6i);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_7i.txt",read_data_7i);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_8i.txt",read_data_8i);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_9i.txt",read_data_9i);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_10i.txt",read_data_10i);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_11i.txt",read_data_11i);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_12i.txt",read_data_12i);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_13i.txt",read_data_13i);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_14i.txt",read_data_14i);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_15i.txt",read_data_15i);

	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_0r.txt",read_data_0r);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_1r.txt",read_data_1r);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_2r.txt",read_data_2r);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_3r.txt",read_data_3r);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_4r.txt",read_data_4r);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_5r.txt",read_data_5r);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_6r.txt",read_data_6r);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_7r.txt",read_data_7r);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_8r.txt",read_data_8r);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_9r.txt",read_data_9r);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_10r.txt",read_data_10r);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_11r.txt",read_data_11r);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_12r.txt",read_data_12r);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_13r.txt",read_data_13r);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_14r.txt",read_data_14r);
	$readmemb("/lab215/home/gferreira/ferreirinha/dissertacao/16fft_split/16bits/baseline/bench/inputs/inputs_15r.txt",read_data_15r);


	#(CLOCK_PERIOD*3/2);
	limpa=1'b1;

	for (i=0;i<450;i=i+1)
	begin
		{Xi0} = read_data_0i[i];
		{Xi1} = read_data_1i[i];
		{Xi2} = read_data_2i[i];
		{Xi3} = read_data_3i[i];
		{Xi4} = read_data_4i[i];
		{Xi5} = read_data_5i[i];
		{Xi6} = read_data_6i[i];
		{Xi7} = read_data_7i[i];
		{Xi8} = read_data_8i[i];
		{Xi9} = read_data_9i[i];
		{Xi10} = read_data_10i[i];
		{Xi11} = read_data_11i[i];
		{Xi12} = read_data_12i[i];
		{Xi13} = read_data_13i[i];
		{Xi14} = read_data_14i[i];
		{Xi15} = read_data_15i[i];

		{Xr0} = read_data_0r[i];
      {Xr1} = read_data_1r[i];
        {Xr2} = read_data_2r[i];
        {Xr3} = read_data_3r[i];
        {Xr4} = read_data_4r[i];
        {Xr5} = read_data_5r[i];
        {Xr6} = read_data_6r[i];
        {Xr7} = read_data_7r[i];
        {Xr8} = read_data_8r[i];
        {Xr9} = read_data_9r[i];
        {Xr10} = read_data_10r[i];
        {Xr11} = read_data_11r[i];
       {Xr12} = read_data_12r[i];
       {Xr13} = read_data_13r[i];
        {Xr14} = read_data_14r[i];
        {Xr15} = read_data_15r[i];
		#(CLOCK_PERIOD*32);
    end
 $finish;
end


toplevel DUT (.clock(clock),.limpa(limpa),
.Xr0(Xr0),.Xi0(Xi0),
.Xr1(Xr1),.Xi1(Xi1),
.Xr2(Xr2),.Xi2(Xi2),
.Xr3(Xr3),.Xi3(Xi3),
.Xr4(Xr4),.Xi4(Xi4),
.Xr5(Xr5),.Xi5(Xi5),
.Xr6(Xr6),.Xi6(Xi6),
.Xr7(Xr7),.Xi7(Xi7),
.Xr8(Xr8),.Xi8(Xi8),
.Xr9(Xr9),.Xi9(Xi9),
.Xr10(Xr10),.Xi10(Xi10),
.Xr11(Xr11),.Xi11(Xi11),
.Xr12(Xr12),.Xi12(Xi12),
.Xr13(Xr13),.Xi13(Xi13),
.Xr14(Xr14),.Xi14(Xi14),
.Xr15(Xr15),.Xi15(Xi15),
.sair0(sair0),.saii0(saii0),
.sair1(sair1),.saii1(saii1),
.sair2(sair2),.saii2(saii2),
.sair3(sair3),.saii3(saii3),
.sair4(sair4),.saii4(saii4),
.sair5(sair5),.saii5(saii5),
.sair6(sair6),.saii6(saii6),
.sair7(sair7),.saii7(saii7),
.sair8(sair8),.saii8(saii8),
.sair9(sair9),.saii9(saii9),
.sair10(sair10),.saii10(saii10),
.sair11(sair11),.saii11(saii11),
.sair12(sair12),.saii12(saii12),
.sair13(sair13),.saii13(saii13),
.sair14(sair14),.saii14(saii14),
.sair15(sair15),.saii15(saii15));


endmodule



