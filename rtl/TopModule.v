module TopModule (
    input wire clk,
    input wire rst,

    output wire [15:0] debug_mem0,
    output wire [15:0] debug_mem1,
    output wire [15:0] debug_mem2,
    output wire [15:0] debug_mem3,
    output wire [15:0] debug_mem4,

    output wire [11:0] AR_reg,
    output wire [15:0] DR_reg,
    output wire [15:0] IR_reg,
    output wire [11:0] PC_reg,
    output wire [15:0] AC_reg,
    output wire [15:0] TR_reg,
    output wire E_reg,

    output wire [2:0]  step,

    output wire HALT

);

// Wires for control signals from ControlUnit to DataPath
wire ld_ac, clr_ac;
wire ld_dr, clr_dr, inc_dr;
wire ld_ar, clr_ar, inc_ar;
wire ld_ir, clr_ir, inc_ir;
wire ld_pc, clr_pc, inc_pc;
wire ld_tr, clr_tr;
wire ld_e, clr_e;
wire mem_read, mem_write;
wire [2:0] alu_op;
wire [2:0] bus_sel;
wire [15:0] mem_out;
wire halt;

wire [11:0] AR_wire;
wire [15:0] DR_wire;
wire [15:0] IR_wire;
wire [11:0] PC_wire;
wire [15:0] AC_wire;
wire [15:0] TR_wire;
wire E_wire;

wire [2:0] step_wire;

// Instantiate ControlUnit
TimingControlUnit control_unit (
    .clk(clk),
    .rst(rst),
    .IR(IR_wire),
    .DR(DR_wire),
    .AC(AC_wire),
    .E(E_wire),

    .S(step_wire),

    .ld_AC(ld_ac),
    .clr_AC(clr_ac),
    .ld_DR(ld_dr),
    .clr_DR(clr_dr),
    .inc_DR(inc_dr),
    .ld_AR(ld_ar),
    .clr_AR(clr_ar),
    .inc_AR(inc_ar),
    .ld_IR(ld_ir),
    .clr_IR(clr_ir),
    .inc_IR(inc_ir),
    .ld_PC(ld_pc),
    .clr_PC(clr_pc),
    .inc_PC(inc_pc),
    .ld_TR(ld_tr),
    .clr_TR(clr_tr),
    .ld_E(ld_e),
    .clr_E(clr_e),

    .bus_sel(bus_sel),
    .alu_sel(alu_op),

    .rd_MEM(mem_read),
    .wr_MEM(mem_write),

    .halt(halt)
);

// Instantiate DataPath
DataPath datapath (
    .clk(clk),
    .reset(rst),

    .ld_ac(ld_ac),
    .clr_ac(clr_ac),
    .ld_dr(ld_dr),
    .clr_dr(clr_dr),
    .inc_dr(inc_dr),
    .ld_ar(ld_ar),
    .clr_ar(clr_ar),
    .inc_ar(inc_ar),
    .ld_ir(ld_ir),
    .clr_ir(clr_ir),
    .inc_ir(inc_ir),
    .ld_pc(ld_pc),
    .inc_pc(inc_pc),
    .clr_pc(clr_pc),
    .ld_tr(ld_tr),
    .clr_tr(clr_tr),
    .ld_e(ld_e),
    .clr_e(clr_e),

    .mem_read(mem_read),
    .mem_write(mem_write),

    .alu_op(alu_op),
    .bus_sel(bus_sel),

    .AR_reg(AR_wire),
    .DR_reg(DR_wire),
    .IR_reg(IR_wire),
    .PC_reg(PC_wire),
    .AC_reg(AC_wire),
    .TR_reg(TR_wire),
    .E_reg(E_wire),

        .debug_mem0(debug_mem0),
        .debug_mem1(debug_mem1),
        .debug_mem2(debug_mem2),
        .debug_mem3(debug_mem3),
        .debug_mem4(debug_mem4)

);

assign IR_reg = IR_wire;
assign AR_reg = AR_wire;
assign DR_reg = DR_wire;
assign PC_reg = PC_wire;
assign AC_reg = AC_wire;
assign TR_reg = TR_wire;
assign E_reg = E_wire;

assign step = step_wire;

assign HALT = halt;


endmodule

