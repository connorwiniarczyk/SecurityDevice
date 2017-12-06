module Decoder_ (
    input clk, reset,
    input logic [3:0]row,
    output logic [3:0]column,

    output logic [3:0] digit,
    output logic valid
);

	// generate 1-hot column signal
	 logic [2:0] count;
	BinaryCounter #(5) counter(clk, reset, count);

	always_comb begin //Generating output with selected column
	    case(count)
		    3'b000: column = 4'b1110;
		    3'b001: column = 4'b1101;
		    3'b010: column = 4'b1011;
		    3'b011: column = 4'b0111;
		    3'b100:	column = 4'b1111;
		    default : column = 4'b1111;
	    endcase
	end


	// Decode column and row signal into digit
	logic [4:0]  buttons;
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
               4'b1011: buttons = 5'b11100;//C
               default : buttons = 5'b00000;//nothing pressed
               endcase           
	endcase

	logic [4:0] lastButton;
	logic [4:0] currentButton;
	always_ff @(posedge clk) begin
		if(buttons[4])	currentButton = buttons;

		if(count == 5) begin
			valid = ~(currentButton == lastButton) & ~(currentButton == 5'b00000);
			lastButton = currentButton;

			currentButton = 5'b00000;
		end
		else	valid = 0;
	end

	// always_ff @(posedge (count == 5)) begin
	// 	if(currentButton ~= lastButton)	valid = 0;
	// 	else							valid = 1;
	// end

	// assign valid = 1;
	assign digit = lastButton[3:0];

endmodule