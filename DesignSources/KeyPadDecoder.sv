module Decoder(input logic [3:0]row,
                 input clk, reset,
                 output logic [3:0]column,

                 output logic [3:0] digit,
                 output logic valid,
                 output logic [7:0]led
                // output logic [4:0]ValidPressedButton,
                 // output logic [6:0] seg
    );
// we need a counter to cylcle through the rows in order to check in what row the button is being selected. 
        // ClockDivider #(.DIVFREQ(1000)) clkdiv( sclk, 0, clk);
        logic [4:0]  buttons; // we need a 5 bit signal because we need a valid signal  
        logic [1:0] count=0; 
        logic [1:0] nextcount;

        assign digit = buttons[3:0];
        assign valid = buttonPressed;
        
    always_ff@ (posedge clk) 
        count <= nextcount; // count should increase by one 
    
    always_comb 
          if(buttons[4])  nextcount = count ;
          
          else nextcount = count +1; 
    
    // assign led[3:0] = column [3:0];
    
    // assign led[7:4] = row;

    logic buttonPressed;
    always_ff @(posedge clk) begin
      if(count == 0)      buttonPressed = 0;

      if(buttons[4] == 1) buttonPressed = 1;
    end
                    
    always_comb 
        
        case(count) 
        2'b00: case(row)    
                4'b1110: buttons = 5'b10001;//1Most significant bit indicates button is being pressed, the other true indicates which button it is
                4'b1101: buttons = 5'b10100;//4
                4'b1011: buttons = 5'b10111;//7
                4'b0111: buttons = 5'b10000;//0
                default : buttons = 5'b00000;//Default statement: nothing is being pressed
                endcase
          
        2'b01: case(row)    
                 4'b1110: buttons = 5'b10010;//2
                 4'b1101: buttons = 5'b10101;//5
                 4'b1011: buttons = 5'b11000;//8
                 default : buttons = 5'b00000;//nothing pressed
                 endcase
        
        2'b10: case(row)    
               4'b1110: buttons = 5'b10011;//3
               4'b1101: buttons = 5'b10110;//6
               4'b1011: buttons = 5'b11001;//9
               4'b0111: buttons = 5'b11110; //E
               default : buttons = 5'b00000;//nothing pressed
               endcase
               
        2'b11: case(row)    
               4'b1110: buttons = 5'b11010; //A
               4'b1011: buttons = 5'b11100; //C
               default : buttons = 5'b00000;//nothing pressed
               endcase
               
endcase
        always_comb //Generating output with selected column
                    case(count)
                    2'b00: column = 4'b1110;
                    2'b01: column = 4'b1101;
                    2'b10: column = 4'b1011;
                    2'b11: column = 4'b0111;
                    default : column = 4'b1111;
                    endcase
        logic out;
        //LevelToPulseConverter holdbutton(.clk(clk),.reset(reset),.en(buttons[4]),.out(out));
        //assign ValidPressedButton={out,buttons[3:0]};
        //SevenSegmenDecoder display(buttons[3:0],seg);
        
        
endmodule