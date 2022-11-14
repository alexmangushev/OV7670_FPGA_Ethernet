//let's set the time scale for the simulation and the accuracy of calculating time intervals
`timescale 1ns/ 1ps
module testbench_cam_data_generation;
	
	reg clk;
	wire [7:0] data;
	wire pixel_valid;
	wire frame_done;
	reg reset;
	wire [1:0] FCM;
	integer i;
	
	data_generation d
	(
		.clk(clk),
		.data_to_send(data),
		.pixel_valid(pixel_valid),
		.frame_done(frame_done),
		.reset(reset),
		.FCM(FCM)
	);
	
	initial begin
		i = 0;
		reset = 1;
		clk = 0;
	end

	always
		#1 clk = !clk;
		
	
	always@ (posedge clk) begin
		i <= i + 1;
		reset = 0;
	end
		
endmodule
