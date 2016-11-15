`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:10:23 11/15/2015 
// Design Name: 
// Module Name:    dm_4k 
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
module dm_4k(
    input clk,
    input clk2,
    input [11:2] A,
    input [3:0] BE,
    input [31:0] WD,
    input We,
    output [31:0] RD
    );
	wire [3:0]BWe;

	assign BWe=BE&{4{We}};

	RAM_4K DM(.clka(clk),
			  .wea(BWe),
			  .addra(A),
			  .dina(WD),
			  .clkb(clk2),
			  .addrb(A),
			  .doutb(RD));

endmodule
