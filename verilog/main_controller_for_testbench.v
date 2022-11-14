module main_controller_for_testbench
(
	input reset,
	input clk_eth,
	input clk,
	output [4:0] MII,
	output MII_EN,
	output [31:0] crc_out,
	output [10:0] ram_addrr,
	output [7:0] ram_data_out,
	output [7:0] ramm_data_in,
	output ram_clock,
	output eth_start_out,
	output eth_finish_out,
	output fcs_start_out,
	output fcs_finish_out,
	
	output[2:0] FSM_STATE,
	output ram_wr
);


	localparam ETH_FRAME_SIZE = 1400;
	
	wire eth_start;
	wire eth_finish;
	wire fcs_start;
	wire fcs_finish;
	
	assign eth_start_out = eth_start;
	assign eth_finish_out = eth_finish;
	assign fcs_start_out = fcs_start;
	assign fcs_finish_out = fcs_finish; 
	
	
	wire ram_clk;
	wire [10:0] ram_addr;
	wire [10:0] eth_ram_addr;
	wire [10:0] fcs_ram_addr;
	wire [7:0] ram_data_in;
	wire [7:0] data;
	wire ram_en;
	
	assign ram_clock = ram_clk;
	assign ram_addrr = ram_addr;
	assign ram_data_out = data;
	assign ramm_data_in = ram_data_in;
	
	wire [31:0] crc;
	assign crc_out = crc;
	
	assign ram_wr = ram_en;
	
	ethernet_send_data #(ETH_FRAME_SIZE) send1
	(
		.ETH_TX_DATA(MII),
		.ETH_TX_CLK(clk_eth),
		.ETH_TX_EN(MII_EN),
		.data(data),
		.data_adr(eth_ram_addr),
		.start(eth_start),
		.finish(eth_finish)
	);
	
	ram ram1
	(	
		.clk(ram_clk),
		.addr(ram_addr),
		.dout(data),
		.din(ram_data_in),
		.wr_en(ram_en)
	);
	
	FCS #(ETH_FRAME_SIZE) F
	(
		.clk(clk),
		.crc32_out(crc),
		.data_adr(fcs_ram_addr),
		.data(data),
		.reset(fcs_start),
		.finish(fcs_finish)
	);
	
	main_controller #(ETH_FRAME_SIZE) m
	(
		.FSM_STATE(FSM_STATE),
		
		.clk_in(clk),
		.eth_clk(clk_eth),
		
		.eth_finish(eth_finish),
		.fcs_finish(fcs_finish),
		.reset(reset),
		
		.fcs_ram_addr(fcs_ram_addr),
		.eth_ram_addr(eth_ram_addr),
		
		.crc_in(crc),
		
		.eth_start(eth_start),
		.fcs_start(fcs_start),
		
		.ram_clk(ram_clk),
		.ram_addr(ram_addr),
		.ram_data_in(ram_data_in),
		.ram_en(ram_en)
		
	);

endmodule
