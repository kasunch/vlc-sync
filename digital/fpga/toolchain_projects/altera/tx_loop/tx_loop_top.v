
module tx_loop_top(i_clk_50, o_dac_clk, o_dac_pd, o_dac_out, o_tx_done, o_tx_sfd);

    parameter WIDTH=10;

    input i_clk_50;

    output [WIDTH-1:0] o_dac_out;
    output o_tx_done;
    output o_tx_sfd;
    output o_dac_clk;
    output o_dac_pd;

    wire w_clk_20;
    wire w_auto_reset;
    
    pll pll_inst(.inclk0(i_clk_50), .c0(w_clk_20)); 

    auto_reset auto_reset_inst(.clk(w_clk_20), .reset(w_auto_reset));

    tx_loop tx_loop_inst(.clk(w_clk_20), .reset(w_auto_reset), 
                         .o_tx_ind(o_tx_done), .o_tx_sfd(o_tx_sfd), 
                         .o_tx_out(o_dac_out), .o_clk(o_dac_clk));
                         
    assign o_dac_pd = 1'b0;
              

endmodule








