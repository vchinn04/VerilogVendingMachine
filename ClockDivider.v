`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:01:54 03/02/2023 
// Design Name: 
// Module Name:    ClockDivider 
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
module ClockDivider(
	input masterClk,

	output reg debounceClock,
	output reg debounceDelayClock,
	output reg segmentClock
);
   wire [18:0] clk_dv_inc; 
   reg [17:0] clk_dv; 

	reg [19:0] segmentCounter; 
	reg rst;
   initial begin 
   rst <= 0;
	   clk_dv <= 0;
		segmentCounter <= 0;
		segmentClock <= 0;
		debounceClock <= 0;
		debounceDelayClock <= 0;
   end 

   assign clk_dv_inc = clk_dv + 1;
   
   always @ (posedge masterClk) begin
     if (rst)
       begin
          clk_dv   <= 0;
          debounceClock   <= 1'b0;
          debounceDelayClock <= 1'b0;
       end
     else
       begin
          clk_dv   <= clk_dv_inc[17:0]; 
          debounceClock   <= clk_dv_inc[17]; 
          debounceDelayClock <=debounceClock   ;
       end
	end

   always @ (posedge masterClk) begin
     if (rst)
       begin
		segmentCounter = 0;
       end
     else
       begin
		  segmentCounter = segmentCounter + 1;
		  if (segmentCounter >= 200000) begin
				segmentCounter = 0;
				segmentClock = ~segmentClock;
			end
       end
	end
endmodule 
