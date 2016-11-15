`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:37:35 11/21/2015 
// Design Name: 
// Module Name:    PR_MEM_WB 
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
module PR_MEM_WB(/*autoport*/
//output
			LoadOut_W,
			ByteAddr_W,
			RFA3_W,
			RFWDM_W,
			RegWrite_W,
			RegWriteSrcM_W,
			LoadOp_W,
			CP0_Out_W,
			currentPC_W,
			BorJ_W,
			EXLClr_W,
//input
			clk,
			PR_MEM_WB_Clr,
			LoadOut_M,
			ByteAddr_M,
			RFA3_M,
			RFWD_M,
			RegWrite_M,
			RegWriteSrcM_M,
			LoadOp_M,
			CP0_Out_M,
			currentPC_M,
			BorJ_M,
			EXLClr_M);
	input clk;
	input PR_MEM_WB_Clr;
	
	input [31:0] LoadOut_M;
	input [1:0] ByteAddr_M;
	input [4:0] RFA3_M;
	input [31:0] RFWD_M;
	input RegWrite_M;
	input [1:0] RegWriteSrcM_M;
	input [2:0] LoadOp_M;
	input [31:0] CP0_Out_M;
	input [31:0] currentPC_M;
	input BorJ_M;
	input EXLClr_M;
	
	output reg [31:0] LoadOut_W;
	output reg [1:0] ByteAddr_W;
	output reg [4:0] RFA3_W;
	output reg [31:0] RFWDM_W;
	output reg RegWrite_W;
	output reg [1:0] RegWriteSrcM_W;
	output reg [2:0] LoadOp_W;
	output reg [31:0] CP0_Out_W;
	output reg [31:0] currentPC_W;
	output reg BorJ_W;
	output reg EXLClr_W;

	always@(posedge clk)
		begin
			if(PR_MEM_WB_Clr)
				begin
					RegWrite_W<=0;
				end
			else
				begin
					LoadOut_W<=LoadOut_M;
					ByteAddr_W<=ByteAddr_M;
					RFA3_W<=RFA3_M;
					RFWDM_W<=RFWD_M;
					RegWrite_W<=RegWrite_M;
					RegWriteSrcM_W<=RegWriteSrcM_M;
					LoadOp_W<=LoadOp_M;

					CP0_Out_W<=CP0_Out_M;	
					currentPC_W<=currentPC_M;
					BorJ_W<=BorJ_M;
					EXLClr_W<=EXLClr_M;
				end
		end

endmodule
