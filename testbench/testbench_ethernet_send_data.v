//let's set the time scale for the simulation and the accuracy of calculating time intervals
`timescale 1ns/ 100ps

module testbench_ethernet_send_data();

	reg clk;
	wire [3:0] MII;
	wire MII_EN;
	
	ethernet_send_data_for_testbench eth
	(
		.clk(clk),
		.MII(MII),
		.MII_EN(MII_EN)
	);
	
	initial
		begin
			clk = 0;
		end

	always
		#1 clk = !clk;
		
endmodule
