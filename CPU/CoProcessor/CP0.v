`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:35:28 12/08/2015 
// Design Name: 
// Module Name:    CP0 
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
module CP0(/*autoport*/
//output
			IntReq,
			Dout,
			EPC,
//input
			clk,
			rst,
			Addr,
			We,
			Din,
			PC,
			HWInt,
			EXLClr);
	input clk;
	input rst;
	input [4:0] Addr;
	input We;
	input [31:0] Din;
	input [31:0] PC;
	input [15:10] HWInt;
	input EXLClr;

	output IntReq;
	output [31:0] Dout;
	output reg [31:0] EPC;

	reg [15:10] IP;
	reg [15:10] IM;
	reg EXL,IE;
	wire [31:0] SR,Cause,PRId;

	assign IntReq=(|(HWInt&IM))&~EXL&IE;
//SR
	always @(posedge clk) begin
		if (rst) begin
			IM<=6'b111111;
			EXL<=1'b0;
			IE<=1'b1;	
		end
		else if (IntReq) begin
			EXL<=1'b1;
		end
		else if (EXLClr) begin
			EXL<=1'b0;
		end
		else if(We&&(Addr==5'd12)) begin
			IM<=Din[15:10];
			EXL<=Din[1];
			IE<=Din[0];
		end 
	end

	assign SR={16'b0,IM,8'b0,EXL,IE};
//Cause
	always @(posedge clk) begin
		if (rst) begin
			IP<=6'b0;			
		end
		else if (IntReq) begin
			IP<=HWInt;
		end		
	end

	assign Cause={16'b0,IP,10'b0};
//EPC
	always @(posedge clk) begin
		if (rst) begin
			EPC<=32'b0;			
		end
		else if (IntReq) begin
			EPC<=PC;
		end
		else if(We&&(Addr==5'd14)) begin
			EPC<=Din;
		end
	end
//PRId
	assign PRId = 32'h14061139;

	assign Dout = (Addr==5'd12)?SR:
				  (Addr==5'd13)?Cause:
				  (Addr==5'd14)?EPC:
				  (Addr==5'd15)?PRId:
				  32'b0;
endmodule
