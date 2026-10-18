module ALU (
    input  [15:0] ac,
    input  [15:0] dr,
    input  [2:0]  sel,
    input         e_in,
    output reg [15:0] alu_out,
    output reg       e_out
);

always @(*) begin
    case (sel)
        4'b000: begin // ADD: AC ? AC + DR
            {e_out, alu_out} = ac + dr;
        end
        4'b001: begin // INC: AC ? AC + 1
            {e_out, alu_out} = ac + 1;
        end
        4'b010: begin // AND: AC ? AC & DR
            alu_out = ac & dr;
            e_out = e_in;
        end
        4'b011: begin // CMA: AC ? ~AC
            alu_out = ~ac;
            e_out = e_in;
        end
        4'b100: begin // LDA: AC ? DR
            alu_out = dr;
            e_out = e_in; 
        end
        4'b101: begin // CME: E ? ~E
            alu_out = ac; 
            e_out = ~e_in;
        end
        4'b110: begin // CIR: AC,E ? Rotate Right
            alu_out = {e_in, ac[15:1]};
            e_out   = ac[0];
        end
        4'b111: begin // CIL: AC,E ? Rotate Left
            alu_out = {ac[14:0], e_in};
            e_out   = ac[15];
        end
        default: begin // Undefined
            alu_out = 16'bx;
            e_out = 1'bx;
        end
    endcase
end

endmodule

