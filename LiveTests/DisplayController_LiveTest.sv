module DisplayController_LiveTest (
		input clk_raw, reset,
		input [3:0] keyPad_row,

		output buzzer,
		output [3:0] keyPad_column,
		output [6:0] seg,	// segment pins on the seven-segment display
		output [7:0] an 	// anode pins on the seven-segment display
	);

	//divide out clk signal down to 1 kHz
	logic clk;	// New Clk signal
	clkdiv clkdiv(clk_raw, reset, clk); // this module is set to 1kHz by default, so need to specify any parameters

	//Set up some mock values for testing
	logic [15:0] Digits = 16'h4444;
	logic [1:0] DispMode = 2'b00;
	logic [3:0] Valid = 4'b1111;

	//connect DisplayController
	Display display(
			.clk(clk), .Digits(Digits), .DispMode(DispMode), .Valid(Valid), // inputs
			.anodes(an), .digits(seg)	// outputs
		);

endmodule