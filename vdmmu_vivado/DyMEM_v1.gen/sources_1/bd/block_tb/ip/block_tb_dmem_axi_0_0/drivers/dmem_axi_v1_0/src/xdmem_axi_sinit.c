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
#include "xdmem_axi.h"

extern XDmem_axi_Config XDmem_axi_ConfigTable[];

#ifdef SDT
XDmem_axi_Config *XDmem_axi_LookupConfig(UINTPTR BaseAddress) {
	XDmem_axi_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XDmem_axi_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XDmem_axi_ConfigTable[Index].Dmem_ctrl_BaseAddress == BaseAddress) {
			ConfigPtr = &XDmem_axi_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XDmem_axi_Initialize(XDmem_axi *InstancePtr, UINTPTR BaseAddress) {
	XDmem_axi_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XDmem_axi_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XDmem_axi_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XDmem_axi_Config *XDmem_axi_LookupConfig(u16 DeviceId) {
	XDmem_axi_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XDMEM_AXI_NUM_INSTANCES; Index++) {
		if (XDmem_axi_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XDmem_axi_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XDmem_axi_Initialize(XDmem_axi *InstancePtr, u16 DeviceId) {
	XDmem_axi_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XDmem_axi_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XDmem_axi_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

