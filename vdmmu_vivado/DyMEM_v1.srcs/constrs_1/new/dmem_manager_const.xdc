
set clk_p 12.5;

create_clock -name sys_clk -period "$clk_p" [get_ports "clk"];

set_input_delay -clock "sys_clk" -max 1.5 [get_ports [list "reset_n" "benes_restart" "req_valid" "req_type" "req_bytes" "req_trans" "ps_addr_valid" "ps_trans_id" "ps_addr_bus" "ps_wr_data_bus" "ps_we" "pl_addr_valid" "pl_addr_bus" "pl_wr_data_bus"]];
set_input_delay -clock "sys_clk" -min 1.5 [get_ports [list "reset_n" "benes_restart" "req_valid" "req_type" "req_bytes" "req_trans" "ps_addr_valid" "ps_trans_id" "ps_addr_bus" "ps_wr_data_bus" "ps_we" "pl_addr_valid" "pl_addr_bus" "pl_wr_data_bus"]];

set_output_delay -clock "sys_clk" -max 0.5 [get_ports [list "rep_trans" "rep_ack" "heap_full" "ps_rd_data_bus" "ps_rd_data_valid" "pl_port_ready" "pl_rd_data_bus" "pl_rd_data_valid"]];
set_output_delay -clock "sys_clk" -min 0.5 [get_ports [list "rep_trans" "rep_ack" "heap_full" "ps_rd_data_bus" "ps_rd_data_valid" "pl_port_ready" "pl_rd_data_bus" "pl_rd_data_valid"]];

