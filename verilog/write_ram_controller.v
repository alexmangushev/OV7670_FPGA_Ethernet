////////// Модуль записи данных с камеры в память и управления отправкой
module write_ram_controller
#(
	parameter ETH_DATA_SIZE = 1280
)
(
	input reset,
	input clk,
	
	input pix_valid,
	input [7:0] cam_data,
	input frame_done,
	
	input eth_finish,
	input eth_contr_clk,
	input eth_contr_wr_en,
	input [7:0] eth_contr_din,
	input [10:0] eth_contr_addr,
	
	output reg ram_clk,
	output reg ram_wr_en,
	output reg rom_wr_en,
	output reg [7:0] ram_din,
	output reg [10:0] ram_addr,
	output reg eth_contr_reset,
	
	output [1:0] FSM_state,
	output reg mux_send
);

	localparam FSM_IDLE = 0;
	localparam FSM_WRITE_DATA = 1;
	localparam FSM_ETH_CONTR = 2;
	localparam FSM_ETH_CONTR_ROM = 3;
	
	reg [1:0] state, next_state;
	reg [10:0] cnt;
	reg clk_intr;
	
	assign FSM_state = state;
	
	
	// счетчик адреса для памяти
	always@ (posedge pix_valid)
	if (next_state == FSM_WRITE_DATA)
		cnt <= cnt + 1;
	else
		cnt <= 50;

		
	// выбор источника тактового сигнала
	always@ *
	case(state)
	FSM_IDLE:
		clk_intr = clk;
	FSM_WRITE_DATA:
		clk_intr = clk;
	FSM_ETH_CONTR:
		clk_intr = eth_contr_clk;
	FSM_ETH_CONTR_ROM:
		clk_intr = eth_contr_clk;
	endcase
		
	// Выбор переходов
	always@ * 
	case(state)
	FSM_IDLE: begin
		if (pix_valid)
			next_state = FSM_WRITE_DATA;
		else if (frame_done)
			next_state = FSM_ETH_CONTR_ROM;
		else
			next_state = FSM_IDLE;
	end
	FSM_WRITE_DATA:
		//if (cnt > ETH_DATA_SIZE + 49)
		if (cnt > ETH_DATA_SIZE + 48)
			next_state = FSM_ETH_CONTR;
		else
			next_state = FSM_WRITE_DATA;
	FSM_ETH_CONTR:
		if (eth_finish)
			next_state = FSM_IDLE;
		else
			next_state = FSM_ETH_CONTR;
	FSM_ETH_CONTR_ROM:
		if (eth_finish)
			next_state = FSM_IDLE;
		else
			next_state = FSM_ETH_CONTR_ROM;
	endcase
		
	// Выбор состояния выходов
	always@ * 
	case(state)
	FSM_IDLE: begin
		ram_clk = pix_valid;
		ram_wr_en = 0;
		rom_wr_en = 0;
		eth_contr_reset = 1;
		ram_din = cam_data;
		ram_addr = 50;
		mux_send = 1; //ram
	end
	FSM_WRITE_DATA: begin
		ram_clk = pix_valid;
		ram_wr_en = 1;
		rom_wr_en = 0;
		eth_contr_reset = 1;
		ram_din = cam_data;
		ram_addr = cnt;
		mux_send = 1; //ram
	end
	FSM_ETH_CONTR: begin
		ram_clk = eth_contr_clk;
		ram_wr_en = eth_contr_wr_en;
		rom_wr_en = 0;
		eth_contr_reset = 0;
		ram_din = eth_contr_din;
		ram_addr = eth_contr_addr;
		mux_send = 1; //ram
	end
	FSM_ETH_CONTR_ROM: begin
		ram_clk = eth_contr_clk;
		ram_wr_en = 0;
		rom_wr_en = eth_contr_wr_en;
		eth_contr_reset = 0;
		ram_din = eth_contr_din;
		ram_addr = eth_contr_addr;
		mux_send = 0; //rom
	end
		
	endcase
	
	// Технический блок для сброса
	always@ (posedge clk_intr or posedge reset)
	if (reset)
		state <= FSM_IDLE;
	else
		state <= next_state;
		

endmodule
