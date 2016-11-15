`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:05:33 11/21/2015 
// Design Name: 
// Module Name:    PR_ID_EXE 
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
module PR_ID_EXE(/*autoport*/
//output
			ALUSrcA_E,
			ALUSrcB_E,
			shamt_E,
			ALUOp_E,
			MemWrite_E,
			LoadOp_E,
			RegWrite_E,
			RegWriteSrcD_E,
			RegWriteSrcE_E,
			RegWriteSrcM_E,
			RD1_E,
			RD2_E,
			imm32_E,
			rs_E,
			rt_E,
			RFA3_E,
			PCplus8_E,
			rsUseInEXE_E,
			rtUseInEXE_E,
			MnDOp_E,
			MnDWe_E,
			MnDStart_E,
			MnDHiLo_E,
			currentPC_E,
			EXLClr_E,
			CP0_We_E,
			rd_E,
			BorJ_E,
//input
			clk,
			PR_ID_EXE_En,
			PR_ID_EXE_Clr,
			RD1_Forward_D,
			RD2_Forward_D,
			imm32_D,
			rs_D,
			rt_D,
			RFA3_D,
			PCplus8_D,
			ALUSrcA_D,
			ALUSrcB_D,
			shamt_D,
			ALUOp_D,
			MemWrite_D,
			LoadOp_D,
			RegWrite_D,
			RegWriteSrcD_D,
			RegWriteSrcE_D,
			RegWriteSrcM_D,
			rsUseInEXE_D,
			rtUseInEXE_D,
			MnDOp_D,
			MnDWe_D,
			MnDStart_D,
			MnDHiLo_D,
			currentPC_D,
			rd_D,
			EXLClr_D,
			CP0_We_D,
			BorJ_D);
	input clk;
	input PR_ID_EXE_En;
	input PR_ID_EXE_Clr;

	input [31:0] RD1_Forward_D,RD2_Forward_D,imm32_D;
	input [4:0] rs_D,rt_D,RFA3_D;
	input [31:0] PCplus8_D;
	input ALUSrcA_D;
	input ALUSrcB_D;
	input [4:0] shamt_D;
	input [3:0] ALUOp_D;
	input [1:0] MemWrite_D;
	input [2:0] LoadOp_D;
	input RegWrite_D;
	input RegWriteSrcD_D;
	input [1:0] RegWriteSrcE_D;
	input [1:0] RegWriteSrcM_D;
	input rsUseInEXE_D,rtUseInEXE_D;
	input [1:0] MnDOp_D;
	input MnDWe_D;
	input MnDStart_D;
	input MnDHiLo_D;
	input [31:0] currentPC_D;
	input [4:0] rd_D;
	input EXLClr_D;
	input CP0_We_D;
	input BorJ_D;
	
	output reg ALUSrcA_E;
	output reg ALUSrcB_E;
	output reg [4:0] shamt_E;
	output reg [3:0] ALUOp_E;
	output reg [1:0] MemWrite_E;
	output reg [2:0] LoadOp_E;
	output reg RegWrite_E;
	output reg RegWriteSrcD_E;
	output reg [1:0] RegWriteSrcE_E;
	output reg [1:0] RegWriteSrcM_E;
	output reg [31:0] RD1_E,RD2_E,imm32_E;
	output reg [4:0] rs_E,rt_E,RFA3_E;
	output reg [31:0] PCplus8_E;
	output reg rsUseInEXE_E,rtUseInEXE_E;
	output reg [1:0] MnDOp_E;
	output reg MnDWe_E;
	output reg MnDStart_E;
	output reg MnDHiLo_E;
	output reg [31:0] currentPC_E;
	output reg EXLClr_E;
	output reg CP0_We_E;
	output reg [4:0] rd_E;
	output reg BorJ_E;

	always@(posedge clk)
		begin
			if (PR_ID_EXE_Clr)
				begin
					RegWrite_E<=1'b0;
					MemWrite_E<=2'b0;
					MnDStart_E<=1'b0;
					MnDWe_E<=1'b0;
					rs_E<=5'b0;
					rt_E<=5'b0;
					RFA3_E<=5'b0;
					currentPC_E<=currentPC_D;
				end
			else if(PR_ID_EXE_En)
				begin
					RD1_E<=RD1_Forward_D;
					RD2_E<=RD2_Forward_D;
					imm32_E<=imm32_D;
					rs_E<=rs_D;
					rt_E<=rt_D;
					RFA3_E<=RFA3_D;
					PCplus8_E<=PCplus8_D;

					ALUSrcA_E<=ALUSrcA_D;
					ALUSrcB_E<=ALUSrcB_D;
					shamt_E<=shamt_D;
					ALUOp_E<=ALUOp_D;
					MemWrite_E<=MemWrite_D;
					LoadOp_E<=LoadOp_D;
					RegWrite_E<=RegWrite_D;
					RegWriteSrcD_E<=RegWriteSrcD_D;
					RegWriteSrcE_E<=RegWriteSrcE_D;
					RegWriteSrcM_E<=RegWriteSrcM_D;
					rsUseInEXE_E<=rsUseInEXE_D;
					rtUseInEXE_E<=rtUseInEXE_D;

					MnDOp_E<=MnDOp_D;
					MnDWe_E<=MnDWe_D;
					MnDStart_E<=MnDStart_D;
					MnDHiLo_E<=MnDHiLo_D;

					currentPC_E<=currentPC_D;
					EXLClr_E<=EXLClr_D;
					CP0_We_E<=CP0_We_D;
					rd_E<=rd_D;
					BorJ_E<=BorJ_D;
				end
		end
		
endmodule
