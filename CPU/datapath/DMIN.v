`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:52:31 11/25/2015 
// Design Name: 
// Module Name:    DMIN 
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
module DMIN(/*autoport*/
//output
			WDOut,
			DMWe,
			BE,
//input
			WDIn,
			Addr,
			MemWrite);
	input [31:0] WDIn;
	input [1:0] Addr;
	input [1:0] MemWrite;

	output [31:0] WDOut;
	output DMWe;
	output [3:0] BE;

	wire sw,sh,sb;

	assign sw=(MemWrite==2'b11);
	assign sh=(MemWrite==2'b01);
	assign sb=(MemWrite==2'b10);

	assign BE[3]=sw|(sh&Addr[1])|(sb&Addr[1]&Addr[0]);
	assign BE[2]=sw|(sh&Addr[1])|(sb&Addr[1]&~Addr[0]);
	assign BE[1]=sw|(sh&~Addr[1])|(sb&~Addr[1]&Addr[0]);
	assign BE[0]=sw|(sh&~Addr[1])|(sb&~Addr[1]&~Addr[0]);
	assign DMWe=sw|sh|sb;

	assign WDOut=(sw)?WDIn:
				 (sh)?(Addr[1]?{WDIn[15:0],16'b0}:{16'b0,WDIn[15:0]}):
				 (sb)?((Addr==2'b00)?{24'b0,WDIn[7:0]}:
				 	   (Addr==2'b01)?{16'b0,WDIn[7:0],8'b0}:
				 	   (Addr==2'b10)?{8'b0,WDIn[7:0],16'b0}:
				 	   {Addr==2'b11}?{WDIn[7:0],24'b0}:
				 	   32'b0):
				 32'b0;
endmodule
