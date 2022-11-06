`include "tx.vh"

`define STATE_WAIT_SLIP_RX      2'd0
`define STATE_SLIP_DATA         2'd1
`define STATE_TX                2'd2

module tx_loop_slip(clk, reset, 
                    i_uart_rx, 
                    o_tx_ind, 
                    o_tx_sfd, 
                    o_tx_out, 
                    o_clk);
    
    parameter WIDTH=10, PLD_LEN=7'd4;

    input clk;
    input reset;
    input i_uart_rx;

    output reg         o_tx_ind = 0;
    output reg         o_tx_sfd = 0;
    output [WIDTH-1:0] o_tx_out;
    output             o_clk;

    // Registers and wires for TX 
    reg       r_tx_start = 0;
    reg       r_tx_buf_w_en = 0;
    reg [6:0] r_tx_buf_w_addr = 7'h00;
    reg [7:0] r_tx_buf_byte = 8'h00;

    wire        w_tx_ev_sig;
    wire [2:0]  w_tx_ev;

    // Registers and wires for SLIP RX
    wire       w_slip_rx_started;
    wire       w_slip_rx_ended;
    wire       w_slip_rx_byte_done;
    wire [7:0] w_slip_rx_byte;

    // Module registers and wires
    reg [6:0] r_slip_rx_cnt = 7'h00;
    reg [1:0] r_state = `STATE_WAIT_SLIP_RX;

    tx tx_inst(.clk(clk), .reset(reset), 
                .i_start(r_tx_start),
                .i_buf_w_en(r_tx_buf_w_en), 
                .i_buf_w_addr(r_tx_buf_w_addr), 
                .i_buf_byte(r_tx_buf_byte), 
                .o_ev(w_tx_ev), 
                .o_ev_sig(w_tx_ev_sig), 
                .o_tx_out(o_tx_out),
                .o_clk(o_clk));

    slip_rx rx_inst(.clk(clk), .reset(reset),
                    .i_uart_line(i_uart_rx),
                    .o_rx_started(w_slip_rx_started), 
                    .o_rx_ended(w_slip_rx_ended), 
                    .o_rx_byte_done(w_slip_rx_byte_done), 
                    .o_rx_byte(w_slip_rx_byte));

    always @ (posedge clk) begin
        if (reset) begin
          
        end
        else begin

            case (r_state)

                `STATE_WAIT_SLIP_RX: begin
                    r_tx_start <= 1'b0;
                    r_tx_buf_w_en <= 1'b0;
                    r_slip_rx_cnt <= 7'd0;

                    if (w_slip_rx_started)
                        r_state <= `STATE_SLIP_DATA;
                    else
                        r_state <= `STATE_WAIT_SLIP_RX;
                end

                `STATE_SLIP_DATA: begin
                    if (w_slip_rx_byte_done) begin
                        r_state <= `STATE_SLIP_DATA;
                        r_tx_buf_byte <= w_slip_rx_byte;
                        r_tx_buf_w_addr <= r_slip_rx_cnt;
                        r_tx_buf_w_en <= 1'b1;
                        r_slip_rx_cnt <= r_slip_rx_cnt + 7'd1;
                    end
                    else if (w_slip_rx_ended) begin
                        r_state <= `STATE_TX;
                        r_tx_buf_w_en <= 1'b0;
                        r_tx_start <= 1'b1;
                    end
                    else begin
                        r_state <= `STATE_SLIP_DATA;
                        r_tx_buf_w_en <= 1'b0;
                    end
                end

                `STATE_TX: begin
                    r_tx_start <= 1'b0;
                    if (w_tx_ev_sig) begin
                        if (w_tx_ev == `TX_EVENT_SFD) begin
                            r_state <= `STATE_TX;
                            o_tx_sfd <= 1;
                        end
                        else if (w_tx_ev == `TX_EVENT_END) begin
                            // Transmission completed. Ready to receive new data via SLIP
                            r_state <= `STATE_WAIT_SLIP_RX;  
                            o_tx_ind <= ~o_tx_ind;
                            o_tx_sfd <= 0;
                        end
                        else begin
                            // Some other TX event
                            r_state <= `STATE_TX;  
                        end
                    end
                    else begin
                        r_state <= `STATE_TX;
                    end
                end

                default: begin
                    // Nothing to do
                end
            endcase

        end
    end

endmodule