`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:52:53 11/25/2015 
// Design Name: 
// Module Name:    DMOUT 
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
module LOADOUT(/*autoport*/
//output
			Dout,
//input
			A,
			Din,
			Op);
	input [1:0] A;
	input [31:0] Din;
	input [2:0] Op;
	output [31:0] Dout;
	wire lh,lb,lhu,lbu;
	wire [7:0] Byte;
	wire [15:0] Half;

	assign Byte=(A==2'b00)?Din[7:0]:
				(A==2'b01)?Din[15:8]:
				(A==2'b10)?Din[23:16]:
				(A==2'b11)?Din[31:24]:
				8'b0;
	assign Half=(A[1])?Din[31:16]:Din[15:0];

	assign lb=(Op==3'b010);
	assign lh=(Op==3'b100);
	assign lbu=(Op==3'b001);
	assign lhu=(Op==3'b011);

	assign Dout = (lbu)?{24'b0,Byte}:
				  (lhu)?{16'b0,Half}:
				  (lb)?{{24{Byte[7]}},Byte}:
				  (lh)?{{16{Half[15]}},Half}:
				  Din;

endmodule
