`timescale 1ns / 1ps

module KeyPadController(
        input logic [3:0]   keyPad_row,
        output logic [3:0]  keyPad_column,
        
        output logic [20:0] digits,
        output logic storageFull,
        
        output logic enter, // sends a pulse whenever E "Enter" is pressed
        output logic newPassword // sends a pulse whenever A "NewPassword" is pressed
    );
    
    //One hot encoded reference to the column we are currently on
    logic [3:0] column;
    
    //Hook up our two submodules
    
    //First, name some wires that the modules will use to communicate with eachother
    logic [3:0] digit_wire;
    logic valid_wire;
    logic clear_wire;
    
    KeyPadDecoder decoder(
        .clk(clk), .reset(reset),
        .keyPad_column(column),         //Inputs
        .keyPad_row(keyPad_row),
        .digit(digit_wire),             //Outputs
        .valid(valid_wire)
    );
    
    DigitStore store(
        .clk(clk), .reset(reset),
        .digit(digit_wire), .valid(valid_wire), .clear(clear_wire),     //Inputs
        .out(digits), .storageFull(storageFull)                         //Outputs
    );
     
endmodule



module KeyPadDecoder(
    input logic [3:0]   keyPad_row, keyPad_column,
    output logic [3:0]  digit, // shows the current digit being pressed
    output logic        valid // goes high for a clock cycle whenever a button is pressed
);

endmodule



module DigitStore(
    input logic clk, reset,
    input logic [3:0] digit,    // Hexadecimal value of the digit we are trying to store
    input logic valid,           // Pulse that tells us when to shift a new digit in
    input logic clear,          // Clears all stored digits, comes on for a clock cycle when "A" is pressed
    
    output logic [20:0] out,
    output logic storageFull
);

    logic [4:0] digits [3:0];   // ShiftRegister that stores the Hexadecimal value of each digit
    
    always_ff @(posedge clk) begin
        if(reset)               digits = {5'b00000, 5'b00000, 5'b00000, 5'b00000};
        else if(clear)          digits = {5'b00000, 5'b00000, 5'b00000, 5'b00000};
        else if(valid) begin  
            case({digits[3][4], digits[2][4], digits[1][4], digits[0][4]})
                4'b0000:    digits[3] = {1'b1, digit};
                4'b1000:    digits[2] = {1'b1, digit};
                4'b1100:    digits[1] = {1'b1, digit};
                4'b1110:    digits[0] = {1'b1, digit};
                4'b1111:    ; // if the register is full, don't do anything
                default:    ; // if the input is invalid, don't do anything
            endcase
        end
    end
    
    assign out = {digits[3],digits[2],digits[1],digits[0]};
    assign storageFull = (digits[3][4] & digits[2][4] & digits[1][4] & digits[0][4]);
    
    

endmodule