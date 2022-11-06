`include "uart_cfg.vh"

`define SLIP_CHAR_END       8'hC0
`define SLIP_CHAR_ESC       8'hDB
`define SLIP_CHAR_ESC_END   8'hDC
`define SLIP_CHAR_ESC_ESC   8'hDD

`define SLIP_TX_STATE_IDLE         2'd0
`define SLIP_TX_STATE_WAIT         2'd1 
`define SLIP_TX_STATE_DATA         2'd2   
`define SLIP_TX_STATE_STOP_WAIT    2'd3

module slip_tx(clk, reset, 
            i_start, 
            i_end,
            i_tx_dv,
            i_tx_byte,
            o_tx_byte_done, 
            o_uart_line);

    input       clk;
    input       reset;
    input       i_start;
    input       i_end;
    input       i_tx_dv;
    input [7:0] i_tx_byte;

    output reg  o_tx_byte_done = 1'b0;
    output      o_uart_line;

    reg [7:0]   r_uart_tx_byte = 8'h00;
    reg [7:0]   r_prev_byte = 8'h00;
    reg         r_uart_tx_dv = 1'b0;
    reg [1:0]   r_state = `SLIP_TX_STATE_IDLE;

    wire        w_uart_tx_done;

    uart_tx #(.CLKS_PER_BIT(`CLKS_PER_BIT_115200))  tx_inst(.clk(clk), 
                                                        .i_tx_dv(r_uart_tx_dv), 
                                                        .i_tx_byte(r_uart_tx_byte),
                                                        .o_tx_serial(o_uart_line), 
                                                        .o_tx_done(w_uart_tx_done));
    always @(posedge clk) begin
        if (reset) begin
            r_state <= `SLIP_TX_STATE_IDLE;
            r_uart_tx_dv <= 0;
            o_tx_byte_done <= 0;
        end
        else begin
            case (r_state)

                `SLIP_TX_STATE_IDLE: begin
                    if (i_start) begin
                        r_state <= `SLIP_TX_STATE_WAIT;
                        r_uart_tx_byte <= `SLIP_CHAR_END;
                        r_uart_tx_dv <= 1;
                    end
                    else begin
                        r_state <= `SLIP_TX_STATE_IDLE;
                        r_uart_tx_dv <= 0;
                    end
                    o_tx_byte_done <= 0;
                end
                 
                `SLIP_TX_STATE_WAIT: begin
                     if (w_uart_tx_done) begin 
                        if (r_prev_byte == `SLIP_CHAR_END) begin
                            r_uart_tx_byte <= `SLIP_CHAR_ESC_END;
                            r_uart_tx_dv <= 1; 
                            r_prev_byte <= `SLIP_CHAR_ESC_END;
                            r_state <= `SLIP_TX_STATE_WAIT;
                        end 
                        else if (r_prev_byte == `SLIP_CHAR_ESC) begin
                            r_uart_tx_byte <= `SLIP_CHAR_ESC_ESC;
                            r_uart_tx_dv <= 1; 
                            r_prev_byte <= `SLIP_CHAR_ESC_ESC;
                            r_state <= `SLIP_TX_STATE_WAIT;
                        end
                        else begin
                            // The previous byte can be 8'h00, SLIP_CHAR_ESC_END, SLIP_CHAR_ESC_ESC
                            // or some other byte.
                            // We are ready to accept data again
                            r_state <= `SLIP_TX_STATE_DATA;
                            o_tx_byte_done <= 1; 
                        end
                     end
                     else begin
                        // Stay in the same state
                        r_uart_tx_dv <= 0;  
                     end
                end
                
                `SLIP_TX_STATE_DATA: begin
                    // We accept data in this state
                    o_tx_byte_done <= 0;
                    if (i_tx_dv) begin
                        if (i_tx_byte == `SLIP_CHAR_END || i_tx_byte == `SLIP_CHAR_ESC) begin
                            // We need to escape SLIP_CHAR_END and SLIP_CHAR_ESC 
                            r_uart_tx_byte <= `SLIP_CHAR_ESC;
                        end
                        else begin
                            r_uart_tx_byte <= i_tx_byte;
                        end
                        r_prev_byte <= i_tx_byte;
                        r_state <= `SLIP_TX_STATE_WAIT;
                        r_uart_tx_dv <= 1;
                    end
                    else if(i_end) begin
                        r_state <= `SLIP_TX_STATE_STOP_WAIT;
                        r_uart_tx_byte <= `SLIP_CHAR_END;
                        r_uart_tx_dv <= 1;
                    end
                    else begin
                        r_state <= `SLIP_TX_STATE_DATA;
                    end
                end
                
                `SLIP_TX_STATE_STOP_WAIT: begin
                    r_uart_tx_dv <= 0;
                    if (w_uart_tx_done) begin 
                        r_state <= `SLIP_TX_STATE_IDLE;
                        o_tx_byte_done <= 1;
                    end
                    else begin
                        r_state <= `SLIP_TX_STATE_STOP_WAIT;
                    end
                end

                default: begin
                  
                end
            endcase

        end
    end

endmodule