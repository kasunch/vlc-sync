module slip_tx_test_top(i_clk_50, o_uart_tx_line);
    input i_clk_50;
    output o_uart_tx_line;

    wire w_clk_20;
    wire w_auto_reset;
    
    pll pll_inst(.inclk0(i_clk_50), .c0(w_clk_20)); 

    auto_reset auto_reset_inst(.clk(w_clk_20), .reset(w_auto_reset));
    
    slip_sender slip_sender_inst(.clk(w_clk_20), .reset(w_auto_reset), 
                                .o_uart_tx_line(o_uart_tx_line));
    
endmodule
