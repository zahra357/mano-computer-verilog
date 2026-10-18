// i did itttt
module TimingControlUnit (
    input wire clk,
    input wire rst,
    input wire [15:0] IR,
    input wire [15:0] DR,
    input wire [15:0] AC,
    input wire E,

    output reg ld_AC, clr_AC,
    output reg ld_DR, clr_DR, inc_DR,
    output reg ld_AR, clr_AR, inc_AR,
    output reg ld_IR, clr_IR, inc_IR,
    output reg ld_PC, clr_PC, inc_PC,
    output reg ld_TR, clr_TR,
    output reg ld_E,  clr_E,

    output reg [2:0] bus_sel,
    output reg [2:0] alu_sel,

    output reg rd_MEM, wr_MEM,

    output reg halt,

    output wire [2:0] S
);


reg [2:0] state , next_state;
assign S = state;


// States ----------------------------------
parameter fetch1 = 3'b001; 
parameter fetch2 = 3'b010; 
parameter decode = 3'b011; 
parameter indirect = 3'b100; 
parameter execute1 = 3'b101; 
parameter execute2 = 3'b110; 
parameter execute3 = 3'b111; 

///////////////////////////////////////////
always @(posedge clk or posedge rst) begin

    if (rst) begin
        state <= fetch1;
    end 
    
    else begin
	state <= next_state;
    end
end

///////////////////////////////////////////

always @(*) begin
clear_signals();
next_state = state;

    case (state)
//------------------------------------| FETCH_1 |
 fetch1: begin
// PC to AR
bus_sel = 3'b100; // PC on bus
ld_AR = 1;

next_state = fetch2;
end

//------------------------------------| FETCH_2 |
fetch2: begin
rd_MEM = 1;
bus_sel = 3'b111; // M on bus
ld_IR = 1;
inc_PC = 1;

next_state = decode;
end

//-------------------------------------| DECODE |
decode: begin
bus_sel = 3'b011; // IR on bus
ld_AR = 1;

next_state = indirect;
end

