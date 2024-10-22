`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2024 05:00:52 PM
// Design Name: 
// Module Name: skids_top
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


module skids_top #(
        parameter TRANSLATORS           = 8,
        parameter ADDR_W                = 16,
        parameter DATA_W                = 32
    )(
        input wire                              clk,
        input wire                              reset_n,
        input wire  [TRANSLATORS-1:0]           pl_port_ready,
        input wire  [TRANSLATORS-1:0]           pl_addr_valid,
        input wire  [ADDR_W*TRANSLATORS-1:0]    pl_addr_bus,
        input wire  [DATA_W*TRANSLATORS-1:0]    pl_wr_data_bus,
        
        output wire [TRANSLATORS-1:0]           skid_pl_addr_valid,
        output wire [ADDR_W*TRANSLATORS-1:0]    skid_pl_addr_bus,
        output wire [DATA_W*TRANSLATORS-1:0]    skid_pl_wr_data_bus
    );
    
    wire    [ADDR_W-1:0]                pl_addr_bus_unpkd[0:TRANSLATORS-1];
    wire    [ADDR_W-1:0]                skid_pl_addr_bus_unpkd[0:TRANSLATORS-1];
    wire    [DATA_W-1:0]                pl_wr_data_bus_unpkd[0:TRANSLATORS-1];
    wire    [DATA_W-1:0]                skid_pl_wr_data_bus_unpkd[0:TRANSLATORS-1];
    
    genvar i;
    
    // Generate Skid buffers for PL inputs
    generate
        for (i = 0; i < TRANSLATORS; i = i+1) begin
            // Unpack and Pack data
            assign pl_addr_bus_unpkd[i] = pl_addr_bus[i*ADDR_W +: ADDR_W];
            assign pl_wr_data_bus_unpkd[i] = pl_wr_data_bus[i*DATA_W +: DATA_W];
            assign skid_pl_addr_bus[i*ADDR_W +: ADDR_W] = skid_pl_addr_bus_unpkd[i];
            assign skid_pl_wr_data_bus[i*DATA_W +: DATA_W] = skid_pl_wr_data_bus_unpkd[i];
            // Skid pl_addr_valid
            skids #(
                .DATA_W(1)
            ) skid_pl_addr_valid_i (
                .clk(clk),
                .reset_n(reset_n),
                .skid_en(pl_port_ready[i]),
                .din(pl_addr_valid[i]),
                
                .dout(skid_pl_addr_valid[i])
            );
            // Skid pl_addr_bus
            skids #(
                .DATA_W(ADDR_W)
            ) skid_pl_addr_bus_i (
                .clk(clk),
                .reset_n(reset_n),
                .skid_en(pl_port_ready[i]),
                .din(pl_addr_bus_unpkd[i]),
                
                .dout(skid_pl_addr_bus_unpkd[i])
            );
            // Skid pl_wr_data_bus
            skids #(
                .DATA_W(DATA_W)
            ) skid_pl_wr_data_bus_i (
                .clk(clk),
                .reset_n(reset_n),
                .skid_en(pl_port_ready[i]),
                .din(pl_wr_data_bus_unpkd[i]),
                
                .dout(skid_pl_wr_data_bus_unpkd[i])
            );
        end
    endgenerate
    
endmodule
