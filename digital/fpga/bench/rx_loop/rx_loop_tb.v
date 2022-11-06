`include "rx_loop_tb.vh"

module rx_loop_tb(i_clk);
    input i_clk;
    
    parameter WIDTH=10;

    reg [WIDTH-1:0]                       r_rx_mem[`RX_INPUT_DATA_SIZE-1:0];
    reg [WIDTH-1:0]                       r_rx_in = 0;
    reg [$clog2(`RX_INPUT_DATA_SIZE)-1:0] r_rx_in_cnt = 0;

    reg r_rx_in_finished = 0;

    wire w_auto_reset;
    wire w_done_ind;
    //wire w_uart_line;

    
    auto_reset auto_reset_inst(.clk(i_clk), .reset(w_auto_reset));

    rx_loop_slip rx_loop_inst(.clk(i_clk), .reset(w_auto_reset), 
                            .i_rx_in(r_rx_in),
                            .o_done_ind(w_done_ind)); 
                            //.o_uart_line(w_uart_line));
                            
    initial begin
        $readmemh("input_rx_tb.csv", r_rx_mem);
    end
              
              
    always @ (posedge i_clk) begin
        if (w_auto_reset) begin

        end
        else begin

            if (!r_rx_in_finished) begin
                if (r_rx_in_cnt == `RX_INPUT_DATA_SIZE - 1) begin
                    r_rx_in_finished <= 1;
                    $display("End of input data");
                end
                else begin
                    r_rx_in_cnt <= r_rx_in_cnt + 1;
                end
                r_rx_in <= r_rx_mem[r_rx_in_cnt];
            end

            if (w_done_ind) begin
                finish();  
            end


        end
    end
    
    task finish;
    begin
        $finish;
    end
    endtask
    
endmodule








