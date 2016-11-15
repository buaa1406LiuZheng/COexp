`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:12:40 11/15/2015 
// Design Name: 
// Module Name:    controller 
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
module Controller(/*autoport*/
//output
			RegWrite,
			jump,
			JumpSrc,
			RegWriteSrcD,
			RegWriteSrcE,
			RegWriteSrcM,
			Branch,
			CMPOp,
			MemWrite,
			LoadOp,
			ALUOp,
			ALUSrcB,
			ALUSrcA,
			RegDst,
			EXTOp,
			rsUseInID,
			rsUseInEXE,
			rtUseInID,
			rtUseInEXE,
			MnDOp,
			MnDWe,
			MnDStart,
			MnDHiLo,
			MnDMove,
			EXLClr,
			CP0_We,
//input
			op,
			funct,
			rs,
			rt);
	input [5:0] op,funct;
	input [4:0] rs,rt;

	output RegWrite,jump,JumpSrc;
	output RegWriteSrcD;
	output [1:0] RegWriteSrcE;
	output [1:0] RegWriteSrcM;

	output Branch;
	output [2:0] CMPOp;

	output [1:0] MemWrite;
	output [2:0] LoadOp;

	output [3:0] ALUOp;
	output ALUSrcB,ALUSrcA;
	output [1:0] RegDst,EXTOp;

	output rsUseInID,rsUseInEXE;
	output rtUseInID,rtUseInEXE;

	output [1:0] MnDOp;
	output MnDWe,MnDStart,MnDHiLo,MnDMove;

	output EXLClr,CP0_We;
	
	wire R,add,addu,sub,subu,And,Or,Xor,Nor,sll,srl,sra,sllv,srlv,srav,slt,sltu,jr,jalr;
	wire R_Shift,R_Arithmetic;
	wire addi,addiu,andi,ori,xori,lui,slti,sltiu,I_Arithmetic;
	wire lw,lh,lb,lhu,lbu,Load;
	wire sw,sh,sb,Store;
	wire beq,bne,bltz,blez,bgtz,bgez,branch,REGIMM;
	wire j,jal;
	wire mult,multu,div,divu,mfhi,mflo,mthi,mtlo;
	wire COP0,eret,mfc0,mtc0;

	
	//R type
	assign R    =(op==6'b000000);
	//R arithmetic and logic
	assign add  =R&(funct==6'b100000);
	assign addu =R&(funct==6'b100001);
	assign sub  =R&(funct==6'b100010);
	assign subu =R&(funct==6'b100011); 
	assign And  =R&(funct==6'b100100);
	assign Or   =R&(funct==6'b100101);
	assign Xor  =R&(funct==6'b100110);
	assign Nor  =R&(funct==6'b100111);

	assign sll  =R&(funct==6'b000000);
	assign srl  =R&(funct==6'b000010);
	assign sra  =R&(funct==6'b000011);
	assign sllv =R&(funct==6'b000100);
	assign srlv =R&(funct==6'b000110);
	assign srav =R&(funct==6'b000111);

	assign slt  =R&(funct==6'b101010);	
	assign sltu =R&(funct==6'b101011);

	assign mult =R&(funct==6'b011000);
	assign multu=R&(funct==6'b011001);
	assign div  =R&(funct==6'b011010);
	assign divu =R&(funct==6'b011011);
	assign mfhi =R&(funct==6'b010000);
	assign mflo =R&(funct==6'b010010);
	assign mthi =R&(funct==6'b010001);
	assign mtlo =R&(funct==6'b010011);

	assign R_Shift=sll|srl|sra|sllv|srlv|srav;
	assign R_Arithmetic=add|addu|sub|subu|And|Or|Xor|Nor|sllv|srlv|srav|slt|sltu;
	//jump
	assign jr   =R&(funct==6'b001000);
	assign jalr =R&(funct==6'b001001);
	//others

	//I arithmetic and logic
	assign addi =(op==6'b001000);
	assign addiu=(op==6'b001001);
	assign andi =(op==6'b001100);
	assign ori  =(op==6'b001101);
	assign xori =(op==6'b001110);
	assign lui  =(op==6'b001111);
	assign slti =(op==6'b001010);
	assign sltiu=(op==6'b001011);

	assign I_Arithmetic=addi|addiu|andi|ori|xori|lui|slti|sltiu;
	//load and store
	assign lw   =(op==6'b100011);
	assign lh   =(op==6'b100001);
	assign lb   =(op==6'b100000);
	assign lhu  =(op==6'b100101);
	assign lbu  =(op==6'b100100);
	assign sw   =(op==6'b101011);
	assign sh   =(op==6'b101001);
	assign sb   =(op==6'b101000);

	assign Load=lw|lh|lb|lhu|lbu;
	assign Store=sw|sh|sb;
	//branch
	assign REGIMM=(op==6'b000001);
	assign beq  =(op==6'b000100);
	assign bne  =(op==6'b000101);
	assign bltz =REGIMM&(rt==5'b00000);
	assign blez =(op==6'b000110);
	assign bgtz =(op==6'b000111);
	assign bgez =REGIMM&(rt==5'b00001);
	assign branch=beq|bne|bltz|blez|bgtz|bgez;
	//jump
	assign j    =(op==6'b000010);
	assign jal  =(op==6'b000011);

	//C0
	assign COP0 =(op==6'b010000);
	assign eret =COP0&(funct==6'b011000);
	assign mfc0 =COP0&(rs==5'b00000);
	assign mtc0 =COP0&(rs==5'b00100);
	


	//Control Signal
	assign RegDst[1]=jal;
	assign RegDst[0]=I_Arithmetic|Load|mfc0;

	assign RegWrite=R_Arithmetic|R_Shift|I_Arithmetic|Load|jal|jalr|mfhi|mflo|mfc0;

	assign ALUSrcB=I_Arithmetic|Load|Store;
	assign ALUSrcA=sll|srl|sra;
	assign ALUOp[3]=R_Shift|slt|sltu|slti|sltiu;
	assign ALUOp[2]=Xor|Nor|xori|slt|sltu|slti|sltiu;
	assign ALUOp[1]=And|andi|Or|ori|sra|srav;
	assign ALUOp[0]=sub|subu|Or|ori|Nor|beq|srl|srlv|sltu|sltiu;

	assign EXTOp[1]=lui;
	assign EXTOp[0]=addi|addiu|slti|sltiu|Load|Store|branch;

	assign CMPOp[2]=beq|bne;
	assign CMPOp[1]=bgtz|bgez;
	assign CMPOp[0]=bne|blez|bgez;

	assign RegWriteSrcD=jal|jalr;
	assign RegWriteSrcE[1]=jal|jalr|lui|mfhi;
	assign RegWriteSrcE[0]=jal|jalr|lui|mflo;
	assign RegWriteSrcM[1]=~Load;
	assign RegWriteSrcM[0]=~Load&~mfc0;

	assign MemWrite[1]=sw|sb;
	assign MemWrite[0]=sw|sh;

	assign LoadOp[2]=lh;
	assign LoadOp[1]=lb|lhu;
	assign LoadOp[0]=lhu|lbu;

	assign Branch=branch;

	assign jump=j|jr|jal|jalr;
	assign JumpSrc=jr|jalr;
	
	assign rsUseInID=branch|jr|jalr;
	assign rtUseInID=beq|bne;
	assign rsUseInEXE=R_Arithmetic|I_Arithmetic|Load|Store|mult|multu|div|divu|mthi|mtlo;
	assign rtUseInEXE=R_Arithmetic|sll|srl|sra|mult|multu|div|divu|mtc0;

	assign MnDOp[1] = div|divu;
	assign MnDOp[0] = mult|div;
	assign MnDWe = mthi|mtlo;
	assign MnDStart = mult|multu|div|divu;
	assign MnDHiLo = mthi;
	assign MnDMove = mfhi|mflo;

	assign EXLClr = eret;
	assign CP0_We = mtc0;

endmodule