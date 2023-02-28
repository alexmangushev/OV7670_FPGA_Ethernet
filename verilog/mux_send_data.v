module mux_send_data
(
	input source,
	
	input [7:0] ram_data,
	input [7:0] rom_data,
	
	output reg [7:0] send_data
);

	always@*
		case(source)
			1'b0: send_data = rom_data;
			1'b1: send_data = ram_data;
		endcase

endmodule
