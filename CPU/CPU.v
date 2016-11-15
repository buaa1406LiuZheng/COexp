`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:47:48 11/21/2015 
// Design Name: 
// Module Name:    mips 
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
module CPU(
	input clk2,
    input clk,
    input rst,
    input [31:0] PrRD,
    input [15:10] HWInt,
    output [31:0] PrAddr,
    output [31:0] PrWD,
    output PrWe
    );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////SIGNAL DEFINE/////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//IF Stage
	wire [31:0]currentPC_F,nextPC_F,NormalnextPC_F,eretPC_F;
	wire [31:0]Instr_F;
	wire NormalPCSrc_F;
	wire [1:0] PCSrc_F;
	wire [31:0]IMaddr_F;
	
//ID Stage
	wire [31:0]Instr_D;
	wire [5:0] op_D,funct_D;
	wire [4:0] rs_D,rt_D,rd_D;
	wire [4:0] shamt_D;
	wire [15:0]imm16_D;
	wire [25:0]imm26_D;
	
	wire [31:0]currentPC_D,PCplus8_D;
	wire [31:0]JAddr_D,JImm_D;
	wire [31:0]BorJPC_D;
	wire BorJ_D;

	wire CMPResult_D;
	
	wire [31:0] RD1_D,RD2_D;
	wire [4:0] RFA3_D;
	wire [31:0] RD1_Forward_D,RD2_Forward_D;
	
	wire [31:0]imm32_D;

//EXE Stage
	wire [31:0]currentPC_E;
	wire [31:0] RD1_E,RD2_E,imm32_E;
	wire [31:0] RD1_Forward_E,RD2_Forward_E;
	wire [4:0] rs_E,rt_E,rd_E,RFA3_E;
	
	wire [31:0] ALUinA_E,ALUinB_E;
	wire [4:0] shamt_E;
	wire [31:0] ALUResult_E;

	wire [31:0] PCplus8_E;
	wire [31:0] RFWD_E;

	wire MnDBusy_E;
	wire [31:0] HI_E,LO_E;

	wire BorJ_E;
	
//MEM Stage
	wire [31:0]currentPC_M;
	wire [31:0]ALUResult_M;
	wire [31:0]RD2_M,RD2_Forward_M;
	wire [4:0]RFA3_M;
	wire [4:0]rt_M,rd_M;
	
	wire [31:0] DMRD_M;
	wire [31:0] RFWD_M,RFWDE_M;
	wire DMWe_M;
	wire [31:0] DMWD_M;
	wire [3:0] BE_M;
	wire [31:0] DMlowAddr_M;
	wire [31:0] HI_M,LO_M;
	wire [31:0] LoadOut_M;
	wire [1:0] ByteAddr_M;
	wire BorJ_M;

//WB Stage
	wire [31:0]LoadOut_W;
	wire [31:0]LoadResult_W;
	wire [31:0]DMRD_W;
	wire [1:0] ByteAddr_W;
	wire [4:0]RFA3_W;
	
	wire [31:0]RFWD_W,RFWDM_W;

	wire [31:0] currentPC_W;
	wire BorJ_W;
	
///////////////////////////////Control Signal///////////////////////////////
	wire [1:0]EXTOp_D;
	wire Branch_D; 
	wire jump_D;
	wire JumpSrc_D;
	wire [1:0]RegDst_D;
	wire ALUSrcA_D;
	wire ALUSrcB_D;
	wire [3:0]ALUOp_D;
	wire [1:0]MemWrite_D;
	wire [2:0]LoadOp_D;
	wire RegWrite_D;
	wire RegWriteSrcD_D;
	wire [1:0]RegWriteSrcE_D;
	wire [1:0]RegWriteSrcM_D;
	wire rsUseInID_D,rsUseInEXE_D;
	wire rtUseInID_D,rtUseInEXE_D;
	wire [2:0] CMPOp_D;
	wire [1:0] MnDOp_D;
	wire MnDWe_D,MnDStart_D,MnDHiLo_D,MnDMove_D;
	wire EXLClr_D;
	wire CP0_We_D;

	wire ALUSrcA_E;
	wire ALUSrcB_E;
	wire [3:0]ALUOp_E;
	wire [1:0]MemWrite_E;
	wire [2:0]LoadOp_E;
	wire RegWrite_E;
	wire RegWriteSrcD_E;
	wire [1:0]RegWriteSrcE_E;
	wire [1:0]RegWriteSrcM_E;
	wire rsUseInEXE_E;
	wire rtUseInEXE_E;
	wire [1:0] MnDOp_E;
	wire MnDWe_E,MnDStart_E,MnDHiLo_E;
	wire EXLClr_E;
	wire CP0_We_E;

	wire [1:0]MemWrite_M;
	wire [2:0]LoadOp_M;
	wire RegWrite_M;
	wire [1:0]RegWriteSrcE_M;
	wire [1:0]RegWriteSrcM_M;
	wire EXLClr_M;
	wire CP0_We_M;

	wire RegWrite_W;
	wire [1:0]RegWriteSrcM_W;
	wire [2:0]LoadOp_W;
	wire EXLClr_W;

//Hazard Control
	wire [1:0] Forward_rs_D,Forward_rs_E;
	wire [1:0] Forward_rt_D,Forward_rt_E;
	wire Forward_rt_M;
	wire stall_D,stall_E;
	
	wire PC_En;
	wire PR_IF_ID_En,PR_ID_EXE_En;
	wire PR_IF_ID_Clr,PR_ID_EXE_Clr,PR_EXE_MEM_Clr,PR_MEM_WB_Clr;

///////////////////////////////Interupt And Exception///////////////////////////////

	wire IntReq;
	wire [31:0] CP0_Out_M,CP0_Out_W; 
	wire [31:0] CP0_PCin;
	wire [31:0] EPC;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
///////////////////////////////////////////////////////DATAPATH///////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////IF Stage///////////////////////////////////////////////////////
	
	assign NormalPCSrc_F=(Branch_D&CMPResult_D)|jump_D;
	assign NormalnextPC_F=(NormalPCSrc_F)?BorJPC_D:(currentPC_F+4);
	assign eretPC_F=(CP0_We_E&&(rd_E==5'd14))?RD2_Forward_E:
					(CP0_We_M&&(rd_M==5'd14))?RD2_Forward_M:
					EPC;

	assign PCSrc_F[1]=IntReq|EXLClr_D;
	assign PCSrc_F[0]=EXLClr_D;	
	assign nextPC_F=(PCSrc_F[1]===1'b1)?
						((PCSrc_F[0]===1'b1)?eretPC_F:32'h0000_4180):
						NormalnextPC_F;
	
	assign IMaddr_F=currentPC_F-32'h0000_3000;
	PC PC(.clk(clk),.rst(rst),.en(PC_En),.nextPC(nextPC_F),.currentPC(currentPC_F));
	im_6k IM(.clk(clk2),.addr(IMaddr_F[12:2]),.dout(Instr_F));

////////////////////////PipeLine Register IF/ID////////////////////////
PR_IF_ID IF_ID(/*autoinst*/
			.Instr_D(Instr_D[31:0]),
			.currentPC_D(currentPC_D[31:0]),
			.clk(clk),
			.rst(rst),
			.PR_IF_ID_Clr(PR_IF_ID_Clr),
			.PR_IF_ID_En(PR_IF_ID_En),
			.Instr_F(Instr_F[31:0]),
			.currentPC_F(currentPC_F[31:0]));

///////////////////////////////////////////////////////ID Stage///////////////////////////////////////////////////////
	assign op_D=Instr_D[31:26];
	assign funct_D=Instr_D[5:0];
	assign rs_D=Instr_D[25:21];
	assign rt_D=Instr_D[20:16];
	assign rd_D=Instr_D[15:11];
	assign shamt_D=Instr_D[10:6];
	assign imm16_D=Instr_D[15:0];
	assign imm26_D=Instr_D[25:0];
	
	RegFile RF(.Clk(clk),.Rst(rst),.A1(rs_D),.A2(rt_D),.A3(RFA3_W),
				  .WD(RFWD_W),.We(RegWrite_W),.RD1(RD1_D),.RD2(RD2_D));

	assign RD1_Forward_D=(Forward_rs_D==2'b01)?RFWD_E:
						 (Forward_rs_D==2'b10)?RFWD_M:
						 RD1_D;
	assign RD2_Forward_D=(Forward_rt_D==2'b01)?RFWD_E:
						 (Forward_rt_D==2'b10)?RFWD_M:
						 RD2_D;

				  
	EXT EXT(.imm16(imm16_D),.EXTOp(EXTOp_D),.imm32(imm32_D));
	
	assign JImm_D={currentPC_D[31:28],imm26_D,2'b00};
	assign JAddr_D=(JumpSrc_D)?RD1_Forward_D:JImm_D;

	CMP CMP(.A(RD1_Forward_D),.B(RD2_Forward_D),.Op(CMPOp_D),.Br(CMPResult_D));

	BJPC BJPC(.PCin(currentPC_D),.PCout(BorJPC_D),.PCplus8(PCplus8_D),
				 .Branch(Branch_D),.jump(jump_D),.BOffset(imm32_D),.JAddr(JAddr_D));
	assign BorJ_D = Branch_D|jump_D;

	assign RFA3_D=(RegDst_D[1])?5'b11111:
				  (RegDst_D[0])?rt_D:rd_D;

////////////////////////PipeLine Register ID/EXE////////////////////////
PR_ID_EXE ID_EXE(/*autoinst*/
			.ALUSrcA_E(ALUSrcA_E),
			.ALUSrcB_E(ALUSrcB_E),
			.shamt_E(shamt_E[4:0]),
			.ALUOp_E(ALUOp_E[3:0]),
			.MemWrite_E(MemWrite_E[1:0]),
			.LoadOp_E(LoadOp_E[2:0]),
			.RegWrite_E(RegWrite_E),
			.RegWriteSrcD_E(RegWriteSrcD_E),
			.RegWriteSrcE_E(RegWriteSrcE_E[1:0]),
			.RegWriteSrcM_E(RegWriteSrcM_E[1:0]),
			.RD1_E(RD1_E[31:0]),
			.RD2_E(RD2_E[31:0]),
			.imm32_E(imm32_E[31:0]),
			.rs_E(rs_E[4:0]),
			.rt_E(rt_E[4:0]),
			.RFA3_E(RFA3_E[4:0]),
			.PCplus8_E(PCplus8_E[31:0]),
			.rsUseInEXE_E(rsUseInEXE_E),
			.rtUseInEXE_E(rtUseInEXE_E),
			.MnDOp_E(MnDOp_E[1:0]),
			.MnDWe_E(MnDWe_E),
			.MnDStart_E(MnDStart_E),
			.MnDHiLo_E(MnDHiLo_E),
			.currentPC_E(currentPC_E[31:0]),
			.EXLClr_E(EXLClr_E),
			.CP0_We_E(CP0_We_E),
			.rd_E(rd_E[4:0]),
			.BorJ_E(BorJ_E),
			.clk(clk),
			.PR_ID_EXE_En(PR_ID_EXE_En),
			.PR_ID_EXE_Clr(PR_ID_EXE_Clr),
			.RD1_Forward_D(RD1_Forward_D[31:0]),
			.RD2_Forward_D(RD2_Forward_D[31:0]),
			.imm32_D(imm32_D[31:0]),
			.rs_D(rs_D[4:0]),
			.rt_D(rt_D[4:0]),
			.RFA3_D(RFA3_D[4:0]),
			.PCplus8_D(PCplus8_D[31:0]),
			.ALUSrcA_D(ALUSrcA_D),
			.ALUSrcB_D(ALUSrcB_D),
			.shamt_D(shamt_D[4:0]),
			.ALUOp_D(ALUOp_D[3:0]),
			.MemWrite_D(MemWrite_D[1:0]),
			.LoadOp_D(LoadOp_D[2:0]),
			.RegWrite_D(RegWrite_D),
			.RegWriteSrcD_D(RegWriteSrcD_D),
			.RegWriteSrcE_D(RegWriteSrcE_D[1:0]),
			.RegWriteSrcM_D(RegWriteSrcM_D[1:0]),
			.rsUseInEXE_D(rsUseInEXE_D),
			.rtUseInEXE_D(rtUseInEXE_D),
			.MnDOp_D(MnDOp_D[1:0]),
			.MnDWe_D(MnDWe_D),
			.MnDStart_D(MnDStart_D),
			.MnDHiLo_D(MnDHiLo_D),
			.currentPC_D(currentPC_D[31:0]),
			.rd_D(rd_D[4:0]),
			.EXLClr_D(EXLClr_D),
			.CP0_We_D(CP0_We_D),
			.BorJ_D(BorJ_D));
						  
///////////////////////////////////////////////////////EXE Stage///////////////////////////////////////////////////////

	assign RD1_Forward_E=(Forward_rs_E==2'b01)?RFWD_M:
						 (Forward_rs_E==2'b10)?RFWD_W:
						 RD1_E;
	assign RD2_Forward_E=(Forward_rt_E==2'b01)?RFWD_M:
						 (Forward_rt_E==2'b10)?RFWD_W:
						 RD2_E;

	assign ALUinA_E=(ALUSrcA_E)?({26'b0,shamt_E}):RD1_Forward_E;
	assign ALUinB_E=(ALUSrcB_E)?imm32_E:RD2_Forward_E;
	assign RFWD_E=(RegWriteSrcD_E)?PCplus8_E:imm32_E;

	ALU ALU(.A(ALUinA_E),.B(ALUinB_E),.Op(ALUOp_E),.C(ALUResult_E));

	MULandDIV MULandDIV(/*autoinst*/
			.Busy(MnDBusy_E),
			.HI(HI_E),
			.LO(LO_E),
			.clk(clk),
			.rst(rst),
			.D1(RD1_Forward_E),
			.D2(RD2_Forward_E),
			.HiLo(MnDHiLo_E),
			.Op(MnDOp_E),
			.Start(MnDStart_E&(~IntReq)),
			.We(MnDWe_E&(~IntReq)));
	
////////////////////////PipeLine Register EXE/MEM////////////////////////
PR_EXE_MEM EXE_MEM(/*autoinst*/
			.ALUResult_M(ALUResult_M[31:0]),
			.RD2_M(RD2_M[31:0]),
			.RFA3_M(RFA3_M[4:0]),
			.rt_M(rt_M[4:0]),
			.RFWDE_M(RFWDE_M[31:0]),
			.MemWrite_M(MemWrite_M[1:0]),
			.LoadOp_M(LoadOp_M[2:0]),
			.RegWrite_M(RegWrite_M),
			.RegWriteSrcE_M(RegWriteSrcE_M[1:0]),
			.RegWriteSrcM_M(RegWriteSrcM_M[1:0]),
			.HI_M(HI_M[31:0]),
			.LO_M(LO_M[31:0]),
			.currentPC_M(currentPC_M[31:0]),
			.rd_M(rd_M[4:0]),
			.EXLClr_M(EXLClr_M),
			.CP0_We_M(CP0_We_M),
			.BorJ_M(BorJ_M),
			.clk(clk),
			.PR_EXE_MEM_Clr(PR_EXE_MEM_Clr),
			.ALUResult_E(ALUResult_E[31:0]),
			.RD2_Forward_E(RD2_Forward_E[31:0]),
			.RFA3_E(RFA3_E[4:0]),
			.rt_E(rt_E[4:0]),
			.RFWD_E(RFWD_E[31:0]),
			.MemWrite_E(MemWrite_E[1:0]),
			.LoadOp_E(LoadOp_E[2:0]),
			.RegWrite_E(RegWrite_E),
			.RegWriteSrcE_E(RegWriteSrcE_E[1:0]),
			.RegWriteSrcM_E(RegWriteSrcM_E[1:0]),
			.HI_E(HI_E[31:0]),
			.LO_E(LO_E[31:0]),
			.currentPC_E(currentPC_E[31:0]),
			.rd_E(rd_E[4:0]),
			.EXLClr_E(EXLClr_E),
			.CP0_We_E(CP0_We_E),
			.BorJ_E(BorJ_E));

///////////////////////////////////////////////////////MEM Stage///////////////////////////////////////////////////////
	
	assign RD2_Forward_M=(Forward_rt_M)?RFWD_W:RD2_M;
	assign RFWD_M=(RegWriteSrcE_M==2'b00)?ALUResult_M:
				  (RegWriteSrcE_M==2'b01)?LO_M:
				  (RegWriteSrcE_M==2'b10)?HI_M:
				  RFWDE_M;
	assign DMlowAddr_M=ALUResult_M;
	assign ByteAddr_M=DMlowAddr_M[1:0];

	assign PrWD = RD2_Forward_M;
	assign PrAddr = DMlowAddr_M;
	assign PrWe = (MemWrite_M[1]&MemWrite_M[0])&(~IntReq);

	DMIN DMIN(.WDOut(DMWD_M),
			  .DMWe(DMWe_M),
			  .BE(BE_M),
			  .WDIn(RD2_Forward_M),
			  .Addr(DMlowAddr_M[1:0]),
			  .MemWrite(MemWrite_M));
	dm_4k DM(/*autoinst*/
			.RD(DMRD_M),
			.clk(clk),
			.clk2(clk2),
			.A(DMlowAddr_M[11:2]),
			.BE(BE_M),
			.WD(DMWD_M),
			.We(DMWe_M&(~IntReq)&(DMlowAddr_M[31:8]!=24'h0000_7f)));

	assign LoadOut_M = (DMlowAddr_M[31:8]==24'h0000_7f)?PrRD:DMRD_M;
	
////////////////////////PieLine Register MEM/WB////////////////////////
PR_MEM_WB MEM_WB(/*autoinst*/
			.LoadOut_W(LoadOut_W[31:0]),
			.ByteAddr_W(ByteAddr_W[1:0]),
			.RFA3_W(RFA3_W[4:0]),
			.RFWDM_W(RFWDM_W[31:0]),
			.RegWrite_W(RegWrite_W),
			.RegWriteSrcM_W(RegWriteSrcM_W[1:0]),
			.LoadOp_W(LoadOp_W[2:0]),
			.CP0_Out_W(CP0_Out_W[31:0]),
			.currentPC_W(currentPC_W[31:0]),
			.BorJ_W(BorJ_W),
			.EXLClr_W(EXLClr_W),
			.clk(clk),
			.PR_MEM_WB_Clr(PR_MEM_WB_Clr),
			.LoadOut_M(LoadOut_M[31:0]),
			.ByteAddr_M(ByteAddr_M[1:0]),
			.RFA3_M(RFA3_M[4:0]),
			.RFWD_M(RFWD_M[31:0]),
			.RegWrite_M(RegWrite_M),
			.RegWriteSrcM_M(RegWriteSrcM_M[1:0]),
			.LoadOp_M(LoadOp_M[2:0]),
			.CP0_Out_M(CP0_Out_M[31:0]),
			.currentPC_M(currentPC_M[31:0]),
			.BorJ_M(BorJ_M),
			.EXLClr_M(EXLClr_M));
///////////////////////////////////////////////////////WB Stage///////////////////////////////////////////////////////
	
	LOADOUT LOADOUT(/*autoinst*/
			.Dout(LoadResult_W),
			.A(ByteAddr_W),
			.Din(LoadOut_W),
			.Op(LoadOp_W));


	assign RFWD_W=(RegWriteSrcM_W[1])?
					((RegWriteSrcM_W[0])?RFWDM_W:CP0_Out_W):
					LoadResult_W;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////					  
///////////////////////////////////////////////////////CONTROL////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Controller Controller(/*autoinst*/
			.RegWrite(RegWrite_D),
			.jump(jump_D),
			.JumpSrc(JumpSrc_D),
			.RegWriteSrcD(RegWriteSrcD_D),
			.RegWriteSrcE(RegWriteSrcE_D),
			.RegWriteSrcM(RegWriteSrcM_D),
			.Branch(Branch_D),
			.CMPOp(CMPOp_D),
			.MemWrite(MemWrite_D),
			.LoadOp(LoadOp_D),
			.ALUOp(ALUOp_D),
			.ALUSrcB(ALUSrcB_D),
			.ALUSrcA(ALUSrcA_D),
			.RegDst(RegDst_D),
			.EXTOp(EXTOp_D),
			.rsUseInID(rsUseInID_D),
			.rsUseInEXE(rsUseInEXE_D),
			.rtUseInID(rtUseInID_D),
			.rtUseInEXE(rtUseInEXE_D),
			.MnDOp(MnDOp_D),
			.MnDWe(MnDWe_D),
			.MnDStart(MnDStart_D),
			.MnDHiLo(MnDHiLo_D),
			.MnDMove(MnDMove_D),
			.EXLClr(EXLClr_D),
			.CP0_We(CP0_We_D),
			.op(op_D),
			.funct(funct_D),
			.rs(rs_D),
			.rt(rt_D));
////////////////////////Hazard Control////////////////////////
HazardUnit HazardUnit(/*autoinst*/
			.Forward_rs_D(Forward_rs_D[1:0]),
			.Forward_rs_E(Forward_rs_E[1:0]),
			.Forward_rt_D(Forward_rt_D[1:0]),
			.Forward_rt_E(Forward_rt_E[1:0]),
			.Forward_rt_M(Forward_rt_M),
			.stall_D(stall_D),
			.stall_E(stall_E),
			.RegWrite_E(RegWrite_E),
			.RegWrite_M(RegWrite_M),
			.RegWrite_W(RegWrite_W),
			.RegWriteSrcE_E(RegWriteSrcE_E[1:0]),
			.RegWriteSrcM_M(RegWriteSrcM_M[1:0]),
			.RegWriteSrcM_E(RegWriteSrcM_E[1:0]),
			.RFA3_E(RFA3_E[4:0]),
			.RFA3_M(RFA3_M[4:0]),
			.RFA3_W(RFA3_W[4:0]),
			.rs_D(rs_D[4:0]),
			.rs_E(rs_E[4:0]),
			.rt_D(rt_D[4:0]),
			.rt_E(rt_E[4:0]),
			.rt_M(rt_M[4:0]),
			.rsUseInID_D(rsUseInID_D),
			.rsUseInEXE_D(rsUseInEXE_D),
			.rsUseInEXE_E(rsUseInEXE_E),
			.rtUseInID_D(rtUseInID_D),
			.rtUseInEXE_D(rtUseInEXE_D),
			.rtUseInEXE_E(rtUseInEXE_E),
			.MnDStart_E(MnDStart_E),
			.MnDBusy_E(MnDBusy_E),
			.MnDWe_D(MnDWe_D),
			.MnDMove_D(MnDMove_D),
			.MnDStart_D(MnDStart_D));

	assign PC_En=(~(stall_D|stall_E))|IntReq;
	assign PR_IF_ID_En=~(stall_D|stall_E);
	assign PR_ID_EXE_En=~stall_E;
	assign PR_IF_ID_Clr=rst|IntReq|EXLClr_D;
	assign PR_ID_EXE_Clr=stall_D&~stall_E|IntReq;
	assign PR_EXE_MEM_Clr=stall_E|IntReq;
	assign PR_MEM_WB_Clr=(IntReq&~EXLClr_E);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////					  
///////////////////////////////////////////////Interupt And Exception/////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	assign CP0_PCin = (BorJ_W)?currentPC_W:
					  (EXLClr_E)?currentPC_F:
					  (EXLClr_M)?currentPC_D:
					  (EXLClr_W)?currentPC_E:
					  currentPC_M;

	CP0 CP0(/*autoinst*/
			.IntReq(IntReq),
			.Dout(CP0_Out_M),
			.EPC(EPC[31:0]),
			.clk(clk),
			.rst(rst),
			.Addr(rd_M),
			.We(CP0_We_M&(~IntReq)),
			.Din(RD2_Forward_M),
			.PC(CP0_PCin),
			.HWInt(HWInt),
			.EXLClr(EXLClr_D));

//////////////////////////////////////////////////////////////////////////////////
endmodule