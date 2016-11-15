`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:39:56 11/15/2015 
// Design Name: 
// Module Name:    PC 
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
module PC(
    input clk,
    input rst,
    input en,
    input [31:0] nextPC,
    output reg [31:0] currentPC
    );
	
	always@(posedge clk)
		begin
			if(rst)
				currentPC<=32'h0000_3000;
			else if(en)
				currentPC<=nextPC;
		end
		
endmodule
