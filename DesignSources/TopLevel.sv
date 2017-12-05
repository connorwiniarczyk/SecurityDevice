`timescale 1ns / 1ps

// Very Top level of the circuit. This is where we connect the inputs and outputs to the modules and the modules to each other
module TopLevel(
        input clk_raw, reset,
        input [3:0] keyPad_row,

        output buzzer,
        output [3:0] keyPad_column,
        output [6:0] seg,   // segment pins on the seven-segment display
        output [7:0] an     // anode pins on the seven-segment display
    );

    //divide out clk signal down to 1 kHz
    logic clk;  // New Clk signal
    clkdiv clkdiv(clk_raw, , clk); // this module is set to 1kHz by default, so need to specify any parameters

    // Connect our modules together

    // Name some wires for the modules to use to comunicate with eachother
    logic [15:0] digits;
    logic [3:0] digitsToDisplay;

    logic [1:0] displayMode;
    logic [1:0] buzzerMode;

    logic enter, newPassword;
    logic setPassword;

    logic match, valid;

    logic [15:0] currentPassword;

    //Hook up DisplayController
    Display display(
        .clk(clk), .reset(reset),
        .Digits(digits), .DispMode(displayMode), .Valid(digitsToDisplay),
        .anodes(an), .digits(seg)
    );

    //Hook up KeyPadController
    KeyPadController keyPad(
        .clk(clk), .reset(reset),
        .keyPad_row(keyPad_row), .keyPad_column(keyPad_column),
        .digits(digits), .digitsToDisplay(digitsToDisplay), .storageFull(valid),
        .enter(enter), .newPassword(newPassword)
    );

    //Hook up ControlFSM
    ControlFSM control(
        .clk(clk), .reset(reset),
        .enter(enter), .newPassword(newPassword),
        .match(match), .valid(valid),
        .buzzerMode (buzzerMode), .displayMode(displayMode),
        .setPassword(setPassword)
    );

    //Hook up PasswordStore
    PasswordStore password(
        .clk(clk), .reset(reset),
        .newPassword(digits),
        .set(setPassword),
        .out(currentPassword)
    );

endmodule

module PasswordStore(
        input clk, reset,
        input [15:0] newPassword,
        input set,
        output [15:0] out
    );
    
    logic [15:0] password;
    
    always_ff @(posedge clk) begin
        if(reset)       password = 16'h0000;
        else if(set)    password = newPassword;
    end
    
    assign out = password;
    
endmodule