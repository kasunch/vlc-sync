module slope_find(clk, reset, i_in, o_pos_slope, o_neg_slope);
    parameter WIDTH=16, POS_THRESHOLD=4'd10, NEG_THRESHOLD=4'd10;

    integer i;

    input clk;
    input reset;

    input [WIDTH-1:0]       i_in;
    output                  o_pos_slope;
    output                  o_neg_slope;

    reg [WIDTH-1:0]         r_mem[15:0];
    wire [15:0]              w_bits_pos;
    wire [15:0]              w_bits_neg;
    wire [3:0]               w_score_pos;
    wire [3:0]               w_score_neg;
    //reg [15:0]              r_bits_pos;
    //reg [15:0]              r_bits_neg;
    //reg [3:0]               r_score_pos;
    //reg [3:0]               r_score_neg;

    assign o_pos_slope = w_score_pos > POS_THRESHOLD ? 1'b1: 1'b0;
    assign o_neg_slope = w_score_neg > NEG_THRESHOLD ? 1'b1: 1'b0;
    
    assign w_bits_pos[0] = 1'b0;
    assign w_bits_pos[1] = r_mem[0] < r_mem[1] ? 1'b1: 1'b0;
    assign w_bits_pos[2] = r_mem[0] < r_mem[2] ? 1'b1: 1'b0;
    assign w_bits_pos[3] = r_mem[0] < r_mem[3] ? 1'b1: 1'b0;
    assign w_bits_pos[4] = r_mem[0] < r_mem[4] ? 1'b1: 1'b0;
    assign w_bits_pos[5] = r_mem[0] < r_mem[5] ? 1'b1: 1'b0;
    assign w_bits_pos[6] = r_mem[0] < r_mem[6] ? 1'b1: 1'b0;
    assign w_bits_pos[7] = r_mem[0] < r_mem[7] ? 1'b1: 1'b0;
    assign w_bits_pos[8] = r_mem[0] < r_mem[8] ? 1'b1: 1'b0;
    assign w_bits_pos[9] = r_mem[0] < r_mem[9] ? 1'b1: 1'b0;
    assign w_bits_pos[10] = r_mem[0] < r_mem[10] ? 1'b1: 1'b0;
    assign w_bits_pos[11] = r_mem[0] < r_mem[11] ? 1'b1: 1'b0;
    assign w_bits_pos[12] = r_mem[0] < r_mem[12] ? 1'b1: 1'b0;
    assign w_bits_pos[13] = r_mem[0] < r_mem[13] ? 1'b1: 1'b0;
    assign w_bits_pos[14] = r_mem[0] < r_mem[14] ? 1'b1: 1'b0;
    assign w_bits_pos[15] = r_mem[0] < r_mem[15] ? 1'b1: 1'b0;
    
    assign w_bits_neg[0] = 1'b0;
    assign w_bits_neg[1] = r_mem[0] > r_mem[1] ? 1'b1: 1'b0;
    assign w_bits_neg[2] = r_mem[0] > r_mem[2] ? 1'b1: 1'b0;
    assign w_bits_neg[3] = r_mem[0] > r_mem[3] ? 1'b1: 1'b0;
    assign w_bits_neg[4] = r_mem[0] > r_mem[4] ? 1'b1: 1'b0;
    assign w_bits_neg[5] = r_mem[0] > r_mem[5] ? 1'b1: 1'b0;
    assign w_bits_neg[6] = r_mem[0] > r_mem[6] ? 1'b1: 1'b0;
    assign w_bits_neg[7] = r_mem[0] > r_mem[7] ? 1'b1: 1'b0;
    assign w_bits_neg[8] = r_mem[0] > r_mem[8] ? 1'b1: 1'b0;
    assign w_bits_neg[9] = r_mem[0] > r_mem[9] ? 1'b1: 1'b0;
    assign w_bits_neg[10] = r_mem[0] > r_mem[10] ? 1'b1: 1'b0;
    assign w_bits_neg[11] = r_mem[0] > r_mem[11] ? 1'b1: 1'b0;
    assign w_bits_neg[12] = r_mem[0] > r_mem[12] ? 1'b1: 1'b0;
    assign w_bits_neg[13] = r_mem[0] > r_mem[13] ? 1'b1: 1'b0;
    assign w_bits_neg[14] = r_mem[0] > r_mem[14] ? 1'b1: 1'b0;
    assign w_bits_neg[15] = r_mem[0] > r_mem[15] ? 1'b1: 1'b0;
    
    assign w_score_pos = {3'd0, w_bits_pos[0]} // This is always zero
                            + {3'd0, w_bits_pos[1]}
                            + {3'd0, w_bits_pos[2]}
                            + {3'd0, w_bits_pos[3]}
                            + {3'd0, w_bits_pos[4]}
                            + {3'd0, w_bits_pos[5]}
                            + {3'd0, w_bits_pos[6]}
                            + {3'd0, w_bits_pos[7]}
                            + {3'd0, w_bits_pos[8]}
                            + {3'd0, w_bits_pos[9]}
                            + {3'd0, w_bits_pos[10]}
                            + {3'd0, w_bits_pos[11]}
                            + {3'd0, w_bits_pos[12]}
                            + {3'd0, w_bits_pos[13]}
                            + {3'd0, w_bits_pos[14]}
                            + {3'd0, w_bits_pos[15]};
    
    assign w_score_neg = {3'd0, w_bits_neg[0]} // This is always zero
                            + {3'd0, w_bits_neg[1]}
                            + {3'd0, w_bits_neg[2]}
                            + {3'd0, w_bits_neg[3]}
                            + {3'd0, w_bits_neg[4]}
                            + {3'd0, w_bits_neg[5]}
                            + {3'd0, w_bits_neg[6]}
                            + {3'd0, w_bits_neg[7]}
                            + {3'd0, w_bits_neg[8]}
                            + {3'd0, w_bits_neg[9]}
                            + {3'd0, w_bits_neg[10]}
                            + {3'd0, w_bits_neg[11]}
                            + {3'd0, w_bits_neg[12]}
                            + {3'd0, w_bits_neg[13]}
                            + {3'd0, w_bits_neg[14]}
                            + {3'd0, w_bits_neg[15]};

    //assign o_pos_slope = r_score_pos > POS_THRESHOLD ? 1'b1: 1'b0;
    //assign o_neg_slope = r_score_neg > NEG_THRESHOLD ? 1'b1: 1'b0;

    always @ (posedge clk) begin
        if (reset) begin
        end
        else begin

            //r_bits_pos[0] <= 1'b0;
            //r_bits_neg[0] <= 1'b0;
            for(i = 1; i < 16; i = i + 1) begin
                //if (r_mem[0] < r_mem[i]) begin
                //    // possible positive edge
                //    r_bits_pos[i] <= 1'b1;
                //    r_bits_neg[i] <= 1'b0;
                //end
                //else if (r_mem[0] > r_mem[i]) begin
                //    // possible negative edge
                //    r_bits_pos[i] <= 1'b0;
                //    r_bits_neg[i] <= 1'b1;
                //end
                //else begin
                //    // Neither of the edges  
                //end
                r_mem[i - 1] <= r_mem[i];
            end
            r_mem[15] <= i_in;

            //r_score_pos <= {3'd0, r_bits_pos[0]} // This is always zero
            //                + {3'd0, r_bits_pos[1]}
            //                + {3'd0, r_bits_pos[2]}
            //                + {3'd0, r_bits_pos[3]}
            //                + {3'd0, r_bits_pos[4]}
            //                + {3'd0, r_bits_pos[5]}
            //                + {3'd0, r_bits_pos[6]}
            //                + {3'd0, r_bits_pos[7]}
            //                + {3'd0, r_bits_pos[8]}
            //                + {3'd0, r_bits_pos[9]}
            //                + {3'd0, r_bits_pos[10]}
            //                + {3'd0, r_bits_pos[11]}
            //                + {3'd0, r_bits_pos[12]}
            //                + {3'd0, r_bits_pos[13]}
            //                + {3'd0, r_bits_pos[14]}
            //                + {3'd0, r_bits_pos[15]};
            //
            //r_score_neg <= {3'd0, r_bits_neg[0]} // This is always zero
            //                + {3'd0, r_bits_neg[1]}
            //                + {3'd0, r_bits_neg[2]}
            //                + {3'd0, r_bits_neg[3]}
            //                + {3'd0, r_bits_neg[4]}
            //                + {3'd0, r_bits_neg[5]}
            //                + {3'd0, r_bits_neg[6]}
            //                + {3'd0, r_bits_neg[7]}
            //                + {3'd0, r_bits_neg[8]}
            //                + {3'd0, r_bits_neg[9]}
            //                + {3'd0, r_bits_neg[10]}
            //                + {3'd0, r_bits_neg[11]}
            //                + {3'd0, r_bits_neg[12]}
            //                + {3'd0, r_bits_neg[13]}
            //                + {3'd0, r_bits_neg[14]}
            //                + {3'd0, r_bits_neg[15]};

        end
    end
endmodule