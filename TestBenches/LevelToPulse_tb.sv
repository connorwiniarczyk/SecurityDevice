module LevelToPulse_tb ();

	logic clk, reset, level, pulse;

	LevelToPulse dut(
		clk, reset, level, pulse
	);

	initial begin
		reset = 1; #2;
		reset = 0; 
		level = 0; #2;

		level = 1; #2;
		level = 0;
	end

	always begin
		clk = 0; #1;
		clk = 1; #1;
	end

endmodule