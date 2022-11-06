`include "glossy.vh"
`include "glossy_app_config.vh"

`define GLOSSY_APP_STATE_IDLE                      4'd0
`define GLOSSY_APP_STATE_INI_LOAD_INIT             4'd1
`define GLOSSY_APP_STATE_INI_LOAD                  4'd2
`define GLOSSY_APP_STATE_INI_TX                    4'd3
`define GLOSSY_APP_STATE_INI_WAIT_PERIOD           4'd4
`define GLOSSY_APP_STATE_INI_WAIT_GLOSSY_DONE      4'd5
`define GLOSSY_APP_STATE_RCV_INIT                  4'd6
`define GLOSSY_APP_STATE_RCV_WAIT_PERIOD           4'd7
`define GLOSSY_APP_STATE_RCV_WAIT_GLOSSY_DONE      4'd8
`define GLOSSY_APP_STATE_DONE                      4'd9

`define GLOSSY_APP_SYNC_STATE_IDLE                 2'd0
`define GLOSSY_APP_SYNC_STATE_IND_WAIT             2'd1
`define GLOSSY_APP_SYNC_STATE_IND_HIGH             2'd2


module glossy_app(clk, reset, 
                    i_start,
                    i_mode,
                    /* TX/RX lines */
                    i_rx_in,
                    o_rx_in_clk,
                    o_tx_out,
                    o_tx_out_clk,
                    o_rx_sfd,
                    o_tx_sfd,
                    o_tx_active,
                    o_rx_active,
                    /* Status lines */
                    o_sync_ind);

    parameter WIDTH=10;

    input clk;
    input reset;
    input i_start;
    input i_mode;
    // TX/RX lines
    input  [WIDTH-1:0]  i_rx_in;
    output              o_rx_in_clk;
    output [WIDTH-1:0]  o_tx_out;
    output              o_tx_out_clk;
    output              o_rx_sfd;
    output              o_tx_sfd;
    output              o_tx_active;
    output              o_rx_active;
    /* Other configurations */
    output reg          o_sync_ind = 0;

    reg         r_glossy_start = 0;
    reg         r_glossy_mode = 0;
    wire        w_glossy_done;
    wire        w_t_cnt_ref_updated;
    wire [63:0] w_t_cnt_ref;
    wire [63:0] w_t_cnt_g_clk;
    reg  [63:0] r_t_cnt_g_clk_period_stop;

    reg       r_ini_buf_w_en = 0;
    reg [7:0] r_ini_buf_w_byte = 8'h00;
    reg [6:0] r_ini_buf_w_addr = 7'h00;
    reg [6:0] r_byte_idx = 7'h00;

    //reg [6:0]   r_recv_buf_r_addr = 7'h00;
    //wire [7:0]  w_recv_buf_r_byte;

    // Length should includes size of 2-byte footer [RSSI, (FCS_OK, MIN_PWR)]
    // +------------------------------------------+
    // | LEN(1) | RL_CNT(1) | DATA(n) | FCS(2)    |
    // +------------------------------------------+
    reg [7:0]   r_glossy_frame [7:0]; // len(1) + relay counter(1) + data(4) + fcs(2)
    reg [31:0]  r_frm_cnt = 32'd0;

    reg [63:0] r_t_cnt_sync_ind_wait = 0;

    reg [3:0]  r_state = `GLOSSY_APP_STATE_IDLE;
    reg [1:0]  r_state_ind = `GLOSSY_APP_SYNC_STATE_IDLE;

    glossy glossy_inst(.clk(clk), .reset(reset),
                        // Glossy main interface
                        .i_start(r_glossy_start),
                        .i_mode(r_glossy_mode),
                        .i_n_tx_max(`GLOSSY_APP_MAX_N_TX),
                        .i_t_cnt_active(`GLOSSY_APP_T_GLOSSY_SLOT),
                        .o_t_cnt_ref(w_t_cnt_ref),
                        .o_t_cnt_ref_updated(w_t_cnt_ref_updated),
                        .o_done(w_glossy_done),
                        .o_t_cnt_g_clk(w_t_cnt_g_clk),
                        // TX and RX inputs/outputs
                        .i_rx_in(i_rx_in),
                        .o_rx_in_clk(o_rx_in_clk),
                        .o_tx_out(o_tx_out),
                        .o_tx_out_clk(o_tx_out_clk),
                        .o_tx_sfd(o_tx_sfd),
                        .o_rx_sfd(o_rx_sfd),
                        .o_tx_active(o_tx_active),
                        .o_rx_active(o_rx_active),
                        // Initiator buffer access lines
                        .i_buf_w_en(r_ini_buf_w_en),
                        .i_buf_w_addr(r_ini_buf_w_addr),
                        .i_buf_w_byte(r_ini_buf_w_byte)
                        // Receiver buffer access lines
                        //.i_buf_r_addr(r_recv_buf_r_addr), // Read address
                        //.o_buf_r_byte(w_recv_buf_r_byte));
                        );


    always @ (posedge clk) begin
        case (r_state_ind)
            
            `GLOSSY_APP_SYNC_STATE_IDLE: begin
                if (w_glossy_done && w_t_cnt_ref_updated) begin
                    r_state_ind <= `GLOSSY_APP_SYNC_STATE_IND_WAIT;
                    r_t_cnt_sync_ind_wait <= w_t_cnt_ref + `GLOSSY_APP_SYNC_IND_START;
                end
                else begin
                    r_state_ind <= `GLOSSY_APP_SYNC_STATE_IDLE;
                end
            end

            `GLOSSY_APP_SYNC_STATE_IND_WAIT: begin
                if (w_t_cnt_g_clk < r_t_cnt_sync_ind_wait) begin
                    o_sync_ind <= 1'b0;
                    r_state_ind <= `GLOSSY_APP_SYNC_STATE_IND_WAIT;
                end
                else begin
                    o_sync_ind <= 1'b1;
                    r_t_cnt_sync_ind_wait <= r_t_cnt_sync_ind_wait + `GLOSSY_APP_SYNC_IND_HIGH_TIME;
                    r_state_ind <= `GLOSSY_APP_SYNC_STATE_IND_HIGH;
                end
            end

            `GLOSSY_APP_SYNC_STATE_IND_HIGH: begin
                if (w_t_cnt_g_clk < r_t_cnt_sync_ind_wait) begin
                    o_sync_ind <= 1'b1;
                    r_state_ind <= `GLOSSY_APP_SYNC_STATE_IND_HIGH;
                end
                else begin
                    o_sync_ind <= 1'b0;
                    r_state_ind <= `GLOSSY_APP_SYNC_STATE_IDLE;
                end
            end

            default: begin
                /* Handled all the states */
            end
        endcase
    end

    always @ (posedge clk) begin
        if (reset) begin
            r_state <= `GLOSSY_APP_STATE_IDLE;
            r_frm_cnt <= 0;
        end
        else begin
            case (r_state)
                `GLOSSY_APP_STATE_IDLE: begin
                    if (i_start) begin
                        r_glossy_mode <= i_mode;
                        if (i_mode) begin
                            r_state <= `GLOSSY_APP_STATE_INI_LOAD_INIT;
                        end
                        else begin
                            r_state <= `GLOSSY_APP_STATE_RCV_INIT;
                        end
                    end
                    else begin
                        r_state <= `GLOSSY_APP_STATE_IDLE;
                    end
                end

                //------------------- Initiator states ---------------------------------------------

                /* In this state, we initialize the frame. */
                `GLOSSY_APP_STATE_INI_LOAD_INIT: begin
                    r_glossy_frame[0] <= 8'd7; // Frame length
                    r_glossy_frame[1] <= 8'd0; // Relay counter (Reset by glossy module before TX)
                    r_glossy_frame[2] <= r_frm_cnt[7:0];
                    r_glossy_frame[3] <= r_frm_cnt[15:8];
                    r_glossy_frame[4] <= r_frm_cnt[23:16];
                    r_glossy_frame[5] <= r_frm_cnt[31:24];
                    r_glossy_frame[6] <= 8'd0; // Left as zeros (FCS is added before TX)
                    r_glossy_frame[7] <= 8'd0; // Left as zeros (FCS is added before TX)
                    r_frm_cnt <= r_frm_cnt + 32'd1;
                    r_byte_idx <= 0;
                    r_state <= `GLOSSY_APP_STATE_INI_LOAD;
                end

                /* In this state, we load the frame to the Glossy buffer */
                `GLOSSY_APP_STATE_INI_LOAD: begin
                    if (r_byte_idx == 8) begin
                        r_ini_buf_w_en <= 0;
                        r_t_cnt_g_clk_period_stop <= w_t_cnt_g_clk + {32'd0, `GLOSSY_APP_T_GLOSSY_PERIOD};
                        r_glossy_start <= 1; // Glossy start for the initiator
                        r_state <= `GLOSSY_APP_STATE_INI_WAIT_GLOSSY_DONE;
                    end
                    else begin
                        r_ini_buf_w_en <= 1'b1;
                        r_ini_buf_w_addr <= r_byte_idx;
                        r_ini_buf_w_byte <= r_glossy_frame[r_byte_idx[2:0]];
                        r_byte_idx <= r_byte_idx + 7'd1;
                        r_state <= `GLOSSY_APP_STATE_INI_LOAD;
                    end
                end

                /* In this state, we wait until the initiator's Glossy phase is completed. */
                `GLOSSY_APP_STATE_INI_WAIT_GLOSSY_DONE: begin
                    r_glossy_start <= 0;
                    if (w_glossy_done) begin
                        r_state <= `GLOSSY_APP_STATE_INI_WAIT_PERIOD;
                    end
                    else begin
                        r_state <= `GLOSSY_APP_STATE_INI_WAIT_GLOSSY_DONE;
                    end
                end

                /* In this state, we wait until Glossy period elapsed to start next Glossy phase */
                `GLOSSY_APP_STATE_INI_WAIT_PERIOD: begin
                    if (w_t_cnt_g_clk < r_t_cnt_g_clk_period_stop) begin
                        r_state <= `GLOSSY_APP_STATE_INI_WAIT_PERIOD;
                    end
                    else begin
                        r_state <= `GLOSSY_APP_STATE_INI_LOAD_INIT;
                    end
                end

                //------------------- Receiver states ----------------------------------------------

                `GLOSSY_APP_STATE_RCV_INIT: begin
                    r_glossy_start <= 1'b1; // Glossy start for the receiver
                    r_state <= `GLOSSY_APP_STATE_RCV_WAIT_GLOSSY_DONE;
                end

                `GLOSSY_APP_STATE_RCV_WAIT_GLOSSY_DONE: begin
                    r_glossy_start <= 0;
                    if (w_glossy_done) begin
                        if (w_t_cnt_ref_updated) begin
                            /* Synchronized */
                            r_t_cnt_g_clk_period_stop <= w_t_cnt_ref 
                                                            + {32'd0, `GLOSSY_APP_T_GLOSSY_PERIOD} 
                                                            - {32'd0, `GLOSSY_APP_T_GLOSSY_GUARD};
                            r_state <= `GLOSSY_APP_STATE_RCV_WAIT_PERIOD;
                        end
                        else begin
                            /* Synchronization missed. Need to bootstrap */
                            r_state <= `GLOSSY_APP_STATE_RCV_INIT;
                        end
                    end
                    else begin
                        r_state <= `GLOSSY_APP_STATE_RCV_WAIT_GLOSSY_DONE;
                    end
                end

                `GLOSSY_APP_STATE_RCV_WAIT_PERIOD: begin
                    if (w_t_cnt_g_clk < r_t_cnt_g_clk_period_stop) begin
                        r_state <= `GLOSSY_APP_STATE_RCV_WAIT_PERIOD;
                    end
                    else begin
                        r_state <= `GLOSSY_APP_STATE_RCV_INIT;
                    end
                end

                default: begin
                    /* Handled all the states */
                end 
            endcase
        end
    end

endmodule