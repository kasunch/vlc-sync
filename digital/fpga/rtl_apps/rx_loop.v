`include "rx.vh"

`define RX_LOOP_STATE_IDLE      2'd0
`define RX_LOOP_STATE_START     2'd1
`define RX_LOOP_STATE_RUN       2'd2

module rx_loop(clk, reset, 
                    i_start,
                    i_rx_in, 
                    o_rx_in_clk,
                    o_rx_sfd,
                    o_rx_active, 
                    o_done);

    parameter WIDTH=10;

    // Input/outputs
    input               clk;
    input               reset;
    input               i_start;
    input [WIDTH-1:0]   i_rx_in;
    output              o_rx_in_clk;
    output              o_rx_sfd;
    output              o_rx_active;
    output reg          o_done = 0;

    // Registers and wires for RX
    reg         r_rx_enable = 0;
    wire        w_rx_event_sig;
    wire [2:0]  w_rx_event;

    reg [1:0] r_state = `RX_LOOP_STATE_IDLE;

    rx rx_inst(.clk(clk), 
                .reset(reset), 
                // RX input
                .i_rx_in(i_rx_in),
                .o_clk(o_rx_in_clk),
                // RX enable(1)/disable(0)
                .i_enable(r_rx_enable),
                // RX events 
                .o_ev(w_rx_event),
                .o_ev_sig(w_rx_event_sig),
                // Status
                .o_sfd(o_rx_sfd),
                .o_active(o_rx_active));

    always @ (posedge clk) begin
        if (reset) begin
            o_done <= 0;
            r_rx_enable <= 0;
            r_state <= `RX_LOOP_STATE_IDLE;
        end
        else begin

            case (r_state)
                `RX_LOOP_STATE_IDLE: begin
                    if (i_start) begin
                        r_state <= `RX_LOOP_STATE_START;
                    end
                    else begin
                        r_state <= `RX_LOOP_STATE_IDLE;
                    end
                end

                `RX_LOOP_STATE_START: begin
                    r_rx_enable <= 1;
                    r_state <= `RX_LOOP_STATE_RUN;
                end

                `RX_LOOP_STATE_RUN: begin
                    if (w_rx_event_sig) begin
                        if (w_rx_event == `RX_EVENT_END) begin
                            o_done <= 1'b1;
                        end
                        else begin
                            // Some other event. 
                            o_done <= 0;
                        end
                    end
                    else begin
                        // Nothing to do
                        o_done <= 0;
                    end
                end

                default: begin
                    // We handled all the states  
                end 
            endcase
        end
    end

endmodule