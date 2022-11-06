`define TOP_STATE_IDLE              4'd0
`define TOP_STATE_INIT_WAIT         4'd1
`define TOP_STATE_LOAD_CFG          4'd2
`define TOP_STATE_LOAD_CFG_WAIT     4'd3
`define TOP_STATE_APP_START         4'd4
`define TOP_STATE_APP_RUN           4'd5

`define TOP_WAIT_CNT_MAX            32'd100000000 // 500 ms with 20 MHz clock

`define APP_TX_ID            8'd1

module dft_dump_top(i_clk_50,
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

    wire w_clk;
    wire w_auto_reset;

    pll pll_inst(.inclk0(i_clk_50), .c0(w_clk)); 

    auto_reset auto_reset_inst(.clk(w_clk), .reset(w_auto_reset));

    idft_gen_slip igs_inst(.clk(w_clk), 
                        .reset(w_auto_reset), 
                        .o_tx_out(o_dac_out),
                        .o_clk(o_dac_clk),
                        .i_uart_rx(i_uart_rx));

    dft_dump_slip dds_inst(.clk(w_clk), 
                        .reset(w_auto_reset), 
                        .i_rx_in(i_adc_in), 
                        .o_clk(o_adc_clk),
                        .o_uart_tx(o_uart_tx));


    // ADC/DAC power lines and clocks
    assign o_adc_pd = 1'b0;
    assign o_dac_pd = 1'b0;
    // LED assignments
    assign o_leds[0] = !i_uart_rx;
    assign o_leds[1] = 0;
    assign o_leds[2] = 0;
    assign o_leds[3] = 0;
    assign o_leds[4] = 0;
    assign o_leds[5] = 0;
    assign o_leds[6] = 0;
    assign o_leds[7] = !o_uart_tx;


endmodule




