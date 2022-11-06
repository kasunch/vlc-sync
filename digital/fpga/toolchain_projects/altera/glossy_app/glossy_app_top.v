`define TOP_STATE_IDLE              4'd0
`define TOP_STATE_INIT_WAIT         4'd1
`define TOP_STATE_LOAD_CFG          4'd2
`define TOP_STATE_LOAD_CFG_WAIT     4'd3
`define TOP_STATE_APP_START         4'd4
`define TOP_STATE_APP_RUN           4'd5

`define TOP_WAIT_CNT_MAX            32'd200000000 // 500 ms with 40 MHz clock
`define APP_INITIATOR_ID            8'd1

`define T_GLOSSY_SLOT               32'd800000 // 20 ms with 40 MHz clock
`define T_GLOSSY_PERIOD             32'd20000000 // 500 ms with 40 MHz clock

module glossy_app_top(i_clk_50, 
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
                        o_leds
                        // Other debug lines
                        );

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

    // Registers and wires for i2c_cfg
    reg        r_eeprom_start = 0;
    wire       w_eeprom_done;
    wire       w_eeprom_busy;
    wire       w_eeprom_scl_i;
    wire       w_eeprom_scl_o;
    wire       w_eeprom_scl_t;
    wire       w_eeprom_sda_i;
    wire       w_eeprom_sda_o;
    wire       w_eeprom_sda_t;
    reg  [7:0] r_page_addr = 0;
    wire [7:0] w_page_bytes [7:0]; 

    // Registers and wires for Glossy App
    reg        r_app_start = 0;
    reg        r_app_mode = 0; // 0 receiver, 1 initiator
    reg        r_cfg_load_status = 0;
    reg [7:0]  r_node_id = 0;
    wire       w_tx_active;
    wire       w_rx_active;

    reg [3:0]  r_state = `TOP_STATE_IDLE;
    reg [31:0] r_wait_cnt = 0;

    pll pll_inst(.inclk0(i_clk_50), .c0(w_clk_20)); 

    //assign w_clk_20 = i_clk_50;

    auto_reset auto_reset_inst(.clk(w_clk_20), .reset(w_auto_reset));

    i2c_eeprom eeprom(.clk(w_clk_20), 
                    .reset(w_auto_reset),
                    .i_start(r_eeprom_start),   
                    .i_mode(0),     
                    .i_dev_addr(7'h50),
                    .i_page_addr(8'h00),  
                    .o_page_b0(w_page_bytes[0]), 
                    .o_page_b1(w_page_bytes[1]), 
                    .o_page_b2(w_page_bytes[2]), 
                    .o_page_b3(w_page_bytes[3]), 
                    .o_page_b4(w_page_bytes[4]), 
                    .o_page_b5(w_page_bytes[5]), 
                    .o_page_b6(w_page_bytes[6]), 
                    .o_page_b7(w_page_bytes[7]),
                    .o_done(w_eeprom_done),
                    .o_busy(w_eeprom_busy),
                    // I2C interface
                    .i_sda(w_eeprom_sda_i),
                    .o_sda(w_eeprom_sda_o),
                    .t_sda(w_eeprom_sda_t),
                    .i_scl(w_eeprom_scl_i),
                    .o_scl(w_eeprom_scl_o),
                    .t_scl(w_eeprom_scl_t),
                    .i_prescale(16'd1000)); // We derive 40 KHz from 40 MHz clock

    glossy_app app_inst(.clk(w_clk_20), .reset(w_auto_reset), 
                        .i_start(r_app_start),
                        .i_mode(r_app_mode),
                        // TX/RX lines
                        .i_rx_in(i_adc_in),
                        .o_rx_in_clk(o_adc_clk),
                        .o_tx_out(o_dac_out),
                        .o_tx_out_clk(o_dac_clk),
                        //.o_rx_sfd(o_rx_sfd),
                        //.o_tx_sfd(o_tx_sfd),
                        .o_sync_ind(o_tx_sfd),
                        //.o_rx_sfd(o_tx_sfd),
                        .o_rx_active(w_rx_active),
                        .o_tx_active(w_tx_active));

    // I2C assignments
    assign w_eeprom_scl_i = io_scl;
    assign io_scl = w_eeprom_scl_t ? 1'bz : w_eeprom_scl_o;
    assign w_eeprom_sda_i = io_sda;
    assign io_sda = w_eeprom_sda_t ? 1'bz : w_eeprom_sda_o;
    // ADC/DAC power lines
    assign o_adc_pd = 1'b0;
    assign o_dac_pd = 1'b0;
    // LED assignments
    assign o_leds[0] = w_tx_active;
    assign o_leds[1] = w_rx_active;
    assign o_leds[2] = 0;
    assign o_leds[3] = 0;
    assign o_leds[4] = 0;
    assign o_leds[5] = 0;
    assign o_leds[6] = r_cfg_load_status;
    assign o_leds[7] = r_app_mode;

    always @ (posedge w_clk_20) begin
        if (w_auto_reset) begin
            r_state <= `TOP_STATE_INIT_WAIT;
            r_wait_cnt <= 0;
            r_eeprom_start <= 0;
            r_app_mode <= 0;
            r_cfg_load_status <= 0;
            r_node_id <= 0;
        end
        else begin
            case (r_state)
                `TOP_STATE_IDLE: begin
                    r_wait_cnt <= 0;
                    r_eeprom_start <= 0;
                    r_state <= `TOP_STATE_IDLE;
                end

                `TOP_STATE_INIT_WAIT: begin
                    if (r_wait_cnt < `TOP_WAIT_CNT_MAX) begin
                        r_wait_cnt <= r_wait_cnt + 32'd1;  
                        r_state <= `TOP_STATE_INIT_WAIT;
                    end
                    else begin
                        r_state <= `TOP_STATE_LOAD_CFG;  
                    end
                end

                `TOP_STATE_LOAD_CFG: begin
                    if (!w_eeprom_busy) begin
                        r_eeprom_start <= 1'b1;
                        r_cfg_load_status <= 1'b1;
                        r_state <= `TOP_STATE_LOAD_CFG_WAIT;
                    end
                    else begin
                        r_state <= `TOP_STATE_LOAD_CFG;  
                    end
                end

                `TOP_STATE_LOAD_CFG_WAIT: begin
                    r_eeprom_start <= 0;
                    if (w_eeprom_done) begin
                        r_cfg_load_status <= 0;
                        r_node_id <= w_page_bytes[0];
                        r_state <= `TOP_STATE_APP_START;
                    end
                    else begin
                        r_cfg_load_status <= 1'b1;
                        r_state <= `TOP_STATE_LOAD_CFG;  
                    end
                end

                `TOP_STATE_APP_START: begin
                    if (r_node_id == `APP_INITIATOR_ID) begin
                        r_app_mode <= 1'b1;
                    end
                    else begin
                        r_app_mode <= 0;
                    end
                    r_app_start <= 1'b1;
                    r_state <= `TOP_STATE_APP_RUN;
                end

                `TOP_STATE_APP_RUN: begin
                  
                end

                default: begin
                    // We handled all the states
                end 
            endcase
        end
    end

endmodule