//-----------------------------------| INDIRECT |
indirect: begin
	if ( IR[15] == 1 && IR[14:12] != 3'b111 ) begin 
		rd_MEM = 1;
		bus_sel = 3'b111; // M on bus
		ld_AR = 1;
	end
next_state = execute1;
end

//-----------------------------------| EXECUTE_1 |
 execute1: begin 
// - - - - - - - - | Memory _1 | - - - - - - - - - - 
	if ( IR[14:12] != 3'b111 ) begin 
		//________AND________._. 
		if ( IR[14:12] == 3'b000 ) begin
			// M to DR
			rd_MEM = 1;
			bus_sel = 3'b111; //M on bus
			ld_DR = 1;
			next_state = execute2;
		end
		//________ADD________._.
		else if ( IR[14:12] == 3'b001 ) begin 
			// M to DR
			rd_MEM = 1;
			bus_sel = 3'b111; //M on bus
			ld_DR = 1;
			next_state = execute2;
		end
		//________LDA________._.
		else if ( IR[14:12] == 3'b010 ) begin 
			// M to DR
			rd_MEM = 1;
			bus_sel = 3'b111; //M on bus
			ld_DR = 1;
			next_state = execute2;
		end
		//________STA________._.
		else if ( IR[14:12] == 3'b011 ) begin 
			//AC to M
			bus_sel = 3'b000; //AC on bus
			wr_MEM = 1;
			next_state = fetch1;
		end
		//________BUN________._.
		else if ( IR[14:12] == 3'b100 ) begin 
			// AR to PC
			bus_sel = 3'b010; //AR on bus
			ld_PC = 1;
			next_state = fetch1;
		end
		//________BSA________._.
		else if ( IR[14:12] == 3'b101 ) begin 
			// PC to M , AR+1
			bus_sel = 3'b100;
			wr_MEM = 1;	
			next_state = execute2;
		end
		//________ISZ________._.
		else if ( IR[14:12] == 3'b110 ) begin 
			// M to DR
			rd_MEM = 1;
			bus_sel = 3'b111;
			ld_DR = 1;
			next_state = execute2;
		end
end

// - - - - - - - - | Register | - - - - - - - - - - 
	else if ( IR[15:12] == 4'b0111 ) begin 
		//-=-=-=-= CLA =-=-=-=-
		 if     ( IR[11] ) begin 
			clr_AC = 1;
		end
		//-=-=-=-= CLE =-=-=-=-
		else if ( IR[10] ) begin 
			clr_E = 1;
		end
		//-=-=-=-= CMA =-=-=-=-
		else if ( IR[9] ) begin 
			alu_sel = 3'b011;
			ld_AC = 1;
		end
		//-=-=-=-= CME =-=-=-=-
		else if ( IR[8] ) begin 
			alu_sel = 3'b101;
			ld_E = 1;
		end
		//-=-=-=-= CIR =-=-=-=-
		else if ( IR[7] ) begin 
			alu_sel = 3'b110;
			ld_AC = 1;
			ld_E = 1;
		end
		//-=-=-=-= CIL =-=-=-=-
		else if ( IR[6] ) begin 
			alu_sel = 3'b111;
			ld_AC = 1;
			ld_E = 1;
		end
		//-=-=-=-= INC =-=-=-=-
		else if ( IR[5] ) begin 
			alu_sel = 3'b001;
			ld_AC = 1;
			ld_E = 1;
		end
		//-=-=-=-= SPA =-=-=-=-
		else if ( IR[4] ) begin 
			if ( AC[15] == 0 ) inc_PC = 1;
		end
		//-=-=-=-= SNA =-=-=-=-
		else if ( IR[3] ) begin 
			if ( AC[15] == 1 ) inc_PC = 1;
		end
		//-=-=-=-= SZA =-=-=-=-
		else if ( IR[2] ) begin 
			if ( AC == 16'h0000 ) inc_PC = 1;
		end
		//-=-=-=-= SZE =-=-=-=-
		else if ( IR[1] ) begin 
			if ( E == 1'b0 ) inc_PC = 1;
		end
		//-=-=-=-= HLT =-=-=-=-
		else if ( IR[0] ) halt = 1;
	next_state = fetch1;
	end

end

//-----------------------------------| EXECUTE_2 |
 execute2: begin
// - - - - - - - - | Memory _2 | - - - - - - - - - - 
	if ( IR[14:12] != 3'b111 ) begin 
		//________AND________._. 
		if ( IR[14:12] == 3'b000 ) begin 
			alu_sel = 3'b010;
			ld_AC = 1;
			next_state = fetch1;
		end
		//________ADD________._.
		else if ( IR[14:12] == 3'b001 ) begin 
			alu_sel = 3'b000;
			ld_AC = 1;
			ld_E = 1;
			next_state = fetch1;
		end
		//________LDA________._.
		else if ( IR[14:12] == 3'b010 ) begin 
			alu_sel = 3'b100;
			ld_AC = 1;
			next_state = fetch1;
		end
		//________BSA________._.
		else if ( IR[14:12] == 3'b101 ) begin 
			inc_AR = 1;
			next_state = execute3;
		end
		//________ISZ________._.
		else if ( IR[14:12] == 3'b110 ) begin 
			inc_DR = 1;
			next_state = execute3;
		end
	end
end

//-----------------------------------| EXECUTE_3 |
 execute3: begin
// - - - - - - - - | Memory _3 | - - - - - - - - - - 
	if ( IR[14:12] != 3'b111 ) begin 
		//________BSA________._.
		if ( IR[14:12] == 3'b101 ) begin 
			bus_sel =3'b010;
			ld_PC = 1;
			next_state = fetch1;
		end
		//________ISZ________._.
		else if ( IR[14:12] == 3'b110 ) begin 
			bus_sel = 3'b001;
			wr_MEM = 1;
			if ( DR == 16'h0000 ) inc_PC = 1;
			next_state = fetch1;
		end
	end
end

    endcase
end



task clear_signals;
 begin
    ld_AC  = 0;
    ld_DR  = 0;
    ld_AR  = 0;
    ld_IR  = 0;
    ld_PC  = 0;
    ld_TR  = 0;
    ld_E  = 0;

    clr_AC = 0;
    clr_DR = 0;
    clr_AR = 0;
    clr_IR = 0;
    clr_PC = 0;
    clr_TR = 0;
    clr_E  = 0;

    inc_PC = 0;
    inc_AR = 0;
    inc_DR = 0;
    inc_IR = 0;

    wr_MEM = 0;
    rd_MEM = 0;
 end
endtask

endmodule