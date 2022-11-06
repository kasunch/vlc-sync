`include "uart_cfg.vh"

`define SLIP_CHAR_END       8'hC0
`define SLIP_CHAR_ESC       8'hDB
`define SLIP_CHAR_ESC_END   8'hDC
`define SLIP_CHAR_ESC_ESC   8'hDD

`define SLIP_RX_STATE_IDLE         2'd0
`define SLIP_RX_STATE_ACTIVE       2'd1   
`define SLIP_RX_STATE_ESCPED       2'd2

module slip_rx(clk, reset, 
            i_uart_line,
            o_rx_started, o_rx_ended, 
            o_rx_byte_done, o_rx_byte);

    input clk;
    input reset;
    input i_uart_line;

    output reg       o_rx_started; // Goes high for one cycle when SLIP start is detected.
    output reg       o_rx_ended; // Goes high for one cycle when SLIP end is detected.
    output reg       o_rx_byte_done; // Goes high for one cycle when a byte is received.
    output reg [7:0] o_rx_byte; // Received byte (only valid at positive edge of o_rx_byte_done).

    reg [1:0]   r_state = `SLIP_RX_STATE_IDLE;

    wire [7:0] w_uart_byte;
    wire       w_uart_done;

    uart_rx #(.CLKS_PER_BIT(`CLKS_PER_BIT_115200))  rx_inst(.clk(clk), 
                                                        .i_rx_line(i_uart_line),
                                                        .o_rx_byte(w_uart_byte),
                                                        .o_rx_done(w_uart_done));

    always @(posedge clk) begin
        if (reset) begin
            r_state <= `SLIP_RX_STATE_IDLE;
            o_rx_started <= 0;
            o_rx_ended <= 0;
            o_rx_byte_done <= 0;
        end
        else begin
            if (w_uart_done) begin
                case (r_state)
                    
                    `SLIP_RX_STATE_IDLE: begin
                        if (w_uart_byte == `SLIP_CHAR_END) begin
                            o_rx_started <= 1;
                            r_state <= `SLIP_RX_STATE_ACTIVE;
                        end
                        else begin
                            // Nothing to do. We wait until SLIP_CHAR_END is
                            // received which marks the start of a SLIP frame. 
                        end
                    end

                    `SLIP_RX_STATE_ACTIVE: begin
                        if (w_uart_byte == `SLIP_CHAR_ESC) begin
                            // Start of the escaped sequence.
                            r_state <= `SLIP_RX_STATE_ESCPED;
                        end
                        else if (w_uart_byte == `SLIP_CHAR_END) begin
                            // End of the SLIP frame.
                            o_rx_ended <= 1;
                            r_state <= `SLIP_RX_STATE_IDLE;  
                        end
                        else begin
                            // Some other byte
                            o_rx_byte_done <= 1;
                            o_rx_byte <= w_uart_byte;  
                        end  
                    end

                    `SLIP_RX_STATE_ESCPED: begin
                        if (w_uart_byte == `SLIP_CHAR_ESC_ESC) begin
                            r_state <= `SLIP_RX_STATE_ACTIVE;
                            o_rx_byte_done <= 1;
                            o_rx_byte <= `SLIP_CHAR_ESC;
                        end
                        else if (w_uart_byte == `SLIP_CHAR_ESC_END) begin
                            r_state <= `SLIP_RX_STATE_ACTIVE;
                            o_rx_byte_done <= 1;
                            o_rx_byte <= `SLIP_CHAR_END;
                        end
                        else begin
                            // Error situation. We are not expecting a
                            // character other than SLIP_CHAR_ESC_ESC or SLIP_CHAR_ESC_END
                            // Go to idle. We also indicate the stop of the frame.
                            r_state <= `SLIP_RX_STATE_IDLE;
                            o_rx_ended <= 1;  
                        end
                    end

                    default: begin
                        // Nothing to do.
                    end
                endcase
            end
            else begin
                o_rx_started <= 0;
                o_rx_ended <= 0;
                o_rx_byte_done <= 0;
            end
        end
    end

endmodule