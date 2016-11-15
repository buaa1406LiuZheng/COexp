`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:22:44 11/21/2015 
// Design Name: 
// Module Name:    PR_EXE_MEM 
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
module PR_EXE_MEM(/*autoport*/
//output
			ALUResult_M,
			RD2_M,
			RFA3_M,
			rt_M,
			RFWDE_M,
			MemWrite_M,
			LoadOp_M,
			RegWrite_M,
			RegWriteSrcE_M,
			RegWriteSrcM_M,
			HI_M,
			LO_M,
			currentPC_M,
			rd_M,
			EXLClr_M,
			CP0_We_M,
			BorJ_M,
//input
			clk,
			PR_EXE_MEM_Clr,
			ALUResult_E,
			RD2_Forward_E,
			RFA3_E,
			rt_E,
			RFWD_E,
			MemWrite_E,
			LoadOp_E,
			RegWrite_E,
			RegWriteSrcE_E,
			RegWriteSrcM_E,
			HI_E,
			LO_E,
			currentPC_E,
			rd_E,
			EXLClr_E,
			CP0_We_E,
			BorJ_E);
	input clk;
	input PR_EXE_MEM_Clr;

	input [31:0]ALUResult_E;
	input [31:0]RD2_Forward_E;
	input [4:0]RFA3_E;
	input [4:0]rt_E;
	input [31:0]RFWD_E;
	input [1:0] MemWrite_E;
	input [2:0] LoadOp_E;
	input RegWrite_E;
	input [1:0] RegWriteSrcE_E;
	input [1:0] RegWriteSrcM_E;
	input [31:0] HI_E;
	input [31:0] LO_E;
	input [31:0] currentPC_E;
	input [4:0] rd_E;
	input EXLClr_E;
	input CP0_We_E;
	input BorJ_E;

	output reg [31:0]ALUResult_M;
	output reg [31:0]RD2_M;
	output reg [4:0]RFA3_M;
	output reg [4:0]rt_M;
	output reg [31:0]RFWDE_M;
	output reg [1:0] MemWrite_M;
	output reg [2:0] LoadOp_M;
	output reg RegWrite_M;
	output reg [1:0] RegWriteSrcE_M;
	output reg [1:0] RegWriteSrcM_M;
	output reg [31:0] HI_M;
	output reg [31:0] LO_M;
	output reg [31:0] currentPC_M;
	output reg [4:0] rd_M;
	output reg EXLClr_M;
	output reg CP0_We_M;
	output reg BorJ_M;

	always@(posedge clk)
		begin
			if(PR_EXE_MEM_Clr)
				begin
					RegWrite_M<=1'b0;
					MemWrite_M<=2'b0;
					currentPC_M<=currentPC_E;
				end
			else
				begin
					ALUResult_M<=ALUResult_E;
					RD2_M<=RD2_Forward_E;
					RFA3_M<=RFA3_E;
					rt_M<=rt_E;
					RFWDE_M<=RFWD_E;
					MemWrite_M<=MemWrite_E;
					LoadOp_M<=LoadOp_E;
					RegWrite_M<=RegWrite_E;
					RegWriteSrcE_M<=RegWriteSrcE_E;
					RegWriteSrcM_M<=RegWriteSrcM_E;
					HI_M<=HI_E;
					LO_M<=LO_E;

					currentPC_M<=currentPC_E;
					EXLClr_M<=EXLClr_E;
					CP0_We_M<=CP0_We_E;
					rd_M<=rd_E;	
					BorJ_M<=BorJ_E;				
				end
		end

endmodule
