module clk_div_tb();

    reg clk = 0;
    wire w_auto_reset;

    reg [7:0] r_cycles = 0;

    reg r_clk_div2 = 0;

    reg r_clk_div4 = 1;
    reg r_cnt_div4 = 0; 

    reg       r_clk_div8 = 1;
    reg [1:0] r_cnt_div8 = 0; 

    auto_reset auto_reset_inst(.clk(clk), .reset(w_auto_reset));

    always #1 clk = ~clk;

    initial begin
        $dumpfile("clk_div_tb.vcd");
        $dumpvars(0, clk_div_tb);
    end

    always @ (posedge clk) begin

        if (w_auto_reset) begin
            r_clk_div2 <= 1;
            r_clk_div4 <= 1;
            r_clk_div8 <= 1;

            r_cnt_div4 <= 0;
            r_cnt_div8 <= 0;
        end
        else begin
            if (r_cycles == 8'hff) begin
                $finish();
            end
            else begin
                r_cycles <= r_cycles + 8'd1;
            end

            r_clk_div2 <= ~r_clk_div2;

            if (r_cnt_div4 == 1'd1) begin
                r_cnt_div4 <= 1'd0;
                r_clk_div4 <= ~r_clk_div4;
            end
            else begin
                r_cnt_div4 <= r_cnt_div4 + 1'd1;
            end

            if (r_cnt_div8 == 2'd3) begin
                r_cnt_div8 <= 2'd0;
                r_clk_div8 <= ~r_clk_div8;
            end
            else begin
                r_cnt_div8 <= r_cnt_div8 + 1'd1;
            end
        end
    end

    always @ (posedge r_clk_div8) begin
        $display("%3d", r_cycles);
    end


endmodule