module ram
(
	input clk,
   input [10:0] addr,
   output reg [7:0] dout,
	input [7:0] din,
	input wr_en
);

	integer i;
	reg [8:0] mem[1400:0];
	
	initial begin
	
		mem[0] = 8'h55; //preambula
		mem[1] = 8'h55; //preambula
		mem[2] = 8'h55; //preambula
		mem[3] = 8'h55; //preambula
		mem[4] = 8'h55; //preambula
		mem[5] = 8'h55; //preambula
		mem[6] = 8'h55; //preambula
		mem[7] = 8'hd5; //preambula
	
		// mac dst
		mem[8] = 8'hff;
		mem[9] = 8'hff;
		mem[10] = 8'hff;
		mem[11] = 8'hff;
		mem[12] = 8'hff;
		mem[13] = 8'hff;
	
		// mac src
		mem[14] = 8'hd0;
		mem[15] = 8'h37;
		mem[16] = 8'h45;
		mem[17] = 8'hf6;
		mem[18] = 8'h6d;
		mem[19] = 8'h9c;
		
		// IPV4
		mem[20] = 8'h08;
		mem[21] = 8'h00;
		
		mem[22] = 8'h45;
		mem[23] = 8'h00;
	
		// len
		//mem[24] = 8'h00;
		//mem[25] = 8'h2c; //44(in 10)
		
		mem[24] = 8'h05;
		mem[25] = 8'h5e; //44(in 10)
		
		
		mem[26] = 8'haa;
		mem[27] = 8'h71;
		mem[28] = 8'h40; //don't fragment
		mem[29] = 8'h00;
		mem[30] = 8'h80; //ttl
		mem[31] = 8'h11; //udp
		
		// checksum
		//mem[32] = 8'h41; 
		//mem[33] = 8'h05;
		
		mem[32] = 8'h3b; 
		mem[33] = 8'hd3;

		// ip src
		mem[34] = 8'hc0;
		mem[35] = 8'ha8;
		mem[36] = 8'h01;
		mem[37] = 8'h02;
		
		// ip dst
		mem[38] = 8'ha9;
		mem[39] = 8'hfe;
		mem[40] = 8'ha3;
		mem[41] = 8'ha1;
		
		/*mem[38] = 8'h7f;
		mem[39] = 8'h0;
		mem[40] = 8'h0;
		mem[41] = 8'h0f;*/

		// udp src port
		mem[42] = 8'hf1;
		mem[43] = 8'h52;
		
		// udp dst port
		mem[44] = 8'h4e;
		mem[45] = 8'h21;
		
		// length_data
		//mem[46] = 8'h00; //70 общая длина пакета
		//mem[47] = 8'h18;
		mem[46] = 8'h05; //1400 общая длина пакета
		mem[47] = 8'h4a;
		
		// checksum
		mem[48] = 8'h00;
		mem[49] = 8'h00;
		
		// data
		mem[50] = 8'h48;
		mem[51] = 8'h65;
		mem[52] = 8'h6c;
		mem[53] = 8'h6c;
		mem[54] = 8'h6f;
		mem[55] = 8'h20;
		mem[56] = 8'h55;
		mem[57] = 8'h44;
		mem[58] = 8'h50;
		mem[59] = 8'h20;
		mem[60] = 8'h53;
		mem[61] = 8'h65;
		mem[62] = 8'h72;
		mem[63] = 8'h76;
		mem[64] = 8'h65;
		mem[65] = 8'h72;
		
		for (i = 66; i < 1400; i = i + 1)
			mem[i] = 8'hff;
		
		// ethernet_checksum
		/*mem[66] = 8'h5c;
		mem[67] = 8'he5;
		mem[68] = 8'hb9;
		mem[69] = 8'hf6;*/
	end
		
	always @(posedge clk) begin
		if (wr_en == 1'b1) begin
			mem[addr] <= din; //write 
		end	
		dout <= mem[addr]; //read
	end
			
endmodule
