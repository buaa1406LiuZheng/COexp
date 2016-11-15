`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:01:23 11/21/2015 
// Design Name: 
// Module Name:    PR_IF_ID 
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
module PR_IF_ID(/*autoport*/
//output
			Instr_D,
			currentPC_D,
//input
			clk,
			rst,
			PR_IF_ID_Clr,
			PR_IF_ID_En,
			Instr_F,
			currentPC_F);
	input clk,rst;
	input PR_IF_ID_Clr;
	input PR_IF_ID_En;
	
	input [31:0]Instr_F;
	input [31:0]currentPC_F;

	output reg [31:0]Instr_D;
	output reg [31:0]currentPC_D;
	
	always@(posedge clk)
		begin
			if(PR_IF_ID_Clr||rst)
				begin
					Instr_D<=32'h0000_0000;
					currentPC_D<=32'h0000_3000;
				end
			else if(PR_IF_ID_En)
				begin
					Instr_D<=Instr_F;
					currentPC_D<=currentPC_F;
				end
		end

endmodule
