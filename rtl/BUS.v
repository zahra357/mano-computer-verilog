module Bus (
    input  wire [15:0] ac,
    input  wire [15:0] dr,
    input  wire [15:0] ar,
    input  wire [15:0] ir,
    input  wire [15:0] pc, 
    input  wire [15:0] tr,
    input  wire [15:0] m,
    input  wire [2:0]  sel,
    output wire [15:0] data_out
);

    reg [15:0] mux_out;

    always @(*) begin
        case (sel)
            3'b000: mux_out = ac;
            3'b001: mux_out = dr;
            3'b010: mux_out = {4'b0000, ar[11:0]}; 
            3'b011: mux_out = ir;
            3'b100: mux_out = {4'b0000, pc[11:0]};
            3'b101: mux_out = tr;
            3'b111: mux_out = m;
            default: mux_out = 16'hABCD;
        endcase
    end

    assign data_out = mux_out;

endmodule

