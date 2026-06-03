`timescale 1ns/1ps

// Simple power-activity testbench for fft16_hls.
// Purpose:
//   1) Apply the same TXT input frames used by the VHDL testbench.
//   2) Generate a VCD file for OpenROAD power estimation.
//   3) Keep the testbench simple: no output comparison is performed here.
//
// Expected input directory inside the Docker container:
//   /design/entradas_tb/inputs/
//
// Expected input files:
//   inputs_0r.txt ... inputs_15r.txt
//   inputs_0i.txt ... inputs_15i.txt
//
// Run example with Icarus Verilog:
//   iverilog -g2012 -o sim_fft_power tb_fft16_hls_power_vcd.v /OpenROAD-flow-scripts/flow/results/sky130hd/fft16_hls/base/6_final.v
//   vvp sim_fft_power
//
// The generated VCD will be:
//   fft16_hls_activity.vcd

module tb_fft16_hls_power_vcd;

  localparam integer NUM_FRAMES = 450;
  localparam integer CLK_PERIOD = 10;

  reg ap_clk   = 1'b0;
  reg ap_rst   = 1'b1;
  reg ap_start = 1'b0;

  wire ap_done;
  wire ap_idle;
  wire ap_ready;

  wire [3:0]  Xr_address0;
  wire        Xr_ce0;
  reg  [15:0] Xr_q0 = 16'd0;
  wire [3:0]  Xr_address1;
  wire        Xr_ce1;
  reg  [15:0] Xr_q1 = 16'd0;

  wire [3:0]  Xi_address0;
  wire        Xi_ce0;
  reg  [15:0] Xi_q0 = 16'd0;
  wire [3:0]  Xi_address1;
  wire        Xi_ce1;
  reg  [15:0] Xi_q1 = 16'd0;

  wire [3:0]  outRe_address0;
  wire        outRe_ce0;
  wire        outRe_we0;
  wire [15:0] outRe_d0;
  wire [3:0]  outRe_address1;
  wire        outRe_ce1;
  wire        outRe_we1;
  wire [15:0] outRe_d1;

  wire [3:0]  outIm_address0;
  wire        outIm_ce0;
  wire        outIm_we0;
  wire [15:0] outIm_d0;
  wire [3:0]  outIm_address1;
  wire        outIm_ce1;
  wire        outIm_we1;
  wire [15:0] outIm_d1;

  reg [15:0] Xr_mem    [0:15];
  reg [15:0] Xi_mem    [0:15];
  reg [15:0] outRe_mem [0:15];
  reg [15:0] outIm_mem [0:15];

  reg [15:0] in_0r  [0:NUM_FRAMES-1];
  reg [15:0] in_1r  [0:NUM_FRAMES-1];
  reg [15:0] in_2r  [0:NUM_FRAMES-1];
  reg [15:0] in_3r  [0:NUM_FRAMES-1];
  reg [15:0] in_4r  [0:NUM_FRAMES-1];
  reg [15:0] in_5r  [0:NUM_FRAMES-1];
  reg [15:0] in_6r  [0:NUM_FRAMES-1];
  reg [15:0] in_7r  [0:NUM_FRAMES-1];
  reg [15:0] in_8r  [0:NUM_FRAMES-1];
  reg [15:0] in_9r  [0:NUM_FRAMES-1];
  reg [15:0] in_10r [0:NUM_FRAMES-1];
  reg [15:0] in_11r [0:NUM_FRAMES-1];
  reg [15:0] in_12r [0:NUM_FRAMES-1];
  reg [15:0] in_13r [0:NUM_FRAMES-1];
  reg [15:0] in_14r [0:NUM_FRAMES-1];
  reg [15:0] in_15r [0:NUM_FRAMES-1];

  reg [15:0] in_0i  [0:NUM_FRAMES-1];
  reg [15:0] in_1i  [0:NUM_FRAMES-1];
  reg [15:0] in_2i  [0:NUM_FRAMES-1];
  reg [15:0] in_3i  [0:NUM_FRAMES-1];
  reg [15:0] in_4i  [0:NUM_FRAMES-1];
  reg [15:0] in_5i  [0:NUM_FRAMES-1];
  reg [15:0] in_6i  [0:NUM_FRAMES-1];
  reg [15:0] in_7i  [0:NUM_FRAMES-1];
  reg [15:0] in_8i  [0:NUM_FRAMES-1];
  reg [15:0] in_9i  [0:NUM_FRAMES-1];
  reg [15:0] in_10i [0:NUM_FRAMES-1];
  reg [15:0] in_11i [0:NUM_FRAMES-1];
  reg [15:0] in_12i [0:NUM_FRAMES-1];
  reg [15:0] in_13i [0:NUM_FRAMES-1];
  reg [15:0] in_14i [0:NUM_FRAMES-1];
  reg [15:0] in_15i [0:NUM_FRAMES-1];

  integer frame;
  integer i;
  integer timeout_cycles;

  fft16_hls dut (
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(ap_start),
    .ap_done(ap_done),
    .ap_idle(ap_idle),
    .ap_ready(ap_ready),

    .Xr_address0(Xr_address0),
    .Xr_ce0(Xr_ce0),
    .Xr_q0(Xr_q0),
    .Xr_address1(Xr_address1),
    .Xr_ce1(Xr_ce1),
    .Xr_q1(Xr_q1),

    .Xi_address0(Xi_address0),
    .Xi_ce0(Xi_ce0),
    .Xi_q0(Xi_q0),
    .Xi_address1(Xi_address1),
    .Xi_ce1(Xi_ce1),
    .Xi_q1(Xi_q1),

    .outRe_address0(outRe_address0),
    .outRe_ce0(outRe_ce0),
    .outRe_we0(outRe_we0),
    .outRe_d0(outRe_d0),
    .outRe_address1(outRe_address1),
    .outRe_ce1(outRe_ce1),
    .outRe_we1(outRe_we1),
    .outRe_d1(outRe_d1),

    .outIm_address0(outIm_address0),
    .outIm_ce0(outIm_ce0),
    .outIm_we0(outIm_we0),
    .outIm_d0(outIm_d0),
    .outIm_address1(outIm_address1),
    .outIm_ce1(outIm_ce1),
    .outIm_we1(outIm_we1),
    .outIm_d1(outIm_d1)
  );

  always #(CLK_PERIOD/2) ap_clk = ~ap_clk;

  initial begin
    $dumpfile("fft16_hls_activity.vcd");
    $dumpvars(0, tb_fft16_hls_power_vcd);
  end

  initial begin
    $readmemb("/design/entradas_tb/inputs/inputs_0r.txt",  in_0r);
    $readmemb("/design/entradas_tb/inputs/inputs_1r.txt",  in_1r);
    $readmemb("/design/entradas_tb/inputs/inputs_2r.txt",  in_2r);
    $readmemb("/design/entradas_tb/inputs/inputs_3r.txt",  in_3r);
    $readmemb("/design/entradas_tb/inputs/inputs_4r.txt",  in_4r);
    $readmemb("/design/entradas_tb/inputs/inputs_5r.txt",  in_5r);
    $readmemb("/design/entradas_tb/inputs/inputs_6r.txt",  in_6r);
    $readmemb("/design/entradas_tb/inputs/inputs_7r.txt",  in_7r);
    $readmemb("/design/entradas_tb/inputs/inputs_8r.txt",  in_8r);
    $readmemb("/design/entradas_tb/inputs/inputs_9r.txt",  in_9r);
    $readmemb("/design/entradas_tb/inputs/inputs_10r.txt", in_10r);
    $readmemb("/design/entradas_tb/inputs/inputs_11r.txt", in_11r);
    $readmemb("/design/entradas_tb/inputs/inputs_12r.txt", in_12r);
    $readmemb("/design/entradas_tb/inputs/inputs_13r.txt", in_13r);
    $readmemb("/design/entradas_tb/inputs/inputs_14r.txt", in_14r);
    $readmemb("/design/entradas_tb/inputs/inputs_15r.txt", in_15r);

    $readmemb("/design/entradas_tb/inputs/inputs_0i.txt",  in_0i);
    $readmemb("/design/entradas_tb/inputs/inputs_1i.txt",  in_1i);
    $readmemb("/design/entradas_tb/inputs/inputs_2i.txt",  in_2i);
    $readmemb("/design/entradas_tb/inputs/inputs_3i.txt",  in_3i);
    $readmemb("/design/entradas_tb/inputs/inputs_4i.txt",  in_4i);
    $readmemb("/design/entradas_tb/inputs/inputs_5i.txt",  in_5i);
    $readmemb("/design/entradas_tb/inputs/inputs_6i.txt",  in_6i);
    $readmemb("/design/entradas_tb/inputs/inputs_7i.txt",  in_7i);
    $readmemb("/design/entradas_tb/inputs/inputs_8i.txt",  in_8i);
    $readmemb("/design/entradas_tb/inputs/inputs_9i.txt",  in_9i);
    $readmemb("/design/entradas_tb/inputs/inputs_10i.txt", in_10i);
    $readmemb("/design/entradas_tb/inputs/inputs_11i.txt", in_11i);
    $readmemb("/design/entradas_tb/inputs/inputs_12i.txt", in_12i);
    $readmemb("/design/entradas_tb/inputs/inputs_13i.txt", in_13i);
    $readmemb("/design/entradas_tb/inputs/inputs_14i.txt", in_14i);
    $readmemb("/design/entradas_tb/inputs/inputs_15i.txt", in_15i);
  end

  task load_frame;
    input integer f;
    begin
      Xr_mem[0]  = in_0r[f];   Xr_mem[1]  = in_1r[f];
      Xr_mem[2]  = in_2r[f];   Xr_mem[3]  = in_3r[f];
      Xr_mem[4]  = in_4r[f];   Xr_mem[5]  = in_5r[f];
      Xr_mem[6]  = in_6r[f];   Xr_mem[7]  = in_7r[f];
      Xr_mem[8]  = in_8r[f];   Xr_mem[9]  = in_9r[f];
      Xr_mem[10] = in_10r[f];  Xr_mem[11] = in_11r[f];
      Xr_mem[12] = in_12r[f];  Xr_mem[13] = in_13r[f];
      Xr_mem[14] = in_14r[f];  Xr_mem[15] = in_15r[f];

      Xi_mem[0]  = in_0i[f];   Xi_mem[1]  = in_1i[f];
      Xi_mem[2]  = in_2i[f];   Xi_mem[3]  = in_3i[f];
      Xi_mem[4]  = in_4i[f];   Xi_mem[5]  = in_5i[f];
      Xi_mem[6]  = in_6i[f];   Xi_mem[7]  = in_7i[f];
      Xi_mem[8]  = in_8i[f];   Xi_mem[9]  = in_9i[f];
      Xi_mem[10] = in_10i[f];  Xi_mem[11] = in_11i[f];
      Xi_mem[12] = in_12i[f];  Xi_mem[13] = in_13i[f];
      Xi_mem[14] = in_14i[f];  Xi_mem[15] = in_15i[f];

      for (i = 0; i < 16; i = i + 1) begin
        outRe_mem[i] = 16'd0;
        outIm_mem[i] = 16'd0;
      end
    end
  endtask

  always @(posedge ap_clk) begin
    if (ap_rst) begin
      Xr_q0 <= 16'd0;
      Xr_q1 <= 16'd0;
      Xi_q0 <= 16'd0;
      Xi_q1 <= 16'd0;
    end else begin
      if (Xr_ce0) Xr_q0 <= Xr_mem[Xr_address0];
      if (Xr_ce1) Xr_q1 <= Xr_mem[Xr_address1];
      if (Xi_ce0) Xi_q0 <= Xi_mem[Xi_address0];
      if (Xi_ce1) Xi_q1 <= Xi_mem[Xi_address1];
    end
  end

  always @(negedge ap_clk) begin
    if (outRe_ce0 && outRe_we0) outRe_mem[outRe_address0] <= outRe_d0;
    if (outRe_ce1 && outRe_we1) outRe_mem[outRe_address1] <= outRe_d1;
    if (outIm_ce0 && outIm_we0) outIm_mem[outIm_address0] <= outIm_d0;
    if (outIm_ce1 && outIm_we1) outIm_mem[outIm_address1] <= outIm_d1;
  end

  initial begin
    ap_rst   = 1'b1;
    ap_start = 1'b0;

    repeat (5) @(posedge ap_clk);
    ap_rst = 1'b0;
    repeat (2) @(posedge ap_clk);

    for (frame = 0; frame < NUM_FRAMES; frame = frame + 1) begin
      load_frame(frame);

      ap_rst   = 1'b1;
      ap_start = 1'b0;
      repeat (5) @(posedge ap_clk);
      ap_rst = 1'b0;
      repeat (2) @(posedge ap_clk);

      @(posedge ap_clk);
      ap_start = 1'b1;
      @(posedge ap_clk);
      ap_start = 1'b0;

      timeout_cycles = 0;
      while (ap_done !== 1'b1 && timeout_cycles < 2000) begin
        @(posedge ap_clk);
        timeout_cycles = timeout_cycles + 1;
      end

      if (timeout_cycles >= 2000) begin
        $display("ERROR: timeout waiting ap_done at frame %0d", frame);
        $finish;
      end

      repeat (20) @(posedge ap_clk);

      $display("Frame %0d done. outRe[0]=%0d outIm[0]=%0d",
               frame, $signed(outRe_mem[0]), $signed(outIm_mem[0]));
    end

    $display("Simulation finished. Frames processed=%0d", NUM_FRAMES);
    $finish;
  end

endmodule
