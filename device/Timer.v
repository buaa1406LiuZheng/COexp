`timescale 1ns / 1ps
`define IDLE 2'b00
`define LOAD 2'b01
`define CNTING 2'b10
`define INT 2'b11

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:48:12 12/08/2015 
// Design Name: 
// Module Name:    Timer 
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
module Timer(/*autoport*/
//output
			Dout,
			IntReq,
//input
			clk,
			rst,
			addr,
			We,
			Din);
	input clk;
	input rst;
	input [3:2] addr;
	input We;
	input [31:0] Din;
	output [31:0] Dout;
	output IntReq;

	wire [31:0] CTRL;
	reg [31:0] PRESET;
	reg [31:0] COUNT;
	reg [1:0] STATE;

	reg IM;
	reg [1:0] Mode;
	reg Enable;

	always @(posedge clk) begin
		if (rst) begin
			IM<=1'b0;
			Mode<=2'b0;
			Enable<=2'b0;			
		end
		else if (We && addr==2'b00) begin
			{IM,Mode,Enable}<=Din[3:0];
		end
	end
	assign CTRL={28'b0,IM,Mode,Enable};

	always @(posedge clk) begin
		if (rst) begin
			PRESET<=32'b0;
		end
		else if (We && addr==2'b01) begin
			PRESET<=Din;
		end
	end

	always @(posedge clk) begin
		if (rst) begin
			STATE<=`IDLE;
			COUNT<=32'b0;
		end
		else if(Mode==2'b00) begin
			case(STATE)
			`IDLE: 	begin
						if(We && addr==2'b01)
							STATE<=`LOAD;
					end
			`LOAD: 	begin
						if(Enable) begin
							COUNT<=PRESET;
							STATE<=`CNTING;
						end
					//else begin
					//	STATE<=`IDLE;
					//end
					end
			`CNTING: begin
						if(Enable) begin
							COUNT<=COUNT-1;
							if(COUNT==32'b1)
								STATE<=`INT;
						end
						else begin
							STATE<=`IDLE;
						end
					end
			`INT: 	begin
					if(!Enable)
						STATE<=`IDLE;
					end
			endcase
		end
		else if(Mode==2'b01) begin
			if(COUNT>32'b0) begin
				COUNT<=COUNT-1;
			end
			else begin
				COUNT<=PRESET;
			end
		end
	end

	//COUNT
	/*always @(posedge clk or posedge rst) begin
		if (rst) begin
			COUNT<=32'b0;			
		end
		//else if(We && addr==2'b00&&Din[3]==0) begin
		//	COUNT<=32'b0;
		//end
		//Mode 1
		else if (Mode==2'b01 && Enable) begin
			if (COUNT>32'b0) begin
				COUNT<=COUNT-1;
			end
			else begin
				COUNT<=PRESET;
			end
		end
		//Mode 0
		else if (Mode==2'b00) begin
			if(~Enable) begin
				if(We && addr==2'b01)
					COUNT<=Din;	
			end
			else if (COUNT>32'b0) begin
				COUNT<=COUNT-1;
			end
		end
	end*/

	assign Dout = (addr==2'b00)?CTRL:
				   (addr==2'b01)?PRESET:
				   (addr==2'b10)?COUNT:
				   32'b0;
	assign IntReq = IM & (STATE==`INT);
	//assign IntReq = IM & (COUNT==32'b0);

endmodule
