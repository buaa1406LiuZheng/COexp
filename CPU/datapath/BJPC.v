`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:47:49 11/15/2015 
// Design Name: 
// Module Name:    NPC 
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
module BJPC(
    input [31:0] PCin,
    output [31:0] PCout,
	 output [31:0] PCplus8,
    input Branch,
    input jump,
    input [31:0] BOffset,
    input [31:0] JAddr
    );

	assign PCplus8=PCin+8;
	assign PCout=(jump)?JAddr:
					 (Branch)?(PCin+4+(BOffset<<2)):
					 (PCin+4);
					 
endmodule
