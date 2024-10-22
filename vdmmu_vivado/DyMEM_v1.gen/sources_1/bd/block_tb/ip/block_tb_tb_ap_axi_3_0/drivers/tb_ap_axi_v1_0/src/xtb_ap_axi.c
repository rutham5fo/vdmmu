// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xtb_ap_axi.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XTb_ap_axi_CfgInitialize(XTb_ap_axi *InstancePtr, XTb_ap_axi_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Pu_rd_BaseAddress = ConfigPtr->Pu_rd_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XTb_ap_axi_Start(XTb_ap_axi *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTb_ap_axi_ReadReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_AP_CTRL) & 0x80;
    XTb_ap_axi_WriteReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_AP_CTRL, Data | 0x01);
}

u32 XTb_ap_axi_IsDone(XTb_ap_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTb_ap_axi_ReadReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XTb_ap_axi_IsIdle(XTb_ap_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTb_ap_axi_ReadReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XTb_ap_axi_IsReady(XTb_ap_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTb_ap_axi_ReadReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XTb_ap_axi_EnableAutoRestart(XTb_ap_axi *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTb_ap_axi_WriteReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_AP_CTRL, 0x80);
}

void XTb_ap_axi_DisableAutoRestart(XTb_ap_axi *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTb_ap_axi_WriteReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_AP_CTRL, 0);
}

void XTb_ap_axi_Set_i_pu_rd_addr(XTb_ap_axi *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTb_ap_axi_WriteReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_I_PU_RD_ADDR_DATA, Data);
}

u32 XTb_ap_axi_Get_i_pu_rd_addr(XTb_ap_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTb_ap_axi_ReadReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_I_PU_RD_ADDR_DATA);
    return Data;
}

u32 XTb_ap_axi_Get_o_pu_rd_data(XTb_ap_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTb_ap_axi_ReadReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_O_PU_RD_DATA_DATA);
    return Data;
}

u32 XTb_ap_axi_Get_o_pu_rd_data_vld(XTb_ap_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTb_ap_axi_ReadReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_O_PU_RD_DATA_CTRL);
    return Data & 0x1;
}

u32 XTb_ap_axi_Get_o_pu_rd_done(XTb_ap_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTb_ap_axi_ReadReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_O_PU_RD_DONE_DATA);
    return Data;
}

u32 XTb_ap_axi_Get_o_pu_rd_done_vld(XTb_ap_axi *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTb_ap_axi_ReadReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_O_PU_RD_DONE_CTRL);
    return Data & 0x1;
}

void XTb_ap_axi_InterruptGlobalEnable(XTb_ap_axi *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTb_ap_axi_WriteReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_GIE, 1);
}

void XTb_ap_axi_InterruptGlobalDisable(XTb_ap_axi *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTb_ap_axi_WriteReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_GIE, 0);
}

void XTb_ap_axi_InterruptEnable(XTb_ap_axi *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XTb_ap_axi_ReadReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_IER);
    XTb_ap_axi_WriteReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_IER, Register | Mask);
}

void XTb_ap_axi_InterruptDisable(XTb_ap_axi *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XTb_ap_axi_ReadReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_IER);
    XTb_ap_axi_WriteReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_IER, Register & (~Mask));
}

void XTb_ap_axi_InterruptClear(XTb_ap_axi *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTb_ap_axi_WriteReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_ISR, Mask);
}

u32 XTb_ap_axi_InterruptGetEnabled(XTb_ap_axi *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XTb_ap_axi_ReadReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_IER);
}

u32 XTb_ap_axi_InterruptGetStatus(XTb_ap_axi *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XTb_ap_axi_ReadReg(InstancePtr->Pu_rd_BaseAddress, XTB_AP_AXI_PU_RD_ADDR_ISR);
}

