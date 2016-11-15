`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:35:23 11/22/2015 
// Design Name: 
// Module Name:    HazardUnit 
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
module HazardUnit(/*autoport*/
//output
			Forward_rs_D,
			Forward_rs_E,
			Forward_rt_D,
			Forward_rt_E,
			Forward_rt_M,
			stall_D,
			stall_E,
//input
			RegWrite_E,
			RegWrite_M,
			RegWrite_W,
			RegWriteSrcE_E,
			RegWriteSrcM_E,
			RegWriteSrcM_M,
			RFA3_E,
			RFA3_M,
			RFA3_W,
			rs_D,
			rs_E,
			rt_D,
			rt_E,
			rt_M,
			rsUseInID_D,
			rsUseInEXE_D,
			rsUseInEXE_E,
			rtUseInID_D,
			rtUseInEXE_D,
			rtUseInEXE_E,
			MnDStart_E,
			MnDBusy_E,
			MnDWe_D,
			MnDMove_D,
			MnDStart_D);

	input RegWrite_E,RegWrite_M,RegWrite_W;
	input [1:0] RegWriteSrcE_E,RegWriteSrcM_M,RegWriteSrcM_E;
	input [4:0] RFA3_E,RFA3_M,RFA3_W;
	input [4:0] rs_D,rs_E;
	input [4:0] rt_D,rt_E,rt_M;
	input rsUseInID_D,rsUseInEXE_D,rsUseInEXE_E;
	input rtUseInID_D,rtUseInEXE_D,rtUseInEXE_E;
	input MnDStart_E,MnDBusy_E;
	input MnDWe_D,MnDMove_D,MnDStart_D;

	output reg [1:0] Forward_rs_D,Forward_rs_E;
	output reg [1:0] Forward_rt_D,Forward_rt_E;
	output reg Forward_rt_M;
	output reg stall_D,stall_E;

	always@(*)
		begin
		/* forward in RD1 in ID stage*/
			if(RegWrite_E&&rs_D==RFA3_E&&RFA3_E!=5'b0&&RegWriteSrcE_E==2'b11)			//If there is hazard with RD1 in ID Stage and RD1' to be writen in EXE Stage
				Forward_rs_D=2'b01;										
			else if(RegWrite_M&&rs_D==RFA3_M&&RFA3_M!=5'b0&&RegWriteSrcM_M==2'b11) 		//If there is hazard with RD1 in ID Stage and RD1'' to be writen in MEM Stage
				Forward_rs_D=2'b10;										
			else
				Forward_rs_D=2'b00; 							//No hazard, no forward

		/* forward in RD2 in ID stage*/  						//The same as above
			if(RegWrite_E&&rt_D==RFA3_E&&RFA3_E!=5'b0&&RegWriteSrcE_E==2'b11)
				Forward_rt_D=2'b01;
			else if(RegWrite_M&&rt_D==RFA3_M&&RFA3_M!=5'b0&&RegWriteSrcM_M==2'b11)
				Forward_rt_D=2'b10;
			else
				Forward_rt_D=2'b00;

		/* forward in RD1 in EXE stage*/
			if(RegWrite_M&&rs_E==RFA3_M&&RFA3_M!=5'b0&&RegWriteSrcM_M==2'b11) 			//If there is hazard with RD1 in EXE Stage and RD1' to be writen in MEM Stage
				Forward_rs_E=2'b01; 											//already known no hazard with RD1 in EXE Stage and MEM Stage
			else if(RegWrite_W&&rs_E==RFA3_W&&RFA3_W!=5'b0)										//No result will be generated in WB Stage, so we can directly forward
				Forward_rs_E=2'b10;											//already known no hazard with RD1 in EXE Stage and WB Stage
			else
				Forward_rs_E=2'b00; 							//No hazard, no forward

		/* forward in RD2 in EXE stage*/ 						//The same as above
			if(RegWrite_M&&rt_E==RFA3_M&&RFA3_M!=5'b0)
				Forward_rt_E=2'b01;
			else if(RegWrite_W&&rt_E==RFA3_W&&RFA3_W!=5'b0)
				Forward_rt_E=2'b10;
			else
				Forward_rt_E=2'b00;
			
		/* forward in RD2 in MEM stage*/
			if(RegWrite_W&&rt_M==RFA3_W&&RFA3_W!=5'b0) 			//If there is hazard with RD2 in MEM Stage and RD2' to be writen in WB Stage
				Forward_rt_M=1; 								//No result will be generated in WB Stage, so we can directly forward RD1' in WB Stage to MEM Stage
			else
				Forward_rt_M=0;


		/*stall_D*/
			if(RegWrite_E&&rs_D==RFA3_E&&RFA3_E!=5'b0&&RegWriteSrcE_E!=2'b11&&rsUseInID_D)
				stall_D=1;
			else if(RegWrite_M&&rs_D==RFA3_M&&RFA3_M!=5'b0&&RegWriteSrcM_M!=2'b11&&rsUseInID_D)
				stall_D=1;
			else if(RegWrite_E&&rt_D==RFA3_E&&RFA3_E!=5'b0&&RegWriteSrcE_E!=2'b11&&rtUseInID_D)
				stall_D=1;
			else if(RegWrite_M&&rt_D==RFA3_M&&RFA3_M!=5'b0&&RegWriteSrcM_M!=2'b11&&rtUseInID_D)
				stall_D=1;
			else if((MnDStart_E||MnDBusy_E)&&(MnDWe_D||MnDMove_D||MnDStart_D))		// stall for MUL and DIV
				stall_D=1;
			else if(RegWrite_E && RegWriteSrcM_E!=2'b11 &&
			   ((rsUseInEXE_D && RFA3_E==rs_D && rs_D!=5'b0)||
			   	(rtUseInEXE_D && RFA3_E==rt_D && rt_D!=5'b0)))
				stall_D=1;
			else
				stall_D=0;
		/*stall_E*/
			if(RegWrite_M&&rs_E==RFA3_M&&RFA3_M!=5'b0&&RegWriteSrcM_M!=2'b11&&rsUseInEXE_E)
				stall_E=1;
			else if(RegWrite_M&&rt_E==RFA3_M&&RFA3_M!=5'b0&&RegWriteSrcM_M!=2'b11&&rtUseInEXE_E)
				stall_E=1;
			else
				stall_E=0;
		end

endmodule