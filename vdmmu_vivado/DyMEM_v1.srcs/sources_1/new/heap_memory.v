`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:23:14 PM
// Design Name: 
// Module Name: heap_memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


//(* DONT_TOUCH = "yes" *)
/*
module heap_memory #(
        parameter HEAP_SIZE             = 32,
        parameter DATA_W                = 8,
        parameter OFFSET                = 11,
        parameter MEM_CTRL              = OFFSET+1
    )(
        input wire                              clk,
        input wire                              reset_n,
        input wire  [MEM_CTRL*HEAP_SIZE-1:0]    addr_a,
        input wire  [MEM_CTRL*HEAP_SIZE-1:0]    addr_b,
        input wire  [DATA_W*HEAP_SIZE-1:0]      wr_data_a,
        input wire  [DATA_W*HEAP_SIZE-1:0]      wr_data_b,
        
        output wire [DATA_W*HEAP_SIZE-1:0]      rd_data_a,
        output wire [DATA_W*HEAP_SIZE-1:0]      rd_data_b
    );
    
    localparam A_DATA_W                 = DATA_W;
    localparam A_OFFSET_W               = OFFSET;
    localparam B_DATA_W                 = DATA_W;
    localparam B_OFFSET_W               = OFFSET;
    localparam A_MEMORY_SIZE            = A_DATA_W << A_OFFSET_W;
    //localparam B_MEMORY_SIZE            = B_DATA_W << B_OFFSET_W;
    
    wire    [A_OFFSET_W-1:0]            addr_a_unpkd[0:HEAP_SIZE-1];
    wire    [B_OFFSET_W-1:0]            addr_b_unpkd[0:HEAP_SIZE-1];
    wire    [A_DATA_W-1:0]              wr_data_a_unpkd[0:HEAP_SIZE-1];
    wire    [B_DATA_W-1:0]              wr_data_b_unpkd[0:HEAP_SIZE-1];
    wire    [A_DATA_W-1:0]              rd_data_a_unpkd[0:HEAP_SIZE-1];
    wire    [B_DATA_W-1:0]              rd_data_b_unpkd[0:HEAP_SIZE-1];
    wire    [HEAP_SIZE-1:0]             we_a;
    wire    [HEAP_SIZE-1:0]             we_b;
    
    genvar i;
    
    generate
        for (i = 0; i < HEAP_SIZE; i = i+1) begin
            assign we_a[i] = addr_a[(i*MEM_CTRL)+MEM_CTRL-1];
            assign we_b[i] = addr_b[(i*MEM_CTRL)+MEM_CTRL-1];
            assign addr_a_unpkd[i] = addr_a[i*MEM_CTRL +: A_OFFSET_W];
            assign addr_b_unpkd[i] = addr_b[i*MEM_CTRL +: B_OFFSET_W];
            assign wr_data_a_unpkd[i] = wr_data_a[i*A_DATA_W +: A_DATA_W];
            assign wr_data_b_unpkd[i] = wr_data_b[i*B_DATA_W +: B_DATA_W];
            assign rd_data_a[i*A_DATA_W +: A_DATA_W] = rd_data_a_unpkd[i];
            assign rd_data_b[i*B_DATA_W +: B_DATA_W] = rd_data_b_unpkd[i];
        end
    endgenerate
    
    generate
        for (i = 0; i < HEAP_SIZE; i = i+1) begin
            xpm_memory_tdpram #(
                .ADDR_WIDTH_A(A_OFFSET_W),               // DECIMAL
                .ADDR_WIDTH_B(B_OFFSET_W),               // DECIMAL
                .AUTO_SLEEP_TIME(0),            // DECIMAL
                .BYTE_WRITE_WIDTH_A(A_DATA_W),        // DECIMAL
                .BYTE_WRITE_WIDTH_B(B_DATA_W),        // DECIMAL
                .CASCADE_HEIGHT(0),             // DECIMAL
                .CLOCKING_MODE("common_clock"), // String
                .ECC_BIT_RANGE("7:0"),          // String
                .ECC_MODE("no_ecc"),            // String
                .ECC_TYPE("none"),              // String
                .IGNORE_INIT_SYNTH(0),          // DECIMAL
                .MEMORY_INIT_FILE("none"),      // String
                .MEMORY_INIT_PARAM("0"),        // String
                .MEMORY_OPTIMIZATION("true"),   // String
                .MEMORY_PRIMITIVE("block"),      // String
                .MEMORY_SIZE(A_MEMORY_SIZE),             // DECIMAL
                .MESSAGE_CONTROL(0),            // DECIMAL
                .RAM_DECOMP("auto"),            // String
                .READ_DATA_WIDTH_A(A_DATA_W),         // DECIMAL
                .READ_DATA_WIDTH_B(B_DATA_W),         // DECIMAL
                .READ_LATENCY_A(1),             // DECIMAL
                .READ_LATENCY_B(1),             // DECIMAL
                .READ_RESET_VALUE_A("0"),       // String
                .READ_RESET_VALUE_B("0"),       // String
                .RST_MODE_A("SYNC"),            // String
                .RST_MODE_B("SYNC"),            // String
                .SIM_ASSERT_CHK(0),             // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
                .USE_MEM_INIT(1),               // DECIMAL
                .USE_MEM_INIT_MMI(0),           // DECIMAL
                .WAKEUP_TIME("disable_sleep"),  // String
                .WRITE_DATA_WIDTH_A(A_DATA_W),        // DECIMAL
                .WRITE_DATA_WIDTH_B(B_DATA_W),        // DECIMAL
                .WRITE_MODE_A("write_first"),     // String
                .WRITE_MODE_B("write_first"),     // String
                .WRITE_PROTECT(0)               // DECIMAL
            )
            xpm_memory_tdpram_inst (
                .dbiterra(),             // 1-bit output: Status signal to indicate double bit error occurrence
                                       // on the data output of port A.

                .dbiterrb(),             // 1-bit output: Status signal to indicate double bit error occurrence
                                       // on the data output of port A.

                .douta(rd_data_a_unpkd[i]),                   // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
                .doutb(rd_data_b_unpkd[i]),                   // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
                .sbiterra(),             // 1-bit output: Status signal to indicate single bit error occurrence
                                       // on the data output of port A.

                .sbiterrb(),             // 1-bit output: Status signal to indicate single bit error occurrence
                                       // on the data output of port B.

                .addra(addr_a_unpkd[i]),                   // ADDR_WIDTH_A-bit input: Address for port A write and read operations.
                .addrb(addr_b_unpkd[i]),                   // ADDR_WIDTH_B-bit input: Address for port B write and read operations.
                .clka(clk),                     // 1-bit input: Clock signal for port A. Also clocks port B when
                                                 // parameter CLOCKING_MODE is "common_clock".

                .clkb(clk),                     // 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
                                       // "independent_clock". Unused when parameter CLOCKING_MODE is
                                       // "common_clock".

                .dina(wr_data_a_unpkd[i]),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
                .dinb(wr_data_b_unpkd[i]),                     // WRITE_DATA_WIDTH_B-bit input: Data input for port B write operations.
                .ena(1'b1),                       // 1-bit input: Memory enable signal for port A. Must be high on clock
                                       // cycles when read or write operations are initiated. Pipelined
                                       // internally.

                .enb(1'b1),                       // 1-bit input: Memory enable signal for port B. Must be high on clock
                                       // cycles when read or write operations are initiated. Pipelined
                                       // internally.

                .injectdbiterra(1'b0), // 1-bit input: Controls double bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

                .injectdbiterrb(1'b0), // 1-bit input: Controls double bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

                .injectsbiterra(1'b0), // 1-bit input: Controls single bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

                .injectsbiterrb(1'b0), // 1-bit input: Controls single bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

                .regcea(1'b0),                 // 1-bit input: Clock Enable for the last register stage on the output
                                       // data path.

                .regceb(1'b0),                 // 1-bit input: Clock Enable for the last register stage on the output
                                       // data path.

                .rsta(~reset_n),                     // 1-bit input: Reset signal for the final port A output register stage.
                                       // Synchronously resets output port douta to the value specified by
                                       // parameter READ_RESET_VALUE_A.

                .rstb(~reset_n),                     // 1-bit input: Reset signal for the final port B output register stage.
                                       // Synchronously resets output port doutb to the value specified by
                                       // parameter READ_RESET_VALUE_B.

                .sleep(1'b0),                   // 1-bit input: sleep signal to enable the dynamic power saving feature.
                .wea(we_a[i]),                       // WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector
                                       // for port A input data port dina. 1 bit wide when word-wide writes are
                                       // used. In byte-wide write configurations, each bit controls the
                                       // writing one byte of dina to address addra. For example, to
                                       // synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A
                                       // is 32, wea would be 4'b0010.

                .web(we_b[i])                        // WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B-bit input: Write enable vector
                                       // for port B input data port dinb. 1 bit wide when word-wide writes are
                                       // used. In byte-wide write configurations, each bit controls the
                                       // writing one byte of dinb to address addrb. For example, to
                                       // synchronously write only bits [15-8] of dinb when WRITE_DATA_WIDTH_B
                                       // is 32, web would be 4'b0010.

            );
        end
    endgenerate
    
endmodule
*/

//(* DONT_TOUCH = "yes" *)
module heap_memory #(
        parameter HEAP_SIZE             = 32,
        parameter DATA_W                = 8,
        parameter OFFSET                = 11,
        parameter MEM_CTRL              = OFFSET+1,
        parameter BRAM_SIZE             = "18Kb"
    )(
        input wire                              clk,
        input wire                              reset_n,
        input wire  [MEM_CTRL*HEAP_SIZE-1:0]    addr_a,
        input wire  [MEM_CTRL*HEAP_SIZE-1:0]    addr_b,
        input wire  [DATA_W*HEAP_SIZE-1:0]      wr_data_a,
        input wire  [DATA_W*HEAP_SIZE-1:0]      wr_data_b,
        input wire  [HEAP_SIZE-1:0]             port_en,
        
        output wire [DATA_W*HEAP_SIZE-1:0]      rd_data_a,
        output wire [DATA_W*HEAP_SIZE-1:0]      rd_data_b
    );
    
    localparam BRAM_18E1                = 16;                               // For data widths greater than 16, use the whole 36kb BRAM (2*BRAM18E1)
    
    localparam A_DATA_W                 = DATA_W;
    localparam A_OFFSET_W               = OFFSET;
    localparam B_DATA_W                 = DATA_W;
    localparam B_OFFSET_W               = OFFSET;
    localparam A_MEMORY_SIZE            = A_DATA_W << A_OFFSET_W;
    //localparam B_MEMORY_SIZE            = B_DATA_W << B_OFFSET_W;
    
    (* MARK_DEBUG = "TRUE" *)wire    [A_OFFSET_W-1:0]            addr_a_unpkd[0:HEAP_SIZE-1];
    (* MARK_DEBUG = "TRUE" *)wire    [B_OFFSET_W-1:0]            addr_b_unpkd[0:HEAP_SIZE-1];
    (* MARK_DEBUG = "TRUE" *)wire    [A_DATA_W-1:0]              wr_data_a_unpkd[0:HEAP_SIZE-1];
    (* MARK_DEBUG = "TRUE" *)wire    [B_DATA_W-1:0]              wr_data_b_unpkd[0:HEAP_SIZE-1];
    (* MARK_DEBUG = "TRUE" *)wire    [A_DATA_W-1:0]              rd_data_a_unpkd[0:HEAP_SIZE-1];
    (* MARK_DEBUG = "TRUE" *)wire    [B_DATA_W-1:0]              rd_data_b_unpkd[0:HEAP_SIZE-1];
    //wire    [HEAP_SIZE-1:0]             we_a;
    //wire    [HEAP_SIZE-1:0]             we_b;
    wire    [HEAP_SIZE-1:0]             we_a_assert;
    wire    [HEAP_SIZE-1:0]             we_b_assert;
    (* MARK_DEBUG = "TRUE" *)wire    [3:0]                       we_a[0:HEAP_SIZE-1];
    (* MARK_DEBUG = "TRUE" *)wire    [3:0]                       we_b[0:HEAP_SIZE-1];
    
    genvar i;
    
    //////////////////////////////////////////////////////////////////////////
    // DATA_WIDTH_A/B | BRAM_SIZE | RAM Depth | ADDRA/B Width | WEA/B Width //
    // ===============|===========|===========|===============|=============//
    //     19-36      |  "36Kb"   |    1024   |    10-bit     |    4-bit    //
    //     10-18      |  "36Kb"   |    2048   |    11-bit     |    2-bit    //
    //     10-18      |  "18Kb"   |    1024   |    10-bit     |    2-bit    //
    //      5-9       |  "36Kb"   |    4096   |    12-bit     |    1-bit    //
    //      5-9       |  "18Kb"   |    2048   |    11-bit     |    1-bit    //
    //      3-4       |  "36Kb"   |    8192   |    13-bit     |    1-bit    //
    //      3-4       |  "18Kb"   |    4096   |    12-bit     |    1-bit    //
    //        2       |  "36Kb"   |   16384   |    14-bit     |    1-bit    //
    //        2       |  "18Kb"   |    8192   |    13-bit     |    1-bit    //
    //        1       |  "36Kb"   |   32768   |    15-bit     |    1-bit    //
    //        1       |  "18Kb"   |   16384   |    14-bit     |    1-bit    //
    //////////////////////////////////////////////////////////////////////////
    
    generate
        for (i = 0; i < HEAP_SIZE; i = i+1) begin
            //assign we_a[i] = addr_a[(i*MEM_CTRL)+MEM_CTRL-1];
            //assign we_b[i] = addr_b[(i*MEM_CTRL)+MEM_CTRL-1];
            assign we_a_assert[i] = addr_a[(i*MEM_CTRL)+MEM_CTRL-1];
            assign we_b_assert[i] = addr_b[(i*MEM_CTRL)+MEM_CTRL-1];
            assign we_a[i] = (we_a_assert[i]) ? -1 : 0;
            assign we_b[i] = (we_b_assert[i]) ? -1 : 0;
            assign addr_a_unpkd[i] = addr_a[i*MEM_CTRL +: A_OFFSET_W];
            assign addr_b_unpkd[i] = addr_b[i*MEM_CTRL +: B_OFFSET_W];
            assign wr_data_a_unpkd[i] = wr_data_a[i*A_DATA_W +: A_DATA_W];
            assign wr_data_b_unpkd[i] = wr_data_b[i*B_DATA_W +: B_DATA_W];
            assign rd_data_a[i*A_DATA_W +: A_DATA_W] = rd_data_a_unpkd[i];
            assign rd_data_b[i*B_DATA_W +: B_DATA_W] = rd_data_b_unpkd[i];
        end
    endgenerate
    
    generate
        for (i = 0; i < HEAP_SIZE; i = i+1) begin
            BRAM_TDP_MACRO #(
                .BRAM_SIZE(BRAM_SIZE), // Target BRAM: "18Kb" or "36Kb"
				.DEVICE("7SERIES"), // Target device: "7SERIES"
				.DOA_REG(0),        // Optional port A output register (0 or 1)
				.DOB_REG(0),        // Optional port B output register (0 or 1)
				.INIT_A(36'h0000000),  // Initial values on port A output port
				.INIT_B(36'h00000000), // Initial values on port B output port
				.INIT_FILE ("NONE"),
				.READ_WIDTH_A (A_DATA_W),   // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
				.READ_WIDTH_B (B_DATA_W),   // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
				.SIM_COLLISION_CHECK ("ALL"), // Collision check enable "ALL", "WARNING_ONLY",
												//   "GENERATE_X_ONLY" or "NONE"
				.SRVAL_A(36'h00000000), // Set/Reset value for port A output
				.SRVAL_B(36'h00000000), // Set/Reset value for port B output
				.WRITE_MODE_A("WRITE_FIRST"), // "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE"
				.WRITE_MODE_B("WRITE_FIRST"), // "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE"
				.WRITE_WIDTH_A(A_DATA_W), // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
				.WRITE_WIDTH_B(B_DATA_W), // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
				.INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
				
				// The next set of INIT_xx are valid when configured as 36Kb
				.INIT_40(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_41(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_42(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_43(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_44(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_45(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_46(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_47(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_48(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_49(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_4A(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_4B(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_4C(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_4D(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_4E(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_4F(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_50(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_51(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_52(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_53(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_54(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_55(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_56(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_57(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_58(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_59(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_5A(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_5B(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_5C(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_5D(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_5E(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_5F(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_60(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_61(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_62(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_63(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_64(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_65(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_66(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_67(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_68(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_69(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_6A(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_6B(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
				
				// The next set of INITP_xx are for the parity bits
				.INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
				
				// The next set of INITP_xx are valid when configured as 36Kb
				.INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
				.INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000)
            ) BRAM_TDP_MACRO_inst (
				.DOA(rd_data_a_unpkd[i]),       // Output port-A data, width defined by READ_WIDTH_A parameter
				.DOB(rd_data_b_unpkd[i]),       // Output port-B data, width defined by READ_WIDTH_B parameter
				.ADDRA(addr_a_unpkd[i]),   // Input port-A address, width defined by Port A depth
				.ADDRB(addr_b_unpkd[i]),   // Input port-B address, width defined by Port B depth
				.CLKA(clk),     // 1-bit input port-A clock
				.CLKB(clk),     // 1-bit input port-B clock
				.DIA(wr_data_a_unpkd[i]),       // Input port-A data, width defined by WRITE_WIDTH_A parameter
				.DIB(wr_data_b_unpkd[i]),       // Input port-B data, width defined by WRITE_WIDTH_B parameter
				.ENA(port_en[i]),       // 1-bit input port-A enable
				.ENB(1'b1),       // 1-bit input port-B enable
				.REGCEA(1'b0), // 1-bit input port-A output register enable
				.REGCEB(1'b0), // 1-bit input port-B output register enable
				.RSTA(~reset_n),     // 1-bit input port-A reset
				.RSTB(~reset_n),     // 1-bit input port-B reset
				.WEA(we_a[i]),       // Input port-A write enable, width defined by Port A depth
				.WEB(we_b[i])        // Input port-B write enable, width defined by Port B depth
			);
        end
    endgenerate
    
endmodule