//let's set the time scale for the simulation and the accuracy of calculating time intervals
`timescale 1ns/ 1ps

module testbench_write_ram_controller();

	reg clk;
	reg cam_clk;
	reg eth_clk;
	reg cam_reset;
	reg reset;
	
	wire [3:0] MII;
	wire MII_EN;
	
	wire eth_finish;
	
	wire ram_en_out;
	wire [10:0] ram_addr_out;
	wire [7:0] ram_data_in_out;
	wire [7:0] ram_data_out_out;
	
	wire [7:0] cam_data_out;
	wire pix_valid_out;
	wire frame_done_out;
	
	reg [20:0] cnt;
	
	wire [1:0] FSM_state;
	
	initial begin
		cnt = 0;
		clk = 0;
		eth_clk = 0;
		cam_clk = 0;
		reset = 1;
		cam_reset = 1;
	end
	
	write_ram_controller_for_testbench t
	(
		.reset(reset),
		.cam_reset(cam_reset),
		.clk_eth(eth_clk),
		.clk(clk),
		.clk_cam(cam_clk),
		.MII(MII),
		.MII_EN(MII_EN),
		.eth_finish(eth_finish),
		
		.ram_en_out(ram_en_out),
		.ram_addr_out(ram_addr_out),
		.ram_data_in_out(ram_data_in_out),
		.ram_data_out_out(ram_data_out_out),
		
		.cam_data_out(cam_data_out),
		.pix_valid_out(pix_valid_out),
		.frame_done_out(frame_done_out),
		
		.FSM_state(FSM_state)
		
	);

	
	initial
		begin
			clk = 0;
		end

	always
		#1 clk = !clk; //50 MHz
		
	always
		#2 eth_clk = !eth_clk; //25 MHz
		
	always
		#20 cam_clk = !cam_clk; //2.5 MHz
	
	always@ (posedge cam_clk) begin
		cnt <= cnt + 1;
		cam_reset <= 0;
		reset <= 0;
		if (cnt == 2) begin
			cam_reset <= 1;
			reset <= 1;
		end
	end
		
endmodule
