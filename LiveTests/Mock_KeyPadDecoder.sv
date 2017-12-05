`timescale 1ns / 1ps

module Mock_KeyPadDecoder (
	input logic clk, reset,   // clk and reset
	output logic [3:0] digit,
	output logic valid
);

	logic OneHz_clock;

	logic [3:0] secondCounter;

	BinaryPulseGenerator #(1000) pulseGenerator(clk, reset, OneHz_clock);

	BinaryCounter #(16) counter(OneHz_clock, reset, secondCounter);

	assign digit = secondCounter;
	// assign valid = OneHz_clock;
	LevelToPulse LevelToPulse(clk, reset, OneHz_clock, valid);

endmodule