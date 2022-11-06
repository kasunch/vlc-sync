module schmidl_cox(clk, reset, i_enable, i_sample, o_corr, o_corr_valid);

    parameter WIDTH=10, CORR_LEN=64, CORR_OUT_WIDTH=64, CORR_SCALE_PWR=7;

    integer     i;

    input       clk;
    input       reset;
    input       i_enable;

    input [WIDTH-1:0]   i_sample;

    output [7:0]        o_corr;
    output              o_corr_valid;

    reg signed [WIDTH-1:0]  r_buf[CORR_LEN*2:0];

    reg signed [CORR_OUT_WIDTH-1:0]     r_pd = 0;
    reg signed [CORR_OUT_WIDTH-1:0]     r_rd_1half = 0;
    reg signed [CORR_OUT_WIDTH-1:0]     r_rd_2half = 0;
    reg                                 r_corr_valid = 0;
    reg [7:0]                           r_valid_ctr = 0;

    // Make verilator happy. 
    /* verilator lint_off UNUSED */ 
    reg [CORR_OUT_WIDTH-1:0]            r_md;
    wire [CORR_OUT_WIDTH-1:0]           w_md;
    /* verilator lint_on UNUSED */
    reg                                 r_div0 = 0;

    assign o_corr = r_div0 ? 8'd0 : r_md[7:0];
    assign o_corr_valid = r_corr_valid;

    always @ (posedge clk) begin
        if (reset) begin
            for(i = 0; i <= CORR_LEN*2; i = i + 1) begin
                r_buf[i] <= 0;
            end
            r_corr_valid <= 1'b0;
            r_valid_ctr <= 0;

            r_pd <= 0;
            r_rd_1half <= 0;
            r_rd_2half <= 0;
        end
        else begin

            if (i_enable) begin
                // We skip the first CORR_LEN*2 number of correlator values 
                if (r_valid_ctr == CORR_LEN*2) begin
                    r_corr_valid <= 1'd1;
                end
                else begin
                    r_valid_ctr <= r_valid_ctr + 8'd1;
                    r_corr_valid <= 1'd0;
                end

                // Shift the buffer by one sample to the left
                for(i = 1; i <= CORR_LEN*2; i = i + 1) begin
                    r_buf[i - 1] <= r_buf[i];    
                end
                // Convert the full ranged integer to a signed integer
                r_buf[CORR_LEN*2] <= i_sample ^ 10'h200; 

                // P(d) = SUM[m=0, m=L-1]( r(d+m) * r(d+m+L) )
                // P(d+1) = P(d) + r(d+L)*r(d+2L) - r(d)*r(d+L)
                // Here, we consider d=0 since we shift the sample buffer by one to the left for every new sample. 
                r_pd <= r_pd 
                            +   ( {{CORR_OUT_WIDTH-WIDTH{r_buf[CORR_LEN][WIDTH-1]}}, r_buf[CORR_LEN][WIDTH-1:0]} 
                                * {{CORR_OUT_WIDTH-WIDTH{r_buf[CORR_LEN*2][WIDTH-1]}}, r_buf[CORR_LEN*2][WIDTH-1:0]} ) 
                            -   ( {{CORR_OUT_WIDTH-WIDTH{r_buf[0][WIDTH-1]}}, r_buf[0][WIDTH-1:0]} 
                                * {{CORR_OUT_WIDTH-WIDTH{r_buf[CORR_LEN][WIDTH-1]}}, r_buf[CORR_LEN][WIDTH-1:0]} );

                // R1(d) = SUM[m=0, m=L-1](|r(d+m)|^2)
                // R1(d+1) = R1(d) + |r(d+L)|^2 - |r(d)|^2
                r_rd_1half <= r_rd_1half 
                                +   ( {{CORR_OUT_WIDTH-WIDTH{r_buf[CORR_LEN][WIDTH-1]}}, r_buf[CORR_LEN][WIDTH-1:0]} 
                                    * {{CORR_OUT_WIDTH-WIDTH{r_buf[CORR_LEN][WIDTH-1]}}, r_buf[CORR_LEN][WIDTH-1:0]} ) 
                                -   ( {{CORR_OUT_WIDTH-WIDTH{r_buf[0][WIDTH-1]}}, r_buf[0][WIDTH-1:0]} 
                                    * {{CORR_OUT_WIDTH-WIDTH{r_buf[0][WIDTH-1]}}, r_buf[0][WIDTH-1:0]} );

                // R2(d) = SUM[m=0, m=L-1](|r(d+m+L)|^2)
                // R2(d+1) = R2(d) + |r(d+2L)|^2 - |r(d+L)|^2
                r_rd_2half <= r_rd_2half 
                                +   ( {{CORR_OUT_WIDTH-WIDTH{r_buf[CORR_LEN*2][WIDTH-1]}}, r_buf[CORR_LEN*2][WIDTH-1:0]} 
                                    * {{CORR_OUT_WIDTH-WIDTH{r_buf[CORR_LEN*2][WIDTH-1]}}, r_buf[CORR_LEN*2][WIDTH-1:0]} ) 
                                -   ( {{CORR_OUT_WIDTH-WIDTH{r_buf[CORR_LEN][WIDTH-1]}}, r_buf[CORR_LEN][WIDTH-1:0]} 
                                    * {{CORR_OUT_WIDTH-WIDTH{r_buf[CORR_LEN][WIDTH-1]}}, r_buf[CORR_LEN][WIDTH-1:0]} );


                // For the moment, we let toolchain's synthesizer to implement division
                // TODO: This seems to be efficient in area vise than non-restoring pipelined integer division 
                r_md <= ((r_pd * r_pd) << CORR_SCALE_PWR) / (r_rd_1half * r_rd_2half);
                r_div0 <= (~| r_rd_1half) | (~|r_rd_2half);
            end

        end
    end
    
endmodule