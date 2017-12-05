`timescale 1ns / 1ps

module BinaryCounter_tb ();

	logic clk, reset;
	logic [3:0] out;

	BinaryCounter dut(clk, reset, out);

	initial begin
		reset = 1; #2;
		reset = 0;
	end

	always begin
		clk = 0; #1;
		clk = 1; #1;
	end

endmodule