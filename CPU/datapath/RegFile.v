`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:24:34 11/15/2015 
// Design Name: 
// Module Name:    RegFile 
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
module RegFile(
    input Clk,
    input Rst,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
    input We,
    output [31:0] RD1,
    output [31:0] RD2
    );
	reg [31:0] GPR[1:31];
	integer i;
	
	always@(posedge Clk or posedge Rst)
		begin
			if(Rst)
				for(i=1;i<32;i=i+1)
					GPR[i]<=32'b0;
			else if(We&&A3!=5'b0)
				begin
					//$display("$%d <= %x", A3, WD);				
					GPR[A3]<=WD;
				end
		end
	
	assign RD1=(A1==5'b0)?32'b0:
			   (We===1&&A1===A3)?WD:GPR[A1];
	assign RD2=(A2==5'b0)?32'b0:
			   (We===1&&A2===A3)?WD:GPR[A2];
	
endmodule
