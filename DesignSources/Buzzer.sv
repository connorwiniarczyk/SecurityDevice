`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2017 09:44:26 PM
// Design Name: 
// Module Name: Buzzer
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


module Buzzer(input CLK, [1:0] Mode, 
              output logic out,
              output logic done
        );
         logic carry;
         logic [3:0] d1, d2, d3, d4;
         logic clk800, clk2048, clk1000;
         clkdiv #(.DIVFREQ(1000)) clkDiv1000(.clk(CLK), .reset(1'b0), .sclk(clk1000));
         clkdiv #(.DIVFREQ(800)) clkDiv800(.clk(CLK), .reset(1'b0), .sclk(clk800));
         clkdiv #(.DIVFREQ(2048)) clkDiv2k(.clk(CLK), .reset(1'b0), .sclk(clk2048));
         //clkdiv #(.DIVFREQ(2)) clkDiv2(.clk(CLK), .reset(1'b0), .sclk(clk2));
         
         bcdCounter bcdCnt(.clk(clk1000),.en(Mode[1] == 1'b1),.reset(Mode[1] == 1'b0),.q0(d4),.q1(d3),.q2(d2),.q3(d1),.carry(carry));
         always_comb
            if (Mode == 2'b10 && d1 < 4'b0010)  out = clk800;
            else if (Mode == 2'b11 && d2 < 4'b0101 && d1 < 4'b0010)  out = clk2048;
            else out = 1'b0;

         assign done = (d1 == 4'b0010 && d4 == 4'b0001);
         
endmodule