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
module MULandDIV(/*autoport*/
//output
			Busy,
			HI,
			LO,
//input
			clk,
			rst,
			D1,
			D2,
			HiLo,
			Op,
			Start,
			We);
	input clk,rst;
	input [31:0] D1,D2;
	input HiLo;
	input [1:0] Op;
	input Start;
	input We;
	output reg Busy;
	output reg [31:0] HI,LO;

	reg [31:0] SrcA,SrcB;
	reg [5:0] count;
	reg [1:0] OpReg;

	wire [63:0] SignedMulTemp,UnsignedMulTemp;
	wire [31:0] SignedDivTempQ,SignedDivTempR;
	wire [31:0] UnsignedDivTempQ,UnsignedDivTempR;

	/*SignedMul SignedMul(.clk(clk),.a(SrcA),.b(SrcB),.p(SignedMulTemp));
	UnsignedMul UnsignedMul(.clk(clk),.a(SrcA),.b(SrcB),.p(UnsignedMulTemp));
	SignedDiv SignedDiv(.clk(clk),.dividend(SrcA),.divisor(SrcB),
						.quotient(SignedDivTempQ),.fractional(SignedDivTempR));
	UnsignedDiv UnsignedDiv(.clk(clk),.dividend(SrcA),.divisor(SrcB),
						.quotient(UnsignedDivTempQ),.fractional(UnsignedDivTempR));*/

	always@(posedge clk)
		begin
			if(rst)
				begin 
					HI<=32'b0;
					LO<=32'b0;
					Busy<=1'b0;
					count<=4'b0;
					SrcA<=0;
					SrcB<=0;
				end
			else if(We)
				begin
					if(HiLo)
						HI<=D1;
					else
						LO<=D1;
				end
			else if(Start==1'b1 && Busy==1'b0)
				begin
					SrcA<=D1;
					SrcB<=D2;				
					Busy<=1'b1;
					OpReg<=Op;
				end
			else if(Busy==1'b1)
				begin
					if(OpReg==2'b00)
						begin
							if(count==6'd10)
								begin
									{HI,LO}<=UnsignedMulTemp;						
									count<=4'b0;
									Busy<=1'b0;
								end
							else 
								count<=count+1;
						end
					else if(OpReg==2'b01)
						begin
							if(count==6'd10)
								begin
									{HI,LO}<=SignedMulTemp;						
									count<=4'b0;
									Busy<=1'b0;
								end
							else 
								count<=count+1;
						end						
					else if(OpReg==2'b10)
						begin
							if(count==6'd40)
								begin
									if(SrcB!=32'b0)
										begin
											HI<=UnsignedDivTempR;
											LO<=UnsignedDivTempQ;
										end									
									count<=4'b0;
									Busy<=1'b0;
								end
							else 
								count<=count+1;
						end
					else if(OpReg==2'b11)
						begin
							if(count==6'd40)
								begin
									if(SrcB!=32'b0)
										begin
											HI<=SignedDivTempR;
											LO<=SignedDivTempQ;
										end								
									count<=4'b0;
									Busy<=1'b0;
								end
							else 
								count<=count+1;
						end	
				end
		end

endmodule
