/* CO224 Lab - 06 Part 3*/
/* Author : Adikari A.M.I.N. */
/* Reg no. : E/16/012 */
/* module for 2x1 Multiplexer */

`timescale 1ns/100ps

module mux_2x1(IN0, IN1, SEL, OUT);

input [7:0] IN0,IN1; /* 8 bit input ports */
input SEL;          /* 1 bit select port */
output reg [7:0] OUT;  /* 8 bit output port */

/* Executes in change of inputs or selection signals */
always @ (IN0, IN1, SEL)
	begin
		if(SEL == 1'b0)begin
			OUT = IN0;     /* Forward value in IN0 port */
		end else if(SEL == 1'b1) begin
			OUT = IN1;     /* Forward value in IN1 port */
		end
	end

endmodule