module camera_initialization
(
	input clk_in_50,
	input start,
	input frame_done,
	output clk_camera,
	output SCCB_data,
	output SCCB_clk,
	output reg init_finish
);

reg clk;
wire init_done;
reg init_end;
reg frame_done_;
assign clk_camera = clk;

always @*
	frame_done_ = init_finish ? 1'b1 : frame_done;

// start configure camera
camera_configure  conf(
	.clk(clk),
	.start(start),
   .sioc(SCCB_clk),
   .siod(SCCB_data),
   .done(init_done)
	);

//clock for module config
always @(posedge clk_in_50)
	clk = !clk;
	
	
// signal for ready to read data

always @(posedge clk)
	if (init_done && frame_done_)
		init_finish <= 1'b1;
	else
		init_finish <= 1'b0;
	
endmodule
