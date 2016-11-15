`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:15:35 10/22/2015 
// Design Name: 
// Module Name:    test 
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
module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] Op,
    output [31:0] C
    );
	wire [4:0] shamt;
	wire [31:0] ShiftTemp;
	 	
	assign shamt=A[4:0];
	assign ShiftTemp=$signed(B)>>>shamt;

	assign C=(Op==4'b0000)?(A+B):
				  (Op==4'b0001)?(A-B):
				  (Op==4'b0010)?(A&B):
				  (Op==4'b0011)?(A|B):
				  (Op==4'b0100)?(A^B):
				  (Op==4'b0101)?(~(A|B)):
				  (Op==4'b1000)?(B<<shamt):
				  (Op==4'b1001)?(B>>shamt):
				  (Op==4'b1010)?(ShiftTemp):
				  (Op==4'b1100)?($signed(A)<$signed(B)):
				  (Op==4'b1101)?(A<B):
				  32'hffff_ffff;

endmodule
