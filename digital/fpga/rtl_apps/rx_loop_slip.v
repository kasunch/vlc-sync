`include "rx.vh"

`define STATE_RX_WAIT           3'd0
`define STATE_RX_DONE           3'd1
`define STATE_SLIP_TX           3'd2
`define STATE_SLIP_STOP_WAIT    3'd3

module rx_loop_slip(clk, reset, 
                    i_rx_in, 
                    o_done_ind, 
                    o_rx_sfd, 
                    o_uart_tx, 
                    o_clk);

    parameter WIDTH=10;

    // Input/outputs
    input             clk;
    input             reset;
    input [WIDTH-1:0] i_rx_in;

    output reg o_done_ind = 0;
    output reg o_rx_sfd = 0;
    output     o_uart_tx;
    output     o_clk;

    // State
    reg [2:0]   r_state = `STATE_RX_WAIT;

    // Registers and wires for RX
    reg       r_rx_enable = 0;
    reg [6:0] r_rx_buf_r_addr = 0;
    reg [6:0] r_rx_len = 0;

    wire       w_rx_event_sig;
    wire [2:0] w_rx_event;
    wire [7:0] w_rx_buf_byte;

    // Registers and wires for SLIP
    reg       r_slip_start = 1'b0;
    reg       r_slip_end = 1'b0;
    reg       r_slip_byte_w_en = 1'b0;
    reg [7:0] r_slip_byte = 8'h00;

    wire       w_slip_byte_done;

    // Module instances
    slip_tx slip_tx_inst(.clk(clk), .reset(reset),
                            .i_start(r_slip_start),
                            .i_end(r_slip_end),
                            .i_tx_dv(r_slip_byte_w_en),
                            .i_tx_byte(r_slip_byte),
                            .o_tx_byte_done(w_slip_byte_done),
                            .o_uart_line(o_uart_tx));

    rx rx_inst(.clk(clk), 
                .reset(reset), 
                .i_enable(r_rx_enable),
                .i_rx_in(i_rx_in),
                .i_buf_r_addr(r_rx_buf_r_addr),
                .o_buf_r_byte(w_rx_buf_byte),
                .o_ev(w_rx_event),
                .o_ev_sig(w_rx_event_sig),
                .o_clk(o_clk));

    always @ (posedge clk) begin
        if (reset) begin
        end
        else begin
            case (r_state)
                `STATE_RX_WAIT: begin
                    r_rx_enable <= 1; // RX is active
                    if (w_rx_event_sig) begin
                        if (w_rx_event == `RX_EVENT_SFD) begin
                            r_state <= `STATE_RX_WAIT;
                            o_rx_sfd <= 1;
                        end
                        if (w_rx_event == `RX_EVENT_PHR) begin
                            r_state <= `STATE_RX_WAIT;
                            // Set the RX buffer address to zero, so we can 
                            // read the frame length when the reception completed.
                            r_rx_buf_r_addr <= 0;
                        end
                        else if (w_rx_event == `RX_EVENT_END) begin
                            r_state <= `STATE_RX_DONE; 
                            o_rx_sfd <= 0;
                            r_rx_len <= w_rx_buf_byte[6:0];
                        end
                        else begin
                            // Some other status. 
                            r_state <= `STATE_RX_WAIT;
                        end
                    end
                    else begin
                        r_state <= `STATE_RX_WAIT;
                    end
                end

                `STATE_RX_DONE: begin
                    r_rx_enable <= 0;
                    r_state <= `STATE_SLIP_TX;
                    // Data from RX buffer will be available after 2 cycles from 
                    // changing the read address.
                    // However, SLIP sending takes lot more than 2 cycles.
                    // So we do not need additional waiting after changing the
                    // RX buffer read address. 
                    r_rx_buf_r_addr <= 0; 
                    r_slip_start <= 1;
                    r_slip_end <= 0;
                end

                `STATE_SLIP_TX: begin
                    r_slip_start <= 1'b0;
                    if (w_slip_byte_done) begin
                        // We have to iterate (frame length + 1) times since
                        // first byte of the RX buffer is the frame length.
                        if (r_rx_buf_r_addr == r_rx_len + 7'd1) begin
                            // We are done reading rx buffer.
                            r_state <= `STATE_SLIP_STOP_WAIT;
                            // End SLIP frame.
                            r_slip_end <= 1'b1;
                        end
                        else begin
                            r_state <= `STATE_SLIP_TX;
                            r_slip_byte_w_en <= 1'b1;
                            r_slip_byte <= w_rx_buf_byte;
                            // See the above note regarding waiting time
                            // for reading from RX buffer.
                            r_rx_buf_r_addr <= r_rx_buf_r_addr + 7'd1; 
                        end
                    end
                    else begin
                        r_slip_byte_w_en <= 1'b0;
                    end
                end

                `STATE_SLIP_STOP_WAIT: begin  
                    if (w_slip_byte_done) begin
                        r_state <= `STATE_RX_WAIT;
                        o_done_ind <= ~o_done_ind;
                    end
                    else begin
                        r_state <= `STATE_SLIP_STOP_WAIT;
                        r_slip_end <= 1'b0;
                    end
                end

                default: begin
                    // Nothing to be done here
                end

            endcase
          
        end
    end

endmodule