`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:02:12 03/02/2023 
// Design Name: 
// Module Name:    ItemManager 
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
module ItemManager( 
	input cycleSignal,

	input [10:0] userBalance,

	input stockMode,
	input priceMode,
	input purchaseMode,
	input leftOrRightButton,
	input keyPressEvent,
	input [3:0] keypadInput,

	output reg[9:0] stockA,
	output reg[9:0] stockB,
	output reg[9:0] stockC,
	output reg[9:0] stockD,
	
	output wire[9:0] priceA,
	output wire[9:0] priceB,
	output wire[9:0] priceC,
	output wire[9:0] priceD,

	output reg [3:0] currentItem, 
	
	output wire [9:0] priceOut,
	output reg [9:0] stockOut,
	output wire [9:0] itemSymbolOut
);
	reg [9:0] itemData[3:0][2:0]; // {{price, stock}, {price, stock}....}

	assign priceOut = itemData[currentItem][1];
    
    assign priceA = itemData[0][1];
    assign priceB = itemData[1][1];
    assign priceC = itemData[2][1];
    assign priceD = itemData[3][1];

	assign itemSymbolOut = itemData[currentItem][0];

	reg[9:0] NewStockA;
	reg[9:0] NewStockB;
	reg[9:0] NewStockC;
	reg[9:0] NewStockD;

	initial begin 
		stockA = 150;
		stockB = 3;
		stockC = 10'b0000000001;
		stockD = 10;
		NewStockA = 0;
		NewStockB = 0;
		NewStockC = 0;
		NewStockD = 0;
		itemData[0][0] = 10;
		itemData[0][1] = 5;
		itemData[0][2] = 150;
		 
		itemData[1][0] = 11;
		itemData[1][1] = 220;
		itemData[1][2] = 3;
		
		itemData[2][0] = 12;
		itemData[2][1] = 5;
		itemData[2][2] = 1;
		
		itemData[3][0] = 13;
		itemData[3][1] = 52;
		itemData[3][2] = 10;
		currentItem = 0;
	end

    always @(currentItem or stockA or stockB or stockC or stockD) begin
        stockOut = 0;
        case (currentItem) 
            4'd0 : stockOut = stockA;
			4'd1 : stockOut = stockB; 
			4'd2 : stockOut = stockC;
			4'd3 : stockOut = stockD;
			default : stockOut  = stockA;
        endcase
    end
    
	always @(posedge cycleSignal) begin
		if (priceMode || stockMode) begin
			if (leftOrRightButton) begin
				if (currentItem >= 3) begin
					currentItem = 0;
				end else begin
					currentItem = currentItem + 1;
				end
			end else if (!leftOrRightButton) begin
				if (currentItem <= 0) begin
					currentItem = 3;
				end else begin
					currentItem = currentItem - 1;
				end
			end
		end
	end 

	always @(purchaseMode) begin
		if (userBalance >= priceA) begin
			NewStockA = (stockA == 0) ? 0 : (stockA - 1);
		end else begin 
			NewStockA = stockA;
		end
		
		if (userBalance >= priceB) begin
			NewStockB = (stockB == 0) ? 0 : (stockB - 1);
		end else begin 
			NewStockB = stockB;
		end

		if (userBalance >= priceC) begin
			NewStockC = (stockC == 0) ? 0 : (stockC - 1);
		end else begin 
			NewStockC = stockC;
		end

		if (userBalance >= priceD) begin
			NewStockD = (stockD == 0) ? 0 : (stockD - 1);
		end else begin 
			NewStockD = stockD;
		end
    end

	always @(posedge keyPressEvent) begin
		if (purchaseMode) begin 
            if (keypadInput == 4'hA) begin
				stockA = NewStockA; 
			end else if (keypadInput == 4'd11) begin
				stockB = NewStockB; 
			end else if (keypadInput == 4'd12) begin 
				stockC = NewStockC;
			end else if (keypadInput == 4'd13) begin
				stockD = NewStockD; 
			end
		end
	end
endmodule