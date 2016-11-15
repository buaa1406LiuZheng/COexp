`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:08:59 11/15/2015 
// Design Name: 
// Module Name:    im_4k 
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
module im_6k(
	input clk,
    input [12:2] addr,
    output [31:0] dout
    );
	
	RAM_6K IM(.clka(clk),
			  .wea(1'b0),
			  .addra(addr),
			  .dina(32'b0),
			  .douta(dout));

endmodule