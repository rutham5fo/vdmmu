// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Fri Jul 19 14:41:36 2024
// Host        : LAPTOP-SRGHD2GT running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ u_ila_0_stub.v
// Design      : u_ila_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2023.2" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6, probe7, probe8, probe9, probe10, probe11, probe12, probe13, probe14, probe15, probe16, probe17, 
  probe18, probe19, probe20, probe21, probe22, probe23, probe24, probe25, probe26, probe27, probe28, 
  probe29, probe30, probe31, probe32, probe33, probe34, probe35, probe36, probe37, probe38, probe39, 
  probe40, probe41, probe42, probe43, probe44, probe45, probe46, probe47, probe48, probe49, probe50, 
  probe51, probe52, probe53, probe54, probe55, probe56, probe57, probe58, probe59, probe60, probe61, 
  probe62, probe63, probe64, probe65, probe66, probe67, probe68, probe69, probe70, probe71, probe72, 
  probe73, probe74, probe75, probe76, probe77, probe78, probe79, probe80, probe81, probe82, probe83, 
  probe84, probe85, probe86)
/* synthesis syn_black_box black_box_pad_pin="probe0[1:0],probe1[1:0],probe2[1:0],probe3[14:0],probe4[0:0],probe5[10:0],probe6[10:0],probe7[10:0],probe8[10:0],probe9[10:0],probe10[10:0],probe11[10:0],probe12[10:0],probe13[10:0],probe14[10:0],probe15[10:0],probe16[10:0],probe17[10:0],probe18[10:0],probe19[10:0],probe20[10:0],probe21[7:0],probe22[7:0],probe23[7:0],probe24[7:0],probe25[7:0],probe26[7:0],probe27[7:0],probe28[7:0],probe29[7:0],probe30[7:0],probe31[7:0],probe32[7:0],probe33[7:0],probe34[7:0],probe35[7:0],probe36[7:0],probe37[7:0],probe38[7:0],probe39[7:0],probe40[7:0],probe41[7:0],probe42[7:0],probe43[7:0],probe44[7:0],probe45[3:0],probe46[3:0],probe47[3:0],probe48[3:0],probe49[3:0],probe50[3:0],probe51[3:0],probe52[3:0],probe53[7:0],probe54[7:0],probe55[7:0],probe56[3:0],probe57[3:0],probe58[7:0],probe59[7:0],probe60[7:0],probe61[7:0],probe62[7:0],probe63[3:0],probe64[7:0],probe65[3:0],probe66[3:0],probe67[3:0],probe68[3:0],probe69[3:0],probe70[4:0],probe71[15:0],probe72[3:0],probe73[4:0],probe74[4:0],probe75[4:0],probe76[3:0],probe77[3:0],probe78[3:0],probe79[3:0],probe80[4:0],probe81[4:0],probe82[0:0],probe83[0:0],probe84[0:0],probe85[0:0],probe86[0:0]" */
/* synthesis syn_force_seq_prim="clk" */;
  input clk /* synthesis syn_isclock = 1 */;
  input [1:0]probe0;
  input [1:0]probe1;
  input [1:0]probe2;
  input [14:0]probe3;
  input [0:0]probe4;
  input [10:0]probe5;
  input [10:0]probe6;
  input [10:0]probe7;
  input [10:0]probe8;
  input [10:0]probe9;
  input [10:0]probe10;
  input [10:0]probe11;
  input [10:0]probe12;
  input [10:0]probe13;
  input [10:0]probe14;
  input [10:0]probe15;
  input [10:0]probe16;
  input [10:0]probe17;
  input [10:0]probe18;
  input [10:0]probe19;
  input [10:0]probe20;
  input [7:0]probe21;
  input [7:0]probe22;
  input [7:0]probe23;
  input [7:0]probe24;
  input [7:0]probe25;
  input [7:0]probe26;
  input [7:0]probe27;
  input [7:0]probe28;
  input [7:0]probe29;
  input [7:0]probe30;
  input [7:0]probe31;
  input [7:0]probe32;
  input [7:0]probe33;
  input [7:0]probe34;
  input [7:0]probe35;
  input [7:0]probe36;
  input [7:0]probe37;
  input [7:0]probe38;
  input [7:0]probe39;
  input [7:0]probe40;
  input [7:0]probe41;
  input [7:0]probe42;
  input [7:0]probe43;
  input [7:0]probe44;
  input [3:0]probe45;
  input [3:0]probe46;
  input [3:0]probe47;
  input [3:0]probe48;
  input [3:0]probe49;
  input [3:0]probe50;
  input [3:0]probe51;
  input [3:0]probe52;
  input [7:0]probe53;
  input [7:0]probe54;
  input [7:0]probe55;
  input [3:0]probe56;
  input [3:0]probe57;
  input [7:0]probe58;
  input [7:0]probe59;
  input [7:0]probe60;
  input [7:0]probe61;
  input [7:0]probe62;
  input [3:0]probe63;
  input [7:0]probe64;
  input [3:0]probe65;
  input [3:0]probe66;
  input [3:0]probe67;
  input [3:0]probe68;
  input [3:0]probe69;
  input [4:0]probe70;
  input [15:0]probe71;
  input [3:0]probe72;
  input [4:0]probe73;
  input [4:0]probe74;
  input [4:0]probe75;
  input [3:0]probe76;
  input [3:0]probe77;
  input [3:0]probe78;
  input [3:0]probe79;
  input [4:0]probe80;
  input [4:0]probe81;
  input [0:0]probe82;
  input [0:0]probe83;
  input [0:0]probe84;
  input [0:0]probe85;
  input [0:0]probe86;
endmodule
