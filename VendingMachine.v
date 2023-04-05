`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:29:20 02/28/2023 
// Design Name: 
// Module Name:    VendingMachine 
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

module VendingMachine(
		input clk,
		input [1:0] sw,
		input btnR,
		input btn1, 
		inout [7:0] JA,
		output wire [3:0] an,			// Controls the display digits
		output wire [7:0] seg,
		input btn2
    );

	////////////////////////////////////////////////////////////
	// MODE STATUS
	////////////////////////////////////////////////////////////
	wire stockMode;
	wire priceMode;
	wire purchaseMode;
	wire moneyMode;
	
	////////////////////////////////////////////////////////////
	// BUTTON SIGNALS
	////////////////////////////////////////////////////////////
	wire leftSignal;
	wire rightSignal;
	wire selectSignal;

	wire keyPressSignal;

	////////////////////////////////////////////////////////////
	// CLOCK VARIABLES
	////////////////////////////////////////////////////////////
	wire debounceClock;
	wire debounceDelayClock;
	wire segmentClock;


	////////////////////////////////////////////////////////////
	// DISPLAY VARIABLES
	////////////////////////////////////////////////////////////
	reg [3:0] DispVal1; // Right most display
	reg [3:0] DispVal2;
	reg [3:0] DispVal3;
	reg [4:0] DispVal4; // Left most Display

	reg dPoint; // Decimal Point

	////////////////////////////////////////////////////////////
	// DECODER KYPD VARIABLES
	////////////////////////////////////////////////////////////
	wire [3:0] Decode; // Keypad Input Value

	////////////////////////////////////////////////////////////
	// COIN MANAGER VARIABLES
	////////////////////////////////////////////////////////////
	wire [10:0] userBalance; // The current users inputted balance
	wire [9:0] coinSymbolOut; // Coin type symbol

	////////////////////////////////////////////////////////////
	// ITEM MANAGER VARIABLES
	////////////////////////////////////////////////////////////

	wire [3:0] currentItem; // Item that is currently displayed
	wire [9:0] itemSymbolOut; // Letter symbol of item displayed

	wire [9:0] priceOut; // Price of current item displayed
	wire [9:0] stockOut; // Stock of current item displayed


	////////////////////////////////////////////////////////////
	// OTHER VARIABLES
	////////////////////////////////////////////////////////////
	
	wire leftOrRightButton; // Value to store whether left or right button is stored 
	wire leftOrRightSignal; // Signal whether left or right button pressed
	wire keyOrSelect; // Signal to check if select button or key was pressed (1 -> selectButton)

    initial begin 
		DispVal1 <= 4'b0000;
		DispVal2 <= 4'b0000;
		DispVal3 <= 4'b0000;
		DispVal4 <= 4'b0000;
		dPoint <= 0;
	end

	assign stockMode = sw[0] && ~sw[1];
	assign priceMode = sw[0] && sw[1];
	assign purchaseMode = ~sw[0] && sw[1];
	assign moneyMode = ~sw[0] && ~sw[1];
	
	assign leftOrRightSignal = leftSignal || rightSignal;

 	wire[9:0] priceA;
	wire[9:0] priceB;
	wire[9:0] priceC;
	wire[9:0] priceD;
	 
	ClockDivider myClock(
		.masterClk(clk), 
		.debounceClock(debounceClock), 
		.debounceDelayClock(debounceDelayClock), 
		.segmentClock(segmentClock)
	);

	Debouncer myDebouce(
		.leftButton(btn2), 
		.rightButton(btnR), 
		.fastClk(clk), 
		.slowClk(debounceClock), 
		.delayedClk(debounceDelayClock), 
		.selectButton(btn1), 

		.rightSignal(rightSignal), 
		.leftSignal(leftSignal),
		.selectSignal(selectSignal),
		.sideButtonStatus(leftOrRightButton),
		.keyOrSelect(keyOrSelect)
	);

	Decoder keypadDecoder(
		.clk(clk),
		.Row(JA[7:4]),
		.Col(JA[3:0]),

		.DecodeOut(Decode),
		.pressSignal(keyPressSignal)
	);
	wire [9:0] stockA;
	wire [9:0] stockB;
	wire [9:0] stockC;
	wire [9:0] stockD;
    
	CoinManager myCoins(
		///////// INPUTS

		 .purchaseMode(purchaseMode),
		 .moneyMode(moneyMode),

		 .keypadInput(Decode),

		 .keyPressEvent(keyPressSignal),
		 .cycleSignal(leftOrRightSignal),

		 .selectButton(selectSignal),

		 .leftOrRightButton(leftOrRightButton),

		 .keyOrSelect(keyOrSelect),
		 .stockA(stockA),
		 .stockB(stockB),
		 .stockC(stockC),
		 .stockD(stockD),
		
		 .priceA(priceA),
		 .priceB(priceB),
		 .priceC(priceC),
		 .priceD(priceD),
		 ///////// OUTPUTS
		 .coinSymbolOut(coinSymbolOut),
		 .totalValue(userBalance)
	);


	ItemManager myItems(
		///////// INPUTS
		 .cycleSignal(leftOrRightSignal),
		
		 .userBalance(userBalance),
		 .keypadInput(Decode),

		 .keyPressEvent(keyPressSignal),
		 .stockMode(stockMode),
		 .priceMode(priceMode),
		 .purchaseMode(purchaseMode),
		
		 .leftOrRightButton(leftOrRightButton),
		
		///////// OUTPUTS
		 .currentItem(currentItem),
		
		 .stockA(stockA),
		 .stockB(stockB),
		 .stockC(stockC),
		 .stockD(stockD),
        
         .priceA(priceA),
         .priceB(priceB),
         .priceC(priceC),
         .priceD(priceD),
    
		 .priceOut(priceOut),
		 .stockOut(stockOut),
		 .itemSymbolOut(itemSymbolOut)
	);
	
	DisplayController myDisplay(
		.DispVal1(DispVal1),
		.DispVal2(DispVal2),
		.DispVal3(DispVal3),
		.DispVal4(DispVal4),
		.dPoint(dPoint),
		.segmentClk(segmentClock),
		.segOut(seg),
		.an(an)
	);

	always @ (currentItem or sw[0] or sw[1] or stockA or stockB or stockC or stockD or userBalance) begin 
		if (stockMode) begin 
			DispVal1 = stockOut %10;
			DispVal2 = ((stockOut - DispVal1) % 100)/10;
			DispVal3 = (stockOut - (DispVal2*10) - DispVal1) / 100;
			DispVal4 = itemSymbolOut;
			dPoint = 0;
		end else if (priceMode) begin
			DispVal1 = priceOut %10;
			DispVal2 = ((priceOut - DispVal1) % 100)/10;
			DispVal3 = (priceOut - (DispVal2*10) - DispVal1) / 100;
			DispVal4 = itemSymbolOut;
			dPoint = 1;
		end else if (moneyMode) begin 
			DispVal1 = userBalance %10;
			DispVal2 = ((userBalance - DispVal1) % 100)/10;
			DispVal3 = (userBalance - (DispVal2*10) - DispVal1) / 100;
			DispVal4 = coinSymbolOut;
			dPoint = 1;
		end else if (purchaseMode) begin
			DispVal1 = userBalance %10;
			DispVal2 = ((userBalance - DispVal1) % 100)/10;
			DispVal3 = (userBalance - (DispVal2*10) - DispVal1) / 100;
			DispVal4 = 19;
			dPoint = 1;
		end
	end
endmodule