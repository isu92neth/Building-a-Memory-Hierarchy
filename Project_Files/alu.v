/* CO224 Lab - 06 Part 3*/
/* Author : Adikari A.M.I.N. */
/* Reg no. : E/16/012 */
/* module for 8 - bit ALU */

`timescale 1ns/100ps

module alu(DATA1, DATA2, RESULT, SELECT, ZERO);
	input [7:0] DATA1, DATA2;     /* 8 - bit input ports */
	input [2:0] SELECT;           /* 3 - bit control input port */ 
	output [7:0] RESULT;          /* 8 - bit output port */
	output ZERO;
	wire [7:0] FRESULT,ADDRESULT,ANDRESULT,ORRESULT;

	/* RESULT port stores values */
	reg [7:0] RESULT;  
	/* ZERO: Output 1 if RESULT is 0 */
	wire ZERO;
	/* Get output ZERO */
	nor u3(ZERO,RESULT[0],RESULT[1],RESULT[2],RESULT[3],RESULT[4],RESULT[5],RESULT[6],RESULT[7]);
	/* always block will be executed whenever the values of signals at DATA1 or DATA2 or SELECT change */

	/* FORWARD function for loadi, mov instructions */	
	/* Forwards value from DATA2 into RESULT */
	assign	 #1 FRESULT = DATA2;
	
	/* ADD function for add, sub instructions */
	/* Add values in DATA1 and DATA2 */
	assign   #2	ADDRESULT = DATA1 + DATA2;
	
	/* AND function */
	/* Does bitwise AND on values in DATA1 with DATA2 for and instruction */
	assign	 #1 ANDRESULT = DATA1 & DATA2;
	
	/* OR function */
	/* Does bitwise OR on values in DATA1 with DATA2 for Or instruction */
	assign	 #1 ORRESULT = DATA1 | DATA2;


	/* Forward the corresponding results for the se;ect operations */
	always @ (*) 
		begin
			case(SELECT)
				
				3'b000:RESULT = FRESULT; 				
				
				3'b001:RESULT = ADDRESULT;				          				
				
				3'b010:RESULT = ANDRESULT;				
				
				3'b011:RESULT = ORRESULT;
				/* Any other combinations */
				default:RESULT = 8'bxxxxxxxx;					
			endcase

		end

	
endmodule