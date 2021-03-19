/* CO224 Lab - 06 Part 3*/
/* Author : Adikari A.M.I.N. */
/* Reg no. : E/16/012 */
/* module for Control Unit - Decode */

`timescale 1ns/100ps

module control_unit(INSTRUCTION,OPCODE,SOURCE1,SOURCE2,DESTINATION,READREG2,READREG1,WRITEREG,IMMEDIATE,ALUOP,WRITEENABLE,LOADI_signal,SUB_signal,J_signal,BEQ_signal,READ,WRITE,insADD,insMemADD,insREAD);

input [31:0] INSTRUCTION;   /* 32 bit Instruction */
/* INSTRUCTION : [OPCODE - 8 bit][DESTINATION - 8 bit][SOURCE1 - 8 bit][SOURCE2 - 8 bit]*/
output reg [7:0] OPCODE,SOURCE1,SOURCE2,IMMEDIATE;  /* IMMEDIATE - 8 bit Immediate value used for loadi instruction */
output reg signed [7:0] DESTINATION;
/* 3 bit address ports - READREG1, READREG2, WRITEREG */
/* ALUOP - 3 bit control signal for ALU */
output reg [2:0] READREG2,READREG1,WRITEREG,ALUOP;
/* Control signals */
/* LOADI_signal - Select signal for mux to forward Immediate value in loadi instruction */
/* SUB_signal - Select signal for mux to forward 2s complement value in sub instruction */
output reg WRITEENABLE,LOADI_signal,SUB_signal,J_signal,BEQ_signal,READ,WRITE; /* Control signals */

/* 10 bit value extracted from PC */
input [9:0] insADD;
/* Read signal to read instructions */
output reg insREAD; 
/* Output 10 bit address to use in instruction cache */
output reg [9:0] insMemADD; 

always @ (insADD)
begin
	insMemADD = insADD;
	insREAD = 1'b1;
end


/* OPCODE for Instructions */
/* loadi - 00000000 */
/* mov   - 00000001 */
/* add   - 00000100 */
/* sub   - 00000101 */
/* and   - 00000010 */
/* or    - 00000011 */
/* j     - 00000110 */
/* beq   - 00000111 */
/* lwi   - 00001000 */
/* lwd   - 00001001 */
/* swi   - 00001010 */
/* swd   - 00001011 */

/* Start decoding the given Instruction whenever a new Instruction is given */

always @ (INSTRUCTION)
	begin
	
		OPCODE = INSTRUCTION[31:24];
		DESTINATION = INSTRUCTION[23:16];
		SOURCE1 = INSTRUCTION[15:8];
		SOURCE2 = INSTRUCTION[7:0];
		READREG1 = INSTRUCTION[10:8]; 
		READREG2 = INSTRUCTION[2:0];  
		WRITEREG = INSTRUCTION[18:16]; 
		IMMEDIATE = INSTRUCTION[7:0];
		READ = 1'b0;
		WRITE = 1'b0;

		#1 /* Delay for decode */
		/* Check if the given Instruction is loadi */
		if(OPCODE == 8'd0)
			begin 
				WRITEENABLE = 1'b1;
				LOADI_signal = 1'b1;
				ALUOP = 3'd0;       /* Set ALUOP for 000 */
				SUB_signal = 1'b0;
				J_signal = 1'b0;
				BEQ_signal = 1'b0;
				
			end
		/* Check if the given Instruction is mov */
		else if(OPCODE == 8'd1)
			begin 
				WRITEENABLE = 1'b1;
				ALUOP = 3'd0;      /* Set ALUOP for 000 */
				LOADI_signal = 1'b0;
				SUB_signal = 1'b0;
				J_signal = 1'b0;
				BEQ_signal = 1'b0;
			
			end
		/* Check if the given Instruction is and */
		else if(OPCODE == 8'd2)
			begin
				WRITEENABLE = 1'b1;			
				ALUOP = 3'd2;  		/* Set ALUOP for 010 */
				LOADI_signal = 1'b0;
				SUB_signal = 1'b0;
				J_signal = 1'b0;
				BEQ_signal = 1'b0;
				
			end
		/* Check if the given Instruction is or */
		else if(OPCODE == 8'd3)
			begin
				WRITEENABLE = 1'b1;				
				ALUOP = 3'd3;     /* Set ALUOP for 011 */
				LOADI_signal = 1'b0;
				SUB_signal = 1'b0;
				J_signal = 1'b0;
				BEQ_signal = 1'b0;
			
			end
		/* Check if the given Instruction is add */
		else if(OPCODE == 8'd4)
			begin
				WRITEENABLE = 1'b1;
				ALUOP = 3'd1;     /* Set ALUOP for 001 */
				LOADI_signal = 1'b0;
				SUB_signal = 1'b0;
				J_signal = 1'b0;
				BEQ_signal = 1'b0;
			
			end
		/* Check if the given Instruction is sub */
		else if(OPCODE == 8'd5)
			begin
				J_signal = 1'b0;
				WRITEENABLE = 1'b1;
				SUB_signal = 1'b1;
				ALUOP = 3'd1;    /* Set ALUOP for 001 */
				LOADI_signal = 1'b0;
				BEQ_signal = 1'b0;
				
		
			end
		/* Check if the given Instruction is j */
		else if(OPCODE == 8'd6)
			begin
			    J_signal = 1'b1;
				WRITEENABLE = 1'b0;
				SUB_signal = 1'b0;
				ALUOP = 3'bxxx;    
				LOADI_signal = 1'b0;
				BEQ_signal = 1'b0;
				
		
			end
		/* Check if the given Instruction is beq */
		else if(OPCODE == 8'd7)
			begin
				WRITEENABLE = 1'b0;
				ALUOP = 3'd1;     /* Set ALUOP for 001 */
				LOADI_signal = 1'b0;
				SUB_signal = 1'b1;
				J_signal = 1'b0;
				BEQ_signal = 1'b1;
			
		
			end
		/* Check if the given Instruction is lwi */
		else if(OPCODE == 8'd8)
			begin
				WRITEENABLE = 1'b1;
				ALUOP = 3'd0;     /* Set ALUOP for 000 */
				LOADI_signal = 1'b1;
				SUB_signal = 1'b0;
				J_signal = 1'b0;
				BEQ_signal = 1'b0;
				READ = 1'b1;
		
			end
		/* Check if the given Instruction is lwd */
		else if(OPCODE == 8'd9)
			begin
				WRITEENABLE = 1'b1;
				ALUOP = 3'd0;      /* Set ALUOP for 000 */
				LOADI_signal = 1'b0;
				SUB_signal = 1'b0;
				J_signal = 1'b0;
				BEQ_signal = 1'b0;
				READ = 1'b1;
		
			end
		/* Check if the given Instruction is swi */
		else if(OPCODE == 8'd10)
			begin
				WRITEENABLE = 1'b0;
				ALUOP = 3'd0;     /* Set ALUOP for 000 */
				LOADI_signal = 1'b1;
				SUB_signal = 1'b0;
				J_signal = 1'b0;
				BEQ_signal = 1'b0;
				WRITE = 1'b1;
		
			end
		/* Check if the given Instruction is swd */
		else if(OPCODE == 8'd11)
			begin
				WRITEENABLE = 1'b0;
				ALUOP = 3'd0;     /* Set ALUOP for 000 */
				LOADI_signal = 1'b0;
				SUB_signal = 1'b0;
				J_signal = 1'b0;
				BEQ_signal = 1'b0;
				WRITE = 1'b1;
		
			end
		/* Executes if there are no more instructions or if invalid instruction */
		else
			begin
				ALUOP = 3'bxxx; 
				WRITEENABLE = 1'b0;
				LOADI_signal = 1'b0;
				SUB_signal = 1'b0;
				J_signal = 1'b0;
				BEQ_signal = 1'b0;
				
			end

	end

endmodule