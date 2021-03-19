/* CO224 Lab - 06 Part 3*/
/* Author : Adikari A.M.I.N. */
/* Reg no. : E/16/012 */
/* module for extend and shift left a binary sequence */

`timescale 1ns/100ps

module left_shift(IN_ADDRESS, SHIFTED_ADDRESS);
input signed [7:0] IN_ADDRESS; /* 8 bit input */
wire [31:0] EXTENDED_ADD;   /* 32 bit extended binary sequence */
output signed [31:0] SHIFTED_ADDRESS;  /* 32 bit shifted binary sequence */

/* Extend 8 bit binary to 32 bit */
assign 	EXTENDED_ADD = IN_ADDRESS;

/* Shift left by 2 */
assign SHIFTED_ADDRESS = EXTENDED_ADD << 2;

endmodule