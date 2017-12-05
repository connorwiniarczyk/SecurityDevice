`timescale 1ns / 1ps

module BinaryPulseGenerator_tb ();

	logic clk, reset;
	logic out;

	BinaryPulseGenerator #(10) dut(clk, reset, out);

	initial begin
		reset = 1; #2;
		reset = 0;
	end

	always begin
		clk = 0; #1;
		clk = 1; #1;
	end

endmodule