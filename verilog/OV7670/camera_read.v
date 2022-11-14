`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:12:24 12/03/2014 
// Design Name: 
// Module Name:    camera_read 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module camera_read(
	input wire p_clock,
	input wire vsync,
	input wire href,
	input wire [7:0] p_data,
	output [7:0] pixel_data,
	output reg pixel_valid,
	output reg frame_done
);
	 
	assign pixel_data = p_data;
	reg [1:0] FSM_state = 0, FSM_cur_state = 0;
	
	localparam WAIT_FRAME_START = 0;
	localparam ROW_CAPTURE = 1;
	
	always@(posedge p_clock)
	begin
		FSM_state <= FSM_cur_state;
	end
	
	always@*
	case(FSM_state)
	
		WAIT_FRAME_START: begin //wait for VSYNC
			FSM_cur_state = (!vsync) ? ROW_CAPTURE : WAIT_FRAME_START;
		end
	
		ROW_CAPTURE: begin 
			FSM_cur_state = vsync ? WAIT_FRAME_START : ROW_CAPTURE;
		end
	
	endcase

	always@*
	case(FSM_state)
		WAIT_FRAME_START: begin
			pixel_valid = 0;
			frame_done = 0;
		end
		
		ROW_CAPTURE: begin 
			if (href)
				pixel_valid = p_clock;
			else
				pixel_valid = 0;
				
			frame_done = vsync ? 1 : 0;
		end
	endcase
	
endmodule
