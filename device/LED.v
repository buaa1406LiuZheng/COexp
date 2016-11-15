`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:09:04 12/23/2015 
// Design Name: 
// Module Name:    LED 
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
module LED(/*autoport*/
//output
			user_led,
//input
			clk,
			rst,
			Din,
			We);
	input clk;
	input rst;
	input [15:0] Din;
	input We;
	output reg [15:0] user_led;

	always @(posedge clk) begin
		if (rst) begin
			user_led<=16'h55aa;
		end
		else if(We) begin
			user_led<=Din;
		end
	end

endmodule
