`timescale 1ns / 1ps
`define CPUClk 50000000 //50MHZ
`define SEL_COUNT `CPUClk/40
`define COUNT_LENTH 21
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:16:14 12/23/2015 
// Design Name: 
// Module Name:    SevenSeg 
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
module SevenSeg(/*autoport*/
//output
			Dout,
			seg4x7_1_a,
			seg4x7_1_b,
			seg4x7_1_c,
			seg4x7_1_d,
			seg4x7_1_e,
			seg4x7_1_f,
			seg4x7_1_g,
			seg4x7_1_dp,
			seg4x7_1_sel,
			seg4x7_2_a,
			seg4x7_2_b,
			seg4x7_2_c,
			seg4x7_2_d,
			seg4x7_2_e,
			seg4x7_2_f,
			seg4x7_2_g,
			seg4x7_2_dp,
			seg4x7_2_sel,
//input
			clk,
			rst,
			We,
			Din);
	input clk;
	input rst;
	input We;
	input [31:0] Din;
	output [31:0] Dout;

	output seg4x7_1_a;
	output seg4x7_1_b;
	output seg4x7_1_c;
	output seg4x7_1_d;
	output seg4x7_1_e;
	output seg4x7_1_f;
	output seg4x7_1_g;
	output seg4x7_1_dp;
	output reg [4:1] seg4x7_1_sel;

	output seg4x7_2_a;
	output seg4x7_2_b;
	output seg4x7_2_c;
	output seg4x7_2_d;
	output seg4x7_2_e;
	output seg4x7_2_f;
	output seg4x7_2_g;
	output seg4x7_2_dp;
	output reg [4:1] seg4x7_2_sel;


	reg A1,B1,C1,D1,E1,F1,G1;
	reg A2,B2,C2,D2,E2,F2,G2;
	reg [3:0] Seg1Num,Seg2Num;
	reg [31:0] NUM;
	reg [`COUNT_LENTH:1] Count;

	always @(posedge clk) begin
		if (rst) begin
			NUM<=32'h23333333;			
		end
		else if (We) begin
			NUM<=Din;
		end
	end

	always @(posedge clk) begin
		if (rst) begin
			seg4x7_1_sel<=4'b1000;
			seg4x7_2_sel<=4'b1000;
			Seg1Num<=4'b0;
			Seg2Num<=4'b0;
			Count<=`SEL_COUNT;
		end
		else begin
			if(Count==`COUNT_LENTH'b0) begin
				Count<=`SEL_COUNT;
				case(seg4x7_1_sel)
					4'b0001:begin seg4x7_1_sel<=4'b0010;Seg1Num<=NUM[11:8];end
					4'b0010:begin seg4x7_1_sel<=4'b0100;Seg1Num<=NUM[7:4];end
					4'b0100:begin seg4x7_1_sel<=4'b1000;Seg1Num<=NUM[3:0];end
					4'b1000:begin seg4x7_1_sel<=4'b0001;Seg1Num<=NUM[15:12];end
					default:begin seg4x7_1_sel<=4'b0001;Seg1Num<=NUM[15:12];end
				endcase
				case(seg4x7_2_sel)
					4'b0001:begin seg4x7_2_sel<=4'b0010;Seg2Num<=NUM[27:24];end
					4'b0010:begin seg4x7_2_sel<=4'b0100;Seg2Num<=NUM[23:20];end
					4'b0100:begin seg4x7_2_sel<=4'b1000;Seg2Num<=NUM[19:16];end
					4'b1000:begin seg4x7_2_sel<=4'b0001;Seg2Num<=NUM[31:28];end
					default:begin seg4x7_2_sel<=4'b0001;Seg2Num<=NUM[31:28];end
				endcase
			end
			else begin
				Count<=Count-1;
			end
		end
	end

	always @(Seg1Num) begin
		case(Seg1Num)
			4'h0:{A1,B1,C1,D1,E1,F1,G1}=7'b0000001;
			4'h1:{A1,B1,C1,D1,E1,F1,G1}=7'b1001111;
			4'h2:{A1,B1,C1,D1,E1,F1,G1}=7'b0010010;
			4'h3:{A1,B1,C1,D1,E1,F1,G1}=7'b0000110;
			4'h4:{A1,B1,C1,D1,E1,F1,G1}=7'b1001100;
			4'h5:{A1,B1,C1,D1,E1,F1,G1}=7'b0100100;
			4'h6:{A1,B1,C1,D1,E1,F1,G1}=7'b0100000;
			4'h7:{A1,B1,C1,D1,E1,F1,G1}=7'b0001111;
			4'h8:{A1,B1,C1,D1,E1,F1,G1}=7'b0000000;
			4'h9:{A1,B1,C1,D1,E1,F1,G1}=7'b0000100;
			4'ha:{A1,B1,C1,D1,E1,F1,G1}=7'b0001000;
			4'hb:{A1,B1,C1,D1,E1,F1,G1}=7'b1100000;
			4'hc:{A1,B1,C1,D1,E1,F1,G1}=7'b0110001;
			4'hd:{A1,B1,C1,D1,E1,F1,G1}=7'b1000010;
			4'he:{A1,B1,C1,D1,E1,F1,G1}=7'b0110000;
			4'hf:{A1,B1,C1,D1,E1,F1,G1}=7'b0111000;
			default:{A1,B1,C1,D1,E1,F1,G1}=7'b1111111;
		endcase
	end

	always @(Seg2Num) begin
		case(Seg2Num)
			4'h0:{A2,B2,C2,D2,E2,F2,G2}=7'b0000001;
			4'h1:{A2,B2,C2,D2,E2,F2,G2}=7'b1001111;
			4'h2:{A2,B2,C2,D2,E2,F2,G2}=7'b0010010;
			4'h3:{A2,B2,C2,D2,E2,F2,G2}=7'b0000110;
			4'h4:{A2,B2,C2,D2,E2,F2,G2}=7'b1001100;
			4'h5:{A2,B2,C2,D2,E2,F2,G2}=7'b0100100;
			4'h6:{A2,B2,C2,D2,E2,F2,G2}=7'b0100000;
			4'h7:{A2,B2,C2,D2,E2,F2,G2}=7'b0001111;
			4'h8:{A2,B2,C2,D2,E2,F2,G2}=7'b0000000;
			4'h9:{A2,B2,C2,D2,E2,F2,G2}=7'b0000100;
			4'ha:{A2,B2,C2,D2,E2,F2,G2}=7'b0001000;
			4'hb:{A2,B2,C2,D2,E2,F2,G2}=7'b1100000;
			4'hc:{A2,B2,C2,D2,E2,F2,G2}=7'b0110001;
			4'hd:{A2,B2,C2,D2,E2,F2,G2}=7'b1000010;
			4'he:{A2,B2,C2,D2,E2,F2,G2}=7'b0110000;
			4'hf:{A2,B2,C2,D2,E2,F2,G2}=7'b0111000;
			default:{A2,B2,C2,D2,E2,F2,G2}=7'b1111111;
		endcase
	end

	assign {seg4x7_1_a,seg4x7_1_b,seg4x7_1_c,seg4x7_1_d,seg4x7_1_e,seg4x7_1_f,seg4x7_1_g,seg4x7_1_dp} = {A1,B1,C1,D1,E1,F1,G1,1'b1};
	assign {seg4x7_2_a,seg4x7_2_b,seg4x7_2_c,seg4x7_2_d,seg4x7_2_e,seg4x7_2_f,seg4x7_2_g,seg4x7_2_dp} = {A2,B2,C2,D2,E2,F2,G2,1'b1};
	assign Dout = NUM;

endmodule
