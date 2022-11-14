//let's set the time scale for the simulation and the accuracy of calculating time intervals
`timescale 1ns/ 1ps
module testbench_FCS();
	
	reg clk;
	wire [31:0] crc;
	wire finish;
	reg reset;
	wire [7:0] d;
	wire [31:0] ddd;
	wire[10:0] data_addr;
	
	FCS_for_testbench t
	(
		.clk(clk),
		.reset(reset),
		.crc(crc),
		.data_addr(data_addr),
		.finish(finish),
		.d(d),
		.ddd(ddd)
	);
	
	reg [15:0] cnt = 0;
	
	initial begin
		clk = 1;
		reset = 0;
	end

	always
		#100 clk = !clk;
		
	always@ (posedge clk) begin
		cnt <= cnt + 1;
		reset <= 0;
		if (cnt == 5)
			reset <= 1;
			
	end
		
	always@ (posedge finish) begin
		cnt = 0;
	end
		
endmodule	
		

