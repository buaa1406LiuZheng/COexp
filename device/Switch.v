`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:01:09 12/23/2015 
// Design Name: 
// Module Name:    Switch 
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
module Switch(/*autoport*/
//output
			Dout,
//input
			clk,
			user0_dipsw,
			user1_dipsw,
			user2_dipsw,
			user3_dipsw);
	input clk;
	input [7:0] user0_dipsw,user1_dipsw,user2_dipsw,user3_dipsw;
	output reg [31:0] Dout;

	always @(posedge clk) begin
		Dout<={user3_dipsw,user2_dipsw,user1_dipsw,user0_dipsw};
	end

endmodule
