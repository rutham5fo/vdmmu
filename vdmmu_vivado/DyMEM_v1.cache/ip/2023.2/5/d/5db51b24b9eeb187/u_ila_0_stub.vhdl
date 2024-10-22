-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
-- Date        : Fri Jul 19 14:41:36 2024
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
    probe0 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    probe1 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    probe2 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    probe3 : in STD_LOGIC_VECTOR ( 14 downto 0 );
    probe4 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe5 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe6 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe7 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe8 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe9 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe10 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe11 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe12 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe13 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe14 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe15 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe16 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe17 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe18 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe19 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe20 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe21 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe22 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe23 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe24 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe25 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe26 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe27 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe28 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe29 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe30 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe31 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe32 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe33 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe34 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe35 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe36 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe37 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe38 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe39 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe40 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe41 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe42 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe43 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe44 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe45 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe46 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe47 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe48 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe49 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe50 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe51 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe52 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe53 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe54 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe55 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe56 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe57 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe58 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe59 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe60 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe61 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe62 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe63 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe64 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe65 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe66 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe67 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe68 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe69 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe70 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe71 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    probe72 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe73 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe74 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe75 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe76 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe77 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe78 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe79 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe80 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe81 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe82 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe83 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe84 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe85 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe86 : in STD_LOGIC_VECTOR ( 0 to 0 )
  );

end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe0[1:0],probe1[1:0],probe2[1:0],probe3[14:0],probe4[0:0],probe5[10:0],probe6[10:0],probe7[10:0],probe8[10:0],probe9[10:0],probe10[10:0],probe11[10:0],probe12[10:0],probe13[10:0],probe14[10:0],probe15[10:0],probe16[10:0],probe17[10:0],probe18[10:0],probe19[10:0],probe20[10:0],probe21[7:0],probe22[7:0],probe23[7:0],probe24[7:0],probe25[7:0],probe26[7:0],probe27[7:0],probe28[7:0],probe29[7:0],probe30[7:0],probe31[7:0],probe32[7:0],probe33[7:0],probe34[7:0],probe35[7:0],probe36[7:0],probe37[7:0],probe38[7:0],probe39[7:0],probe40[7:0],probe41[7:0],probe42[7:0],probe43[7:0],probe44[7:0],probe45[3:0],probe46[3:0],probe47[3:0],probe48[3:0],probe49[3:0],probe50[3:0],probe51[3:0],probe52[3:0],probe53[7:0],probe54[7:0],probe55[7:0],probe56[3:0],probe57[3:0],probe58[7:0],probe59[7:0],probe60[7:0],probe61[7:0],probe62[7:0],probe63[3:0],probe64[7:0],probe65[3:0],probe66[3:0],probe67[3:0],probe68[3:0],probe69[3:0],probe70[4:0],probe71[15:0],probe72[3:0],probe73[4:0],probe74[4:0],probe75[4:0],probe76[3:0],probe77[3:0],probe78[3:0],probe79[3:0],probe80[4:0],probe81[4:0],probe82[0:0],probe83[0:0],probe84[0:0],probe85[0:0],probe86[0:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "ila,Vivado 2023.2";
begin
end;
