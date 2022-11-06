`include "tx.vh"
`include "rx.vh"

`define SLIP_CMDER_STATE_WAIT_EVENT             8'd0
`define SLIP_CMDER_STATE_GET_CMD                8'd1
`define SLIP_CMDER_STATE_SLIP_TX_STOP_AFTER     8'd2
`define SLIP_CMDER_STATE_SLIP_TX_STOP_WAIT      8'd3
`define SLIP_CMDER_STATE_SLIP_TX_HDR            8'd4

`define SLIP_CMDER_STATE_CMD_TRIG_OUT           8'd10
`define SLIP_CMDER_STATE_TRIG_OUT               8'd11

`define SLIP_CMDER_STATE_CMD_TX_DATA            8'd20

`define SLIP_CMDER_STATE_CMD_TX                 8'd30
`define SLIP_CMDER_STATE_TX_WAIT                8'd31

`define SLIP_CMDER_STATE_CMD_NODE_ID            8'd40
`define SLIP_CMDER_STATE_SLIP_TX_NODE_ID        8'd41

`define SLIP_CMDER_STATE_CMD_TRIG_IN_EN         8'd50

`define SLIP_CMDER_STATE_CMD_RX_EN              8'd60
`define SLIP_CMDER_STATE_RX_EN                  8'd61

`define SLIP_CMDER_STATE_RX_DONE                8'd70
`define SLIP_CMDER_STATE_SLIP_TX_RX_DATA        8'd71

`define TRIG_OUT_STATE_IDLE             0
`define TRIG_OUT_STATE_ACTIVE           1

`define SLIP_CMDER_REQ_CODE_TRIG_OUT    8'd1
`define SLIP_CMDER_REQ_CODE_TX_DATA     8'd2
`define SLIP_CMDER_REQ_CODE_TX          8'd3
`define SLIP_CMDER_REQ_CODE_NODE_ID     8'd4
`define SLIP_CMDER_REQ_CODE_TRIG_IN_EN  8'd5
`define SLIP_CMDER_REQ_CODE_RX_EN       8'd6

`define SLIP_CMDER_RES_CODE_RX_DATA     8'd1
`define SLIP_CMDER_RES_CODE_NODE_ID     8'd2

`define SLIP_CMDER_LED_IDX_TX           0
`define SLIP_CMDER_LED_IDX_RX           1

`define TRIG_PULSE_DURATION             16'd40

