// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Sat Aug  3 16:18:11 2024
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
  probe84, probe85, probe86, probe87, probe88, probe89, probe90, probe91, probe92, probe93, probe94, 
  probe95, probe96, probe97, probe98, probe99, probe100, probe101, probe102, probe103, probe104, 
  probe105, probe106, probe107, probe108, probe109, probe110, probe111, probe112, probe113, probe114, 
  probe115, probe116, probe117, probe118, probe119, probe120, probe121, probe122, probe123, probe124, 
  probe125, probe126, probe127, probe128, probe129, probe130, probe131, probe132, probe133, probe134, 
  probe135, probe136, probe137, probe138, probe139, probe140, probe141, probe142, probe143, probe144, 
  probe145, probe146, probe147, probe148, probe149, probe150, probe151, probe152, probe153, probe154, 
  probe155, probe156, probe157, probe158, probe159, probe160, probe161, probe162, probe163, probe164, 
  probe165, probe166, probe167, probe168, probe169, probe170, probe171, probe172)
/* synthesis syn_black_box black_box_pad_pin="probe0[31:0],probe1[7:0],probe2[7:0],probe3[1:0],probe4[7:0],probe5[7:0],probe6[7:0],probe7[31:0],probe8[7:0],probe9[31:0],probe10[31:0],probe11[31:0],probe12[31:0],probe13[7:0],probe14[10:0],probe15[10:0],probe16[10:0],probe17[10:0],probe18[10:0],probe19[10:0],probe20[10:0],probe21[10:0],probe22[10:0],probe23[10:0],probe24[10:0],probe25[10:0],probe26[10:0],probe27[10:0],probe28[10:0],probe29[10:0],probe30[10:0],probe31[10:0],probe32[10:0],probe33[10:0],probe34[10:0],probe35[10:0],probe36[10:0],probe37[10:0],probe38[7:0],probe39[7:0],probe40[7:0],probe41[7:0],probe42[7:0],probe43[3:0],probe44[10:0],probe45[7:0],probe46[10:0],probe47[10:0],probe48[7:0],probe49[7:0],probe50[7:0],probe51[7:0],probe52[3:0],probe53[7:0],probe54[3:0],probe55[7:0],probe56[7:0],probe57[7:0],probe58[7:0],probe59[7:0],probe60[7:0],probe61[3:0],probe62[7:0],probe63[7:0],probe64[7:0],probe65[10:0],probe66[7:0],probe67[7:0],probe68[10:0],probe69[7:0],probe70[7:0],probe71[7:0],probe72[7:0],probe73[7:0],probe74[7:0],probe75[3:0],probe76[3:0],probe77[3:0],probe78[3:0],probe79[3:0],probe80[7:0],probe81[3:0],probe82[3:0],probe83[3:0],probe84[10:0],probe85[7:0],probe86[10:0],probe87[7:0],probe88[7:0],probe89[10:0],probe90[3:0],probe91[3:0],probe92[7:0],probe93[7:0],probe94[7:0],probe95[7:0],probe96[7:0],probe97[7:0],probe98[7:0],probe99[3:0],probe100[3:0],probe101[7:0],probe102[7:0],probe103[3:0],probe104[7:0],probe105[7:0],probe106[7:0],probe107[7:0],probe108[7:0],probe109[7:0],probe110[3:0],probe111[7:0],probe112[7:0],probe113[3:0],probe114[3:0],probe115[7:0],probe116[7:0],probe117[7:0],probe118[7:0],probe119[3:0],probe120[3:0],probe121[3:0],probe122[3:0],probe123[7:0],probe124[3:0],probe125[3:0],probe126[3:0],probe127[7:0],probe128[7:0],probe129[3:0],probe130[3:0],probe131[7:0],probe132[7:0],probe133[7:0],probe134[7:0],probe135[7:0],probe136[3:0],probe137[7:0],probe138[7:0],probe139[7:0],probe140[3:0],probe141[3:0],probe142[4:0],probe143[15:0],probe144[3:0],probe145[3:0],probe146[4:0],probe147[3:0],probe148[3:0],probe149[4:0],probe150[4:0],probe151[3:0],probe152[4:0],probe153[4:0],probe154[0:0],probe155[0:0],probe156[0:0],probe157[0:0],probe158[0:0],probe159[0:0],probe160[0:0],probe161[0:0],probe162[0:0],probe163[0:0],probe164[0:0],probe165[0:0],probe166[0:0],probe167[0:0],probe168[0:0],probe169[0:0],probe170[0:0],probe171[0:0],probe172[0:0]" */
/* synthesis syn_force_seq_prim="clk" */;
  input clk /* synthesis syn_isclock = 1 */;
  input [31:0]probe0;
  input [7:0]probe1;
  input [7:0]probe2;
  input [1:0]probe3;
  input [7:0]probe4;
  input [7:0]probe5;
  input [7:0]probe6;
  input [31:0]probe7;
  input [7:0]probe8;
  input [31:0]probe9;
  input [31:0]probe10;
  input [31:0]probe11;
  input [31:0]probe12;
  input [7:0]probe13;
  input [10:0]probe14;
  input [10:0]probe15;
  input [10:0]probe16;
  input [10:0]probe17;
  input [10:0]probe18;
  input [10:0]probe19;
  input [10:0]probe20;
  input [10:0]probe21;
  input [10:0]probe22;
  input [10:0]probe23;
  input [10:0]probe24;
  input [10:0]probe25;
  input [10:0]probe26;
  input [10:0]probe27;
  input [10:0]probe28;
  input [10:0]probe29;
  input [10:0]probe30;
  input [10:0]probe31;
  input [10:0]probe32;
  input [10:0]probe33;
  input [10:0]probe34;
  input [10:0]probe35;
  input [10:0]probe36;
  input [10:0]probe37;
  input [7:0]probe38;
  input [7:0]probe39;
  input [7:0]probe40;
  input [7:0]probe41;
  input [7:0]probe42;
  input [3:0]probe43;
  input [10:0]probe44;
  input [7:0]probe45;
  input [10:0]probe46;
  input [10:0]probe47;
  input [7:0]probe48;
  input [7:0]probe49;
  input [7:0]probe50;
  input [7:0]probe51;
  input [3:0]probe52;
  input [7:0]probe53;
  input [3:0]probe54;
  input [7:0]probe55;
  input [7:0]probe56;
  input [7:0]probe57;
  input [7:0]probe58;
  input [7:0]probe59;
  input [7:0]probe60;
  input [3:0]probe61;
  input [7:0]probe62;
  input [7:0]probe63;
  input [7:0]probe64;
  input [10:0]probe65;
  input [7:0]probe66;
  input [7:0]probe67;
  input [10:0]probe68;
  input [7:0]probe69;
  input [7:0]probe70;
  input [7:0]probe71;
  input [7:0]probe72;
  input [7:0]probe73;
  input [7:0]probe74;
  input [3:0]probe75;
  input [3:0]probe76;
  input [3:0]probe77;
  input [3:0]probe78;
  input [3:0]probe79;
  input [7:0]probe80;
  input [3:0]probe81;
  input [3:0]probe82;
  input [3:0]probe83;
  input [10:0]probe84;
  input [7:0]probe85;
  input [10:0]probe86;
  input [7:0]probe87;
  input [7:0]probe88;
  input [10:0]probe89;
  input [3:0]probe90;
  input [3:0]probe91;
  input [7:0]probe92;
  input [7:0]probe93;
  input [7:0]probe94;
  input [7:0]probe95;
  input [7:0]probe96;
  input [7:0]probe97;
  input [7:0]probe98;
  input [3:0]probe99;
  input [3:0]probe100;
  input [7:0]probe101;
  input [7:0]probe102;
  input [3:0]probe103;
  input [7:0]probe104;
  input [7:0]probe105;
  input [7:0]probe106;
  input [7:0]probe107;
  input [7:0]probe108;
  input [7:0]probe109;
  input [3:0]probe110;
  input [7:0]probe111;
  input [7:0]probe112;
  input [3:0]probe113;
  input [3:0]probe114;
  input [7:0]probe115;
  input [7:0]probe116;
  input [7:0]probe117;
  input [7:0]probe118;
  input [3:0]probe119;
  input [3:0]probe120;
  input [3:0]probe121;
  input [3:0]probe122;
  input [7:0]probe123;
  input [3:0]probe124;
  input [3:0]probe125;
  input [3:0]probe126;
  input [7:0]probe127;
  input [7:0]probe128;
  input [3:0]probe129;
  input [3:0]probe130;
  input [7:0]probe131;
  input [7:0]probe132;
  input [7:0]probe133;
  input [7:0]probe134;
  input [7:0]probe135;
  input [3:0]probe136;
  input [7:0]probe137;
  input [7:0]probe138;
  input [7:0]probe139;
  input [3:0]probe140;
  input [3:0]probe141;
  input [4:0]probe142;
  input [15:0]probe143;
  input [3:0]probe144;
  input [3:0]probe145;
  input [4:0]probe146;
  input [3:0]probe147;
  input [3:0]probe148;
  input [4:0]probe149;
  input [4:0]probe150;
  input [3:0]probe151;
  input [4:0]probe152;
  input [4:0]probe153;
  input [0:0]probe154;
  input [0:0]probe155;
  input [0:0]probe156;
  input [0:0]probe157;
  input [0:0]probe158;
  input [0:0]probe159;
  input [0:0]probe160;
  input [0:0]probe161;
  input [0:0]probe162;
  input [0:0]probe163;
  input [0:0]probe164;
  input [0:0]probe165;
  input [0:0]probe166;
  input [0:0]probe167;
  input [0:0]probe168;
  input [0:0]probe169;
  input [0:0]probe170;
  input [0:0]probe171;
  input [0:0]probe172;
endmodule
