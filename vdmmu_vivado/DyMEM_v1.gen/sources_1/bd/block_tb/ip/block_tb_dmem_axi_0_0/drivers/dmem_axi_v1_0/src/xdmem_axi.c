// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xdmem_axi.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XDmem_axi_CfgInitialize(XDmem_axi *InstancePtr, XDmem_axi_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Dmem_ctrl_BaseAddress = ConfigPtr->Dmem_ctrl_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XDmem_axi_Set_i_reset(XDmem_axi *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XDmem_axi_WriteReg(InstancePtr->Dmem_ctrl_BaseAddress, XDMEM_AXI_DMEM_CTRL_ADDR_I_RESET_DATA, Data);
}

u32 XDmem_axi_Get_i_reset(XDmem_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XDmem_axi_ReadReg(InstancePtr->Dmem_ctrl_BaseAddress, XDMEM_AXI_DMEM_CTRL_ADDR_I_RESET_DATA);
    return Data;
}

void XDmem_axi_Set_i_req_valid(XDmem_axi *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XDmem_axi_WriteReg(InstancePtr->Dmem_ctrl_BaseAddress, XDMEM_AXI_DMEM_CTRL_ADDR_I_REQ_VALID_DATA, Data);
}

u32 XDmem_axi_Get_i_req_valid(XDmem_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XDmem_axi_ReadReg(InstancePtr->Dmem_ctrl_BaseAddress, XDMEM_AXI_DMEM_CTRL_ADDR_I_REQ_VALID_DATA);
    return Data;
}

void XDmem_axi_Set_i_req_type(XDmem_axi *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XDmem_axi_WriteReg(InstancePtr->Dmem_ctrl_BaseAddress, XDMEM_AXI_DMEM_CTRL_ADDR_I_REQ_TYPE_DATA, Data);
}

u32 XDmem_axi_Get_i_req_type(XDmem_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XDmem_axi_ReadReg(InstancePtr->Dmem_ctrl_BaseAddress, XDMEM_AXI_DMEM_CTRL_ADDR_I_REQ_TYPE_DATA);
    return Data;
}

void XDmem_axi_Set_i_req_bytes(XDmem_axi *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XDmem_axi_WriteReg(InstancePtr->Dmem_ctrl_BaseAddress, XDMEM_AXI_DMEM_CTRL_ADDR_I_REQ_BYTES_DATA, Data);
}

u32 XDmem_axi_Get_i_req_bytes(XDmem_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XDmem_axi_ReadReg(InstancePtr->Dmem_ctrl_BaseAddress, XDMEM_AXI_DMEM_CTRL_ADDR_I_REQ_BYTES_DATA);
    return Data;
}

void XDmem_axi_Set_i_req_trans_id(XDmem_axi *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XDmem_axi_WriteReg(InstancePtr->Dmem_ctrl_BaseAddress, XDMEM_AXI_DMEM_CTRL_ADDR_I_REQ_TRANS_ID_DATA, Data);
}

u32 XDmem_axi_Get_i_req_trans_id(XDmem_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XDmem_axi_ReadReg(InstancePtr->Dmem_ctrl_BaseAddress, XDMEM_AXI_DMEM_CTRL_ADDR_I_REQ_TRANS_ID_DATA);
    return Data;
}

u32 XDmem_axi_Get_o_rep_trans_id(XDmem_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XDmem_axi_ReadReg(InstancePtr->Dmem_ctrl_BaseAddress, XDMEM_AXI_DMEM_CTRL_ADDR_O_REP_TRANS_ID_DATA);
    return Data;
}

u32 XDmem_axi_Get_o_rep_trans_id_vld(XDmem_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XDmem_axi_ReadReg(InstancePtr->Dmem_ctrl_BaseAddress, XDMEM_AXI_DMEM_CTRL_ADDR_O_REP_TRANS_ID_CTRL);
    return Data & 0x1;
}

u32 XDmem_axi_Get_o_rep_ack(XDmem_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XDmem_axi_ReadReg(InstancePtr->Dmem_ctrl_BaseAddress, XDMEM_AXI_DMEM_CTRL_ADDR_O_REP_ACK_DATA);
    return Data;
}

u32 XDmem_axi_Get_o_rep_ack_vld(XDmem_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XDmem_axi_ReadReg(InstancePtr->Dmem_ctrl_BaseAddress, XDMEM_AXI_DMEM_CTRL_ADDR_O_REP_ACK_CTRL);
    return Data & 0x1;
}

u32 XDmem_axi_Get_o_heap_full(XDmem_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XDmem_axi_ReadReg(InstancePtr->Dmem_ctrl_BaseAddress, XDMEM_AXI_DMEM_CTRL_ADDR_O_HEAP_FULL_DATA);
    return Data;
}

u32 XDmem_axi_Get_o_heap_full_vld(XDmem_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XDmem_axi_ReadReg(InstancePtr->Dmem_ctrl_BaseAddress, XDMEM_AXI_DMEM_CTRL_ADDR_O_HEAP_FULL_CTRL);
    return Data & 0x1;
}

