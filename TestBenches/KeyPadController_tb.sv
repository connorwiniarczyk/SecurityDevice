module KeyPadController_tb ();

	logic clk, reset;
	logic [3:0] row, column;

	logic [15:0] digits;
	logic [3:0] digitsToDisplay;

	KeyPadController dut(
		clk, reset, keyPad_row,
		keyPad_column,
		digits, digitsToDisplay, storageFull,
		enter, newPassword
	);

	always begin
		clk = 0; #1
	end

endmodule