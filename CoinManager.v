`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:01:39 03/02/2023 
// Design Name: 
// Module Name:    CoinManager 
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
module CoinManager(
	input purchaseMode,
	input moneyMode,

	input [3:0] keypadInput,
	input cycleSignal,
	input selectButton,

	input [9:0] stockA,
	input [9:0] stockB,
	input [9:0] stockC,
	input [9:0] stockD,
    
	input [9:0] priceA,
	input [9:0] priceB,
	input [9:0] priceC,
	input [9:0] priceD,
    
	input leftOrRightButton,
	input keyPressEvent,
	input keyOrSelect,

	output wire [9:0] coinSymbolOut,
	output reg [10:0] totalValue
);

	reg [9:0] coinAddAmount;
	reg [9:0] coinData[3:0][1:0]; // {{coinType, val},....}
	reg [3:0] currentCoin; // 0 - nickels, 1 - dimes, 2 - quarters, 3 - dollars
	reg [9:0] additionAmount;
    reg rst = 0;
	wire [9:0] currentCoinVal;
	wire posEvent;
	assign coinSymbolOut = coinData[currentCoin][0];
	assign currentCoinVal = coinData[currentCoin][1];

	reg [10:0] changeA;
	reg [10:0] changeB;
	reg [10:0] changeC;
	reg [10:0] changeD;


	initial begin 
		totalValue <= 0; 
        rst <= 0;
		additionAmount <= 0;
		currentCoin <= 0;
		coinAddAmount <= 0;

		changeA <= 0;
		changeB <= 0;
		changeC <= 0;
		changeD <= 0;

		coinData[0][0] <= 16;
		coinData[0][1] <= 5;
		
		coinData[1][0] <= 13;
		coinData[1][1] <= 10;
		
		coinData[2][0] <= 17;
		coinData[2][1] <= 25;
		
		coinData[3][0] <= 18;
		coinData[3][1] <= 100;
	end
	

	assign posEvent = keyPressEvent || selectButton;
	
	always @(purchaseMode) begin
		changeA = 0;
		changeB = 0;
		changeC = 0;
		changeD = 0;
		if (totalValue >= priceA && stockA != 0) begin
			changeA = totalValue - priceA; 
		end else begin 
			changeA = totalValue;
		end

		if (totalValue >= priceB && stockB != 0) begin
			changeB =  300 - priceB; // dummy value to initialize circuit
		end else begin 
			changeB = totalValue;
		end

		if (totalValue >= priceC && stockC != 0) begin
			changeC = totalValue - priceC;
		end else begin 
			changeC = totalValue;
		end

		if (totalValue >= priceD && stockD != 0) begin
			changeD = totalValue - priceD;
		end else begin 
			changeD = totalValue;
		end
	end

	always @(posedge posEvent) begin 
		if (moneyMode) begin
				if (rst) begin
                    totalValue = 0;
                    rst = 0;
                end
                if (keyOrSelect) begin
					if ((totalValue+additionAmount) <= 999) begin
						totalValue = totalValue + additionAmount;
					end
					additionAmount = 0;
					coinAddAmount = 0;
				end else begin
					coinAddAmount = keypadInput;
					additionAmount  = coinAddAmount * currentCoinVal;
				end
		end else if (purchaseMode && !keyOrSelect) begin
			rst = 1;
            if (keypadInput == 4'd10) begin 
                totalValue = changeA; 
            end else if (keypadInput == 4'd11) begin
                totalValue = changeB; 
            end else if (keypadInput == 4'd12) begin 
                totalValue = changeC; 
            end else if (keypadInput == 4'd13) begin
                totalValue = changeD;
            end
			coinAddAmount = 0;
			additionAmount = 0;
		end
	end 

	always @(posedge cycleSignal) begin 
		if (moneyMode) begin
			if (leftOrRightButton) begin
				if (currentCoin >= 3) begin
					currentCoin = 0;
				end else begin
					currentCoin = currentCoin + 1;
				end
			end else begin
				if (currentCoin <= 0) begin
					currentCoin = 3;
				end else begin
					currentCoin = currentCoin - 1;
				end
			end
		end
	end 
endmodule 