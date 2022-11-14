///////// Модуль для отправки данных по Ethernet
module ethernet_send_data
#(
    parameter ETH_FRAME_SIZE = 70 // octets
)
(
	output reg [3:0] ETH_TX_DATA,
	input ETH_TX_CLK,
	output reg ETH_TX_EN,
	
	input [7:0] data,
	output reg [10:0] data_adr,
	input start,
	output reg finish
);
	reg cur_tetrada;
	
	localparam FSM_IDLE = 0;
	localparam FSM_TX = 1;
	reg FSM_STATE = FSM_IDLE;
	
	reg [12:0] cnt;
		
	always@ (posedge ETH_TX_CLK) begin
	
		case(FSM_STATE)
		
			FSM_IDLE: ///////
			begin
				ETH_TX_EN <= 0;
				ETH_TX_DATA <= 0;
				finish <= 0;
				data_adr <= 0;
				cnt <= 0;
				cur_tetrada <= 0;
				if (start)
					FSM_STATE <= FSM_TX;
				else
					FSM_STATE <= FSM_IDLE;
			end
			
			FSM_TX: /////////
			begin
				
				if (cnt >= ETH_FRAME_SIZE * 2) begin
					ETH_TX_DATA <= 0;
					cnt <= 0;
					FSM_STATE <= FSM_IDLE;
					ETH_TX_EN <= 0;
					data_adr <= 0;
					finish <= 1;
				end
				else begin
					ETH_TX_EN <= 1;
					cnt <= cnt + 1;
					
					if (cur_tetrada)
					begin
						ETH_TX_DATA <= data[7:4];
					end
					else
					begin
						ETH_TX_DATA <= data[3:0];
						data_adr = data_adr + 1;
					end
					
					cur_tetrada <= !cur_tetrada;
				end
				
			end
		
		endcase
	end
	
endmodule
