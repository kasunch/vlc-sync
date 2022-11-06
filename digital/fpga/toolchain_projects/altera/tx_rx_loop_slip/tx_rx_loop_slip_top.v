
module tx_rx_loop_slip_top(i_clk_50, 
                            // ADC/DAC lines
                            i_adc_in, 
                            o_dac_out,
                            o_adc_pd,
                            o_dac_pd,
                            o_adc_clk,
                            o_dac_clk,
                            // TX/RX status lines 
                            o_tx_sfd,
                            o_rx_sfd,
                            // UART TX/RX lines
                            i_uart_rx,
                            o_uart_tx,
                            // I2C lines
                            io_scl,
                            io_sda,
                            // LEDs
                            o_leds);

    parameter WIDTH=10;

    input               i_clk_50;
    // ADC/DAC lines
    input [WIDTH-1:0]   i_adc_in;
    output [WIDTH-1:0]  o_dac_out;
    output              o_adc_pd;
    output              o_dac_pd;
    output              o_adc_clk;
    output              o_dac_clk;
    // TX/RX status lines 
    output              o_tx_sfd;
    output              o_rx_sfd;
    // UART TX/RX lines
    input               i_uart_rx;
    output              o_uart_tx;
    // I2C lines
    inout               io_scl;
    inout               io_sda;
    // LEDs
    output [7:0]        o_leds; 
    // Other debug lines

    wire w_clk_20;
    wire w_auto_reset;
    wire w_rx_done;
    wire w_tx_done;
    
    pll pll_inst(.inclk0(i_clk_50), .c0(w_clk_20)); 

    auto_reset auto_reset_inst(.clk(w_clk_20), .reset(w_auto_reset));

    tx_loop_slip tx_loop_inst(.clk(w_clk_20), 
                                .reset(w_auto_reset), 
                                .i_uart_rx(i_uart_rx),
                                .o_tx_sfd(o_tx_sfd),
                                .o_tx_ind(w_tx_done), 
                                .o_tx_out(o_dac_out),
                                .o_clk(o_dac_clk));

    rx_loop_slip rx_loop_inst(.clk(w_clk_20), 
                                .reset(w_auto_reset), 
                                .i_rx_in(i_adc_in),
                                .o_clk(o_adc_clk),
                                .o_rx_sfd(o_rx_sfd),
                                .o_done_ind(w_rx_done),
                                .o_uart_tx(o_uart_tx));
              

    // ADC/DAC power lines
    assign o_adc_pd = 1'b0;
    assign o_dac_pd = 1'b0;
    // LED assignments
    assign o_leds[0] = w_rx_done;
    assign o_leds[1] = 0;
    assign o_leds[2] = 0;
    assign o_leds[3] = 0;
    assign o_leds[4] = 0;
    assign o_leds[5] = 0;
    assign o_leds[6] = 0;
    assign o_leds[7] = w_tx_done;

endmodule




