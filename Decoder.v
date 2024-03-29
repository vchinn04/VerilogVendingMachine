`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc 2011
// Engineer: Michelle Yu  
//				 Josh Sackos
// Create Date:    07/23/2012 
//
// Module Name:    Decoder
// Project Name:   PmodKYPD_Demo
// Target Devices: Nexys3
// Tool versions:  Xilinx ISE 14.1 
// Description: This file defines a component Decoder for the demo project PmodKYPD. The Decoder scans
//					 each column by asserting a low to the pin corresponding to the column at 1KHz. After a
//					 column is asserted low, each row pin is checked. When a row pin is detected to be low,
//					 the key that was pressed could be determined.
//
// Revision History: 
// 						Revision 0.01 - File Created (Michelle Yu)
//							Revision 0.02 - Converted from VHDL to Verilog (Josh Sackos)
//////////////////////////////////////////////////////////////////////////////////////////////////////////

// ==============================================================================================
// 												Define Module
// ==============================================================================================
module Decoder(
    input clk,// 100MHz onboard clock
    input [3:0] Row,// Rows on KYPD
   output reg[3:0] Col,// Columns on KYPD
    output reg [3:0] DecodeOut,// Output data
	output wire pressSignal
    );

// ==============================================================================================
// 							  		Parameters, Regsiters, and Wires
// ==============================================================================================
	
	// Output wires and registers

	// Count register
	reg [19:0] sclk;

// ==============================================================================================
// 												Implementation
// ==============================================================================================
	reg [4:0] col1Debouncer;
	reg [4:0] col2Debouncer;
	reg [4:0] col3Debouncer;
	reg [4:0] col4Debouncer;

	initial begin 
		col1Debouncer <= 5'b00000;
		col2Debouncer <= 5'b00000;
		col3Debouncer <= 5'b00000;
		col4Debouncer <= 5'b00000;
	end
	
	assign pressSignal = col1Debouncer[0] | col2Debouncer[0] | col3Debouncer[0] | col4Debouncer[0];
	
	always @(posedge clk) begin
		// 1ms
		if (sclk == 20'b00011000011010100000) begin
			//C1
			Col <= 4'b0111;
			sclk <= sclk + 1'b1;
		end
		
		// check row pins
		else if(sclk == 20'b00011000011010101000) begin
			//R1
			if (Row == 4'b0111) begin
				DecodeOut <= 4'b0001;		//1
				col1Debouncer <= 5'b11111;
			end
			//R2
			else if(Row == 4'b1011) begin
				DecodeOut <= 4'b0100; 		//4
				col1Debouncer <=5'b11111;

			end
			//R3
			else if(Row == 4'b1101) begin
				DecodeOut <= 4'b0111; 		//7
									col1Debouncer <= 5'b11111;

			end
			//R4
			else if(Row == 4'b1110) begin
				DecodeOut <= 4'b0000; 		//0
				col1Debouncer <= 5'b11111;
			end else begin
				col1Debouncer <= {1'b0, col1Debouncer[4:1]};

			end
			sclk <= sclk + 1'b1;
		end

		// 2ms
		else if(sclk == 20'b00110000110101000000) begin
			//C2
			Col<= 4'b1011;
			sclk <= sclk + 1'b1;

		end
		
		// check row pins
		else if(sclk == 20'b00110000110101001000) begin
			//R1
			if (Row == 4'b0111) begin
				DecodeOut <= 4'b0010; 		//2
				col2Debouncer <=5'b11111;
			end
			//R2
			else if(Row == 4'b1011) begin
				DecodeOut <= 4'b0101; 		//5.
				col2Debouncer <=5'b11111;
			end
			//R3
			else if(Row == 4'b1101) begin
				DecodeOut <= 4'b1000; 		//8
				col2Debouncer <=5'b11111;
			end
			//R4
			else if(Row == 4'b1110) begin
				DecodeOut <= 4'b1111; 		//F
				col2Debouncer <=5'b11111;
			end  else begin
				col2Debouncer <= {1'b0, col2Debouncer[4:1]};
			end
			sclk <= sclk + 1'b1;
		end

		//3ms
		else if(sclk == 20'b01001001001111100000) begin
			//C3
			Col<= 4'b1101;
			sclk <= sclk + 1'b1;
		end
		
		// check row pins
		else if(sclk == 20'b01001001001111101000) begin
			//R1
			if(Row == 4'b0111) begin
				DecodeOut <= 4'b0011; 		//3	
				col3Debouncer <=5'b11111;
			end
			//R2
			else if(Row == 4'b1011) begin
				DecodeOut <= 4'b0110; 		//6
				col3Debouncer <=5'b11111;
			end
			//R3
			else if(Row == 4'b1101) begin
				DecodeOut <= 4'b1001; 		//9
				col3Debouncer <=5'b11111;
			end
			//R4
			else if(Row == 4'b1110) begin
				DecodeOut <= 4'b1110; 		//E
				col3Debouncer <=5'b11111;
			end else begin
				col3Debouncer <= {1'b0, col3Debouncer[4:1]};
			end

			sclk <= sclk + 1'b1;
		end

		//4ms
		else if(sclk == 20'b01100001101010000000) begin
			//C4
			Col<= 4'b1110;
			sclk <= sclk + 1'b1;
		end

		// Check row pins
		else if(sclk == 20'b01100001101010001000) begin
			//R1
			if(Row == 4'b0111) begin
				DecodeOut <= 4'b1010; //A
				col4Debouncer <=5'b11111;
			end
			//R2
			else if(Row == 4'b1011) begin
				DecodeOut <= 4'b1011; //B
				col4Debouncer <=5'b11111;
			end
			//R3
			else if(Row == 4'b1101) begin
				DecodeOut <= 4'b1100; //C
				col4Debouncer <=5'b11111;
			end
			//R4
			else if(Row == 4'b1110) begin
				DecodeOut <= 4'b1101; //D
				col4Debouncer <=5'b11111;
			end else begin
				col4Debouncer <= {1'b0, col4Debouncer[4:1]};
			end

			sclk <= 20'b00000000000000000000;
		end

		// Otherwise increment
		else begin
			sclk <= sclk + 1'b1;
		end	
	end
endmodule
