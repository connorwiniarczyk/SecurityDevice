`timescale 1ns / 1ps

module KeyPadController(
        input clk, reset,
        input logic [3:0]   keyPad_row,
        output logic [3:0]  keyPad_column,
        
        output logic [15:0] digits,           // 4 hexadecimal values indicating the digits entered
        output logic [3:0] digitsToDisplay,   // 4 binary values indicating which digits we want to turn on
        output logic storageFull,             // goes high whenever 4 values have been entered
        
        output logic enter, // sends a pulse whenever E "Enter" is pressed
        output logic newPassword // sends a pulse whenever A "NewPassword" is pressed
    );
    
    //One hot encoded reference to the column we are currently on
    logic [3:0] column;

    
    //Hook up our two submodules

    //First, name some wires that the modules will use to communicate with eachother
    logic [3:0] digit_wire;
    logic valid_wire [1:0];

    // hook up valid_wire to a LevelToPulseConverter
    LevelToPulse ltp_valid(clk, rest, valid_wire[0], valid_wire[1]);

    // Each of these wires corresponds to a button
    logic clear_wire [1:0];
    logic enter_wire [1:0];
    logic newPassword_wire [1:0];
    
    //Hook up our keypad decoder
    //This is our real KeyPad Decoder, which hasn't been implemented yet, instead, we want to hook up a mock controller to help with testing
    Decoder_ decoder(
        .clk(clk), .reset(reset),
        .column(keyPad_column),         //Inputs
        .row(keyPad_row),
        .digit(digit_wire),             //Outputs
        .valid(valid_wire[0])
    );

    //Hook up our 
    DigitStore store(
        .clk(clk), .reset(reset),
        .digit(digit_wire), .valid(valid_wire[1]), .clear(clear_wire[1]),     //Inputs
        .out(digits), .digitsToDisplay(digitsToDisplay), .storageFull(storageFull)                         //Outputs
    );

    // assign storageFull = 1'b1;

    // Hook up button pulses
    assign clear_wire[0] = (digit_wire == 4'hC);
    assign enter_wire[0] = (digit_wire == 4'hE);
    assign newPassword_wire[0] = (digit_wire == 4'hA);

    // all button pulses should be fed through a LevelToPulseConverter
    // LevelToPulse ltp_clear(clk, reset, clear_wire[0], clear_wire[1]);
    LevelToPulse ltp_enter(clk, reset, enter_wire[0], enter_wire[1]);
    LevelToPulse ltp_newPassword(clk, reset, newPassword_wire[0], newPassword_wire[1]);

    //Hook up pulse outputs
    always_comb begin
        enter <= (enter_wire[0] & valid_wire[1]);
        newPassword <= (newPassword_wire[0] & valid_wire[1]);
        clear_wire[1] <= clear_wire[0];//(clear_wire[0] & valid_wire[1]);
    end
  
endmodule

module DigitStore(
    input logic clk, reset,
    input logic [3:0] digit,    // Hexadecimal value of the digit we are trying to store
    input logic valid,           // Pulse that tells us when to shift a new digit in
    input logic clear,          // Clears all stored digits, comes on for a clock cycle when "C" is pressed
    
    output logic [15:0] out,
    output logic [3:0] digitsToDisplay,
    output logic storageFull
);

    logic [4:0] digits [3:0];   // Register that stores the Hexadecimal value of each digit
    
    always_ff @(posedge clk) begin
        if(reset)               digits = {5'b00000, 5'b00000, 5'b00000, 5'b00000};
        else if(clear)          digits = {5'b00000, 5'b00000, 5'b00000, 5'b00000};
        else if(valid & (digit <= 9)) begin 
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
    
    //assign output values
    assign out = {digits[3][3:0], digits[2][3:0], digits[1][3:0], digits[0][3:0]};  // out should be a 16 bit representation of the hex value of each digit
    assign digitsToDisplay = {digits[3][4], digits[2][4], digits[1][4], digits[0][4]};
    assign storageFull = (digits[3][4] && digits[2][4] && digits[1][4] && digits[0][4]);
    
    // assign storageFull = 1;

endmodule



// generates the 4 bit keyPad_column signal
// module ColumnGenerator (
//     input logic clk, reset,
//     output logic [3:0] out
// );

//     logic [3:0] oneHot_count;

//     always_ff @(posedge clk) begin
//         if(reset) begin
//             oneHot_count <= 4'b0001;
//         end else begin
//              <= ;
//         end
//     end

// endmodule