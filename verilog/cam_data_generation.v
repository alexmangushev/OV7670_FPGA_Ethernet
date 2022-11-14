module cam_data_generation
(
	input clk,
	output reg [7:0] data_to_send,
	output reg pixel_valid,
	output reg frame_done,
	output [1:0] FCM,
	input reset
);

	localparam HOR_MAX = 1280;
	localparam VERT_MAX = 480;
	//localparam VERT_MAX = 3;
	localparam START_PAUSE = 17400;
	//localparam START_PAUSE = 1280;
	localparam END_PAUSE = 6255;
	localparam VERT_PAUSE = 144;
	//localparam VERT_PAUSE = 700;
	
	/*localparam HOR_MAX = 1280;
	localparam VERT_MAX = 480;
	localparam START_PAUSE = 100;
	localparam END_PAUSE = 100;
	localparam VERT_PAUSE = 700;*/
	
	/*localparam HOR_MAX = 10;
	localparam VERT_MAX = 10;
	localparam START_PAUSE = 5;
	localparam END_PAUSE = 10;
	localparam VERT_PAUSE = 15;*/
	
	reg [18:0] hor_cur;
	reg [18:0] vert_cur;
	
	//localparam FSM_INITIAL = 0;
	localparam FSM_START = 0;
   localparam FSM_HOR_DATA = 1;
   localparam FSM_VERT_PAUSE = 2;
   localparam FSM_END = 3;
	
	reg [1:0] FSM_state, next_state;
	assign FCM = FSM_state;
	
	always@ * 
	if (FSM_state == FSM_HOR_DATA)
		pixel_valid = clk;
	else
		pixel_valid = 0;
	
	
	always@ (posedge clk) begin
	if (reset) begin
		hor_cur <= 0;
		vert_cur <= 0;
		data_to_send <= 0;
		frame_done <= 0;
		//pixel_valid <= 0;
		FSM_state <= FSM_START;
	end
	else begin
		case(FSM_state)
		
			FSM_START: ///////////
			begin
				frame_done <= 0;
				hor_cur <= hor_cur + 1;
				vert_cur <= 0;
				
				if (hor_cur >= START_PAUSE)
				begin
					hor_cur <= 0;
					FSM_state <= FSM_HOR_DATA;
				end
			end
			
			
			FSM_HOR_DATA: //////////
			begin		
				if (hor_cur >= HOR_MAX - 1)
				begin
					hor_cur <= 0;
					FSM_state <= FSM_VERT_PAUSE;
				end
				else begin
					hor_cur <= hor_cur + 1;
					data_to_send <= data_to_send + 1;
				end
			end
			
			
			FSM_VERT_PAUSE: /////////////
			begin
				hor_cur <= hor_cur + 1;
				
				if (hor_cur >= VERT_PAUSE)
				begin
					hor_cur <= 0;
					FSM_state <= FSM_HOR_DATA;
					vert_cur = vert_cur + 1;
					if (vert_cur >= VERT_MAX)
					begin
						hor_cur <= 0;
						FSM_state <= FSM_END;
					end
				end
			end
			
			FSM_END: ///////////
			begin
				hor_cur <= hor_cur + 1;
				
				if (hor_cur >= END_PAUSE)
				begin
					hor_cur <= 0;
					vert_cur <= 0;
					frame_done <= 1;
					data_to_send <= data_to_send + 1;
					FSM_state <= FSM_START;
				end
				
			end
			
		endcase
	end
	end

endmodule
