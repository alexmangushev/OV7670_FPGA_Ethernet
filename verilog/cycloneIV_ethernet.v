module cycloneIV_ethernet
(
	output [3:0] ENET0_TX_DATA,
	output ENET0_TX_EN,
	output ENET0_TX_ER,
	input ENET0_TX_CLK,
	
	output ENET0_RST_N,
	input CLOCK_50,
	input [1:0] KEY,
	inout [35:0] GPIO,
	
	input [3:0] ENET0_RX_DATA,
	input ENET0_RX_CLK,
	input ENET0_RX_DV
	
);

	localparam ETH_FRAME_SIZE = 1400;
	//assign GPIO[5] = ENET0_RX_CLK;
	//assign GPIO[6] = ENET0_RX_DV;
	//assign GPIO[10:7] = ENET0_RX_DATA;

	assign ENET0_RST_N = 1;
	assign ENET0_TX_ER = 0;
	//assign GPIO[3] = ENET0_TX_CLK;
	//assign GPIO[4:1] = ENET0_TX_DATA;
	assign GPIO[5] = ENET0_TX_EN;
	
	wire eth_finish;
	
	wire clk_10;
	wire init_clk;
	wire clk;
	
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
	
	reg reset;
	wire cam_end;
	
	assign GPIO[4] = pix_valid;
	//assign GPIO[6] = eth_finish;
	//assign GPIO[7] = ram_en;
	//assign GPIO[6] = GPIO[34];
	//assign GPIO[7] = GPIO[35];
	
	camera_initialization
	(
		.clk_in_50(clk),
		.start(1'b1),
		.frame_done(frame_done),
		.clk_camera(GPIO[30]),
		.SCCB_data(GPIO[34]),
		.SCCB_clk(GPIO[35]),
		.init_finish(cam_end)
	);

	camera_read
	(
		.p_clock(GPIO[31]),
		.vsync(GPIO[33]),
		.href(GPIO[32]),
		.p_data(GPIO[29:22]),
		.pixel_data(cam_data),
		.pixel_valid(pix_valid),
		.frame_done(frame_done)
	);
	
	
	
	// initialization delay
		
	init_delay
	(
		.init_clk(init_clk),
		.clk_50(CLOCK_50),
		.clk(clk)
	);
		
	pll p1 // 10kHz
	(
		.inclk0(CLOCK_50),
		.c0(clk_10)
	);
	
	pll p2 // 5Hz
	(
		.inclk0(clk_10),
		.c0(init_clk)
	);
	
	
	/*cam_data_generation cam
	(
		.clk(cam_clk),
		.data_to_send(cam_data),
		.pixel_valid(pix_valid),
		.frame_done(frame_done),
		.reset(reset)
	);*/
	
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
		.eth_contr_reset(eth_reset)
		
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
		.clk_eth(ENET0_TX_CLK),
		.clk(clk),
		
		.MII(ENET0_TX_DATA),
		.MII_EN(ENET0_TX_EN),
		
		.ram_addr(eth_ram_addr),
		.ram_data_out(send_data),
		.ram_data_in(send_data_in),
		.ram_clk(eth_ram_clk),
		
		.ram_en(eth_ram_en),
		.eth_finish_out(eth_finish)
	);
	
	always@ (posedge clk) begin
		//if (KEY[0] == 0)
		if (cam_end == 0)
			reset <= 1;
		else
			reset <= 0;
	end


endmodule
