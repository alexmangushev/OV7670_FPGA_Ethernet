module ethernet_send_data_for_testbench
(
	input clk,
	output [4:0] MII,
	output MII_EN
);

	wire [7:0] data;
	wire [10:0] data_adr;
	wire EN;
	
	ethernet_send_data #(70) send1
	(
		.ETH_TX_DATA(MII),
		.ETH_TX_CLK(clk),
		.ETH_TX_EN(MII_EN),
		.data(data),
		.data_adr(data_adr),
		.start(1'b1)
	);
	
	ram ram1
	(	
		.clk(clk),
		.addr(data_adr),
		.dout(data),
		.din(0),
		.wr_en(1'b0)
	);

endmodule
