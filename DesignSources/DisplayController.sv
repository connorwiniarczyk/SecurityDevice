`timescale 1ns / 1ps

module Display(
		input logic clk, reset,
		input logic [15:0] Digits, [1:0] DispMode, [3:0] Valid,
		output logic [7:0] anodes, [6:0] digits
	);

	logic [2:0] Cnt;
	logic [3:0] segCtrl;
	logic [6:0] decOut;               

	always@(posedge clk)
		Cnt <= Cnt + 3'b001;

	always_comb
		case(Cnt)
			3'b100:  segCtrl = Digits[3:0]; 
			3'b101:  segCtrl = Digits[7:4];  
			3'b110:  segCtrl = Digits[11:8];  
			3'b111:  segCtrl = Digits[15:12]; 
		endcase

	sevenSegDec segDecode(segCtrl, decOut);    

	always_comb
		case(Cnt)
			3'b000: begin
				anodes = 8'b11111110;
				if (DispMode == 2'b00) digits = 7'b0000110;
				else if (DispMode == 2'b01) digits = 7'b0101111;
				else if (DispMode == 2'b10) digits = 7'b0010010;
				else digits = 7'b1111111;
			end
			3'b001: begin
				anodes = 8'b11111101;
				if (DispMode == 2'b00) digits = 7'b0010010;
				else if (DispMode == 2'b01) digits = 7'b1100011;
				else if (DispMode == 2'b10) digits = 7'b0001000;
				else digits = 7'b1111111;
			end
			3'b010: begin
				anodes = 8'b11111011;
				if (DispMode == 2'b00) digits = 7'b0001000;
				else if (DispMode == 2'b01) digits = 7'b1000110;
				else if (DispMode == 2'b10) digits = 7'b0001100;
				else digits = 7'b1111111;
			end
			3'b011: begin
				anodes = 8'b11110111;
				if (DispMode == 2'b00) digits = 7'b0000011;
				else if (DispMode == 2'b01) digits = 7'b0000110;
				else if (DispMode == 2'b10) digits = 7'b0101011;
				else digits = 7'b1111111;
			end
			3'b100: begin 
				if (Valid[0] == 1'b1) anodes = 8'b11101111;
				else anodes = 8'b11111111;
				digits = decOut;
			end
			3'b101: begin
				if (Valid[1] == 1'b1) anodes = 8'b11011111;
				else anodes = 8'b11111111;
				digits = decOut;
			end
			3'b110: begin
				if (Valid[2] == 1'b1) anodes = 8'b10111111;
				else anodes = 8'b11111111;
				digits = decOut;
			end
			3'b111: begin
				if (Valid[3] == 1'b1) anodes = 8'b01111111;
				else anodes = 8'b11111111;
				digits = decOut;
			end
		endcase


endmodule
