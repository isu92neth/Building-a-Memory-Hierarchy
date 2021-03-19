/* CO224 Lab - 06 Part 3*/
/* Author : Adikari A.M.I.N. */
/* Reg no. : E/16/012 */
/* module for dedicated adder for PC */

`timescale 1ns/100ps

module adder(IN_NUM1, IN_NUM2, RESULT,current_pc,next_pc,CLK,BEQ_signal,J_signal,IMMEDIATE,BUSYWAIT,RESET);

input signed [7:0] IMMEDIATE;
input BUSYWAIT,BEQ_signal,J_signal,CLK,RESET;
input [31:0] IN_NUM1, IN_NUM2,current_pc,next_pc; /* 32 bit input numbers */
output reg [31:0] RESULT;  /* 32 bit result of addition */

always @ (current_pc,next_pc,posedge CLK,BEQ_signal,J_signal,IMMEDIATE,BUSYWAIT,RESET)
begin
	if ((!RESET)&&(!BUSYWAIT))
	begin
		#1 RESULT = IN_NUM1 + IN_NUM2;
	end
	
end

//assign #1 RESULT = IN_NUM1 + IN_NUM2;  /* Get the addition of the two numbers */
endmodule