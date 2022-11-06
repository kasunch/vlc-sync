module min_avg(clk, reset, i_next, i_data, o_avg);

    // Averaging window should be a power of two. Instead of the decimal
    // value, we use its power for AVG_WINDOW to make division easy.
    parameter WIDTH=10, MIN_SEARCH_WINDOW=64, AVG_WINDOW=3;

    input clk;
    input reset;    
    input i_next;
    input [WIDTH-1:0] i_data;
    output reg [WIDTH-1:0] o_avg = 0;

    reg [WIDTH-1:0] r_min = 10'h3FF;      // Current minimum
    reg [WIDTH-1:0] r_total = 0;          // Current total of the minimum values
    reg [7:0]       r_sample_cnt = 0;     // Current number of samples used for searching the minimum
    reg [7:0]       r_min_sample_cnt = 0; // Current number of minimum samples 

    always @ (posedge clk) begin
        if (reset) begin
            r_min <= 10'h3FF;
            r_sample_cnt <= 0;
            r_total <= 0;
            o_avg <= 0;
        end
        else begin
            if (i_next) begin
                r_min <= i_data < r_min ? i_data : r_min;
                if (r_sample_cnt == MIN_SEARCH_WINDOW - 1) begin
                    if (r_min_sample_cnt == (1 << AVG_WINDOW) -1) begin
                        o_avg <= (r_total + (i_data < r_min ? i_data : r_min)) >> AVG_WINDOW;
                        r_total <= 0;
                        r_min_sample_cnt <= 0;
                    end
                    else begin
                        r_total <= r_total + r_min;
                        r_min_sample_cnt <= r_min_sample_cnt + 8'd1;
                    end
                    r_min <= 10'h3FF;
                    r_sample_cnt <= 0;
                end
                else begin
                    r_sample_cnt <= r_sample_cnt + 8'd1;
                end
            end
        end
    end

endmodule