`timescale 1ns / 1ps

module LevelToPulse(
        input logic clk, reset,
        input logic level,
        output logic pulse
    );
    
    typedef enum logic [1:0] {READY, ON, OFF} State;
    State currentState, nextState;
    
    always_ff @(posedge clk) begin
        if(reset)   currentState = READY;
        else        currentState = nextState;
    end
    
    always_comb begin
        case(currentState)
            READY:  if(level)   nextState = ON;
                    else        nextState = READY;
            ON:                 nextState = OFF;
            OFF:    if(~level)  nextState = READY;
                    else        nextState = OFF;
            default:    nextState = READY;
        endcase
    end
    
    assign pulse = (currentState == ON);
    
endmodule


module clkdiv(input logic clk, input logic reset, output logic sclk);
    parameter DIVFREQ = 1000;  // desired frequency in Hz (change as needed)
    parameter DIVBITS = 30;   // enough bits to divide 100MHz down to 1 Hz
    parameter CLKFREQ = 100_000_000;
    parameter DIVAMT = (CLKFREQ / DIVFREQ) / 2;

    logic [DIVBITS-1:0] q;

    always_ff @(posedge clk)
        if (reset) begin
            q <= 0;
            sclk <= 0;
        end
        else if (q == DIVAMT-1) begin
            q <= 0;
            sclk <= ~sclk;
        end
    else q <= q + 1;

endmodule // clkdiv