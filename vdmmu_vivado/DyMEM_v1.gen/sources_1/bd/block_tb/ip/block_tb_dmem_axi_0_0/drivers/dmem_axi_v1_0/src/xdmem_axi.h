// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XDMEM_AXI_H
#define XDMEM_AXI_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xdmem_axi_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
#ifdef SDT
    char *Name;
#else
    u16 DeviceId;
#endif
    u64 Dmem_ctrl_BaseAddress;
} XDmem_axi_Config;
#endif

typedef struct {
    u64 Dmem_ctrl_BaseAddress;
    u32 IsReady;
} XDmem_axi;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XDmem_axi_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XDmem_axi_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XDmem_axi_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XDmem_axi_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
#ifdef SDT
int XDmem_axi_Initialize(XDmem_axi *InstancePtr, UINTPTR BaseAddress);
XDmem_axi_Config* XDmem_axi_LookupConfig(UINTPTR BaseAddress);
#else
int XDmem_axi_Initialize(XDmem_axi *InstancePtr, u16 DeviceId);
XDmem_axi_Config* XDmem_axi_LookupConfig(u16 DeviceId);
#endif
int XDmem_axi_CfgInitialize(XDmem_axi *InstancePtr, XDmem_axi_Config *ConfigPtr);
#else
int XDmem_axi_Initialize(XDmem_axi *InstancePtr, const char* InstanceName);
int XDmem_axi_Release(XDmem_axi *InstancePtr);
#endif


void XDmem_axi_Set_i_reset(XDmem_axi *InstancePtr, u32 Data);
u32 XDmem_axi_Get_i_reset(XDmem_axi *InstancePtr);
void XDmem_axi_Set_i_req_valid(XDmem_axi *InstancePtr, u32 Data);
u32 XDmem_axi_Get_i_req_valid(XDmem_axi *InstancePtr);
void XDmem_axi_Set_i_req_type(XDmem_axi *InstancePtr, u32 Data);
u32 XDmem_axi_Get_i_req_type(XDmem_axi *InstancePtr);
void XDmem_axi_Set_i_req_bytes(XDmem_axi *InstancePtr, u32 Data);
u32 XDmem_axi_Get_i_req_bytes(XDmem_axi *InstancePtr);
void XDmem_axi_Set_i_req_trans_id(XDmem_axi *InstancePtr, u32 Data);
u32 XDmem_axi_Get_i_req_trans_id(XDmem_axi *InstancePtr);
u32 XDmem_axi_Get_o_rep_trans_id(XDmem_axi *InstancePtr);
u32 XDmem_axi_Get_o_rep_trans_id_vld(XDmem_axi *InstancePtr);
u32 XDmem_axi_Get_o_rep_ack(XDmem_axi *InstancePtr);
u32 XDmem_axi_Get_o_rep_ack_vld(XDmem_axi *InstancePtr);
u32 XDmem_axi_Get_o_heap_full(XDmem_axi *InstancePtr);
u32 XDmem_axi_Get_o_heap_full_vld(XDmem_axi *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
