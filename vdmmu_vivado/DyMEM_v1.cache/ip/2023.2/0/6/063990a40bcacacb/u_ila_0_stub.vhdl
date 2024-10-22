-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
-- Date        : Sat Aug  3 16:18:11 2024
-- Host        : LAPTOP-SRGHD2GT running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ u_ila_0_stub.vhdl
-- Design      : u_ila_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  Port ( 
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe1 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe2 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe3 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    probe4 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe5 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe6 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe7 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe8 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe9 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe10 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe11 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe12 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe13 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe14 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe15 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe16 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe17 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe18 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe19 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe20 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe21 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe22 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe23 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe24 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe25 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe26 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe27 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe28 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe29 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe30 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe31 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe32 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe33 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe34 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe35 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe36 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe37 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe38 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe39 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe40 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe41 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe42 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe43 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe44 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe45 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe46 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe47 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe48 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe49 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe50 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe51 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe52 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe53 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe54 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe55 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe56 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe57 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe58 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe59 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe60 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe61 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe62 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe63 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe64 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe65 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe66 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe67 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe68 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe69 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe70 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe71 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe72 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe73 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe74 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe75 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe76 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe77 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe78 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe79 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe80 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe81 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe82 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe83 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe84 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe85 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe86 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe87 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe88 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe89 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe90 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe91 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe92 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe93 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe94 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe95 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe96 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe97 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe98 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe99 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe100 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe101 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe102 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe103 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe104 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe105 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe106 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe107 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe108 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe109 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe110 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe111 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe112 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe113 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe114 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe115 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe116 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe117 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe118 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe119 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe120 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe121 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe122 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe123 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe124 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe125 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe126 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe127 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe128 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe129 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe130 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe131 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe132 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe133 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe134 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe135 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe136 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe137 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe138 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe139 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe140 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe141 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe142 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe143 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    probe144 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe145 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe146 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe147 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe148 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe149 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe150 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe151 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe152 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe153 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe154 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe155 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe156 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe157 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe158 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe159 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe160 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe161 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe162 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe163 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe164 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe165 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe166 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe167 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe168 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe169 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe170 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe171 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe172 : in STD_LOGIC_VECTOR ( 0 to 0 )
  );

end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe0[31:0],probe1[7:0],probe2[7:0],probe3[1:0],probe4[7:0],probe5[7:0],probe6[7:0],probe7[31:0],probe8[7:0],probe9[31:0],probe10[31:0],probe11[31:0],probe12[31:0],probe13[7:0],probe14[10:0],probe15[10:0],probe16[10:0],probe17[10:0],probe18[10:0],probe19[10:0],probe20[10:0],probe21[10:0],probe22[10:0],probe23[10:0],probe24[10:0],probe25[10:0],probe26[10:0],probe27[10:0],probe28[10:0],probe29[10:0],probe30[10:0],probe31[10:0],probe32[10:0],probe33[10:0],probe34[10:0],probe35[10:0],probe36[10:0],probe37[10:0],probe38[7:0],probe39[7:0],probe40[7:0],probe41[7:0],probe42[7:0],probe43[3:0],probe44[10:0],probe45[7:0],probe46[10:0],probe47[10:0],probe48[7:0],probe49[7:0],probe50[7:0],probe51[7:0],probe52[3:0],probe53[7:0],probe54[3:0],probe55[7:0],probe56[7:0],probe57[7:0],probe58[7:0],probe59[7:0],probe60[7:0],probe61[3:0],probe62[7:0],probe63[7:0],probe64[7:0],probe65[10:0],probe66[7:0],probe67[7:0],probe68[10:0],probe69[7:0],probe70[7:0],probe71[7:0],probe72[7:0],probe73[7:0],probe74[7:0],probe75[3:0],probe76[3:0],probe77[3:0],probe78[3:0],probe79[3:0],probe80[7:0],probe81[3:0],probe82[3:0],probe83[3:0],probe84[10:0],probe85[7:0],probe86[10:0],probe87[7:0],probe88[7:0],probe89[10:0],probe90[3:0],probe91[3:0],probe92[7:0],probe93[7:0],probe94[7:0],probe95[7:0],probe96[7:0],probe97[7:0],probe98[7:0],probe99[3:0],probe100[3:0],probe101[7:0],probe102[7:0],probe103[3:0],probe104[7:0],probe105[7:0],probe106[7:0],probe107[7:0],probe108[7:0],probe109[7:0],probe110[3:0],probe111[7:0],probe112[7:0],probe113[3:0],probe114[3:0],probe115[7:0],probe116[7:0],probe117[7:0],probe118[7:0],probe119[3:0],probe120[3:0],probe121[3:0],probe122[3:0],probe123[7:0],probe124[3:0],probe125[3:0],probe126[3:0],probe127[7:0],probe128[7:0],probe129[3:0],probe130[3:0],probe131[7:0],probe132[7:0],probe133[7:0],probe134[7:0],probe135[7:0],probe136[3:0],probe137[7:0],probe138[7:0],probe139[7:0],probe140[3:0],probe141[3:0],probe142[4:0],probe143[15:0],probe144[3:0],probe145[3:0],probe146[4:0],probe147[3:0],probe148[3:0],probe149[4:0],probe150[4:0],probe151[3:0],probe152[4:0],probe153[4:0],probe154[0:0],probe155[0:0],probe156[0:0],probe157[0:0],probe158[0:0],probe159[0:0],probe160[0:0],probe161[0:0],probe162[0:0],probe163[0:0],probe164[0:0],probe165[0:0],probe166[0:0],probe167[0:0],probe168[0:0],probe169[0:0],probe170[0:0],probe171[0:0],probe172[0:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "ila,Vivado 2023.2";
begin
end;
