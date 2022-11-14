module cam_ram_data
#(parameter DATA_SIZE = 640 * 2)
(
	input pixel_valid,
	input frame_done,
	input reset,
	output [10:0] ram_addr
);

	reg [10:0] cnt;
	assign ram_addr = cnt;
	
	always@ (posedge pixel_valid) begin
		if (reset || cnt >= DATA_SIZE || frame_done)
			cnt <= 8;
		else
			cnt <= cnt + 1;
	end

endmodule
