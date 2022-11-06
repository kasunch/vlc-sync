module fir_filter(clk, reset, i_in, o_out);
    parameter WIDTH=10;

    integer i;

    input clk;
    input reset;

    input [WIDTH-1:0]       i_in;
    output[15:0]       o_out;

    reg [WIDTH-1:0]         r_mem[15:0];

    // Make verilator happy
    // verilator lint_off UNUSED
    reg [15:0]              r_out = 0;
    assign                  o_out = r_out[15:0];
    // verilator lint_on UNUSED

    always @ (posedge clk) begin
        if (reset) begin
        end
        else begin

            for(i = 1; i < 16; i = i + 1) begin
                r_mem[i - 1] <= r_mem[i];
            end
            r_mem[15] <= i_in;

            r_out <= ({6'd0, r_mem[0]}
                        + {6'd0, r_mem[1]}
                        + {6'd0, r_mem[2]}
                        + {6'd0, r_mem[3]}
                        + {6'd0, r_mem[4]}
                        + {6'd0, r_mem[5]}
                        + {6'd0, r_mem[6]}
                        + {6'd0, r_mem[7]}
                        + {6'd0, r_mem[8]}
                        + {6'd0, r_mem[9]}
                        + {6'd0, r_mem[10]} 
                        + {6'd0, r_mem[11]}
                        + {6'd0, r_mem[12]} 
                        + {6'd0, r_mem[13]} 
                        + {6'd0, r_mem[14]} 
                        + {6'd0, r_mem[15]});
        end
    end

endmodule