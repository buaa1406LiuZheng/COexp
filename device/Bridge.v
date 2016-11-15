`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:07:24 12/08/2015 
// Design Name: 
// Module Name:    Bridge 
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
module Bridge(/*autoport*/
//output
			PrRD,
			HWInt,
			DEVAddr,
			DEVWD,
			Timer_We,
			UART_We,
			LED_We,
			SevenSeg_We,
//input
			PrAddr,
			PrWD,
			PrWe,
			user_pb,
			Timer_RD,
			UART_RD,
			Switch_RD,
			LED_RD,
			SevenSeg_RD,
			Timer_IntReq,
			UART_IntReq);
	input [31:0] PrAddr;
	input [31:0] PrWD;
	output [31:0] PrRD;
	input PrWe;
	output [15:10] HWInt;

	input [4:1] user_pb;
	output [3:2] DEVAddr;
	output [31:0] DEVWD;
	input [31:0] Timer_RD,UART_RD,Switch_RD,LED_RD,SevenSeg_RD;
	output Timer_We,UART_We,LED_We,SevenSeg_We;
	input Timer_IntReq,UART_IntReq;

	wire Timer,UART,Switch,LED,SevenSeg;

	assign Timer = (PrAddr[31:4]==28'h0000_7f0);
	assign UART = (PrAddr[31:4]==28'h0000_7f1);
	assign Switch = (PrAddr[31:4]==28'h0000_7f2 && DEVAddr==2'b00);
	assign LED = (PrAddr[31:4]==28'h0000_7f2 && DEVAddr==2'b01);
	assign SevenSeg = (PrAddr[31:4]==28'h0000_7f2 && DEVAddr==2'b10);

	assign PrRD = (Timer)?Timer_RD:
				  (UART)?UART_RD:
				  (Switch)?Switch_RD:
				  (LED)?LED_RD:
				  (SevenSeg)?SevenSeg_RD:
				  32'h23333333;

	assign DEVAddr = PrAddr[3:2];
	assign DEVWD = PrWD;
	
	assign Timer_We = Timer & PrWe;
	assign UART_We = UART & PrWe;
	assign LED_We = LED & PrWe;
	assign SevenSeg_We = SevenSeg & PrWe;

	assign HWInt = {/*UART_IntReq*/1'b0,~user_pb[4],~user_pb[3],~user_pb[2],~user_pb[1],Timer_IntReq};

endmodule
