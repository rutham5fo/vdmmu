// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
// PU_rd
// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read/COR)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read/COR)
//        bit 7  - auto_restart (Read/Write)
//        bit 9  - interrupt (Read)
//        others - reserved
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0 - enable ap_done interrupt (Read/Write)
//        bit 1 - enable ap_ready interrupt (Read/Write)
//        others - reserved
// 0x0c : IP Interrupt Status Register (Read/TOW)
//        bit 0 - ap_done (Read/TOW)
//        bit 1 - ap_ready (Read/TOW)
//        others - reserved
// 0x10 : Data signal of i_pu_rd_addr
//        bit 31~0 - i_pu_rd_addr[31:0] (Read/Write)
// 0x14 : reserved
// 0x18 : Data signal of o_pu_rd_data
//        bit 31~0 - o_pu_rd_data[31:0] (Read)
// 0x1c : Control signal of o_pu_rd_data
//        bit 0  - o_pu_rd_data_ap_vld (Read/COR)
//        others - reserved
// 0x28 : Data signal of o_pu_rd_done
//        bit 7~0 - o_pu_rd_done[7:0] (Read)
//        others  - reserved
// 0x2c : Control signal of o_pu_rd_done
//        bit 0  - o_pu_rd_done_ap_vld (Read/COR)
//        others - reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XTB_AP_AXI_PU_RD_ADDR_AP_CTRL           0x00
#define XTB_AP_AXI_PU_RD_ADDR_GIE               0x04
#define XTB_AP_AXI_PU_RD_ADDR_IER               0x08
#define XTB_AP_AXI_PU_RD_ADDR_ISR               0x0c
#define XTB_AP_AXI_PU_RD_ADDR_I_PU_RD_ADDR_DATA 0x10
#define XTB_AP_AXI_PU_RD_BITS_I_PU_RD_ADDR_DATA 32
#define XTB_AP_AXI_PU_RD_ADDR_O_PU_RD_DATA_DATA 0x18
#define XTB_AP_AXI_PU_RD_BITS_O_PU_RD_DATA_DATA 32
#define XTB_AP_AXI_PU_RD_ADDR_O_PU_RD_DATA_CTRL 0x1c
#define XTB_AP_AXI_PU_RD_ADDR_O_PU_RD_DONE_DATA 0x28
#define XTB_AP_AXI_PU_RD_BITS_O_PU_RD_DONE_DATA 8
#define XTB_AP_AXI_PU_RD_ADDR_O_PU_RD_DONE_CTRL 0x2c

