`timescale 1ns / 1ps

module Mock_KeyPadDecoder_tb ();

	logic clk, reset;
	logic [3:0] digit;
	logic valid;

	Mock_KeyPadDecoder dut(clk, reset, digit, valid);

	initial begin
		reset = 1; #3;
		reset = 0;
	end

	always begin
		clk = 0; #1;
		clk = 1; #1;
	end

endmodule