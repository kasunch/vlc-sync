`define I2C_EEPROM_STATE_IDLE          3'd0
`define I2C_EEPROM_STATE_SET_ADDR      3'd1
`define I2C_EEPROM_STATE_WRITE         3'd2
`define I2C_EEPROM_STATE_INIT_READ     3'd3
`define I2C_EEPROM_STATE_READ          3'd4
`define I2C_EEPROM_STATE_WAIT_CYCLE    3'd5
`define I2C_EEPROM_STATE_WAIT_END      3'd6

module i2c_eeprom(clk, reset,
            // module interface
            i_start,    // Start operation
            i_mode,     // 0: read, 1:write
            i_dev_addr, // I2C device address
            i_page_addr, // I2C device address
            i_page_b0, i_page_b1, i_page_b2, i_page_b3, i_page_b4, i_page_b5, i_page_b6, i_page_b7,
            o_page_b0, o_page_b1, o_page_b2, o_page_b3, o_page_b4, o_page_b5, o_page_b6, o_page_b7,
            o_done,
            o_busy,
            // I2C interface
            i_sda,
            o_sda,
            t_sda,
            i_scl,
            o_scl,
            t_scl,
            i_prescale);

    input       clk;
    input       reset;
    // module interface
    input            i_start;
    input            i_mode;
    input [6:0]      i_dev_addr; 
    input [7:0]      i_page_addr;           
    input [7:0]      i_page_b0, i_page_b1, i_page_b2, i_page_b3, i_page_b4, i_page_b5, i_page_b6, i_page_b7;
    output[7:0]      o_page_b0, o_page_b1, o_page_b2, o_page_b3, o_page_b4, o_page_b5, o_page_b6, o_page_b7;
    output reg       o_done = 0;
    output           o_busy;
    // I2C interface
    input            i_sda;
    output           o_sda;
    output           t_sda;
    input            i_scl;
    output           o_scl;
    output           t_scl;
    // Clock prescale
    input [15:0]     i_prescale;

    // Registers and wires for i2c master module
    reg         r_i2c_cmd_write = 0;   // Write single byte
    reg         r_i2c_cmd_write_m = 0; // Write multiple bytes
    reg         r_i2c_cmd_read_m = 0;  // Read multiple bytes
    reg         r_i2c_cmd_valid = 0;   // Indicate when the command is valid
    reg         r_i2c_set_stop_at_end = 0;
    reg [7:0]   r_i2c_data_in;
    reg         r_i2c_data_in_valid = 0;
    reg         r_i2c_data_in_last = 0;
    reg         r_i2c_data_out_ready = 0;

    wire        w_i2c_cmd_ready; 
    wire        w_i2c_data_in_ready; 
    wire [7:0]  w_i2c_data_out;
    wire        w_i2c_data_out_valid;
    wire        w_i2c_data_out_last;
    wire        w_i2c_bus_control;
    wire        w_i2c_missed_ack;

    // Other internal registers and wires
    reg         r_mode = 0;
    reg [6:0]   r_i2c_dev_addr = 0;
    reg [7:0]   r_i2c_mem_addr = 0;
    reg [7:0]   r_page_bytes [7:0];
    reg [2:0]   r_state = `I2C_EEPROM_STATE_IDLE;
    reg [2:0]   r_nxt_state = `I2C_EEPROM_STATE_IDLE;
    reg [7:0]   r_byte_idx = 0;

    i2c_master i2c_inst (.clk(clk), .rst(reset),
                        .cmd_address(r_i2c_dev_addr),
                        //.cmd_start(cmd_start),
                        .cmd_read(r_i2c_cmd_read_m),
                        .cmd_write(r_i2c_cmd_write),
                        .cmd_write_multiple(r_i2c_cmd_write_m),
                        .cmd_stop(r_i2c_set_stop_at_end),
                        .cmd_valid(r_i2c_cmd_valid),
                        .cmd_ready(w_i2c_cmd_ready),
                        .data_in(r_i2c_data_in),
                        .data_in_valid(r_i2c_data_in_valid),
                        .data_in_ready(w_i2c_data_in_ready),
                        .data_in_last(r_i2c_data_in_last),
                        .data_out(w_i2c_data_out),
                        .data_out_valid(w_i2c_data_out_valid),
                        .data_out_ready(r_i2c_data_out_ready),
                        .data_out_last(w_i2c_data_out_last),
                        .scl_i(i_scl),
                        .scl_o(o_scl),
                        .scl_t(t_scl),
                        .sda_i(i_sda),
                        .sda_o(o_sda),
                        .sda_t(t_sda),
                        .busy(o_busy),
                        .bus_control(w_i2c_bus_control),
                        //.bus_active(bus_active),
                        .missed_ack(w_i2c_missed_ack),
                        .prescale(i_prescale));
                        //.stop_on_idle(stop_on_idle));

    assign o_page_b0 = r_page_bytes[0];
    assign o_page_b1 = r_page_bytes[1];
    assign o_page_b2 = r_page_bytes[2];
    assign o_page_b3 = r_page_bytes[3];
    assign o_page_b4 = r_page_bytes[4];
    assign o_page_b5 = r_page_bytes[5];
    assign o_page_b6 = r_page_bytes[6];
    assign o_page_b7 = r_page_bytes[7];

    always @ (posedge clk) begin
        if (reset) begin
            r_state <= `I2C_EEPROM_STATE_IDLE;
            r_nxt_state <= `I2C_EEPROM_STATE_IDLE;
            r_i2c_cmd_write <= 0;
            r_i2c_cmd_write_m <= 0;
            r_i2c_cmd_read_m <= 0;
            r_i2c_cmd_valid <= 0;
            r_i2c_set_stop_at_end <= 0;
            r_i2c_data_in_valid <= 0;
            r_i2c_data_in_last <= 0;
            r_i2c_data_out_ready <= 0;
            r_byte_idx <= 0;
            o_done <= 0;
        end
        else begin
            case (r_state)
                `I2C_EEPROM_STATE_IDLE: begin
                    if (i_start) begin
                        if (w_i2c_cmd_ready) begin
                            if (i_mode) begin
                                // We write multiple bytes followed by the memory address byte.
                                // We indicate the stop condition now. 
                                // After writing all bytes, the stop condition is set.
                                r_i2c_cmd_write <= 0;
                                r_i2c_cmd_write_m <= 1'b1;
                                r_i2c_set_stop_at_end <= 1'b1;
                            end
                            else begin
                                // We write only the memory address byte to set the starting address. 
                                // We don't indicate the stop condition now since we are going to read 
                                // afterwards.  
                                r_i2c_cmd_write <= 1'b1;
                                r_i2c_cmd_write_m <= 0;
                                r_i2c_set_stop_at_end <= 1'b0;
                            end
                            r_i2c_cmd_read_m <= 0;
                            r_i2c_cmd_valid <= 1'b1;
                            r_i2c_data_in_valid <= 0;
                            r_i2c_data_in_last <= 0;
                            r_i2c_data_out_ready <= 0;
                            r_byte_idx <= 0;
                            r_mode <= i_mode;
                            r_i2c_dev_addr <= i_dev_addr;
                            r_i2c_mem_addr <= i_page_addr;

                            r_page_bytes[0] <= i_page_b0;
                            r_page_bytes[1] <= i_page_b1;
                            r_page_bytes[2] <= i_page_b2;
                            r_page_bytes[3] <= i_page_b3;
                            r_page_bytes[4] <= i_page_b4;
                            r_page_bytes[5] <= i_page_b5;
                            r_page_bytes[6] <= i_page_b6;
                            r_page_bytes[7] <= i_page_b7;

                            r_state <= `I2C_EEPROM_STATE_WAIT_CYCLE;
                            r_nxt_state <= `I2C_EEPROM_STATE_SET_ADDR;
                        end
                        else begin
                            r_state <= `I2C_EEPROM_STATE_IDLE;
                        end
                    end
                    else begin
                        r_state <= `I2C_EEPROM_STATE_IDLE;
                    end
                    o_done <= 0;
                end 

                `I2C_EEPROM_STATE_SET_ADDR: begin
                    if (w_i2c_data_in_ready) begin
                        r_i2c_data_in <= r_i2c_mem_addr;
                        r_i2c_data_in_valid <= 1'b1;
                        r_state <= `I2C_EEPROM_STATE_WAIT_CYCLE;
                        if (r_mode) begin
                            r_nxt_state <= `I2C_EEPROM_STATE_WRITE;  
                        end
                        else begin
                            r_nxt_state <= `I2C_EEPROM_STATE_INIT_READ;
                        end

                    end
                    else begin
                        r_state <= `I2C_EEPROM_STATE_SET_ADDR;      
                    end
                end

                `I2C_EEPROM_STATE_WRITE: begin
                    if (w_i2c_data_in_ready) begin
                        if (r_byte_idx == 7) begin
                            // This is the last byte we are going to write
                            // So, indicate the stopping condition. 
                            // Stop condition is set after writing the byte.
                            r_i2c_data_in_last <= 1'b1;
                            r_i2c_cmd_valid <= 0;
                            r_nxt_state <= `I2C_EEPROM_STATE_WAIT_END;
                        end
                        else begin
                            r_i2c_data_in_last <= 0;
                            r_byte_idx <= r_byte_idx + 8'd1;
                            r_nxt_state <= `I2C_EEPROM_STATE_WRITE;
                        end
                        r_i2c_data_in_valid <= 1'b1;
                        r_i2c_data_in <= r_page_bytes[r_byte_idx];
                        r_state <= `I2C_EEPROM_STATE_WAIT_CYCLE;
                    end
                    else begin
                        r_i2c_data_in_valid <= 0;
                        r_state <= `I2C_EEPROM_STATE_WRITE;
                    end
                end

                `I2C_EEPROM_STATE_INIT_READ: begin
                    if (w_i2c_cmd_ready) begin
                        // Ready to accept a new command. Issue the read command
                        r_i2c_cmd_write <= 0;
                        r_i2c_cmd_write_m <= 0;
                        r_i2c_cmd_read_m <= 1'b1;
                        r_i2c_cmd_valid <= 1'b1;
                        r_i2c_data_in_last <= 0;
                        r_i2c_set_stop_at_end <= 0;
                        r_i2c_data_out_ready <= 1'b1;
                        r_byte_idx <= 0;
                        r_state <= `I2C_EEPROM_STATE_READ;
                    end
                    else begin
                        r_i2c_cmd_valid <= 0;
                        r_i2c_data_in_valid <= 0;
                        r_state <= `I2C_EEPROM_STATE_INIT_READ;
                    end
                end

                `I2C_EEPROM_STATE_READ: begin
                    if (w_i2c_data_out_valid) begin
                        // Output data is valid
                        if (r_byte_idx == 7) begin
                            // Last byte
                            r_i2c_cmd_valid <= 0;
                            r_i2c_set_stop_at_end <= 1'b1;
                            r_state <= `I2C_EEPROM_STATE_WAIT_END;
                        end
                        else if (r_byte_idx == 6) begin
                            // Next byte is the last byte we are going to read.
                            // We indicate the stop condition now. 
                            // So set the stop condition after reading.
                            r_i2c_set_stop_at_end <= 1'b1;
                            r_state <= `I2C_EEPROM_STATE_READ;  
                        end
                        else begin
                            r_i2c_set_stop_at_end <= 0;
                            r_state <= `I2C_EEPROM_STATE_READ;
                        end
                        r_page_bytes[r_byte_idx] <= w_i2c_data_out;
                        r_byte_idx <= r_byte_idx + 8'd1;
                    end
                    else begin
                        r_state <= `I2C_EEPROM_STATE_READ;
                    end
                end

                `I2C_EEPROM_STATE_WAIT_CYCLE: begin
                    r_state <= r_nxt_state;
                    r_nxt_state <= `I2C_EEPROM_STATE_IDLE;
                end

                `I2C_EEPROM_STATE_WAIT_END: begin
                    if (w_i2c_cmd_ready) begin
                        o_done <= 1'b1;
                        r_i2c_cmd_valid <= 0;
                        r_i2c_cmd_write <= 0;
                        r_i2c_cmd_write_m <= 0;
                        r_i2c_cmd_read_m <= 0;
                        r_i2c_data_in_valid <= 0;
                        r_i2c_data_out_ready <= 0;
                        r_i2c_set_stop_at_end <= 0;
                        r_state <= `I2C_EEPROM_STATE_IDLE;
                    end
                    else begin
                        r_state <= `I2C_EEPROM_STATE_WAIT_END;   
                    end
                end

                default: begin
                    // We handled all the states. So nothing to be done 
                end 
            endcase
        end
    end
endmodule