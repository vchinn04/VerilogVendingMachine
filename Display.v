`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:16:01 03/02/2023 
// Design Name: 
// Module Name:    Display 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module DisplayController(
	input [3:0] DispVal1,
	input [3:0] DispVal2,
	input [3:0] DispVal3,
	input [4:0] DispVal4,
	input dPoint, // Decimal point enabled???
	input segmentClk,
    output reg [3:0]an,			// Controls the display digits
    output reg[7:0] segOut
    );
	
	reg [3:0] segTurn;
	
	initial begin
		segTurn = 0;
	end

	always @(posedge segmentClk) begin 
	an = 4'b1111;
	if (segTurn == 0) begin
			an = 4'b1110;
			case (DispVal1)
				4'h0 : segOut <= 8'b11000000;  // 0
				4'h1 : segOut <= 8'b11111001;  // 1
				4'h2 : segOut <= 8'b10100100;  // 2
				4'h3 : segOut <= 8'b10110000;  // 3
				4'h4 : segOut <= 8'b10011001;  // 4
				4'h5 : segOut <= 8'b10010010;  // 5
				4'h6 : segOut <= 8'b10000010;  // 6
				4'h7 : segOut <= 8'b11111000;  // 7
				4'h8 : segOut <= 8'b10000000;  // 8
				4'h9 : segOut <= 8'b10010000;  // 9
				4'hA : segOut <= 8'b10001000; 	// A
				4'hB : segOut <= 8'b10000011;	// B
				4'hC : segOut <= 8'b11000110;	// C
				4'hD : segOut <= 8'b10100001;	// D
				4'hE : segOut <= 8'b10000110;	// E
				4'hF : segOut <= 8'b10001110;	// F
				default : segOut <= 8'b10111111;		
			endcase
	end else if (segTurn == 1) begin
			an = 4'b1101;
			case (DispVal2)
				4'h0 : segOut <= 8'b11000000;  // 0
				4'h1 : segOut <= 8'b11111001;  // 1
				4'h2 : segOut <= 8'b10100100;  // 2
				4'h3 : segOut <= 8'b10110000;  // 3
				4'h4 : segOut <= 8'b10011001;  // 4
				4'h5 : segOut <= 8'b10010010;  // 5
				4'h6 : segOut <= 8'b10000010;  // 6
				4'h7 : segOut <= 8'b11111000;  // 7
				4'h8 : segOut <= 8'b10000000;  // 8
				4'h9 : segOut <= 8'b10010000;  // 9
				4'hA : segOut <= 8'b10001000; 	// A
				4'hB : segOut <= 8'b10000011;	// B
				4'hC : segOut <= 8'b11000110;	// C
				4'hD : segOut <= 8'b10100001;	// D
				4'hE : segOut <= 8'b10000110;	// E
				4'hF : segOut <= 8'b10001110;	// F
				default : segOut <= 8'b10111111;		
			endcase
	end else if (segTurn == 2) begin
			an = 4'b1011;
			if (dPoint) begin 
				case (DispVal3)
					4'h0 : segOut <= 8'b01000000;  // 0
					4'h1 : segOut <= 8'b01111001;  // 1
					4'h2 : segOut <= 8'b00100100;  // 2
					4'h3 : segOut <= 8'b00110000;  // 3
					4'h4 : segOut <= 8'b00011001;  // 4
					4'h5 : segOut <= 8'b00010010;  // 5
					4'h6 : segOut <= 8'b00000010;  // 6
					4'h7 : segOut <= 8'b01111000;  // 7
					4'h8 : segOut <= 8'b00000000;  // 8
					4'h9 : segOut <= 8'b00010000;  // 9
					4'hA : segOut <= 8'b00001000; 	// A
					4'hB : segOut <= 8'b00000011;	// B
					4'hC : segOut <= 8'b01000110;	// C
					4'hD : segOut <= 8'b00100001;	// D
					4'hE : segOut <= 8'b00000110;	// E
					4'hF : segOut <= 8'b00001110;	// F
					default : segOut <= 8'b00111111;		
				endcase
			end else begin
				case (DispVal3)
					4'h0 : segOut <= 8'b11000000;  // 0
					4'h1 : segOut <= 8'b11111001;  // 1
					4'h2 : segOut <= 8'b10100100;  // 2
					4'h3 : segOut <= 8'b10110000;  // 3
					4'h4 : segOut <= 8'b10011001;  // 4
					4'h5 : segOut <= 8'b10010010;  // 5
					4'h6 : segOut <= 8'b10000010;  // 6
					4'h7 : segOut <= 8'b11111000;  // 7
					4'h8 : segOut <= 8'b10000000;  // 8
					4'h9 : segOut <= 8'b10010000;  // 9
					4'hA : segOut <= 8'b10001000; 	// A
					4'hB : segOut <= 8'b10000011;	// B
					4'hC : segOut <= 8'b11000110;	// C
					4'hD : segOut <= 8'b10100001;	// D
					4'hE : segOut <= 8'b10000110;	// E
					4'hF : segOut <= 8'b10001110;	// F
					default : segOut <= 8'b10111111;		
				endcase
			end
	end else if (segTurn == 3) begin
			an = 4'b0111;
			case (DispVal4)
				5'h0 : segOut <= 8'b11000000;  // 0
				5'h1 : segOut <= 8'b11111001;  // 1
				5'h2 : segOut <= 8'b10100100;  // 2
				5'h3 : segOut <= 8'b10110000;  // 3
				5'h4 : segOut <= 8'b10011001;  // 4
				5'h5 : segOut <= 8'b10010010;  // 5
				5'h6 : segOut <= 8'b10000010;  // 6
				5'h7 : segOut <= 8'b11111000;  // 7
				5'h8 : segOut <= 8'b10000000;  // 8
				5'h9 : segOut <= 8'b10010000;  // 9
				5'hA : segOut <= 8'b10001000; 	// A
				5'hB : segOut <= 8'b10000011;	// B
				5'hC : segOut <= 8'b11000110;	// C
				5'hD : segOut <= 8'b10100001;	// D
				5'hE : segOut <= 8'b10000110;	// E
				5'hF : segOut <= 8'b10001110;	// F
				5'h10 : segOut <= 8'b10101011;	// n
				5'h11 : segOut <= 8'b10011000;	// q
				5'h12 : segOut <= 8'b10010010;	// S
				5'h13 : segOut <= 8'b10001100;	// P

				default : segOut <= 8'b10111111;		
			endcase
	end

	segTurn = segTurn + 1;
	if (segTurn >= 4) segTurn = 0;
	end
endmodule

