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
#include "xtb_heap_axi.h"

extern XTb_heap_axi_Config XTb_heap_axi_ConfigTable[];

#ifdef SDT
XTb_heap_axi_Config *XTb_heap_axi_LookupConfig(UINTPTR BaseAddress) {
	XTb_heap_axi_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XTb_heap_axi_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XTb_heap_axi_ConfigTable[Index].Ps_wr_BaseAddress == BaseAddress) {
			ConfigPtr = &XTb_heap_axi_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XTb_heap_axi_Initialize(XTb_heap_axi *InstancePtr, UINTPTR BaseAddress) {
	XTb_heap_axi_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XTb_heap_axi_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XTb_heap_axi_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XTb_heap_axi_Config *XTb_heap_axi_LookupConfig(u16 DeviceId) {
	XTb_heap_axi_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XTB_HEAP_AXI_NUM_INSTANCES; Index++) {
		if (XTb_heap_axi_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XTb_heap_axi_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XTb_heap_axi_Initialize(XTb_heap_axi *InstancePtr, u16 DeviceId) {
	XTb_heap_axi_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XTb_heap_axi_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XTb_heap_axi_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

