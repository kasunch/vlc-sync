`include "sym_dec.vh"
`include "sym_common.vh"

`define SYM_DEC_STATE_IDLE          4'h0
`define SYM_DEC_STATE_MIN_SEARCH    4'h1
`define SYM_DEC_STATE_PREAMBLE      4'h2
`define SYM_DEC_STATE_SFD           4'h3
`define SYM_DEC_STATE_PHR           4'h4
`define SYM_DEC_STATE_PSDU          4'h5
`define SYM_DEC_STATE_FCS           4'h6
`define SYM_DEC_STATE_FINALIZE      4'h7
`define SYM_DEC_STATE_COMPLETE      4'h8

module sym_dec (clk, reset,
                i_next, 
                i_bin0_mag, 
                i_binvsc_mag, 
                i_bin1_mag,
                o_byte, 
                o_ev_sig, 
                o_ev, 
                o_fcs_ok);
                
    parameter WIDTH=16, 
                MIN_MAG_DIFF=16'd100,
                DFT_BIT_TIME=8'd79;
    
    input               clk; 
    input               reset;
    input               i_next;
    
    input [WIDTH-1:0]   i_bin0_mag;
    input [WIDTH-1:0]   i_binvsc_mag;
    input [WIDTH-1:0]   i_bin1_mag;
    
    output reg [7:0]    o_byte = 8'd0;
    output reg [2:0]    o_ev = `SYM_DEC_EV_NONE;
    output reg          o_ev_sig = 0;
    output reg          o_fcs_ok = 0;

    reg [3:0]                       r_state = `SYM_DEC_STATE_IDLE;
    reg [7:0]                       r_sfd = `SYM_ENC_DEC_SFD;
    reg [6:0]                       r_phr;
    reg [7:0]                       r_dft_out_cnt = 0;
    reg [7:0]                       r_dft_cnt_min_first = 0;
    reg [7:0]                       r_dft_cnt_wait_bit = 0;
    reg [7:0]                       r_bit_idx = 0;
    reg [6:0]                       r_byte_idx = 0;
    reg                             r_fcs_bit_in = 0;
    reg                             r_fcs_next = 0;
    reg [`SYM_ENC_DEC_FCS_SIZE-1:0] r_fcs_rcvd;     
    reg [15:0]                      r_bin_pwr_avg = 0;
    reg [15:0]                 r_vsc_mag_min = 16'h3FF;

    wire                                    w_bit;
    wire                                    w_bit_valid;
    wire [WIDTH-1:0]                        w_bin_mag_diff;
    wire [WIDTH-1:0]                        w_bin_pwr;
    wire [`SYM_ENC_DEC_PREAMBLE_SIZE-1:0]   w_preamble;
    wire [`SYM_ENC_DEC_FCS_SIZE-1:0]        w_fcs;

    wire w_vc_pos_slope;
    wire w_vc_neg_slope;
    reg  r_min_bit = 0;

    crc16_ccitt     crc_inst(.clk(clk), .reset(reset), 
                                .i_next(r_fcs_next), 
                                .i_bit(r_fcs_bit_in), 
                                .o_crc(w_fcs));

    slope_find      slope_find_vc(.clk(i_next), 
                                .i_in(i_binvsc_mag), 
                                .o_pos_slope(w_vc_pos_slope), 
                                .o_neg_slope(w_vc_neg_slope));

    assign w_preamble       = `SYM_ENC_DEC_PREAMBLE;
    assign w_bit            = i_bin0_mag > i_bin1_mag ? 1'b0 : 1'b1;
    assign w_bin_mag_diff   = i_bin0_mag >= i_bin1_mag ? 
                                i_bin0_mag - i_bin1_mag : i_bin1_mag - i_bin0_mag; 
    assign w_bit_valid      = (w_bin_mag_diff > MIN_MAG_DIFF) ? 1'b1 : 1'b0; 
    assign w_bin_pwr        = i_bin0_mag > i_bin1_mag ? i_bin0_mag : i_bin1_mag;
                
    always @ (posedge clk) begin
        if (reset) begin
            r_state <= `SYM_DEC_STATE_IDLE;
            o_ev_sig <= 0;
            o_ev <= `SYM_DEC_EV_NONE;
            o_fcs_ok <= 0;
        end
        else begin
        
            if (i_next) begin

                case (r_state)

                    `SYM_DEC_STATE_IDLE: begin
                        if (w_bit_valid && w_vc_neg_slope) begin
                            r_min_bit <= w_bit;
                            r_dft_out_cnt <= 0;
                            r_vsc_mag_min <= i_binvsc_mag;
                            r_dft_cnt_min_first <= 0;
                            r_state <= `SYM_DEC_STATE_MIN_SEARCH;
                        end
                        else begin
                            r_state <= `SYM_DEC_STATE_IDLE;
                        end
                        o_fcs_ok <= 0;
                    end

                    // Here, we look for the first and last occurrences of the minimum.
                    // Then, we take the middle point as the starting point
                    `SYM_DEC_STATE_MIN_SEARCH: begin
                        if (w_vc_pos_slope) begin
                            // We've detected a positive slope
                            if (r_min_bit == w_preamble[0]) begin
                                // We've successfully received first bit of the preamble
                                r_bit_idx <= 1;
                                r_dft_cnt_wait_bit <= DFT_BIT_TIME + r_dft_cnt_min_first + 8'd2;
                                r_dft_out_cnt <= r_dft_out_cnt + 8'd1;
                                r_state <= `SYM_DEC_STATE_PREAMBLE;
                            end
                            else begin
                                // Invalid bit
                                r_state <= `SYM_DEC_STATE_IDLE;
                            end
                        end
                        else begin
                            if (r_vsc_mag_min > i_binvsc_mag) begin
                                r_min_bit <= w_bit;
                                r_vsc_mag_min <=  i_binvsc_mag;
                                r_dft_cnt_min_first <= r_dft_out_cnt;
                            end
                            else begin
                                // Nothing to do here
                            end
                            r_dft_out_cnt <= r_dft_out_cnt + 8'd1;
                            r_state <= `SYM_DEC_STATE_MIN_SEARCH;
                        end
                    end

                    // We have detected a possible start of the preamble.
                    `SYM_DEC_STATE_PREAMBLE: begin
                        if (r_dft_out_cnt == r_dft_cnt_wait_bit) begin
                            if (w_bit == w_preamble[r_bit_idx[2:0]]) begin
                                if (r_bit_idx == `SYM_ENC_DEC_PREAMBLE_SIZE - 1) begin
                                    // We have received the preamble.
                                    o_ev <= `SYM_DEC_EV_PREAMBLE;
                                    o_ev_sig <= 1;
                                    r_bit_idx <= 0;
                                    // Reset the average power to zero since 
                                    // we are going in measure during SFD reception
                                    r_bin_pwr_avg <= 0;
                                    r_state <= `SYM_DEC_STATE_SFD;
                                end
                                else begin
                                    r_bit_idx <= r_bit_idx + 8'd1;
                                    r_state <= `SYM_DEC_STATE_PREAMBLE;
                                end
                                r_dft_out_cnt <= 0;
                                r_dft_cnt_wait_bit <= DFT_BIT_TIME;
                            end
                            else begin
                                // Incorrect/invalid bit.
                                r_state <= `SYM_DEC_STATE_IDLE;
                            end 
                        end
                        else begin
                            r_dft_out_cnt <= r_dft_out_cnt + 8'd1;
                            r_state <= `SYM_DEC_STATE_PREAMBLE;
                        end 
                    end

                    `SYM_DEC_STATE_SFD: begin
                        if (r_dft_out_cnt == DFT_BIT_TIME) begin
                            if (w_bit == r_sfd[r_bit_idx[2:0]]) begin
                                r_bin_pwr_avg <= r_bin_pwr_avg + {{(16-WIDTH){1'b0}}, w_bin_pwr};
                                if (r_bit_idx == `SYM_ENC_DEC_SFD_SIZE - 1) begin
                                    // We've received the SFD.
                                    o_ev <= `SYM_DEC_EV_SFD;
                                    o_ev_sig <= 1;
                                    r_bit_idx <= 0;
                                    r_state <= `SYM_DEC_STATE_PHR;
                                end
                                else begin
                                    r_bit_idx <= r_bit_idx + 8'd1;
                                    r_state <= `SYM_DEC_STATE_SFD;
                                end
                                r_dft_out_cnt <= 0;
                            end
                            else begin
                                // Incorrect/invalid bit.
                                r_state <= `SYM_DEC_STATE_IDLE;
                            end
                        end
                        else begin
                            r_dft_out_cnt <= r_dft_out_cnt + 8'd1;
                            r_state <= `SYM_DEC_STATE_SFD;
                        end
                    end

                    `SYM_DEC_STATE_PHR: begin
                        if (r_dft_out_cnt == DFT_BIT_TIME) begin
                            if (r_bit_idx == `SYM_ENC_DEC_PHR_SIZE - 1) begin
                                // Though PHR (PHY header) is 8 bits, MSB is reserved.
                                // So we don't care the value of received MSB.
                                if (r_phr < 2) begin
                                    // Invalid frame length. The mandatory FCS is 2 bytes in length 
                                    // There is no point of receiving this packet.
                                    // So go to idle
                                    r_bit_idx <= 0;
                                    r_state <= `SYM_DEC_STATE_IDLE;
                                end
                                else begin
                                    // Valid frame length.
                                    o_ev <= `SYM_DEC_EV_PHR;
                                    o_ev_sig <= 1;
                                    o_byte <= {1'b0, r_phr};
                                    r_bit_idx <= 0;
                                    r_byte_idx <= 0;
                                    r_state <= `SYM_DEC_STATE_PSDU;
                                end
                            end
                            else begin
                                r_phr[r_bit_idx[2:0]] <= w_bit;
                                r_bit_idx <= r_bit_idx + 8'd1;
                                r_state <= `SYM_DEC_STATE_PHR;
                            end
                            r_dft_out_cnt <= 0;
                        end
                        else begin
                            r_dft_out_cnt <= r_dft_out_cnt + 8'd1;
                            r_state <= `SYM_DEC_STATE_PHR;
                        end 
                    end

                    `SYM_DEC_STATE_PSDU: begin
                        if (r_dft_out_cnt == DFT_BIT_TIME) begin
                            o_byte[r_bit_idx[2:0]] <= w_bit;
                            r_fcs_bit_in <= w_bit;
                            r_fcs_next <= 1;
                            if (r_bit_idx == 7) begin
                                // We've received a complete byte
                                if (r_byte_idx == r_phr - 7'd3) begin
                                    // We've received the entire PSDU except FCS (2 bytes)
                                    // Go to CRC reception
                                    // Compute average received power during SFD reception
                                    // (over 8 bit period) 
                                    r_bin_pwr_avg <= r_bin_pwr_avg >> 3;
                                    r_byte_idx <= 0;
                                    r_state <= `SYM_DEC_STATE_FCS;
                                end 
                                else begin
                                    r_byte_idx <= r_byte_idx + 7'd1;
                                    r_state <= `SYM_DEC_STATE_PSDU;
                                end
                                o_ev <= `SYM_DEC_EV_BYTE;
                                o_ev_sig <= 1;
                                r_bit_idx <= 0;
                            end
                            else begin
                                r_bit_idx <= r_bit_idx + 8'd1;
                                r_state <= `SYM_DEC_STATE_PSDU;
                            end
                            r_dft_out_cnt <= 0;
                        end
                        else begin
                            r_dft_out_cnt <= r_dft_out_cnt + 8'd1;
                            r_state <= `SYM_DEC_STATE_PSDU;
                        end 
                    end

                    `SYM_DEC_STATE_FCS: begin
                        if (r_dft_out_cnt == DFT_BIT_TIME) begin
                            r_fcs_rcvd[r_bit_idx[3:0]] <= w_bit;
                            if (r_bit_idx == `SYM_ENC_DEC_FCS_SIZE - 1) begin
                                // We have received the entire FCS
                                r_state <= `SYM_DEC_STATE_FINALIZE;
                                r_bit_idx <= 0;
                                // Replace first byte of FCS with RSSI 
                                o_byte <= r_bin_pwr_avg[7:0];
                                o_ev <= `SYM_DEC_EV_BYTE;
                                o_ev_sig <= 1;
                            end
                            else begin
                                r_bit_idx <= r_bit_idx + 8'd1;
                                r_state <= `SYM_DEC_STATE_FCS;
                            end
                            r_dft_out_cnt <= 0;
                        end
                        else begin
                            r_dft_out_cnt <= r_dft_out_cnt + 8'd1;
                            r_state <= `SYM_DEC_STATE_FCS;
                        end 
                    end

                    `SYM_DEC_STATE_FINALIZE: begin
                        if (r_dft_out_cnt == DFT_BIT_TIME) begin
                            // Replace second byte of FCS with CRC status and
                            // averaged minimum of the virtual sub-scarrier. 
                            if (r_fcs_rcvd == w_fcs) begin
                                o_fcs_ok <= 1;
                                o_byte <= {1'b1, r_bin_pwr_avg[14:8]};
                            end
                            else begin
                                o_fcs_ok <= 0;
                                o_byte <= {1'b0, r_bin_pwr_avg[14:8]};
                            end
                            o_ev <= `SYM_DEC_EV_BYTE;
                            o_ev_sig <= 1;
                            r_dft_out_cnt <= 0;
                            r_state <= `SYM_DEC_STATE_COMPLETE;
                        end
                        else begin
                            r_dft_out_cnt <= r_dft_out_cnt + 8'd1;
                            r_state <= `SYM_DEC_STATE_FINALIZE;
                        end
                    end

                    `SYM_DEC_STATE_COMPLETE: begin
                        // Reception complete. 
                        r_state <= `SYM_DEC_STATE_IDLE;
                        o_ev <= `SYM_DEC_EV_COMPLETE;
                        o_ev_sig <= 1;
                    end

                    default: begin
                        // We handled all the states.
                    end

                endcase

            end
            else begin
                // All the signals which need to be set low in the next clock cycle
                // should be set in here
                r_fcs_next <= 0;
                o_ev_sig <= 0;
            end
        end
    end
                
endmodule
