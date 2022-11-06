`include "glossy_config.vh"
`include "glossy.vh"
`include "rx.vh"
`include "tx.vh"

`define GLOSSY_STATE_IDLE                           5'd0
`define GLOSSY_STATE_WAIT_CYCLE                     5'd1
`define GLOSSY_STATE_RX_START                       5'd2
`define GLOSSY_STATE_RX_EVENTS                      5'd3     
`define GLOSSY_STATE_RX_DONE                        5'd4
`define GLOSSY_STATE_CP_RXBUF_TO_TXBUF_GBUF         5'd5
`define GLOSSY_STATE_CP_RXBUF_TO_TXBUF_GBUF_DONE    5'd6
`define GLOSSY_STATE_CP_GBUF_TO_TXBUF               5'd7
`define GLOSSY_STATE_UPDATE_RC                      5'd8
`define GLOSSY_STATE_TX_START_INI                   5'd9
`define GLOSSY_STATE_TX_START                       5'd10
`define GLOSSY_STATE_TX_EVENTS                      5'd11
`define GLOSSY_STATE_TX_DONE                        5'd12    
`define GLOSSY_STATE_RX_TO_TX_DELAY                 5'd13
`define GLOSSY_STATE_TX_TO_RX_DELAY                 5'd14
`define GLOSSY_STATE_END                            5'd15



