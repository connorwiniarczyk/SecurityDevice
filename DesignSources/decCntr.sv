`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2017 10:42:19 PM
// Design Name: 
// Module Name: decCntr
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


module decCntr(input logic clk, en, reset,
               output logic [3:0] q, 
               output logic carry);
               always@(posedge clk)
                    if(reset) q <= 4'b0;
                    else if(en) 
                        if(q < 4'b1001) 
                            begin 
                                q <= q+4'b0001;
                            end
                            
                        else if(q == 4'b1001) 
                            begin 
                                q <= 4'b0;
                            end
                            
               always_comb
                     if(q < 4'b1001) carry <= 1'b0;
                     else if(q == 4'b1001) carry <= 1'b1;
                     else carry <= 1'b0;
endmodule
