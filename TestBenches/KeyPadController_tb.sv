module KeyPadController_tb ();

	logic clk, reset;
	logic [3:0] row, column;

	logic [15:0] digits;
	logic [3:0] digitsToDisplay;

	logic storageFull;

	logic enter, newPassword;

	KeyPadController dut(
		clk, reset, row,
		column,
		digits, digitsToDisplay, storageFull,
		enter, newPassword
	);

	initial begin
		reset = 1; #2;
		// row = 4'b1111; #30;
		reset = 0;

		// row = 4'b1011; #4;
	end

	always begin
		clk = 0; #1;
		clk = 1; #1;
	end

	always begin
		row = 4'b1110; #4;
		row = 4'b1111; #6;
	end

endmodule