module Register #(parameter WIDTH = 16)(
    input wire clk,
    input wire clr,
    input wire ld,
    input wire inc,
    input wire [WIDTH-1:0]  data_in,
    output reg [WIDTH-1:0] data_out
);


initial begin
    data_out = {WIDTH{1'b0}};
end

always @(posedge clk) begin
    if (clr) begin
        data_out <= {WIDTH{1'b0}};
    end else if (ld) begin
            data_out <= data_in;
    end else if (inc) begin
        data_out <= data_out + 1'b1;
    end
end

endmodule

