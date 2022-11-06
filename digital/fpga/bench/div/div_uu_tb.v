module div_uu_tb(i_clk);

    parameter WIDTH=8;

    input       i_clk;

    wire        reset;

    auto_reset auto_reset_inst(.clk(i_clk), .reset(reset));


    reg                 r_enable = 1'b0;
    reg [WIDTH-1:0]     r_divident = 0;
    reg [WIDTH-1:0]     r_divider = 0;

    wire [WIDTH-1:0]    w_quotient;
    wire [WIDTH-1:0]    w_remainder;
    wire                w_valid;

	div_uu #(.WIDTH(WIDTH)) dut (.clk(i_clk),  
                                .i_enable(r_enable),
                                .i_divident(r_divident), 
                                .i_divisor(r_divider), 
                                .o_quotient(w_quotient), 
                                .o_remainder(w_remainder),
                                .o_valid(w_valid)
                                );

    always @ (posedge i_clk) begin
        if (reset) begin
            r_enable <= 1'b1;
            r_divident <= 8'd5;
            r_divider <= 8'd2;
        end
        else begin
            r_divident <= r_divident + 8'd1;
            r_divider <= r_divider + 8'd1;
            if (w_valid) begin
                $display("%d %d", w_quotient, w_remainder);  
            end
        end
    end


endmodule