
module DataPath(
    input  wire        clk,
    input  wire        reset,

    // Control Signals
    input  wire        ld_ac, clr_ac,
    input  wire        ld_dr, clr_dr, inc_dr,
    input  wire        ld_ar, clr_ar, inc_ar,
    input  wire        ld_ir, clr_ir, inc_ir,
    input  wire        ld_pc, inc_pc, clr_pc,
    input  wire        ld_tr, clr_tr,
    input  wire        ld_e,  clr_e,
    input  wire        mem_read, mem_write,
    input  wire [2:0]  alu_op,
    input  wire [2:0]  bus_sel,

    output wire [11:0] AR_reg,
    output wire [15:0] DR_reg,
    output wire [15:0] IR_reg,
    output wire [11:0] PC_reg,
    output wire [15:0] AC_reg,
    output wire [15:0] TR_reg,
    output wire E_reg,

    output wire [15:0] debug_mem0,
    output wire [15:0] debug_mem1,
    output wire [15:0] debug_mem2,
    output wire [15:0] debug_mem3,
    output wire [15:0] debug_mem4

);


// inside of data path module __________________________ :)
wire [15:0] ac_out;
wire [15:0] dr_out;
wire [11:0] ar_out;
wire [15:0] ir_out;
wire [11:0] pc_out;
wire [15:0] tr_out;
wire [15:0] mem_out;

wire [15:0] bus_way; //bus output

wire [15:0] alu_result;
wire cout;
wire cin;

// Registers ---------------------------------------------------------------------------------------------------------

    Register #(12) AR(.clk(clk), .clr(clr_ar), .ld(ld_ar), .inc(inc_ar), .data_in(bus_way[11:0]), .data_out(ar_out));
    Register #(16) DR(.clk(clk), .clr(clr_dr), .ld(ld_dr), .inc(inc_dr), .data_in(bus_way), .data_out(dr_out));
    Register #(16) IR(.clk(clk), .clr(clr_ir), .ld(ld_ir), .inc(inc_ir), .data_in(bus_way), .data_out(ir_out));
    Register #(12) PC(.clk(clk), .clr(clr_pc), .ld(ld_pc), .inc(inc_pc), .data_in(bus_way[11:0]), .data_out(pc_out));
    Register #(16) TR(.clk(clk), .clr(clr_tr), .ld(ld_tr), .inc(1'b0), .data_in(bus_way), .data_out(tr_out));

    Register #(16) AC(.clk(clk), .clr(clr_ac), .ld(ld_ac), .inc(1'b0), .data_in(alu_result), .data_out(ac_out));
    Register #(1)  E (.clk(clk), .clr(clr_e),  .ld(ld_e),  .inc(1'b0), .data_in(cout), .data_out(cin));

//---------------------------------------------------------------------------------------------------------------------


task show_registers;
  begin
    $display("===== Register States =====");
    $display("AC : %h", ac_out);
    $display("DR : %h", dr_out);
    $display("AR : %h", ar_out);
    $display("IR : %h", ir_out);
    $display("PC : %h", pc_out);
    $display("TR : %h", tr_out);
    $display("E  : %b", cin);
    $display("============================");
  end
endtask


// ALU ----------------------------------------------------------------------------------------------------------------

    ALU alu(
        .ac(ac_out),
        .dr(dr_out),
        .sel(alu_op),
        .alu_out(alu_result),
        .e_out(cout),
	.e_in(cin)
    );

//---------------------------------------------------------------------------------------------------------------------

// Memory -------------------------------------------------------------------------------------------------------------

    Memory mem(
        .address(ar_out),
        .data_in(bus_way),
        .write(mem_write),
        .read(mem_read),
        .data_out(mem_out),

        .debug_mem0(debug_mem0),
        .debug_mem1(debug_mem1),
        .debug_mem2(debug_mem2),
        .debug_mem3(debug_mem3),
        .debug_mem4(debug_mem4)

    );

//--------------------------------------------------------------------------------------------------------------------

// Bus ---------------------------------------------------------------------------------------------------------------

    Bus bus(
        .sel(bus_sel),
        .ac(ac_out),
        .dr(dr_out),
        .ar({4'b0000, ar_out}),
        .ir(ir_out),
        .pc({4'b0000, pc_out}),
        .tr(tr_out),
	.m(mem_out),
        .data_out(bus_way)
    );
//--------------------------------------------------------------------------------------------------------------------


assign AR_reg = ar_out;
assign DR_reg = dr_out;
assign IR_reg = ir_out;
assign PC_reg = pc_out;
assign AC_reg = ac_out;
assign TR_reg = tr_out;
assign E_reg = cin;

endmodule

