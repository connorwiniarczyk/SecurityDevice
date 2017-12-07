`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2017 10:42:37 PM
// Design Name: 
// Module Name: bcdCounter
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


module bcdCounter(input logic clk, en, reset,
                    output logic [3:0] q3, q2, q1, q0,
                           logic carry);
                    logic c0, c1, c2;
                    decCntr cntr1(clk, en, reset, q0, c0);
                    decCntr cntr2(clk, en & c0, reset, q1, c1);
                    decCntr cntr3(clk, en & c1 & c0, reset, q2, c2);
                    decCntr cntr4(clk, en & c2 & c1 & c0, reset, q3, carry);

endmodule