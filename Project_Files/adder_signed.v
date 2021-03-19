/* CO224 Lab - 06 Part 3*/
/* Author : Adikari A.M.I.N. */
/* Reg no. : E/16/012 */
/* module for new adder used for add target offset in J, BEQ instructions */

`timescale 1ns/100ps

module adder_signed(in_num1,in_num2,result);
input  [31:0]in_num1;  /* 32 bit input number */
input signed [31:0]in_num2;  /* 32 bit signed input number */
output signed [31:0] result;  /* 32 bit signed output */

/* Add the 2 inputs */
assign #2 result = in_num1 + in_num2;
endmodule