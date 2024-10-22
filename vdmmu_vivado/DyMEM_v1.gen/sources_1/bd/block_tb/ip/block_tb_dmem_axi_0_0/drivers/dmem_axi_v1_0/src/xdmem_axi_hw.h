// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
// DMEM_ctrl
// 0x00 : reserved
// 0x04 : reserved
// 0x08 : reserved
// 0x0c : reserved
// 0x10 : Data signal of i_reset
//        bit 7~0 - i_reset[7:0] (Read/Write)
//        others  - reserved
// 0x14 : reserved
// 0x18 : Data signal of i_req_valid
//        bit 7~0 - i_req_valid[7:0] (Read/Write)
//        others  - reserved
// 0x1c : reserved
// 0x20 : Data signal of i_req_type
//        bit 7~0 - i_req_type[7:0] (Read/Write)
//        others  - reserved
// 0x24 : reserved
// 0x28 : Data signal of i_req_bytes
//        bit 31~0 - i_req_bytes[31:0] (Read/Write)
// 0x2c : reserved
// 0x30 : Data signal of i_req_trans_id
//        bit 7~0 - i_req_trans_id[7:0] (Read/Write)
//        others  - reserved
// 0x34 : reserved
// 0x38 : Data signal of o_rep_trans_id
//        bit 7~0 - o_rep_trans_id[7:0] (Read)
//        others  - reserved
// 0x3c : Control signal of o_rep_trans_id
//        bit 0  - o_rep_trans_id_ap_vld (Read/COR)
//        others - reserved
// 0x48 : Data signal of o_rep_ack
//        bit 7~0 - o_rep_ack[7:0] (Read)
//        others  - reserved
// 0x4c : Control signal of o_rep_ack
//        bit 0  - o_rep_ack_ap_vld (Read/COR)
//        others - reserved
// 0x58 : Data signal of o_heap_full
//        bit 7~0 - o_heap_full[7:0] (Read)
//        others  - reserved
// 0x5c : Control signal of o_heap_full
//        bit 0  - o_heap_full_ap_vld (Read/COR)
//        others - reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XDMEM_AXI_DMEM_CTRL_ADDR_I_RESET_DATA        0x10
#define XDMEM_AXI_DMEM_CTRL_BITS_I_RESET_DATA        8
#define XDMEM_AXI_DMEM_CTRL_ADDR_I_REQ_VALID_DATA    0x18
#define XDMEM_AXI_DMEM_CTRL_BITS_I_REQ_VALID_DATA    8
#define XDMEM_AXI_DMEM_CTRL_ADDR_I_REQ_TYPE_DATA     0x20
#define XDMEM_AXI_DMEM_CTRL_BITS_I_REQ_TYPE_DATA     8
#define XDMEM_AXI_DMEM_CTRL_ADDR_I_REQ_BYTES_DATA    0x28
#define XDMEM_AXI_DMEM_CTRL_BITS_I_REQ_BYTES_DATA    32
#define XDMEM_AXI_DMEM_CTRL_ADDR_I_REQ_TRANS_ID_DATA 0x30
#define XDMEM_AXI_DMEM_CTRL_BITS_I_REQ_TRANS_ID_DATA 8
#define XDMEM_AXI_DMEM_CTRL_ADDR_O_REP_TRANS_ID_DATA 0x38
#define XDMEM_AXI_DMEM_CTRL_BITS_O_REP_TRANS_ID_DATA 8
#define XDMEM_AXI_DMEM_CTRL_ADDR_O_REP_TRANS_ID_CTRL 0x3c
#define XDMEM_AXI_DMEM_CTRL_ADDR_O_REP_ACK_DATA      0x48
#define XDMEM_AXI_DMEM_CTRL_BITS_O_REP_ACK_DATA      8
#define XDMEM_AXI_DMEM_CTRL_ADDR_O_REP_ACK_CTRL      0x4c
#define XDMEM_AXI_DMEM_CTRL_ADDR_O_HEAP_FULL_DATA    0x58
#define XDMEM_AXI_DMEM_CTRL_BITS_O_HEAP_FULL_DATA    8
#define XDMEM_AXI_DMEM_CTRL_ADDR_O_HEAP_FULL_CTRL    0x5c

