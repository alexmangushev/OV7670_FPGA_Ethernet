module FCS_for_testbench
(
	input clk,
	input reset,
	output [31:0] crc,
	output finish,
	output [10:0] data_addr,
	output [7:0] d,
	output [31:0] ddd
);

	wire [10:0] data_adr;
	wire [7:0] data_rom;
	
	assign data_addr = data_adr;
	
	ram ram
	(	
		.clk(clk),
		.addr(data_adr),
		.dout(data_rom),
		.wr_en(1'b0),
		.din(0)
	);
	
	FCS F
	(
		.clk(clk),
		.crc32_out(crc),
		.data_adr(data_adr),
		.data(data_rom),
		.finish(finish),
		.d(d),
		.reset(reset),
		.ddd(ddd)
	);
endmodule