module slip_cmder
    (input clk,
     input reset,
     input [7:0] i_node_id,
     // UART
     input i_uart_rx,
     output o_uart_tx,
     // Trigger inputs
     input i_trigger,
     // Trigger outputs
     output reg o_trigger_1 = 0,
     output reg o_trigger_2 = 0,
     // TX
     output o_tx_sfd,
     output [WIDTH-1:0] o_tx_out,
     output o_tx_out_clk,
     // RX
     input [WIDTH-1:0] i_rx_in,
     output o_rx_sfd,
     output o_rx_out_clk,
     // Status LEDs
     output reg [3:0] o_leds = 0);

    parameter WIDTH=10;

    // Registers and wires for SLIP RX
    wire       w_slip_rx_started;
    wire       w_slip_rx_ended;
    wire       w_slip_rx_byte_done;
    wire [7:0] w_slip_rx_byte;

    // Registers and wires for SLIP TX
    reg       r_slip_tx_start = 0;
    reg       r_slip_tx_end = 0;
    reg       r_slip_tx_byte_w_en = 0;
    reg [7:0] r_slip_tx_byte = 8'h00;
    wire       w_slip_tx_byte_done;

    // Registers and wires for TX
    reg       r_tx_start = 0;
    reg       r_tx_buf_w_en = 0;
    reg [6:0] r_tx_buf_w_addr = 7'h00;
    reg [7:0] r_tx_buf_byte = 8'h00;
    wire        w_tx_ev_sig;
    wire [2:0]  w_tx_ev;

    // Registers and wires for RX
    reg       r_rx_en = 0;
    //reg       r_rx_en_cfg = 0;
    reg [6:0] r_rx_buf_r_addr = 0;
    reg [6:0] r_rx_len = 0;
    wire       w_rx_event_sig;
    wire [2:0] w_rx_event;
    wire [7:0] w_rx_buf_byte;

    // Registers and wires for input trigger
    reg       r_trig_in_r = 0;
    reg       r_trig_in = 0;
    reg       r_trig_in_en = 0;

    // Registers and wires for output trigger
    reg [7:0] r_trig_out_cfg [3:0];
    reg [15:0] r_trig_out_cnt = 16'd0;
    reg [15:0] r_trig_out_1_start = 16'd0;
    reg [15:0] r_trig_out_2_start = 16'd0;
    reg [15:0] r_trig_out_1_stop = 16'd0;
    reg [15:0] r_trig_out_2_stop = 16'd0;
    reg r_trig_out_en = 0;
    reg r_trig_out_state = `TRIG_OUT_STATE_IDLE;

    reg [7:0] r_slip_rx_cnt = 8'h00;
    reg [7:0] r_state = `SLIP_CMDER_STATE_WAIT_EVENT;
    reg [7:0] r_state_next = `SLIP_CMDER_STATE_WAIT_EVENT;


    slip_rx slip_rx_inst(.clk(clk),
                         .reset(reset),
                         .i_uart_line(i_uart_rx),
                         .o_rx_started(w_slip_rx_started),
                         .o_rx_ended(w_slip_rx_ended),
                         .o_rx_byte_done(w_slip_rx_byte_done),
                         .o_rx_byte(w_slip_rx_byte));

    slip_tx slip_tx_inst(.clk(clk),
                         .reset(reset),
                         .i_start(r_slip_tx_start),
                         .i_end(r_slip_tx_end),
                         .i_tx_dv(r_slip_tx_byte_w_en),
                         .i_tx_byte(r_slip_tx_byte),
                         .o_tx_byte_done(w_slip_tx_byte_done),
                         .o_uart_line(o_uart_tx));

    tx tx_inst(.clk(clk),
               .reset(reset),
               .i_start(r_tx_start),
               // Buffer access interface
               .i_buf_w_en(r_tx_buf_w_en),
               .i_buf_w_addr(r_tx_buf_w_addr),
               .i_buf_byte(r_tx_buf_byte),
               // TX events
               .o_ev(w_tx_ev),
               .o_ev_sig(w_tx_ev_sig),
               // TX output
               .o_tx_out(o_tx_out),
               .o_clk(o_tx_out_clk),
               // TX status
               .o_sfd(o_tx_sfd));

    rx rx_inst(.clk(clk),
               .reset(reset),
               .i_enable(r_rx_en),
               // RX input
               .i_rx_in(i_rx_in),
               .o_clk(o_rx_out_clk),
               // Buffer access interface
               .i_buf_r_addr(r_rx_buf_r_addr),
               .o_buf_r_byte(w_rx_buf_byte),
               // RX events
               .o_ev(w_rx_event),
               .o_ev_sig(w_rx_event_sig),
               // RX status
               .o_sfd(o_rx_sfd));

    always @ (posedge clk) begin
        if (reset) begin
            o_leds <= 0;
            r_state <= `SLIP_CMDER_STATE_WAIT_EVENT;
            r_state_next <= `SLIP_CMDER_STATE_WAIT_EVENT;
        end
        else begin
            // Purpose: Double-register the trigger input.
            // This removes problems caused by metastability
            r_trig_in_r <= i_trigger;
            r_trig_in <= r_trig_in_r;

            // Output trigger handling state machine
            case (r_trig_out_state)
                `TRIG_OUT_STATE_IDLE: begin
                    o_trigger_1 <= 0;
                    o_trigger_2 <= 0;
                    r_trig_out_cnt <= 0;
                    if (r_trig_out_en) begin
                        r_trig_out_state <= `TRIG_OUT_STATE_ACTIVE;
                    end
                    else begin
                        r_trig_out_state <= `TRIG_OUT_STATE_IDLE;
                    end
                end

                `TRIG_OUT_STATE_ACTIVE: begin
                    if (r_trig_out_cnt == 16'hffff) begin
                        r_trig_out_state <= `TRIG_OUT_STATE_IDLE;
                    end
                    else begin
                        if (r_trig_out_cnt == r_trig_out_1_start) begin
                            o_trigger_1 <= 1;
                        end
                        else if (r_trig_out_cnt == r_trig_out_1_stop) begin
                            o_trigger_1 <= 0;
                        end
                        else begin
                            // Nothing to do
                        end

                        if (r_trig_out_cnt == r_trig_out_2_start) begin
                            o_trigger_2 <= 1;
                        end
                        else if (r_trig_out_cnt == r_trig_out_2_stop) begin
                            o_trigger_2 <= 0;
                        end
                        else begin
                            // Nothing to do
                        end

                        r_trig_out_cnt <= r_trig_out_cnt + 16'd1;
                        r_trig_out_state <= `TRIG_OUT_STATE_ACTIVE;
                    end
                end

                default: begin
                end
            endcase

            // Main event handling state machine
            case (r_state)
                `SLIP_CMDER_STATE_WAIT_EVENT: begin
                    r_slip_rx_cnt <= 0;
                    // Set the RX buffer address to zero, so we can
                    // read the frame length when the reception completed.
                    r_rx_buf_r_addr <= 0;
                    if (w_slip_rx_started) begin
                        r_state <= `SLIP_CMDER_STATE_GET_CMD;
                    end
                    else if (r_trig_in_en && r_trig_in) begin
                        // TX Trigger from external signal
                        r_state <= `SLIP_CMDER_STATE_CMD_TX;
                    end
                    else if (w_rx_event_sig) begin
                        // RX events
                        if (w_rx_event == `RX_EVENT_PHR) begin
                            o_leds[`SLIP_CMDER_LED_IDX_RX] <= ~o_leds[`SLIP_CMDER_LED_IDX_RX];
                            r_state <= `SLIP_CMDER_STATE_WAIT_EVENT;
                        end
                        else if (w_rx_event == `RX_EVENT_END) begin
                            // Disable receiver to avoid nested receptions.
                            r_rx_en <= 0;
                            r_rx_len <= w_rx_buf_byte[6:0];
                            r_state <= `SLIP_CMDER_STATE_RX_DONE;
                        end
                        else begin
                            r_state <= `SLIP_CMDER_STATE_WAIT_EVENT;
                        end
                    end
                    else begin
                        r_state <= `SLIP_CMDER_STATE_WAIT_EVENT;
                    end
                end

                `SLIP_CMDER_STATE_GET_CMD: begin
                    if (w_slip_rx_byte_done) begin
                        if (w_slip_rx_byte == `SLIP_CMDER_REQ_CODE_TRIG_OUT) begin
                            r_state <= `SLIP_CMDER_STATE_CMD_TRIG_OUT;
                        end
                        else if (w_slip_rx_byte == `SLIP_CMDER_REQ_CODE_TX_DATA) begin
                            r_state <= `SLIP_CMDER_STATE_CMD_TX_DATA;
                        end
                        else if (w_slip_rx_byte == `SLIP_CMDER_REQ_CODE_TX) begin
                            r_state <= `SLIP_CMDER_STATE_CMD_TX;
                        end
                        else if (w_slip_rx_byte == `SLIP_CMDER_REQ_CODE_NODE_ID) begin
                            r_state <= `SLIP_CMDER_STATE_CMD_NODE_ID;
                        end
                        else if (w_slip_rx_byte == `SLIP_CMDER_REQ_CODE_TRIG_IN_EN) begin
                            r_state <= `SLIP_CMDER_STATE_CMD_TRIG_IN_EN;
                        end
                        else if (w_slip_rx_byte == `SLIP_CMDER_REQ_CODE_RX_EN) begin
                            r_state <= `SLIP_CMDER_STATE_CMD_RX_EN;
                        end
                        else begin
                            r_state <= `SLIP_CMDER_STATE_WAIT_EVENT;
                        end
                    end
                    else if (w_slip_rx_ended) begin
                        r_state <= `SLIP_CMDER_STATE_WAIT_EVENT;
                    end
                    else begin
                        r_state <= `SLIP_CMDER_STATE_GET_CMD;
                    end
                end

                `SLIP_CMDER_STATE_SLIP_TX_HDR: begin
                    r_slip_tx_start <= 1'b0;
                    if (w_slip_tx_byte_done) begin
                        r_slip_tx_byte_w_en <= 1'b1;
                        // r_slip_tx_byte has to be already set
                        r_state <= r_state_next;
                        r_state_next <= `SLIP_CMDER_STATE_WAIT_EVENT;
                    end
                    else begin
                        r_slip_tx_byte_w_en <= 0;
                        r_state <= `SLIP_CMDER_STATE_SLIP_TX_HDR;
                    end
                end

                `SLIP_CMDER_STATE_SLIP_TX_STOP_AFTER: begin
                    r_slip_tx_byte_w_en <= 0;
                    if (w_slip_tx_byte_done) begin
                        r_slip_tx_end <= 1;
                        r_state <= `SLIP_CMDER_STATE_SLIP_TX_STOP_WAIT;
                    end
                    else begin
                        r_state <= `SLIP_CMDER_STATE_SLIP_TX_STOP_AFTER;
                    end
                end

                `SLIP_CMDER_STATE_SLIP_TX_STOP_WAIT: begin
                    r_slip_tx_end <= 0;
                    if (w_slip_tx_byte_done) begin
                        r_state <= r_state_next;
                        r_state_next <= `SLIP_CMDER_STATE_WAIT_EVENT;
                    end
                    else begin
                        r_state <= `SLIP_CMDER_STATE_SLIP_TX_STOP_WAIT;
                    end
                end

                `SLIP_CMDER_STATE_CMD_TRIG_OUT: begin
                    if (w_slip_rx_byte_done) begin
                        if (r_slip_rx_cnt < 8'd4) begin
                            // We read only 4 bytes via SLIP
                            r_trig_out_cfg[r_slip_rx_cnt] <= w_slip_rx_byte;
                            r_slip_rx_cnt <= r_slip_rx_cnt + 8'd1;
                        end
                        r_state <= `SLIP_CMDER_STATE_CMD_TRIG_OUT;
                    end
                    else if (w_slip_rx_ended) begin
                        r_trig_out_1_start <= {r_trig_out_cfg[1], r_trig_out_cfg[0]};
                        r_trig_out_2_start <= {r_trig_out_cfg[3], r_trig_out_cfg[2]};
                        r_trig_out_1_stop <= {r_trig_out_cfg[1], r_trig_out_cfg[0]} + `TRIG_PULSE_DURATION;
                        r_trig_out_2_stop <= {r_trig_out_cfg[3], r_trig_out_cfg[2]} + `TRIG_PULSE_DURATION;
                        // Enable output trigger only for one cycle
                        r_trig_out_en <= 1;
                        r_state <= `SLIP_CMDER_STATE_TRIG_OUT;
                    end
                    else begin
                        r_state <= `SLIP_CMDER_STATE_CMD_TRIG_OUT;
                    end
                end

                `SLIP_CMDER_STATE_TRIG_OUT: begin
                    r_trig_out_en <= 0;
                    r_state <= `SLIP_CMDER_STATE_WAIT_EVENT;
                end

                `SLIP_CMDER_STATE_CMD_TX_DATA: begin
                    if (w_slip_rx_byte_done) begin
                        r_tx_buf_w_addr <= r_slip_rx_cnt[6:0];
                        r_tx_buf_byte <= w_slip_rx_byte;
                        r_tx_buf_w_en <= 1'b1;
                        r_slip_rx_cnt <= r_slip_rx_cnt + 8'd1;
                        r_state <= `SLIP_CMDER_STATE_CMD_TX_DATA;
                    end
                    else if (w_slip_rx_ended) begin
                        r_tx_buf_w_en <= 1'b0;
                        r_state <= `SLIP_CMDER_STATE_WAIT_EVENT;
                    end
                    else begin
                        r_tx_buf_w_en <= 1'b0;
                        r_state <= `SLIP_CMDER_STATE_CMD_TX_DATA;
                    end
                end

                `SLIP_CMDER_STATE_CMD_TX: begin
                    r_state <= `SLIP_CMDER_STATE_TX_WAIT;
                    r_tx_start <= 1;
                    o_leds[`SLIP_CMDER_LED_IDX_TX] <= ~o_leds[`SLIP_CMDER_LED_IDX_TX];
                    // Disable receiver to avoid self reception.
                    r_rx_en <= 0;
                end

                `SLIP_CMDER_STATE_TX_WAIT: begin
                    r_tx_start <= 0;
                    if (w_tx_ev_sig) begin
                        if (w_tx_ev == `TX_EVENT_END) begin
                            r_state <= `SLIP_CMDER_STATE_WAIT_EVENT;
                        end
                        else begin
                            r_state <= `SLIP_CMDER_STATE_TX_WAIT;
                        end
                    end
                    else begin
                        r_state <= `SLIP_CMDER_STATE_TX_WAIT;
                    end
                end

                `SLIP_CMDER_STATE_RX_DONE: begin
                    // Data from RX buffer will be available after 2 cycles from
                    // changing the read address.
                    // However, SLIP sending takes lot more than 2 cycles.
                    // So we do not need additional waiting after changing the
                    // RX buffer read address.
                    r_rx_buf_r_addr <= 0;
                    r_slip_tx_start <= 1;
                    r_slip_tx_end <= 0;
                    r_slip_tx_byte_w_en <= 0;
                    r_slip_tx_byte <= `SLIP_CMDER_RES_CODE_RX_DATA;
                    r_state <= `SLIP_CMDER_STATE_SLIP_TX_HDR;
                    r_state_next <= `SLIP_CMDER_STATE_SLIP_TX_RX_DATA;
                end

                `SLIP_CMDER_STATE_SLIP_TX_RX_DATA: begin
                    if (w_slip_tx_byte_done) begin
                        // We have to iterate (frame length + 1) times since
                        // first byte of the RX buffer is the frame length.
                        if (r_rx_buf_r_addr == r_rx_len) begin
                            /* Re-enable the receiver only if previously enabled. */
                            //r_rx_en <= r_rx_en_cfg;
                            r_rx_en <= 1;
                            r_state <= `SLIP_CMDER_STATE_SLIP_TX_STOP_AFTER;
                        end
                        else begin
                            r_state <= `SLIP_CMDER_STATE_SLIP_TX_RX_DATA;
                        end
                        r_slip_tx_byte_w_en <= 1;
                        r_slip_tx_byte <= w_rx_buf_byte;
                        r_rx_buf_r_addr <= r_rx_buf_r_addr + 7'd1;
                    end
                    else begin
                        r_slip_tx_byte_w_en <= 0;
                        r_state <= `SLIP_CMDER_STATE_SLIP_TX_RX_DATA;
                    end
                end

                `SLIP_CMDER_STATE_CMD_NODE_ID: begin
                    r_slip_tx_start <= 1;
                    r_slip_tx_end <= 0;
                    r_slip_tx_byte_w_en <= 0;
                    r_slip_tx_byte <= `SLIP_CMDER_RES_CODE_NODE_ID;
                    r_state <= `SLIP_CMDER_STATE_SLIP_TX_HDR;
                    r_state_next <= `SLIP_CMDER_STATE_SLIP_TX_NODE_ID;
                end

                `SLIP_CMDER_STATE_SLIP_TX_NODE_ID: begin
                    if (w_slip_tx_byte_done) begin
                        r_slip_tx_byte_w_en <= 1'b1;
                        r_slip_tx_byte <= i_node_id;
                        r_state <= `SLIP_CMDER_STATE_SLIP_TX_STOP_AFTER;
                    end
                    else begin
                        r_slip_tx_byte_w_en <= 0;
                        r_state <= `SLIP_CMDER_STATE_SLIP_TX_NODE_ID;
                    end
                end

                `SLIP_CMDER_STATE_CMD_TRIG_IN_EN: begin
                    if (w_slip_rx_byte_done) begin
                        r_trig_in_en <= w_slip_rx_byte[0];
                        r_state <= `SLIP_CMDER_STATE_CMD_TRIG_IN_EN;
                    end
                    else if (w_slip_rx_ended) begin
                        r_state <= `SLIP_CMDER_STATE_WAIT_EVENT;
                    end
                    else begin
                        r_state <= `SLIP_CMDER_STATE_CMD_TRIG_IN_EN;
                    end
                end

                `SLIP_CMDER_STATE_CMD_RX_EN: begin
                    if (w_slip_rx_byte_done) begin
                        //r_rx_en_cfg <= w_slip_rx_byte[0];
                        r_rx_en <= w_slip_rx_byte[0];
                        r_state <= `SLIP_CMDER_STATE_CMD_RX_EN;
                    end
                    else if (w_slip_rx_ended) begin
                        r_state <= `SLIP_CMDER_STATE_WAIT_EVENT;
                    end
                    else begin
                        r_state <= `SLIP_CMDER_STATE_CMD_RX_EN;
                    end
                end

                default: begin
                end
            endcase
        end
    end
endmodule
