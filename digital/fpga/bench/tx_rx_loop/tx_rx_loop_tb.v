module tx_rx_loop_tb(i_clk);

    parameter WIDTH=10;

    input i_clk;

    reg                 r_start = 0;
    wire                reset;
    wire [WIDTH-1:0]    w_dac_adc_loop;
    wire                w_rx_done;

    auto_reset auto_reset_inst(.clk(i_clk), .reset(reset));

    tx_loop txl_inst(.clk(i_clk), 
                        .reset(reset),
                        .i_start(r_start), 
                        .o_tx_out(w_dac_adc_loop));

    rx_loop rxl_inst(.clk(i_clk), 
                        .reset(reset), 
                        .i_start(r_start),
                        .i_rx_in(w_dac_adc_loop), 
                        .o_done(w_rx_done));

    always @ (posedge i_clk) begin
        if (reset) begin
            r_start <= 1'b1;
        end
        else begin
            r_start <= 0;
            if (w_rx_done) begin
                $display("RX done");
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








