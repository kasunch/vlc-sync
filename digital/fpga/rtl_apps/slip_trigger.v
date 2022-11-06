`include "tx.vh"

`define SLIP_TRIGGER_STATE_WAIT_SLIP    3'd0
`define SLIP_TRIGGER_STATE_GET_CMD      3'd1
`define SLIP_TRIGGER_STATE_GET_TRIG_CFG 3'd2
`define SLIP_TRIGGER_STATE_GET_TX_DATA  3'd3
`define SLIP_TRIGGER_STATE_TRIGGER      3'd4
`define SLIP_TRIGGER_STATE_WAIT_TX      3'd5

module slip_trigger(clk, reset, 
                    i_uart_rx,
                    // Trigger inputs
                    i_trigger,
                    // Trigger outputs
                    o_trigger_1, 
                    o_trigger_2,
                    // TX
                    o_tx_sfd,
                    o_tx_out,
                    o_tx_out_clk);

    parameter WIDTH=10;

    input clk;
    input reset;
    input i_uart_rx;
    input i_trigger;
    output reg o_trigger_1 = 0;
    output reg o_trigger_2 = 0;
    output o_tx_sfd;
    output [WIDTH-1:0] o_tx_out;
    output o_tx_out_clk;

    // Registers and wires for SLIP RX
    wire       w_slip_rx_started;
    wire       w_slip_rx_ended;
    wire       w_slip_rx_byte_done;
    wire [7:0] w_slip_rx_byte;

    // Registers and wires for TX
    reg       r_trigger_r = 0;
    reg       r_trigger = 0;
    reg       r_start = 0;
    reg       r_tx_buf_w_en = 0;
    reg [6:0] r_tx_buf_w_addr = 7'h00;
    reg [7:0] r_tx_buf_byte = 8'h00;
    wire        w_tx_ev_sig;
    wire [2:0]  w_tx_ev;


    reg [7:0] r_trigger_cfg [3:0];
    reg [15:0] r_trigger_cnt = 16'd0;
    reg [15:0] r_trigger_cnt_trg1_start = 16'd0;
    reg [15:0] r_trigger_cnt_trg2_start = 16'd0;
    reg [15:0] r_trigger_cnt_trg1_stop = 16'd0;
    reg [15:0] r_trigger_cnt_trg2_stop = 16'd0;

    reg [7:0] r_slip_rx_cnt = 8'h00;
    reg [2:0] r_state = `SLIP_TRIGGER_STATE_WAIT_SLIP;

    slip_rx rx_inst(.clk(clk), .reset(reset),
                    .i_uart_line(i_uart_rx),
                    .o_rx_started(w_slip_rx_started), 
                    .o_rx_ended(w_slip_rx_ended), 
                    .o_rx_byte_done(w_slip_rx_byte_done), 
                    .o_rx_byte(w_slip_rx_byte));

    tx tx_inst(.clk(clk),
                .reset(reset),
                .i_start(r_start),
                // Buffer access interface
                .i_buf_w_en(r_buf_w_en),
                .i_buf_w_addr(r_buf_w_addr),
                .i_buf_byte(r_buf_byte),
                // TX events
                .o_ev(w_tx_ev),
                .o_ev_sig(w_tx_ev_sig),
                // TX output
                .o_tx_out(o_tx_out),
                .o_clk(o_tx_out_clk),
                // TX status
                .o_sfd(o_tx_sfd));

    // Purpose: Double-register the trigger input.
    // This removes problems caused by metastability
    always @(posedge clk) begin
        r_trigger_r <= i_trigger;
        r_trigger <= r_trigger_r;
    end

    always @ (posedge clk) begin
        if (reset) begin
            r_state <= `SLIP_TRIGGER_STATE_WAIT_SLIP;
        end
        else begin

            case (r_state)
                `SLIP_TRIGGER_STATE_WAIT_SLIP: begin
                    r_slip_rx_cnt <= 8'h00;
                    o_trigger_1 <= 0;
                    o_trigger_2 <= 0;
                    if (w_slip_rx_started) begin
                        r_state <= `SLIP_TRIGGER_STATE_GET_CMD;
                    end
                    else if (r_trigger) begin
                        r_state <= `SLIP_TRIGGER_STATE_WAIT_TX;
                        r_start <= 1; // Start transmission
                    end
                    else begin
                        r_state <= `SLIP_TRIGGER_STATE_WAIT_SLIP;
                    end
                end

                `SLIP_TRIGGER_STATE_GET_CMD: begin
                    if (w_slip_rx_byte_done) begin
                        if (w_slip_rx_byte == 8'd1) begin
                            r_state <= `SLIP_TRIGGER_STATE_GET_TRIG_CFG;
                        end
                        else if (w_slip_rx_byte == 8'd2) begin
                            r_state <= `SLIP_TRIGGER_STATE_GET_TX_DATA;
                        end
                        else if (w_slip_rx_byte == 8'd3) begin
                            r_state <= `SLIP_TRIGGER_STATE_WAIT_TX;
                            r_start <= 1; // Start transmission
                        end
                        else begin
                        r_state <= `SLIP_TRIGGER_STATE_WAIT_SLIP;
                        end
                    end
                    else if (w_slip_rx_ended) begin
                        r_state <= `SLIP_TRIGGER_STATE_WAIT_SLIP;
                    end
                    else begin
                        r_state <= `SLIP_TRIGGER_STATE_GET_CMD;
                    end
                end

                `SLIP_TRIGGER_STATE_GET_TRIG_CFG: begin
                    if (w_slip_rx_byte_done) begin
                        if (r_slip_rx_cnt < 8'd4) begin
                            // We read only 4 bytes via SLIP
                            r_trigger_cfg[r_slip_rx_cnt] <= w_slip_rx_byte;
                            r_slip_rx_cnt <= r_slip_rx_cnt + 8'd1;
                        end
                        r_state <= `SLIP_TRIGGER_STATE_GET_TRIG_CFG;
                    end
                    else if (w_slip_rx_ended) begin
                        r_trigger_cnt_trg1_start <= {r_trigger_cfg[1], r_trigger_cfg[0]};
                        r_trigger_cnt_trg2_start <= {r_trigger_cfg[3], r_trigger_cfg[2]};
                        r_trigger_cnt_trg1_stop <= {r_trigger_cfg[1], r_trigger_cfg[0]} + 16'd1000;
                        r_trigger_cnt_trg2_stop <= {r_trigger_cfg[3], r_trigger_cfg[2]} + 16'd1000;
                        r_trigger_cnt <= 16'd0;
                        r_state <= `SLIP_TRIGGER_STATE_TRIGGER;
                    end
                    else begin
                        r_state <= `SLIP_TRIGGER_STATE_GET_TRIG_CFG;
                    end
                end

                `SLIP_TRIGGER_STATE_GET_TX_DATA: begin
                    if (w_slip_rx_byte_done) begin
                        r_tx_buf_byte <= w_slip_rx_byte;
                        r_tx_buf_w_addr <= r_slip_rx_cnt;
                        r_tx_buf_w_en <= 1'b1;
                        r_state <= `SLIP_TRIGGER_STATE_GET_TX_DATA;
                    end
                    else if (w_slip_rx_ended) begin
                        r_tx_buf_w_en <= 1'b0;
                        r_state <= `SLIP_TRIGGER_STATE_WAIT_SLIP;
                    end
                    else begin
                        r_state <= `SLIP_TRIGGER_STATE_GET_TX_DATA;
                        r_tx_buf_w_en <= 1'b0;
                    end
                end

                `SLIP_TRIGGER_STATE_TRIGGER: begin
                    if (r_trigger_cnt == 16'hffff) begin
                        r_trigger_cnt <= 16'd0;
                        r_state <= `SLIP_TRIGGER_STATE_WAIT_SLIP;
                    end
                    else begin
                        if (r_trigger_cnt == r_trigger_cnt_trg1_start) begin
                            o_trigger_1 <= 1'd1;
                        end
                        else if (r_trigger_cnt == r_trigger_cnt_trg1_stop) begin
                            o_trigger_1 <= 0;
                        end
                        else begin
                            // Nothing to do
                        end

                        if (r_trigger_cnt == r_trigger_cnt_trg2_start) begin
                            o_trigger_2 <= 1'd1;
                        end
                        else if (r_trigger_cnt == r_trigger_cnt_trg2_stop) begin
                            o_trigger_2 <= 0;
                        end
                        else begin
                            // Nothing to do
                        end

                        r_trigger_cnt <= r_trigger_cnt + 16'd1;
                        r_state <= `SLIP_TRIGGER_STATE_TRIGGER;
                    end
                end

                `SLIP_TRIGGER_STATE_WAIT_TX: begin
                    r_start <= 0;
                    if (w_tx_ev_sig) begin
                        if (w_tx_ev == `TX_EVENT_END) begin
                            r_state <= `SLIP_TRIGGER_STATE_WAIT_SLIP;
                        end
                        else begin
                            r_state <= `SLIP_TRIGGER_STATE_WAIT_TX;
                        end
                    end
                    else begin
                        r_state <= `SLIP_TRIGGER_STATE_WAIT_TX;
                    end
                end

                default: begin
                  
                end 
            endcase

        end
    end

endmodule
