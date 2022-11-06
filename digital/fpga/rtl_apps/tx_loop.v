`include "tx.vh"

`define TX_LOOP_STATE_IDLE      3'd0
`define TX_LOOP_STATE_LOAD_INIT 3'd1
`define TX_LOOP_STATE_LOAD      3'd2
`define TX_LOOP_STATE_TX        3'd3
`define TX_LOOP_STATE_WAIT      3'd4

`ifdef  TX_LOOP_CONF_WAIT_CNT
`define TX_LOOP_WAIT_CNT        `TX_LOOP_CONF_WAIT_CNT
`else
`define TX_LOOP_WAIT_CNT        32'd2000000 // 100 ms with 20 MHz clock
`endif

module tx_loop(clk, reset, 
                i_start,
                o_tx_sfd, 
                o_tx_active, 
                o_tx_out,
                o_tx_out_clk,
                o_wait_done);
    
    parameter WIDTH=10;

    input clk;
    input reset;
    input              i_start;
    output             o_tx_sfd;
    output             o_tx_active;
    output [WIDTH-1:0] o_tx_out;
    output             o_tx_out_clk;
    output reg         o_wait_done = 0;

    reg [2:0] r_state = `TX_LOOP_STATE_IDLE;
    reg       r_start = 0;
    reg [7:0] r_buf [3:0];
    reg       r_buf_w_en = 0;
    reg [6:0] r_buf_w_addr = 7'h00;
    reg [7:0] r_buf_byte = 8'h00;

    reg [31:0]  r_wait_cnt = 32'd0;
    reg [31:0]  r_frm_cnt = 32'd0;

    wire        w_tx_ev_sig;
    wire [2:0]  w_tx_ev;

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
                .o_sfd(o_tx_sfd),
                .o_active(o_tx_active));

    always @ (posedge clk) begin
        if (reset) begin
            o_wait_done <= 0;
            r_state <= `TX_LOOP_STATE_IDLE;
        end
        else begin
            case (r_state)
                `TX_LOOP_STATE_IDLE: begin
                    if (i_start) begin
                        r_state <= `TX_LOOP_STATE_LOAD_INIT;
                    end
                    else begin
                        r_state <= `TX_LOOP_STATE_IDLE;
                    end  
                end
                `TX_LOOP_STATE_LOAD_INIT: begin
                    r_state <= `TX_LOOP_STATE_LOAD;
                    // Set some values
                    r_buf[0] <= r_frm_cnt[7:0];
                    r_buf[1] <= r_frm_cnt[15:8];
                    r_buf[2] <= r_frm_cnt[23:16];
                    r_buf[3] <= r_frm_cnt[31:24];
                    // First byte in the TX buffer is the length of the frame.
                    // Length should also include the size of FCS
                    r_buf_byte <= 8'd6;
                    r_buf_w_addr <= 0;
                    r_buf_w_en <= 1;
                    o_wait_done <= 0;
                end

                `TX_LOOP_STATE_LOAD: begin
                    // Load the frame to TX buffer
                    if (r_buf_w_addr == 7'd4) begin
                        r_state <= `TX_LOOP_STATE_TX;
                        r_buf_w_en <= 0;
                        r_frm_cnt <= r_frm_cnt + 32'd1;
                        r_start <= 1; // Start transmission  
                    end
                    else begin
                        r_buf_w_addr <= r_buf_w_addr + 7'd1;
                        r_buf_byte <= r_buf[r_buf_w_addr[1:0]];
                    end
                end
                
                `TX_LOOP_STATE_TX: begin
                    r_start <= 0;
                    if (w_tx_ev_sig) begin
                        if (w_tx_ev == `TX_EVENT_SFD) begin
                            r_state <= `TX_LOOP_STATE_TX;
                        end
                        else if (w_tx_ev == `TX_EVENT_END) begin
                            r_state <= `TX_LOOP_STATE_WAIT;
                        end
                        else begin
                            // Nothing to do here  
                        end
                    end
                    else begin
                        // Nothing to do here
                    end
                end

                `TX_LOOP_STATE_WAIT: begin
                    if (r_wait_cnt == `TX_LOOP_WAIT_CNT) begin
                        r_wait_cnt <= 0;
                        o_wait_done <= 1'b1;
                        r_state <= `TX_LOOP_STATE_LOAD_INIT;    
                    end
                    else begin
                        r_wait_cnt <= r_wait_cnt + 32'd1;
                        o_wait_done <= 0;
                    end
                end
                
                default: begin
                    // We handled all the status. So nothing to be done here.
                end
            endcase

        end
    end

endmodule