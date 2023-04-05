`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:00:25 03/02/2023 
// Design Name: 
// Module Name:    Debouncer 
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
module Debouncer(
	input rightButton,
	input leftButton,
	input fastClk,
	input slowClk,
	input delayedClk,
	input selectButton,

	output reg rightSignal,
	output reg  leftSignal,
	output reg sideButtonStatus,
	output reg keyOrSelect,
	output reg selectSignal
);
	reg [2:0] leftDebouncer;
	reg [2:0] rightDebouncer;
	reg [4:0] selectDebouncerV2;

	initial begin 
		leftDebouncer <= 3'b000;
		rightDebouncer <= 3'b000;
		selectDebouncerV2 <= 5'b00000;
		rightSignal <= 1'b0;
		leftSignal <= 1'b0;
		sideButtonStatus <= 0; // 0 - Left, 1 - Right
	end
	always @ (posedge fastClk) begin 
		if (slowClk) begin
			rightDebouncer <= {rightButton, rightDebouncer[2:1]};
			leftDebouncer <= {leftButton, leftDebouncer[2:1]};
		end 
	end

	always @ (posedge fastClk) begin
		if (rightDebouncer[1] & ~rightDebouncer[0] & delayedClk) begin 
			sideButtonStatus = 1;
		end else if (leftDebouncer[1] & ~leftDebouncer[0] & delayedClk) begin 
			sideButtonStatus = 0;
		end 	
		rightSignal = rightDebouncer[1] & ~rightDebouncer[0] & delayedClk;
		leftSignal = leftDebouncer[1] & ~leftDebouncer[0] & delayedClk;
		
		if (selectButton)begin 
			keyOrSelect = 1;
			selectDebouncerV2 = {1'b1, selectDebouncerV2[4:1]};
		end else begin
			keyOrSelect = 0;
			selectDebouncerV2 = {selectDebouncerV2[3:0], 1'b0};

		end
		keyOrSelect = selectDebouncerV2[0];

		selectSignal = selectDebouncerV2[0];
	end
endmodule 