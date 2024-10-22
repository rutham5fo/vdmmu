// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#ifdef SDT
#include "xparameters.h"
#endif
#include "xtb_ap_axi.h"

extern XTb_ap_axi_Config XTb_ap_axi_ConfigTable[];

#ifdef SDT
XTb_ap_axi_Config *XTb_ap_axi_LookupConfig(UINTPTR BaseAddress) {
	XTb_ap_axi_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XTb_ap_axi_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XTb_ap_axi_ConfigTable[Index].Pu_rd_BaseAddress == BaseAddress) {
			ConfigPtr = &XTb_ap_axi_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XTb_ap_axi_Initialize(XTb_ap_axi *InstancePtr, UINTPTR BaseAddress) {
	XTb_ap_axi_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XTb_ap_axi_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XTb_ap_axi_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XTb_ap_axi_Config *XTb_ap_axi_LookupConfig(u16 DeviceId) {
	XTb_ap_axi_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XTB_AP_AXI_NUM_INSTANCES; Index++) {
		if (XTb_ap_axi_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XTb_ap_axi_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XTb_ap_axi_Initialize(XTb_ap_axi *InstancePtr, u16 DeviceId) {
	XTb_ap_axi_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XTb_ap_axi_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XTb_ap_axi_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

