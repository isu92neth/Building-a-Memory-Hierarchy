/* CO224 Lab - 06 Part 3*/
/* Author : Adikari A.M.I.N. */
/* Reg no. : E/16/012 */
/* module for testbench for CPU*/
`timescale 1ns/100ps

`include "cpu.v"
`include "dcache.v"
`include "data_memory.v"
`include "ins_cache.v"
`include "ins_memory.v"

module cpu_tb;

    reg CLK, RESET;
    wire [31:0] PC;
    wire  [31:0] INSTRUCTION;
	wire [7:0] ALURESULT;
	wire READ,WRITE,BUSYWAIT, mem_busywait;
	wire [7:0] READDATA,WRITEDATA;
	wire mem_read, mem_write, ins_mem_read, ins_mem_busywait;
	wire [31:0] mem_writedata;
	wire [31:0] mem_readdata;
	wire [127:0] ins_mem_readdata;
	wire [5:0] mem_address, ins_mem_address;
	wire  insREAD;
	wire  [9:0] insMemADD;
	wire insWAIT;
    

	
	/* Instantiating cpu module to get the pc value */
    cpu mycpu(PC, INSTRUCTION, CLK, RESET,ALURESULT,READ,WRITE,WRITEDATA,BUSYWAIT,READDATA,insMemADD,insREAD,insWAIT);
	
	/* Instantiating data cache module */
	dcache myData_cache(READ, WRITE, WRITEDATA, ALURESULT, CLK, BUSYWAIT, READDATA, RESET, mem_read, mem_write, mem_busywait, mem_readdata, mem_writedata, mem_address);
	
	/* Instantiating data_memory module to read and write data to the data memory */
	data_memory mem(CLK, RESET, mem_read, mem_write, mem_address, mem_writedata, mem_readdata, mem_busywait);
	
	/* Instantiating instruction cache module */
	ins_cache myIns_cache(insREAD, insMemADD, CLK, insWAIT, INSTRUCTION, RESET, ins_mem_read, ins_mem_readdata, ins_mem_busywait, ins_mem_address);
	
	/* Instantiating instruction memory module */
	ins_memory ins_mem(CLK, ins_mem_read, ins_mem_address, ins_mem_readdata, ins_mem_busywait);
	
	

    initial
    begin
    
        /* Generate files needed to plot the waveform using GTKWave */
        $dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, cpu_tb);
        
        CLK = 1'b0;
        RESET = 1'b0;
        
		#3
		/* Resetting the CPU to start the program execution */
		RESET = 1'b1;
        
        #5
		RESET = 1'b0;
		
        /* Finishing simulation after some time */
        #7000
        $finish;
        
    end
    
    /* Clock signal generation */
    always
        #4 CLK = ~CLK;
        

endmodule