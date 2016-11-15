`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:30:50 11/26/2015 
// Design Name: 
// Module Name:    CMP 
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
module CMP(/*autoport*/
//output
			Br,
//input
			A,
			B,
			Op);
	input [31:0] A;
	input [31:0] B;
	input [2:0] Op;

	output Br;

	assign Br = (Op==3'b000)?(A[31]):
					(Op==3'b001)?(A[31]|(A==32'b0)):
					(Op==3'b010)?(~A[31]&(A!=32'b0)):
					(Op==3'b011)?(~A[31]):
					(Op==3'b100)?(A==B):
					(Op==3'b101)?(A!=B):1'b0;

endmodule
