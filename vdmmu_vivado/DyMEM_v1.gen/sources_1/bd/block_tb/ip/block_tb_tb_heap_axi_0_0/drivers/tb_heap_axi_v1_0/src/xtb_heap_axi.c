// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xtb_heap_axi.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XTb_heap_axi_CfgInitialize(XTb_heap_axi *InstancePtr, XTb_heap_axi_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Ps_wr_BaseAddress = ConfigPtr->Ps_wr_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XTb_heap_axi_Start(XTb_heap_axi *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTb_heap_axi_ReadReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_AP_CTRL) & 0x80;
    XTb_heap_axi_WriteReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_AP_CTRL, Data | 0x01);
}

u32 XTb_heap_axi_IsDone(XTb_heap_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTb_heap_axi_ReadReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XTb_heap_axi_IsIdle(XTb_heap_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTb_heap_axi_ReadReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XTb_heap_axi_IsReady(XTb_heap_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTb_heap_axi_ReadReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XTb_heap_axi_EnableAutoRestart(XTb_heap_axi *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTb_heap_axi_WriteReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_AP_CTRL, 0x80);
}

void XTb_heap_axi_DisableAutoRestart(XTb_heap_axi *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTb_heap_axi_WriteReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_AP_CTRL, 0);
}

void XTb_heap_axi_Set_i_ps_trans_id(XTb_heap_axi *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTb_heap_axi_WriteReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_I_PS_TRANS_ID_DATA, Data);
}

u32 XTb_heap_axi_Get_i_ps_trans_id(XTb_heap_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTb_heap_axi_ReadReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_I_PS_TRANS_ID_DATA);
    return Data;
}

void XTb_heap_axi_Set_i_ps_wr_addr(XTb_heap_axi *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTb_heap_axi_WriteReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_I_PS_WR_ADDR_DATA, Data);
}

u32 XTb_heap_axi_Get_i_ps_wr_addr(XTb_heap_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTb_heap_axi_ReadReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_I_PS_WR_ADDR_DATA);
    return Data;
}

void XTb_heap_axi_Set_i_ps_wr_data(XTb_heap_axi *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTb_heap_axi_WriteReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_I_PS_WR_DATA_DATA, Data);
}

u32 XTb_heap_axi_Get_i_ps_wr_data(XTb_heap_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTb_heap_axi_ReadReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_I_PS_WR_DATA_DATA);
    return Data;
}

u32 XTb_heap_axi_Get_o_ps_wr_done(XTb_heap_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTb_heap_axi_ReadReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_O_PS_WR_DONE_DATA);
    return Data;
}

u32 XTb_heap_axi_Get_o_ps_wr_done_vld(XTb_heap_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTb_heap_axi_ReadReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_O_PS_WR_DONE_CTRL);
    return Data & 0x1;
}

void XTb_heap_axi_InterruptGlobalEnable(XTb_heap_axi *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTb_heap_axi_WriteReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_GIE, 1);
}

void XTb_heap_axi_InterruptGlobalDisable(XTb_heap_axi *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTb_heap_axi_WriteReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_GIE, 0);
}

void XTb_heap_axi_InterruptEnable(XTb_heap_axi *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XTb_heap_axi_ReadReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_IER);
    XTb_heap_axi_WriteReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_IER, Register | Mask);
}

void XTb_heap_axi_InterruptDisable(XTb_heap_axi *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XTb_heap_axi_ReadReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_IER);
    XTb_heap_axi_WriteReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_IER, Register & (~Mask));
}

void XTb_heap_axi_InterruptClear(XTb_heap_axi *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTb_heap_axi_WriteReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_ISR, Mask);
}

u32 XTb_heap_axi_InterruptGetEnabled(XTb_heap_axi *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XTb_heap_axi_ReadReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_IER);
}

u32 XTb_heap_axi_InterruptGetStatus(XTb_heap_axi *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XTb_heap_axi_ReadReg(InstancePtr->Ps_wr_BaseAddress, XTB_HEAP_AXI_PS_WR_ADDR_ISR);
}

