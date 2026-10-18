module Memory(
    input wire [11:0] address,
    input wire [15:0] data_in,
    input wire write,
    input wire read,
    output reg [15:0] data_out,

    output wire [15:0] debug_mem0,
    output wire [15:0] debug_mem1,
    output wire [15:0] debug_mem2,
    output wire [15:0] debug_mem3,
    output wire [15:0] debug_mem4
);

    reg [15:0] M [0:4095];

    // Asynchronous Write and Read
    always @(*) begin
        if (write)
            M[address] = data_in;
        
        if (read)
            data_out = M[address];
        else
            data_out = 16'bz;
    end

    // Memory initialization
    initial begin

        // Program Instructions
        M[16'd0] = 16'h500A; // BSA 10 -- ADD
        M[16'd1] = 16'h5014; // BSA 20 -- SUB
        M[16'd2] = 16'h501E; // BSA 30 -- MUL
        M[16'd3] = 16'h7001; // HLT

        // Data values
        M[16'hF00] = 16'd16;
        M[16'hF01] = 16'd5;
        M[16'hF02] = 16'd0;
        M[16'hF03] = 16'd0;
        M[16'hF04] = 16'd0;

//=======================================> ADD start
	M[16'd11] = 16'h2F00; //LDA F00
	M[16'd12] = 16'h1F01; //ADD F01
	M[16'd13] = 16'h3F02; //STA F02
	M[16'd14] = 16'hC00A; //BUN 10 *

//=======================================> SUB start
	M[16'd21] = 16'h2F01; //LDA F01
	M[16'd22] = 16'h7200; //CMA
	M[16'd23] = 16'h7020; //INC
	M[16'd24] = 16'h3005; //STA 5
	M[16'd25] = 16'h7800; //CLA
	M[16'd26] = 16'h2F00; //LDA F00
	M[16'd27] = 16'h1005; //ADD 5
	M[16'd28] = 16'h3F03; //STA F03
	M[16'd29] = 16'hC014; //BUN 20 *

//=======================================> MUL start
	M[16'd31] = 16'h2F00; //LDA F00
	M[16'd32] = 16'h302C; //STA 44
	M[16'd33] = 16'h2F01; //LDA F01
	M[16'd34] = 16'h7200; //CMA
	M[16'd35] = 16'h7020; //INC
	M[16'd36] = 16'h302D; //STA 45
	M[16'd37] = 16'h7800; //CLA
	M[16'd38] = 16'h202C; //LDA 44
	M[16'd39] = 16'h1F04; //ADD F04
	M[16'd40] = 16'h3F04; //STA F04
	M[16'd41] = 16'h602D; //ISZ 45
	M[16'd42] = 16'h4026; //BUN 38
	M[16'd43] = 16'hC01E; //BUN 30 *


    end

    assign debug_mem0 = M[16'hF00];
    assign debug_mem1 = M[16'hF01];
    assign debug_mem2 = M[16'hF02];
    assign debug_mem3 = M[16'hF03];
    assign debug_mem4 = M[16'hF04];

    // Debugging utility
    task show_memory;
        integer i;
        begin
            $display("===== Memory Dump [F00 - F04] =====");
            for (i = 12'hF00; i <= 12'hF04; i = i + 1) begin
                $display("Mem[%h] = %h", i, M[i]);
            end
            $display("===================================");
        end
    endtask

endmodule

