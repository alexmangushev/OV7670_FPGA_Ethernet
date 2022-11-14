module write_ram_controller_for_testbench
(
	input reset,
	input cam_reset,
	input clk_eth,
	input clk,
	input clk_cam,
	output [4:0] MII,
	output MII_EN,
	output eth_finish,
	
	output ram_en_out,
	output [10:0] ram_addr_out,
	output [7:0] ram_data_in_out,
	output [7:0] ram_data_out_out,
	
	output [7:0] cam_data_out,
	output pix_valid_out,
	output frame_done_out,
	
	output [1:0] FSM_state
	
);

	localparam ETH_FRAME_SIZE = 1400;

	wire ram_clk;
	wire eth_ram_clk;
	wire eth_ram_en;
	wire ram_en;
	wire rom_en;
	wire eth_reset;
	wire [10:0] eth_ram_addr;
	
	wire [10:0] ram_addr;
	wire [7:0] ram_data_out;
	wire [7:0] rom_data_out;
	wire [7:0] send_data_in;
	wire [7:0] send_data;
	
	wire [7:0] ram_data_in;
	
	wire [7:0] cam_data;
	wire pix_valid;
	wire frame_done;
	
	
	assign ram_en_out = ram_en;
	assign ram_addr_out = ram_addr;
	assign ram_data_in_out = ram_data_in;
	assign ram_data_out_out = send_data;
	
	assign cam_data_out = cam_data;
	assign pix_valid_out = pix_valid;
	assign frame_done_out = frame_done;
	
	cam_data_generation cam
	(
		.clk(clk_cam),
		.data_to_send(cam_data),
		.pixel_valid(pix_valid),
		.frame_done(frame_done),
		.reset(cam_reset)
	);
	
	write_ram_controller wr
	(
		.reset(reset),
		.clk(clk),
		
		.pix_valid(pix_valid),
		.cam_data(cam_data),
		.frame_done(frame_done),
		
		.eth_finish(eth_finish),
		.eth_contr_clk(eth_ram_clk),
		.eth_contr_wr_en(eth_ram_en),
		.eth_contr_din(send_data_in),
		.eth_contr_addr(eth_ram_addr),
		
		.ram_dout(ram_data_out),
		.rom_dout(rom_data_out),
		
		.ram_clk(ram_clk),
		.ram_wr_en(ram_en),
		.rom_wr_en(rom_en),
		.ram_din(ram_data_in),
		.send_data(send_data),
		.ram_addr(ram_addr),
		.eth_contr_reset(eth_reset),
		
		.FSM_state(FSM_state)
	);
	
	ram ram1
	(	
		.clk(ram_clk),
		.addr(ram_addr),
		.dout(ram_data_out),
		.din(ram_data_in),
		.wr_en(ram_en)
	);
	
	rom rom1
	(	
		.clk(ram_clk),
		.addr(ram_addr),
		.dout(rom_data_out),
		.din(ram_data_in),
		.wr_en(rom_en)
	);
	
	
	send_and_FCS_controller #(ETH_FRAME_SIZE) send
	(
		.reset(eth_reset),
		.clk_eth(clk_eth),
		.clk(clk),
		
		.MII(MII),
		.MII_EN(MII_EN),
		
		.ram_addr(eth_ram_addr),
		.ram_data_out(send_data),
		.ram_data_in(send_data_in),
		.ram_clk(eth_ram_clk),
		
		.ram_en(eth_ram_en),
		.eth_finish_out(eth_finish)
	);

endmodule