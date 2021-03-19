/* CO224 Lab - 06 Part 2*/
/* Author : Adikari A.M.I.N. */
/* Reg no. : E/16/012 */
/* module for Cache Memory */

`timescale 1ns/100ps



module dcache (read, write, WRITEDATA, ADDRESS, clock, busywait, READDATA, reset, mem_read, mem_write, mem_busywait, mem_readdata, mem_writedata, mem_address);
    
	input read, write, clock, reset, mem_busywait;
	input [7:0] WRITEDATA, ADDRESS;
	output reg busywait;
	output reg [7:0] READDATA;
	output reg mem_read, mem_write;
	output reg [31:0] mem_writedata;
	input [31:0] mem_readdata;
	output reg [5:0] mem_address; 
	
	
	//to split the address
	wire [2:0] Tag_Add;
	wire [2:0] Index;
	wire [1:0] Offset;
	
	//to extract stored values
	wire valid, dirty;
	wire [2:0] Tag_curr;
	wire [31:0] DATA_block;
	
	//cache
	reg [7:0] Valid_Bit, Dirty_Bit;   
    reg [31:0] DATA [7:0]; //data blocks
	reg [2:0] TAG [7:0];
	
	/*
    Combinational part for indexing, tag comparison for hit deciding, etc.
    ...
    ...
    */

	//splitting address
	assign	Index = ADDRESS[4:2];
	assign	Tag_Add = ADDRESS[7:5];
	assign	Offset = ADDRESS[1:0];

	//extract stored values from cache
	assign #1 DATA_block = DATA[Index];	
	assign #1 valid = Valid_Bit[Index];
	assign #1 dirty = Dirty_Bit[Index];
	assign #1 Tag_curr = TAG[Index];
	
	//tag comparison
	wire Tag_out;	
	assign #0.9 Tag_out = (Tag_Add == Tag_curr) ? 1:0;
	
	//decide hit
	wire hit;
	assign hit = valid && Tag_out;
	
	//reading asynchronously
	
	reg [7:0] Data_out;
	
	always @ (*)
	begin
	#1
		if(Offset == 2'b00)
		begin
			READDATA = DATA_block[7:0];
		end
		else if(Offset == 2'b01)
		begin
			READDATA = DATA_block[15:8];
		end
		else if(Offset == 2'b10)
		begin
			READDATA = DATA_block[23:16];
		end
		else if(Offset == 2'b11)
		begin
			READDATA = DATA_block[31:24];
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
				Dirty_Bit[i] =  1'b0;
				TAG[i] = 3'd0;
				DATA[i] = 32'd0;
			end
			busywait = 1'b0;
		end
	end

	
	//at write hit
	always @(posedge clock)
	begin
		if(write && hit)
		begin
		#1
			Valid_Bit[Index] = 1'b1;
			Dirty_Bit[Index] = 1'b1;
			if(Offset == 2'b00)
			begin
				DATA[Index][7:0] = WRITEDATA;
			end
			else if(Offset == 2'b01)
			begin
				DATA[Index][15:8] = WRITEDATA;
			end
			else if(Offset == 2'b10)
			begin
				DATA[Index][23:16] = WRITEDATA;
			end
			else if(Offset == 2'b11)
			begin
				DATA[Index][31:24] = WRITEDATA;
			end
			
		end
	end
	
	//deassert busywait at hit
	always @ (posedge clock)
	begin
		if(hit && (read || write))
		begin
			busywait = 1'b0;
		end
	end
	
	//assert busywait at read or write
	always @ (*)
	begin
		if(read || write)
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
	//MEM_WRITE - Write to memory
	//CACHE - Update the cache

    parameter IDLE = 3'b000, MEM_READ = 3'b001, MEM_WRITE = 3'b010, CACHE = 3'b011;
    reg [2:0] state, next_state;

    // combinational next state logic
    always @(*)
    begin
        case (state)
            IDLE:
                if ((read || write) && !dirty && !hit)  
                    next_state = MEM_READ;
                else if ((read || write) && dirty && !hit)
                    next_state = MEM_WRITE;//mem_write
                else
                    next_state = IDLE;
            
            MEM_READ:
                if (!mem_busywait)
                    next_state = CACHE;
                else    
                    next_state = MEM_READ;
					
			MEM_WRITE:
                if (!mem_busywait)
                    next_state = MEM_READ;
                else    
                    next_state = MEM_WRITE;
					
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
                mem_write = 0;
                mem_address = 6'dx;
                mem_writedata = 6'dx;
                //busywait = 0;
            end
         
            MEM_READ: 
            begin
                mem_read = 1;
                mem_write = 0;
                mem_address = {Tag_Add, Index}; /****/
                mem_writedata = 32'dx;
                //busywait = 1;
            end
			
			MEM_WRITE: 
            begin
                mem_read = 0;
                mem_write = 1;
                mem_address = {Tag_curr, Index};/***/
                mem_writedata = DATA[Index];
                //busywait = 1;
            end
			
			CACHE: 
            begin
				mem_read = 0;
                mem_write = 0;
                mem_address = 6'dx;
                mem_writedata = 32'dx;
                //busywait = 1;
				#1 TAG[Index] = Tag_Add;
				Valid_Bit[Index] = 1'b1;
			    Dirty_Bit[Index] = 1'b0;
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