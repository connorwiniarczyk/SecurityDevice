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

// counts up in binary from 0 to some maximum value
module BinaryCounter(
        input logic clk, reset, // clk and reset
        output logic [$clog2(MAXVAL) - 1 : 0] out
    );

    parameter MAXVAL = 10;

    logic [$clog2(MAXVAL):0] count;

    always_ff @(posedge clk, posedge reset) begin : proc_
        if(reset | count == MAXVAL) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end

    assign out = count;

endmodule

//Generates a 1 clock cycle long pulse every n clock cycles
module BinaryPulseGenerator (
    input logic clk, reset,   // clk and reset
    output logic out         // output pulse
);

    parameter TIME = 10;

    logic [$clog2(TIME) - 1 : 0] count;

    BinaryCounter #(TIME) counter(clk, reset, count);

    assign out = (count == TIME - 1);

endmodule