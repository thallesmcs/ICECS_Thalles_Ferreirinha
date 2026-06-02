### From Node: fft16_hls:u_fft16_hls|fft16_hls_fft16_hls_Pipeline_VITIS_LOOP_157_2:grp_fft16_hls_Pipeline_VITIS_LOOP_157_2_fu_824|MUX_B_IDX_load_reg_3027[2]
### To Node: fft16_hls:u_fft16_hls|fft16_hls_fft16_hls_Pipeline_VITIS_LOOP_157_2:grp_fft16_hls_Pipeline_VITIS_LOOP_157_2_fu_824|m2_reg_3235[15]

-------------------------------

## Nome: u_fft16_hls|grp_fft16_hls_Pipeline_VITIS_LOOP_157_2_fu_824|sparsemux_29_4_16_1_1_U4|Mux10~1|datac

Atraso: 1.354 ns

RF: FF

Type: IC


Esse ponto representa o maior atraso incremental do caminho. Como o tipo é IC, o atraso está relacionado à interconexão interna do FPGA, ou seja, ao roteamento entre elementos. O FF indica que a transição de entrada foi de descida e a transição de saída também foi de descida.

## Nome: u_fft16_hls|grp_fft16_hls_Pipeline_VITIS_LOOP_157_2_fu_824|Add3~17|cout

Atraso: 1.249 ns

RF: FR

Type: CELL

Esse ponto representa um atraso dentro de uma célula lógica do FPGA. Como o tipo é CELL, o atraso está associado à lógica interna usada pelo Quartus, como LUT, mux, registrador, MLAB ou outro recurso lógico. O FR indica que a entrada teve transição de descida e a saída teve transição de subida, mostrando uma inversão lógica nesse trecho.

## Nome: u_fft16_hls|grp_fft16_hls_Pipeline_VITIS_LOOP_157_2_fu_824|mul_15s_17s_30_1_1_U7|Mult0~mac|ay[15]

Atraso: 1.107 ns

RF: FF

Type: IC

Esse atraso também está associado à interconexão interna do FPGA. Portanto, ele representa o tempo gasto para o sinal se propagar fisicamente entre blocos do circuito. O FF indica que a transição permaneceu como descida na entrada e na saída.

## Nome: u_fft16_hls|grp_fft16_hls_Pipeline_VITIS_LOOP_157_2_fu_824|sparsemux_29_4_16_1_1_U2|Mux8~1|dataf

Atraso: 0.966 ns

RF: FF

Type: IC

Esse ponto mostra outro atraso de roteamento dentro do FPGA. Embora seja menor que os anteriores, ainda contribui de forma relevante para o atraso total do caminho crítico. O FF indica que a transição do sinal foi de descida para descida.

## Nome: u_fft16_hls|grp_fft16_hls_Pipeline_VITIS_LOOP_157_2_fu_824|sparsemux_29_4_16_1_1_U4|Mux10~4|datac

Atraso: 0.865 ns
RF: FF
Type: IC

Esse atraso também vem da interconexão interna. Ele mostra que parte do tempo total do caminho está distribuída entre conexões físicas, não apenas entre operações lógicas. O FF indica que a transição de entrada e saída foi de descida.