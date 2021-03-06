module DigitStore_tb ();

	logic clk, reset;
	logic [3:0] digit;
	logic valid, clear;

	logic [15:0] out;
	logic [3:0] digitsToDisplay;
	logic storageFull;

	DigitStore dut(
		clk, reset, digit, valid, clear,
		out, digitsToDisplay, storageFull
	);

	initial begin
		digit = 4'h0;
		valid = 0;
		clear = 0;
		reset = 1; #2;

		reset = 0;

		valid = 1; #2;
		valid = 0; #2;

		digit = 4'h9;
		
		// clear = 1;
		valid = 1; #2;
		// clear = 0;
		valid = 0; #2;

		digit = 4'hb;
		// clear = 1;
		valid = 1; #2;
		// clear = 0;
		valid = 0; #2;

		digit = 4'h3;
		// clear = 1;
		valid = 1; #2;
		// clear = 0;
		valid = 0; #2;

		digit = 4'hd;
		// clear = 1;
		valid = 1; #2;
		// clear = 0;
		valid = 0; #2;

		digit = 4'h1;
		valid = 1; #2;
		valid = 0; #2;

		digit = 4'hf;
		valid = 1; #2;
		valid = 0; #2;
	end

	always begin
		clk = 0; #1;
		clk = 1; #1;
	end

endmodule