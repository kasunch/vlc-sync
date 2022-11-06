`define LOAD_STATE_WAIT_SLIP_RX     4'd0
`define LOAD_STATE_SLIP_DATA        4'd1
`define LOAD_STATE_CFG_EXEC         4'd2
`define LOAD_STATE_START_WRITE      4'd3
`define LOAD_STATE_START_READ       4'd4
`define LOAD_STATE_START_WRITE_WAIT 4'd5
`define LOAD_STATE_START_READ_WAIT  4'd6
`define LOAD_STATE_SLIP_TX          4'd7
`define LOAd_STATE_SLIP_STOP_WAIT   4'd8

module eeprom_rw_top(i_clk_50, 
                        i_uart_rx, 
                        o_uart_tx,
                        io_scl,
                        io_sda,
                        o_ind);

    input       i_clk_50;
    input       i_uart_rx;
    output      o_uart_tx;
    inout       io_scl;
    inout       io_sda;
    output reg  o_ind = 0;

    // Registers and wires for SLIP RX
    wire       w_slip_rx_started;
    wire       w_slip_rx_ended;
    wire       w_slip_rx_byte_done;
    wire [7:0] w_slip_rx_byte;

    // Registers and wires for SLIP TX
    reg       r_slip_tx_start = 0;
    reg       r_slip_tx_end = 0;
    reg       r_slip_tx_byte_w_en = 0;
    reg [7:0] r_slip_tx_byte = 0;
    wire      w_slip_tx_byte_done;

    // Registers and wires for auto_reset
    wire w_clk_20;
    wire w_auto_reset;

    // Registers and wires for i2c_cfg
    reg        r_rw_start = 0;
    reg        r_rw_mode = 0;
    wire       w_eeprom_done;
    wire       w_eeprom_busy;
    wire       w_eeprom_scl_i;
    wire       w_eeprom_scl_o;
    wire       w_eeprom_scl_t;
    wire       w_eeprom_sda_i;
    wire       w_eeprom_sda_o;
    wire       w_eeprom_sda_t;

    reg  [7:0] r_page_addr = 0;
    reg  [7:0] r_cmd_frame [9:0]; // First byte indicates if it is write or read
    wire [7:0] w_page_bytes [7:0]; 

    // Other registers
    reg [4:0] r_slip_byte_idx = 0;
    reg [3:0] r_state = `LOAD_STATE_WAIT_SLIP_RX;

    wire clk;
    wire reset;

    pll pll_inst(.inclk0(i_clk_50), .c0(w_clk_20)); 

    auto_reset auto_reset_inst(.clk(w_clk_20), .reset(w_auto_reset));

    slip_rx slip_rx_inst(.clk(clk), .reset(reset),
                        .i_uart_line(i_uart_rx),
                        .o_rx_started(w_slip_rx_started), 
                        .o_rx_ended(w_slip_rx_ended), 
                        .o_rx_byte_done(w_slip_rx_byte_done), 
                        .o_rx_byte(w_slip_rx_byte));

    slip_tx slip_tx_inst(.clk(clk), .reset(reset),
                            .i_start(r_slip_tx_start),
                            .i_end(r_slip_tx_end),
                            .i_tx_dv(r_slip_tx_byte_w_en),
                            .i_tx_byte(r_slip_tx_byte),
                            .o_tx_byte_done(w_slip_tx_byte_done),
                            .o_uart_line(o_uart_tx));

    i2c_eeprom eeprom(.clk(clk), 
                    .reset(reset),
                    .i_start(r_rw_start),   
                    .i_mode(r_rw_mode),     
                    .i_dev_addr(7'h50),
                    .i_page_addr(r_page_addr),  
                    .i_page_b0(r_cmd_frame[2]), 
                    .i_page_b1(r_cmd_frame[3]), 
                    .i_page_b2(r_cmd_frame[4]), 
                    .i_page_b3(r_cmd_frame[5]), 
                    .i_page_b4(r_cmd_frame[6]), 
                    .i_page_b5(r_cmd_frame[7]), 
                    .i_page_b6(r_cmd_frame[8]), 
                    .i_page_b7(r_cmd_frame[9]),
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
                    .i_prescale(16'h0028));

    assign clk = w_clk_20;
    assign reset = w_auto_reset;

    assign w_eeprom_scl_i = io_scl;
    assign io_scl = w_eeprom_scl_t ? 1'bz : w_eeprom_scl_o;
    assign w_eeprom_sda_i = io_sda;
    assign io_sda = w_eeprom_sda_t ? 1'bz : w_eeprom_sda_o;

    always @ (posedge clk) begin
        if (reset) begin
            r_state <= `LOAD_STATE_WAIT_SLIP_RX;
            o_ind <= 0;
        end
        else begin
            case (r_state)
                `LOAD_STATE_WAIT_SLIP_RX: begin
                    r_rw_start <= 0;
                    r_rw_mode <= 0;
                    r_slip_byte_idx <= 0;
                    if (w_slip_rx_started) begin
                        o_ind <= 1'b1;
                        r_state <= `LOAD_STATE_SLIP_DATA;
                    end
                    else begin
                        r_state <= `LOAD_STATE_WAIT_SLIP_RX;
                    end
                end

                `LOAD_STATE_SLIP_DATA: begin
                    if (w_slip_rx_byte_done) begin
                        if (r_slip_byte_idx < 10) begin
                            r_cmd_frame[r_slip_byte_idx] <= w_slip_rx_byte;
                            r_slip_byte_idx <= r_slip_byte_idx + 4'd1;
                        end
                        else begin
                            // We read only 10 bytes via SLIP
                        end
                        r_state <= `LOAD_STATE_SLIP_DATA;
                    end
                    else if (w_slip_rx_ended) begin
                        if (r_cmd_frame[0] == 8'h00) begin
                            r_state <= `LOAD_STATE_START_READ; 
                            r_page_addr <= r_cmd_frame[1]; 
                        end
                        else if (r_cmd_frame[0] == 8'h01) begin
                            r_state <= `LOAD_STATE_START_WRITE; 
                            r_page_addr <= r_cmd_frame[1];
                        end
                        else begin
                            // Some known command
                            r_state <= `LOAD_STATE_WAIT_SLIP_RX;
                        end
                    end
                    else begin
                        r_state <= `LOAD_STATE_SLIP_DATA;
                    end
                end

                `LOAD_STATE_START_WRITE: begin
                    if (!w_eeprom_busy) begin
                        r_rw_start <= 1'b1;
                        r_rw_mode <= 1'b1;
                        r_state <= `LOAD_STATE_START_WRITE_WAIT;
                    end
                    else begin
                        r_state <= `LOAD_STATE_START_WRITE;  
                    end
                end

                `LOAD_STATE_START_WRITE_WAIT: begin
                    r_rw_mode <= 0;
                    r_rw_start <= 0;
                    if (w_eeprom_done) begin
                        o_ind <= 0;
                        r_state <= `LOAD_STATE_WAIT_SLIP_RX;
                    end
                    else begin
                        r_state <= `LOAD_STATE_START_WRITE_WAIT;
                    end 
                end

                `LOAD_STATE_START_READ: begin
                    if (!w_eeprom_busy) begin
                        r_rw_start <= 1'b1;
                        r_rw_mode <= 1'b0;
                        r_state <= `LOAD_STATE_START_READ_WAIT;
                    end
                    else begin
                        r_state <= `LOAD_STATE_START_READ;  
                    end
                end

                `LOAD_STATE_START_READ_WAIT: begin
                    r_rw_start <= 0;
                    r_rw_mode <= 0;
                    if (w_eeprom_done) begin
                        r_cmd_frame[0] <= 8'hff;
                        r_cmd_frame[1] <= r_page_addr;
                        r_cmd_frame[2] <= w_page_bytes[0];
                        r_cmd_frame[3] <= w_page_bytes[1];
                        r_cmd_frame[4] <= w_page_bytes[2];
                        r_cmd_frame[5] <= w_page_bytes[3];
                        r_cmd_frame[6] <= w_page_bytes[4];
                        r_cmd_frame[7] <= w_page_bytes[5];
                        r_cmd_frame[8] <= w_page_bytes[6];
                        r_cmd_frame[9] <= w_page_bytes[7];
                        r_slip_byte_idx <= 0;
                        r_slip_tx_start <= 1'b1;
                        r_state <= `LOAD_STATE_SLIP_TX;
                    end
                    else begin
                        r_state <= `LOAD_STATE_START_READ_WAIT; 
                    end
                end

                `LOAD_STATE_SLIP_TX: begin
                    r_slip_tx_start <= 0;
                    if (w_slip_tx_byte_done) begin
                        if (r_slip_byte_idx < 10) begin
                            r_slip_tx_byte_w_en <= 1'b1;
                            r_slip_tx_byte <= r_cmd_frame[r_slip_byte_idx];
                            r_slip_byte_idx <= r_slip_byte_idx + 4'd1;
                            r_state <= `LOAD_STATE_SLIP_TX;
                        end
                        else begin
                            r_slip_tx_end <= 1'b1;
                            r_state <= `LOAd_STATE_SLIP_STOP_WAIT;
                        end  
                    end
                    else begin
                        r_slip_tx_byte_w_en <= 0;
                        r_state <= `LOAD_STATE_SLIP_TX;
                    end
                end

                `LOAd_STATE_SLIP_STOP_WAIT: begin
                    o_ind <= 0;
                    r_slip_tx_end <= 0;
                    if (w_slip_tx_byte_done) begin
                        r_state <= `LOAD_STATE_WAIT_SLIP_RX;  
                    end
                    else begin
                        r_state <= `LOAd_STATE_SLIP_STOP_WAIT;
                    end  
                end

                default: begin
                    // Nothing to do
                end
            endcase
        end
    end

endmodule