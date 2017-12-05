`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2017 11:10:57 PM
// Design Name: 
// Module Name: sevenSegDec
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sevenSegDec(
		input [3:0] d,
		output logic [6:0] seg
	);

	assign seg[6] = (~d[3] & ~d[2] & ~d[1]) | (~d[3] & d[2] & d[1] & d[0]);
	assign seg[5] = (~d[3] & ~d[2] & ~d[1] & d[0]) | (~d[3] & ~d[2] & d[1]) | (~d[3] & d[2] & d[1] & d[0]) | (d[3] & d[2] & ~d[1]);
	assign seg[4] = (~d[3] & d[0]) | (~d[3] & d[2] & ~d[1]) | (~d[1] & d[0]);
	assign seg[3] = ~d[2] & ~d[1] & d[0] | d[2] & d[1] & d[0] | d[2] & ~d[1] & ~d[0] | d[3] & ~d[2] & d[1] & ~d[0] | d[3] & d[2] & ~d[1]; 
	assign seg[2] = d[3] & d[2] | ~d[3] & ~d[2] & d[1] & ~d[0]; 
	assign seg[1] = d[3] & d[2] | d[2] & ~d[1] & d[0] | d[2] & d[1] & ~d[0] | d[3] & d[1] & d[0];
	assign seg[0] = d[3] & d[2] & ~d[1] | ~d[3] & ~d[2] & ~d[1] & d[0] | ~d[3] & d[2] & ~d[1] & ~d[0] | d[3] & ~d[2] & d[1] & d[0];            
                   
endmodule
