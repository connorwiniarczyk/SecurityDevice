`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2017 06:49:21 PM
// Design Name: 
// Module Name: ControlFSM
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


module ControlFSM(
        input logic clk, reset, // standard clock and reset inputs
        input logic enter, newPassword, // These should go HIGH for 1 clock cycle when the user presses the "E" or "A" buttons on the keypad, respectively
        input logic match, // this is a boolean value that represents whether the password the user is typing matches the stored one, it should go high as soon as they match
        input logic valid, // this is a boolean value that is true whenver there are 4 digits stored in the keypad reader
        output logic [1:0] buzzerMode,  // a 2-bit signal that tells the buzzer module what to do.  00 is off, 01 is wrong, 10 is right, 11 is unused
        output logic [1:0] displayMode,  // a 2-bit signal that tells the display controller what to do.
        output logic setPassword        // a pulse which controls when a new password is set. When this is high, the storePassword Module should set the current Password to whatever the user has typed
    );
    
    typedef enum logic [2:0] {BASE, ECUR, NPASS, CORRECT, WRONG} State; // Define our states
    
    State currentState, nextState;
    
    always_ff @(posedge clk, posedge reset) begin
        if(reset)   currentState = BASE;
        else        currentState = nextState;
    end
    
    always_comb begin
    
        //Define our state transition
        case(currentState)
        
            BASE:   if(newPassword)         nextState = ECUR;
                    else if(enter & match)  nextState = CORRECT;
                    else if(enter & !match) nextState = WRONG;
                    else                    nextState = BASE;
            
            ECUR:   if(enter & match)       nextState = NPASS;
                    else                    nextState = ECUR;
            
            NPASS:  if(enter & valid)       nextState = BASE;
                    else                    nextState = NPASS;
            
            CORRECT:                        nextState = BASE;
            
            WRONG:                          nextState = BASE;
        
        endcase
        
        //set displayMode
        case(currentState)
            BASE:   displayMode = 2'b00;
            
            ECUR:   displayMode = 2'b01;
            
            NPASS:  displayMode = 2'b10;
            
            default:    displayMode = 2'b00;
            
        endcase
    end
    
    //outputs
    assign setPassword = (enter & valid & currentState == NPASS);
    
    assign buzzerMode[0] = currentState == CORRECT;
    assign buzzerMode[1] = currentState == WRONG;
    
endmodule