module glossy(clk, reset,
                // Glossy main interface
                i_start,                // Start Glossy
                i_mode,                 // Glossy mode, 1: Initiator 0: Receiver
                i_n_tx_max,                 // Number of maximum transmissions
                i_t_cnt_active,         // Number of clock count that the Glossy should be active 
                o_t_cnt_ref,            // The reference time in number of clock count
                o_f_rl_cnt,             // Relay count of the first reception
                o_t_cnt_ref_updated,    // 1 if the reference time is updated
                o_done,                 // 1 when the Glossy phase is completed
                o_t_cnt_g_clk,          // Current clock count of the Glossy clock
                // Glossy buffer access inputs/outputs
                i_buf_w_en,             // Write enable
                i_buf_w_addr,           // Write address
                i_buf_r_addr,           // Read address
                i_buf_w_byte,           // Byte to be written
                o_buf_r_byte,           // Output byte
                // TX and RX inputs/outputs
                i_rx_in, 
                o_rx_in_clk,
                o_tx_out,
                o_tx_out_clk, 
                o_rx_sfd, 
                o_tx_sfd, 
                o_tx_active,
                o_rx_active,
                // Statistics
                o_rx_cnt,               // Glossy RX count
                o_tx_cnt,               // Glossy TX count
                o_crc_failed_cnt);

    parameter WIDTH=10;

    input clk;
    input reset;
    /* Glossy main interface */
    input               i_start;
    input               i_mode;
    input       [3:0]   i_n_tx_max;
    input       [31:0]  i_t_cnt_active;
    output      [63:0]  o_t_cnt_ref;
    output      [7:0]   o_f_rl_cnt;
    output              o_t_cnt_ref_updated;
    output reg          o_done = 0;
    output      [63:0]  o_t_cnt_g_clk;
    /* Buffer access inputs/outputs */
    input               i_buf_w_en;
    input [6:0]         i_buf_w_addr;
    input [6:0]         i_buf_r_addr;
    input [7:0]         i_buf_w_byte;
    output [7:0]        o_buf_r_byte;
    /* TX and RX inputs/outputs */
    input [WIDTH-1:0]   i_rx_in;
    output              o_rx_in_clk;
    output [WIDTH-1:0]  o_tx_out;
    output              o_tx_out_clk;
    output              o_rx_sfd;
    output              o_tx_sfd;
    output              o_tx_active;
    output              o_rx_active;
    /* Statistics */
    output [7:0]        o_rx_cnt;
    output [7:0]        o_tx_cnt;
    output [7:0]        o_crc_failed_cnt;
    /* Other configurations */

    /* Registers and wires for RX */
    reg        r_rx_enable = 0;
    reg [6:0]  r_rx_buf_r_addr = 0;
    reg [6:0]  r_tx_rx_len = 0;
    wire       w_rx_fcs_ok;
    wire       w_rx_ev_sig;
    wire [2:0] w_rx_ev;
    wire [7:0] w_rx_buf_byte;

    /* Registers and wires for TX */ 
    reg        r_tx_start = 0;
    reg        r_tx_buf_w_en = 0;
    reg [6:0]  r_tx_buf_w_addr = 7'h00;
    reg [7:0]  r_tx_buf_w_byte = 8'h00;
    wire       w_tx_ev_sig;
    wire [2:0] w_tx_ev;

    /* Time keeping registers and wires */
    reg [63:0] r_t_cnt_clk = 0;    // Glossy clock
    reg [63:0] r_t_cnt_stop = 0;   // When to stop Glossy
    reg [63:0] r_t_cnt_rx_sfd = 0; // Glossy clock time counter count when the RX ended
    reg [63:0] r_t_cnt_tx_sfd = 0; // Glossy clock time counter count when the TX ended
    reg [63:0] r_t_cnt_ini_rtx_timeout = 0;
    reg [63:0] r_t_cnt_rx_start_timeout = 0;
    reg [63:0] r_t_cnt_tx_start_timeout = 0;
    reg [63:0] r_t_cnt_slot_sum = 0; // Sum of the slot durations in terms of Glossy clock time counter values
    reg [7:0]  r_n_slots = 0;        // Number slots
    reg [63:0] r_t_cnt_slot_est = 0; // Estimated slot duration in terms of Glossy clock time counter values
    wire       w_stop_flag;

    reg        r_mode = 0;
    reg [3:0]  r_n_tx_max = 0;
    reg        r_gbuf_lock = 0;
    reg [7:0]  r_rl_cnt_rx = 0;
    reg [7:0]  r_rl_cnt_tx = 0;
    reg [63:0] r_t_cnt_ref = 0;
    reg [7:0]  r_f_rl_cnt = 0;
    reg        r_t_cnt_ref_updated = 0;
    /* Statistics */
    reg [7:0]  r_rx_cnt = 0;
    reg [7:0]  r_tx_cnt = 0;
    reg [7:0]  r_crc_failed_cnt = 0;

    /* Multiplexed input/output lines for the buffer */
    wire       w_gbuf_w_en;   // Write enable
    wire [6:0] w_gbuf_w_addr; // Write address
    wire [6:0] w_gbuf_r_addr; // Read address
    wire [7:0] w_gbuf_w_byte; // Write byte
    wire [7:0] w_gbuf_r_byte; // Read byte (valid after 2 cycles from writing the read address)

    /* Internal input/output lines for the buffer */
    reg        r_gbuf_int_w_en = 0;
    reg [6:0]  r_gbuf_int_w_addr = 0;
    reg [6:0]  r_gbuf_int_r_addr = 0;
    reg [7:0]  r_gbuf_int_w_byte = 0;
    wire [7:0] w_gbuf_int_r_byte;

    reg [4:0]  r_state = `GLOSSY_STATE_IDLE;
    reg [4:0]  r_nxt_state = `GLOSSY_STATE_IDLE;

    ram_single g_buf(.clk(clk), 
                    .i_w_enable(w_gbuf_w_en), 
                    .i_w_addr(w_gbuf_w_addr), 
                    .i_w_byte(w_gbuf_w_byte),
                    .i_r_addr(w_gbuf_r_addr), 
                    .o_r_byte(w_gbuf_r_byte));

    rx rx_inst(.clk(clk), 
                .reset(reset), 
                .i_enable(r_rx_enable),
                .i_rx_in(i_rx_in),
                .o_clk(o_rx_in_clk),
                .i_buf_r_addr(r_rx_buf_r_addr),
                .o_buf_r_byte(w_rx_buf_byte),
                .o_ev(w_rx_ev),
                .o_ev_sig(w_rx_ev_sig),
                .o_sfd(o_rx_sfd),
                .o_fcs_ok(w_rx_fcs_ok),
                .o_active(o_rx_active));

    tx tx_inst(.clk(clk), .reset(reset), 
                .i_start(r_tx_start),
                .i_buf_w_en(r_tx_buf_w_en), 
                .i_buf_w_addr(r_tx_buf_w_addr), 
                .i_buf_byte(r_tx_buf_w_byte), 
                .o_ev(w_tx_ev), 
                .o_ev_sig(w_tx_ev_sig), 
                .o_tx_out(o_tx_out),
                .o_clk(o_tx_out_clk),
                .o_active(o_tx_active),
                .o_sfd(o_tx_sfd));

    /* Lock the Glossy buffer to avoid Glossy application modifying the buffer content. 
       We do not need to lock output lines i.e. o_buf_r_byte of the buffer.
     */
    assign o_buf_r_byte         = w_gbuf_r_byte;
    assign w_gbuf_int_r_byte    = w_gbuf_r_byte;
    assign w_gbuf_w_en          = r_gbuf_lock ? r_gbuf_int_w_en : i_buf_w_en;
    assign w_gbuf_w_addr        = r_gbuf_lock ? r_gbuf_int_w_addr : i_buf_w_addr;
    assign w_gbuf_r_addr        = r_gbuf_lock ? r_gbuf_int_r_addr : i_buf_r_addr;
    assign w_gbuf_w_byte        = r_gbuf_lock ? r_gbuf_int_w_byte : i_buf_w_byte;
    
    assign o_f_rl_cnt           = r_f_rl_cnt;
    assign o_t_cnt_ref          = r_t_cnt_ref;
    assign o_t_cnt_ref_updated  = r_t_cnt_ref_updated;
    assign o_rx_cnt             = r_rx_cnt;
    assign o_tx_cnt             = r_tx_cnt;
    assign o_crc_failed_cnt     = r_crc_failed_cnt;
    assign o_t_cnt_g_clk        = r_t_cnt_clk;
    assign w_stop_flag          = ((r_t_cnt_clk > r_t_cnt_stop) || (r_tx_cnt >= {4'd0, r_n_tx_max})) ? 1'b1 : 1'b0;

    always @ (posedge clk) begin
        if (reset) begin
            r_t_cnt_clk <= 0;
        end
        else begin
            r_t_cnt_clk <= r_t_cnt_clk + 64'd1;
        end
    end

    always @ (posedge clk) begin
        if (reset) begin
            r_state <= `GLOSSY_STATE_IDLE;
            r_nxt_state <= `GLOSSY_STATE_IDLE;
            r_rx_enable <= 0;
            r_gbuf_lock <= 0;
            r_t_cnt_stop <= 0;
            r_mode <= 0;
        end
        else begin

            case (r_state)
                `GLOSSY_STATE_IDLE: begin
                    if (i_start) begin
                        r_tx_rx_len <= 0;
                        r_crc_failed_cnt <= 0;
                        r_rx_cnt <= 0;
                        r_tx_cnt <= 0;
                        r_rl_cnt_rx <= 0;
                        r_rl_cnt_tx <= 0;
                        r_t_cnt_slot_sum <= 0;
                        r_n_slots <= 0;
                        r_t_cnt_ref <= 0;
                        r_t_cnt_ref_updated <= 0;
                        r_n_tx_max <= i_n_tx_max;
                        r_t_cnt_stop <= r_t_cnt_clk + {32'd0, i_t_cnt_active};
                        r_gbuf_lock <= 1'b1;
                        r_mode <= i_mode;
                        if (i_mode) begin
                            /* We must wait one cycle before reading the frame length */ 
                            r_gbuf_int_r_addr <= `GLOSSY_RXTX_ADDR_FRM_LEN;
                            r_nxt_state <= `GLOSSY_STATE_TX_START_INI;
                            r_state <= `GLOSSY_STATE_WAIT_CYCLE;
                        end
                        else begin
                            r_state <= `GLOSSY_STATE_RX_START;
                        end
                    end
                    else begin
                        r_gbuf_lock <= 0;
                        r_state <= `GLOSSY_STATE_IDLE;
                    end
                    o_done <= 0;
                end

                /* -------------------------- RX processing states ------------------------------ */

                /* This state is only for restarting receiver after end of glossy phase */
                `GLOSSY_STATE_RX_START: begin
                    r_rx_enable <= 1'b1; // Enable RX
                    r_state <= `GLOSSY_STATE_RX_EVENTS;
                end

                /* In this state, we processes RX events. */
                `GLOSSY_STATE_RX_EVENTS: begin
                    if (w_rx_ev_sig) begin
                        if (w_rx_ev == `RX_EVENT_PHR) begin
                            /* We read frame length at the rx end. So, we set the address to be read
                               now. 
                             */
                            r_rx_buf_r_addr <= `GLOSSY_RXTX_ADDR_FRM_LEN;
                            r_state <= `GLOSSY_STATE_RX_EVENTS;             
                        end
                        else if (w_rx_ev == `RX_EVENT_SFD) begin
                            r_t_cnt_rx_sfd <= r_t_cnt_clk;
                            r_state <= `GLOSSY_STATE_RX_EVENTS;             
                        end
                        else if (w_rx_ev == `RX_EVENT_END) begin
                            /* Disable RX after reception to avoid other receptions. */
                            r_rx_enable <= 1'b0; 
                            if (w_rx_fcs_ok) begin
                                r_rx_cnt <= r_rx_cnt + 8'd1;
                                r_tx_rx_len <= w_rx_buf_byte[6:0];
                                /* We need to reed relay counter in GLOSSY_STATE_RX_DONE state. */
                                r_rx_buf_r_addr <= `GLOSSY_RXTX_ADDR_RL_CNT;
                                r_nxt_state <= `GLOSSY_STATE_RX_DONE; 
                                r_state <= `GLOSSY_STATE_WAIT_CYCLE; 
                            end
                            else begin
                                /* Since FCS is failed, we discard the frame and go to receive a new frame. */ 
                                r_crc_failed_cnt <= r_crc_failed_cnt + 8'd1;
                                r_state <= `GLOSSY_STATE_RX_EVENTS;
                            end
                        end
                        else begin
                            /* Some other RX event that we don't care */
                            r_state <= `GLOSSY_STATE_RX_EVENTS; 
                        end
                    end
                    else begin
                        if (o_rx_sfd) begin
                            /* In the middle of a reception. */
                            r_state <= `GLOSSY_STATE_RX_EVENTS;
                        end
                        else begin
                            /* Check if we need to stop Glossy while waiting to receive something. */
                            if (w_stop_flag) begin
                                /* We need to stop */
                                r_state <= `GLOSSY_STATE_END;
                            end
                            else begin
                                if (r_mode && r_rx_cnt == 0) begin
                                    /* Initiator hasn't received anything yet.
                                       So, check if the initiator retransmit the dame frame now.
                                     */
                                    if (r_t_cnt_clk >= r_t_cnt_ini_rtx_timeout) begin
                                        r_rl_cnt_tx <= r_rl_cnt_tx + 8'd2;
                                        r_nxt_state <= `GLOSSY_STATE_TX_START;
                                        r_state <= `GLOSSY_STATE_UPDATE_RC;
                                    end
                                    else begin
                                        r_state <= `GLOSSY_STATE_RX_EVENTS;
                                    end
                                end
                                else begin
                                    r_state <= `GLOSSY_STATE_RX_EVENTS;
                                end
                            end
                        end
                    end
                end

                /* In this state, we validate the received frame. */
                `GLOSSY_STATE_RX_DONE: begin
                    /* We set the relay counter and the SFD time of the first valid reception.
                       Note that w_rx_buf_byte has the relay counter since we've set r_rx_buf_r_addr
                       to read relay counter in the GLOSSY_STATE_RX_EVENTS state. 
                     */
`ifdef GLOSSY_RECV_EN_MIN_RL_CNT_VALIDATION
                    if (r_mode) begin
                        if (r_t_cnt_ref_updated == 1'd0) begin
                            r_f_rl_cnt <= w_rx_buf_byte;
                            r_t_cnt_ref_updated <= 1'b1;
                            r_t_cnt_ref <= r_t_cnt_rx_sfd;
                        end 
                        else begin
                            /* Reference time is already updated. */
                        end                    
                    end
                    else begin
                        /* verilator lint_off UNSIGNED */
                        if (w_rx_buf_byte >= `GLOSSY_RECV_MIN_RL_CNT && r_t_cnt_ref_updated == 1'd0) begin
                        /* verilator lint_on UNSIGNED */
                            r_f_rl_cnt <= w_rx_buf_byte;
                            r_t_cnt_ref_updated <= 1'b1;
                            r_t_cnt_ref <= r_t_cnt_rx_sfd;
                        end 
                        else begin
                            /* Reference time is already updated or 
                               received relay count is below the minimum allowed. 
                             */
                        end
                    end
`else // GLOSSY_RECV_EN_MIN_RL_CNT_VALIDATION
                    if (r_t_cnt_ref_updated == 1'd0) begin
                        r_f_rl_cnt <= w_rx_buf_byte;
                        r_t_cnt_ref_updated <= 1'b1;
                        r_t_cnt_ref <= r_t_cnt_rx_sfd;
                    end 
                    else begin
                        /* Reference time is already updated. */
                    end
`endif // GLOSSY_RECV_EN_MIN_RL_CNT_VALIDATION
                    /* We have to account for the size of frame length field as well. */
                    r_t_cnt_tx_start_timeout <= ({56'd0, (r_tx_rx_len + 8'd1)} *  `GLOSSY_TXRX_BYTE_TIME) 
                                                + `GLOSSY_RX_TO_TX_TURNAROUND 
                                                + r_t_cnt_rx_sfd;
                    /* We've set the address of relay counter 2 cycles ago. 
                        so we can read the RX buffer. */
                    r_rl_cnt_rx <= w_rx_buf_byte;
                    r_rx_buf_r_addr <= `GLOSSY_RXTX_ADDR_FRM_START;
                    r_nxt_state <= `GLOSSY_STATE_CP_RXBUF_TO_TXBUF_GBUF;
                    r_state <= `GLOSSY_STATE_WAIT_CYCLE;               
                end

                /* In this state, we copy the frame from RX buffer to both TX buffer and Glossy buffer
                   at the same time. Note that the RX buffer is copied to the Glossy buffer
                   only at the first reception.
                 */
                `GLOSSY_STATE_CP_RXBUF_TO_TXBUF_GBUF: begin
                    // We have to iterate (frame length + 1) times since
                    // first byte of the RX buffer is the frame length.
                    if (r_rx_buf_r_addr == r_tx_rx_len + 7'd1) begin
                        r_state <= `GLOSSY_STATE_CP_RXBUF_TO_TXBUF_GBUF_DONE;
                    end
                    else begin
                        if (r_rx_cnt == 8'd1) begin
                            r_gbuf_int_w_en <= 1'b1;
                            r_gbuf_int_w_byte <= w_rx_buf_byte;
                            r_gbuf_int_w_addr <= r_rx_buf_r_addr;
                        end 
                        else begin
                            /* We copy only the first packet to Glossy buffer
                               So, nothing to do here.
                             */
                        end
                        r_tx_buf_w_en <= 1'b1;
                        r_tx_buf_w_addr <= r_rx_buf_r_addr;
                        r_tx_buf_w_byte <= w_rx_buf_byte;

                        r_rx_buf_r_addr <= r_rx_buf_r_addr + 7'd1;
                        /* We must read the byte after one cycle */
                        r_nxt_state <= `GLOSSY_STATE_CP_RXBUF_TO_TXBUF_GBUF; 
                        r_state <= `GLOSSY_STATE_WAIT_CYCLE;
                    end
                end

                /* In this state, we check if we need to stop the re-transmission. */
                `GLOSSY_STATE_CP_RXBUF_TO_TXBUF_GBUF_DONE: begin
                    /* Check if this is a reception that is just after a transmission. 
                       If so, we need to update the slot time.
                       NOTE: We don't do this checking at the GLOSSY_STATE_RX_DONE state since
                       r_rl_cnt_rx is updated there. 
                     */
`ifdef GLOSSY_RECV_EN_MIN_RL_CNT_VALIDATION
                    if (r_mode) begin
                        if (r_rl_cnt_rx == r_rl_cnt_tx + 8'd1 && r_tx_cnt > 0) begin
                            r_t_cnt_slot_sum <= r_t_cnt_slot_sum + r_t_cnt_rx_sfd - r_t_cnt_tx_sfd;
                            r_n_slots <= r_n_slots + 8'd1;
                        end
                        else begin
                            /* Do nothing since this is not a reception that is just after a transmission */
                        end
                    end
                    else begin
                        /* verilator lint_off UNSIGNED */
                        if (r_rl_cnt_rx >= `GLOSSY_RECV_MIN_RL_CNT 
                            && r_rl_cnt_rx == r_rl_cnt_tx + 8'd1 
                            && r_tx_cnt > 0) begin
                        /* verilator lint_on UNSIGNED */
                            r_t_cnt_slot_sum <= r_t_cnt_slot_sum + r_t_cnt_rx_sfd - r_t_cnt_tx_sfd;
                            r_n_slots <= r_n_slots + 8'd1;
                        end
                        else begin
                            /* Do nothing since this is not a reception that is just after a transmission 
                               or received relay count is below the minimum allowed. 
                             */
                        end
                    end
`else // GLOSSY_RECV_EN_MIN_RL_CNT_VALIDATION
                    if (r_rl_cnt_rx == r_rl_cnt_tx + 8'd1 && r_tx_cnt > 0) begin
                        r_t_cnt_slot_sum <= r_t_cnt_slot_sum + r_t_cnt_rx_sfd - r_t_cnt_tx_sfd;
                        r_n_slots <= r_n_slots + 8'd1;
                    end
                    else begin
                        /* Do nothing since this is not a reception that is just after a transmission */
                    end
`endif // GLOSSY_RECV_EN_MIN_RL_CNT_VALIDATION
                    /* Check if we need to stop after a reception.
                       NOTE: We do this checking here since we need to copy the received frame to
                             Glossy buffer. 
                     */
                    if (w_stop_flag) begin
                        r_nxt_state <= `GLOSSY_STATE_END;
                        r_state <= `GLOSSY_STATE_WAIT_CYCLE;
                    end
                    else begin
                        r_nxt_state <= `GLOSSY_STATE_RX_TO_TX_DELAY;
                        r_state <= `GLOSSY_STATE_UPDATE_RC;
                        r_rl_cnt_tx <= r_rl_cnt_rx + 8'd1;
                    end
                end

                /* Increase relay counter by one */
                `GLOSSY_STATE_UPDATE_RC: begin
                    r_tx_buf_w_en <= 1'b1;
                    r_tx_buf_w_addr <= `GLOSSY_RXTX_ADDR_RL_CNT;
                    r_tx_buf_w_byte <= r_rl_cnt_tx;
                    r_state <= r_nxt_state;
                    r_nxt_state <= `GLOSSY_STATE_IDLE;
                end

                /* RX to TX delay */
                `GLOSSY_STATE_RX_TO_TX_DELAY: begin
                    r_tx_buf_w_en <= 1'b0;
                    if (r_t_cnt_clk < r_t_cnt_tx_start_timeout) begin
                        r_state <= `GLOSSY_STATE_RX_TO_TX_DELAY;
                    end
                    else begin
                        r_state <= `GLOSSY_STATE_TX_START; 
                    end
                end

                /* ------------------------ TX processing states -------------------------------- */
                
                /* In this state, we prepare the initiator to start transmission. */
                `GLOSSY_STATE_TX_START_INI: begin
                    r_tx_rx_len <= w_gbuf_r_byte[6:0];
                    r_gbuf_int_r_addr <= `GLOSSY_RXTX_ADDR_FRM_START;
                    r_nxt_state <= `GLOSSY_STATE_CP_GBUF_TO_TXBUF; 
                    r_state <= `GLOSSY_STATE_WAIT_CYCLE;
                end

                /* The initiator copies the frame to the tx buffer before start transmitting */
                `GLOSSY_STATE_CP_GBUF_TO_TXBUF: begin
                    /* We have to iterate (frame length + 1) times since first byte of the RX buffer 
                       is the frame length. 
                     */
                    if (r_gbuf_int_r_addr == r_tx_rx_len + 7'd1) begin
                        r_state <= `GLOSSY_STATE_TX_START;
                    end
                    else begin
                        if (r_gbuf_int_r_addr == `GLOSSY_RXTX_ADDR_RL_CNT) begin
                            r_tx_buf_w_byte <= 0; // Initialize relay counter to zero
                        end
                        else begin
                            r_tx_buf_w_byte <= w_gbuf_int_r_byte;
                        end
                        r_tx_buf_w_en <= 1'b1;
                        r_tx_buf_w_addr <= r_gbuf_int_r_addr;
                        r_gbuf_int_r_addr <= r_gbuf_int_r_addr + 7'd1;
                        r_nxt_state <= `GLOSSY_STATE_CP_GBUF_TO_TXBUF; 
                        r_state <= `GLOSSY_STATE_WAIT_CYCLE;
                    end
                end

                /* In this state, we start the transmission. */
                `GLOSSY_STATE_TX_START: begin
                    /* Always disable RX before TX start, 
                       since we don't want to receive our own transmissions. 
                     */
                    r_rx_enable <= 1'b0;
                    r_tx_buf_w_en <= 1'b0; // Disable write access to TX buffer
                    r_tx_start <= 1'b1;
                    r_state <= `GLOSSY_STATE_TX_EVENTS;
                end

                /* In this state, we processes TX events. */
                `GLOSSY_STATE_TX_EVENTS: begin
                    r_tx_start <= 0;
                    if (w_tx_ev_sig) begin
                        if (w_tx_ev == `TX_EVENT_SFD) begin
                            r_t_cnt_tx_sfd <= r_t_cnt_clk;
                            r_state <= `GLOSSY_STATE_TX_EVENTS;             
                        end
                        else if (w_tx_ev == `TX_EVENT_END) begin
                            r_tx_cnt <= r_tx_cnt + 8'd1;
                            r_state <= `GLOSSY_STATE_TX_DONE;
                        end
                        else begin
                            /* Some other TX event that we don't care */
                            r_state <= `GLOSSY_STATE_TX_EVENTS;  
                        end
                    end
                    else begin
                        r_state <= `GLOSSY_STATE_TX_EVENTS;
                    end
                end

                /* In this state, we check if we need to stop after a transmission. */
                `GLOSSY_STATE_TX_DONE: begin
                    /* Check if this is a transmission that is just after a reception. 
                       If so, we need to update the slot time.
                       NOTE: We don't do this checking at the GLOSSY_STATE_RX_DONE state since
                       r_rl_cnt_rx is updated there. 
                     */
`ifdef GLOSSY_RECV_EN_MIN_RL_CNT_VALIDATION
                    if (r_mode) begin
                        if (r_rl_cnt_tx == r_rl_cnt_rx + 8'd1 && r_rx_cnt > 0) begin
                            r_t_cnt_slot_sum <= r_t_cnt_slot_sum + r_t_cnt_tx_sfd - r_t_cnt_rx_sfd;
                            r_n_slots <= r_n_slots + 8'd1;
                        end
                        else begin
                            /* Do nothing since this is not a transmission that is just after a reception */
                        end
                    end
                    else begin
                        /* verilator lint_off UNSIGNED */
                        if (r_rl_cnt_rx >= `GLOSSY_RECV_MIN_RL_CNT 
                            && r_rl_cnt_tx == r_rl_cnt_rx + 8'd1 
                            && r_rx_cnt > 0) begin
                        /* verilator lint_on UNSIGNED */
                            r_t_cnt_slot_sum <= r_t_cnt_slot_sum + r_t_cnt_tx_sfd - r_t_cnt_rx_sfd;
                            r_n_slots <= r_n_slots + 8'd1;
                        end
                        else begin
                            /* Do nothing since this is not a transmission that is just after a reception */
                        end
                    end
`else // GLOSSY_RECV_EN_MIN_RL_CNT_VALIDATION
                    if (r_rl_cnt_tx == r_rl_cnt_rx + 8'd1 && r_rx_cnt > 0) begin
                        r_t_cnt_slot_sum <= r_t_cnt_slot_sum + r_t_cnt_tx_sfd - r_t_cnt_rx_sfd;
                        r_n_slots <= r_n_slots + 8'd1;
                    end
                    else begin
                        /* Do nothing since this is not a transmission that is just after a reception */
                    end
`endif // GLOSSY_RECV_EN_MIN_RL_CNT_VALIDATION



                    /* Calculate estimated slot time. */
                    if (r_tx_cnt == 8'd1) begin
                        /* Estimate slot length based on the frame length. */
                        /* We use r_tx_rx_len + 8'd1 since we have account for the frame length field
                           size.
                          */
                        r_t_cnt_slot_est <= 64'd2 
                                            + ({56'd0, (r_tx_rx_len + 8'd1)} *  `GLOSSY_TXRX_BYTE_TIME) 
                                            + `GLOSSY_RX_TO_TX_TURNAROUND 
                                            + `GLOSSY_TX_START_TO_TX_SFD;  
                    end
                    else begin
                        /* Nothing to do here since we estimate the slot time 
                           only after the first transmission. */
                    end

                    if (r_mode && r_rx_cnt == 0) begin
                        /* Estimate initiator transmission timeout.
                            If the Glossy initiator has not received a frame from a Glossy receiver,
                            the frame is transmitted in the next slot.
                            */
                        r_t_cnt_ini_rtx_timeout <= ((64'd2 
                                                        + ({56'd0, (r_tx_rx_len + 8'd1)} *  `GLOSSY_TXRX_BYTE_TIME)
                                                        + `GLOSSY_RX_TO_TX_TURNAROUND) << 1)
                                                    + `GLOSSY_TX_START_TO_TX_SFD 
                                                    + r_t_cnt_tx_sfd;
                    end
                    else begin
                      /* Nothing to do. */  
                    end

                    if (w_stop_flag) begin
                        r_nxt_state <= `GLOSSY_STATE_END;
                    end
                    else begin
                        r_nxt_state <= `GLOSSY_STATE_RX_START;
                    end

                    r_t_cnt_rx_start_timeout <= 64'd2 
                                                + ({56'd0, (r_tx_rx_len + 8'd1)} *  `GLOSSY_TXRX_BYTE_TIME) 
                                                +  `GLOSSY_TX_TO_RX_TURNAROUND 
                                                + r_t_cnt_tx_sfd;
                    r_state <= `GLOSSY_STATE_TX_TO_RX_DELAY;
                end

                /* In this state, we delay starting the reception after a transmission. */
                `GLOSSY_STATE_TX_TO_RX_DELAY: begin
                    if (r_t_cnt_clk < r_t_cnt_rx_start_timeout) begin
                        r_state <= `GLOSSY_STATE_TX_TO_RX_DELAY;
                    end
                    else begin
                        r_state <= r_nxt_state;
                        r_nxt_state <= `GLOSSY_STATE_IDLE;
                    end
                end

                /* ------------------------------- Common states -------------------------------- */

                /* In this state, we Wait one cycle and go to the next state. 
                   This state is used to read from buffer(s) i.e. RX buffer and Glossy buffer. 
                 */
                `GLOSSY_STATE_WAIT_CYCLE: begin
                    r_gbuf_int_w_en <= 0;
                    r_tx_buf_w_en <= 0;
                    o_done <= 0;
                    r_state <= r_nxt_state;
                    r_nxt_state <= `GLOSSY_STATE_IDLE;
                end

                `GLOSSY_STATE_END: begin
                    /* Unlock the Glossy buffer at the end of Glossy phase, 
                       so the application can write new data to the Glossy buffer. 
                     */
                    r_gbuf_lock <= 0;
                    r_rx_enable <= 0;
                    o_done <= 1'b1;
                    /* Calculate reference time. */
                    if (r_t_cnt_ref_updated) begin
                        if (r_n_slots > 0) begin
                            r_t_cnt_ref <= r_t_cnt_ref 
                                            - ({56'd0, r_f_rl_cnt} 
                                                * r_t_cnt_slot_sum / {56'd0, r_n_slots});
                            //r_t_cnt_ref <= r_t_cnt_ref; 
                        end
                        else begin
                            /* Calculate reference time based on estimated slot time. */
                            r_t_cnt_ref <= r_t_cnt_ref - ({56'd0, r_f_rl_cnt} * r_t_cnt_slot_est);
                        end
                    end
                    else begin
                        /* Nothing to do since reference time was not updated. */  
                    end

                    r_state <= `GLOSSY_STATE_IDLE;
                end

                default: begin
                  
                end
            endcase
        end
    end

endmodule