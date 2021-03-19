/* CO224 Lab - 06 Part 3*/
/* Author : Adikari A.M.I.N. */
/* Reg no. : E/16/012 */
/* module for Instruction Cache Memory */

`timescale 1ns/100ps

module ins_cache(read, ADDRESS, clock, busywait, READDATA, reset, mem_read, mem_readdata, mem_busywait, mem_address);

	input  clock, reset, read, mem_busywait;
	input [9:0] ADDRESS;
	output reg busywait;
	output reg [31:0] READDATA;
	output reg mem_read;
	input [127:0] mem_readdata;
	output reg [5:0] mem_address;

	//to split the address
	wire [2:0] Tag_Add;
	wire [2:0] Index;
	wire [1:0] Offset;
	
	//to extract stored values
	wire valid;
	wire [2:0] Tag_curr;
	wire [127:0] DATA_block;
	
	//cache
	reg [7:0] Valid_Bit;   
    reg [127:0] DATA [7:0]; //data blocks
	reg [2:0] TAG [7:0];
	
	/*
    Combinational part for indexing, tag comparison for hit deciding, etc.
    ...
    ...
    */

	//splitting address
	assign	Index = ADDRESS[6:4];
	assign	Tag_Add = ADDRESS[9:7];
	assign	Offset = ADDRESS[3:2];

	//extract stored values from cache
	assign #1 DATA_block = DATA[Index];	
	assign #1 valid = Valid_Bit[Index];
	assign #1 Tag_curr = TAG[Index];
	
	//tag comparison
	wire Tag_out;	
	assign #1 Tag_out = (Tag_Add == Tag_curr) ? 1:0;
	
	//decide hit
	wire hit;
	assign hit = valid && Tag_out;
	
	//reading asynchronously
	
	reg [31:0] Data_out;
	
	always @ (*)
	begin
	#1
		if(Offset == 2'b00)
		begin
			READDATA = DATA_block[31:0];
		end
		else if(Offset == 2'b01)
		begin
			READDATA = DATA_block[63:32];
		end
		else if(Offset == 2'b10)
		begin
			READDATA = DATA_block[95:64];
		end
		else if(Offset == 2'b11)
		begin
			READDATA = DATA_block[127:96];
		end
	end

	//for reset
	integer i;
	
	always @ (reset)
	begin
		if(reset)
		begin
			for(i=0;i<8;i=i+1)begin
				Valid_Bit[i] =  1'b0;
				TAG[i] = 3'd0;
				DATA[i] = 128'd0;
			end
			busywait = 1'b0;
		end
	end

	
	
	
	//deassert busywait at hit
	always @ (posedge clock)
	begin
		if(hit && read)
		begin
			busywait = 1'b0;
		end
	end
	
	//assert busywait at read 
	always @ (*)
	begin
		if(read)
		begin
			busywait = 1'b1;
		end
		else 
		begin
			busywait = 1'b0;
		end
	end
	

	
    

    /* Cache Controller FSM Start */
	
	//MEM_READ - Read from memory
	//CACHE - Update the cache

    parameter IDLE = 3'b000, MEM_READ = 3'b001, CACHE = 3'b010;
    reg [2:0] state, next_state;

    // combinational next state logic
    always @(*)
    begin
        case (state)
            IDLE:
                if (read && !hit)  
                    next_state = MEM_READ;
                else
                    next_state = IDLE;
            
            MEM_READ:
                if (!mem_busywait)
                    next_state = CACHE;
                else    
                    next_state = MEM_READ;
					
			CACHE:  next_state = IDLE;

            
        endcase
    end

    // combinational output logic
    always @(*)
    begin
        case(state)
            IDLE:
            begin
                mem_read = 0;
                mem_address = 6'dx;
                busywait = 0;
            end
         
            MEM_READ: 
            begin
                mem_read = 1;
                mem_address = {Tag_Add, Index}; /****/
                busywait = 1;
            end

			
			CACHE: 
            begin
				mem_read = 0;
                mem_address = 6'dx;
                busywait = 1;
				#1 TAG[Index] = Tag_Add;
				Valid_Bit[Index] = 1'b1;
				DATA[Index] = mem_readdata;				
            end
            
        endcase
    end

    // sequential logic for state transitioning 
    always @(posedge clock, reset)
    begin
        if(reset)
            state = IDLE;
        else
            state = next_state;
    end

    /* Cache Controller FSM End */
	
	
endmodule