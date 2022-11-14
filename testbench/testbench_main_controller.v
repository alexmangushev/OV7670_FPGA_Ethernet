//let's set the time scale for the simulation and the accuracy of calculating time intervals
`timescale 1ns/ 1ps
module testbench_main_controller;
	
	reg clk;
	reg clk_eth;
	wire ram_clk;
	reg reset;
	wire [3:0] MII;
	wire MII_EN;
	wire [31:0] crc;
	wire [10:0] ram_addr;
	wire [7:0] ram_data_out;
	wire [7:0] ram_data_in;
	
	wire eth_start;
	wire eth_finish;
	wire fcs_start;
	wire fcs_finish;
	
	wire [2:0] FSM_STATE;
	wire ram_wr;
	
	main_controller_for_testbench m
	(
		.reset(reset),
		.clk_eth(clk_eth),
		.clk(clk),
		.MII(MII),
		.MII_EN(MII_EN),
		.crc_out(crc),
		
		.ram_clock(ram_clk),
		.ram_addrr(ram_addr),
		.ram_data_out(ram_data_out),
		.ramm_data_in(ram_data_in),
		
		.eth_start_out(eth_start),
		.eth_finish_out(eth_finish),
		.fcs_start_out(fcs_start),
		.fcs_finish_out(fcs_finish),
		
		.FSM_STATE(FSM_STATE),
		.ram_wr(ram_wr)
	);
	
	reg [11:0] cnt = 0;
	
	initial begin
		cnt = 0;
		clk = 1;
		clk_eth = 1;
		reset = 1;
	end

	always
		#5 clk = !clk;
		
	always
		#3 clk_eth = !clk_eth;

	
	always@ (posedge clk) begin
		cnt <= cnt + 1;
		reset <= 0;
		if (cnt == 2)
			reset <= 1;
	end
		
endmodule
