module init_delay
(
	input init_clk,
	input clk_50,
	output reg clk
);

	always@*
		clk = ready ? clk_50 : 1'b0;
		
	reg [5:0] init_delay_reg;
	reg [27:0] cnt;
	reg ready;
	
	always@ (posedge init_clk) begin
		if (init_delay_reg == 6'd60) begin
			ready <= 1'b1;
		end
		else begin
			init_delay_reg <= init_delay_reg + 1;
			ready <= 1'b0;
		end
	end

endmodule
