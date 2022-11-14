////////// Модуль для управления передачей данных из памяти по ethernet
////////// и расчета FCS с записью в память
module main_controller
#(
    parameter ETH_FRAME_SIZE = 70 // octets
)
(
	
	output [2:0] FSM_STATE,
		
	input clk_in,
	input eth_clk,
		
	input eth_finish,
	input fcs_finish,
	input reset,
		
	input [10:0] fcs_ram_addr,
	input [10:0] eth_ram_addr,
		
	input [31:0] crc_in,
		
	output reg eth_start,
	output reg fcs_start,
		
	output reg ram_clk,
	output reg [10:0] ram_addr,
	output reg [7:0] ram_data_in,
	output reg ram_en
);

	localparam FSM_IDLE = 0;
	localparam FSM_FCS = 1;
	localparam FSM_FCS_IDLE = 2;
	localparam FSM_FCS_WRITE = 3;
	localparam FSM_SEND = 4;
	localparam FSM_SEND_IDLE = 5;
	localparam FSM_END = 6;
	
	reg [2:0] state, next_state;
	reg write_fcs;
	reg [2:0] cnt;
	reg [10:0] reg_ram_addr;
	reg [31:0] crc;
	reg clk;
	
	assign FSM_STATE = state;
	
	// меняем источник тактирования для контроллера
	always@ * begin
		if (state == FSM_SEND || state == FSM_SEND_IDLE)
			clk = eth_clk;
		else
			clk = clk_in;
	end
	
	// счетчик для записи в память
	always@ (posedge clk)
		if (state == FSM_FCS_IDLE)
			cnt <= 0;
		else
			cnt <= cnt + 1;
			
	// адрес записи в память в зависимости от счетчика
	always@ (posedge clk)
	case (cnt)
		0: begin
			write_fcs <= 0;
			reg_ram_addr <= ETH_FRAME_SIZE-4;
			ram_data_in <= crc[7:0];
		end
		1: begin
			write_fcs <= 0;
			reg_ram_addr <= ETH_FRAME_SIZE-3;
			ram_data_in <= crc[15:8];
		end
		2: begin
			write_fcs <= 0;
			reg_ram_addr <= ETH_FRAME_SIZE-2;
			ram_data_in <= crc[23:16];
		end
		3: begin
			write_fcs <= 0;
			reg_ram_addr <= ETH_FRAME_SIZE-1;
			ram_data_in <= crc[31:24];
		end
		4: begin
			write_fcs <= 1;
			reg_ram_addr <= ETH_FRAME_SIZE;
			ram_data_in <= crc[7:0];
		end
	endcase
	
	// сохранение контрольной суммы
	always@ (posedge clk)
	if (state == FSM_FCS_IDLE)
		crc <= crc_in;
		
	
	// определение следующего состояния
	always@*
	case (state)
	FSM_IDLE:
		next_state = FSM_FCS;
		
	FSM_FCS: 
		next_state = FSM_FCS_IDLE;
		
	FSM_FCS_IDLE:
		if (fcs_finish)
			next_state = FSM_FCS_WRITE;
		else
			next_state = FSM_FCS_IDLE;
		
	FSM_FCS_WRITE:
		if (write_fcs)
			next_state = FSM_SEND;
		else
			next_state = FSM_FCS_WRITE;
			
	FSM_SEND:
		next_state = FSM_SEND_IDLE;
		
	FSM_SEND_IDLE:
		if (eth_finish)
			next_state = FSM_END;
		else
			next_state = FSM_SEND_IDLE;
			
	FSM_END:
		next_state = FSM_END;
	endcase

	// выходы по состоянию
	always@*
	case (state)
	FSM_IDLE: begin
		fcs_start = 0;
		eth_start = 0;
		ram_en = 0;
		ram_clk = clk;
		ram_addr = fcs_ram_addr;
	end
	FSM_FCS: begin	
		fcs_start = 1;
		eth_start = 0;
		ram_en = 0;
		ram_clk = clk;
		ram_addr = fcs_ram_addr;
	end
		
	FSM_FCS_IDLE: begin
		fcs_start = 0;
		eth_start = 0;
		ram_en = 0;
		ram_clk = clk;
		ram_addr = fcs_ram_addr;
	end
			
	FSM_FCS_WRITE: begin
		fcs_start = 1;
		eth_start = 0;
		ram_en = 1;
		ram_clk = clk;
		ram_addr = reg_ram_addr;
	end	
	
	FSM_SEND: begin
		fcs_start = 1;
		eth_start = 1;
		ram_en = 0;
		ram_clk = eth_clk;
		ram_addr = eth_ram_addr;
	end
		
	FSM_SEND_IDLE: begin
		fcs_start = 1;
		eth_start = 0;
		ram_en = 0;
		ram_clk = eth_clk;
		ram_addr = eth_ram_addr;
	end
		
	FSM_END: begin
		fcs_start = 0;
		eth_start = 0;
		ram_en = 0;
		ram_clk = clk;
		ram_addr = fcs_ram_addr;
	end	
	endcase
	
	
	// технический блок
	always@ (posedge clk) begin
		if (reset)
			state <= FSM_IDLE;
		else
			state <= next_state;
	end

endmodule