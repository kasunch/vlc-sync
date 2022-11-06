`include "sym_enc.vh"
`include "sym_common.vh"

`define SYM_ENC_PREAMBLE_BIN_PWR    200
`define SYM_ENC_SFD_BIN_PWR         200

`define SYM_ENC_STATE_IDLE          3'h0
`define SYM_ENC_STATE_PREAMBLE      3'h1
`define SYM_ENC_STATE_SFD           3'h2
`define SYM_ENC_STATE_PHR           3'h3
`define SYM_ENC_STATE_PSDU          3'h4
`define SYM_ENC_STATE_FCS           3'h5
`define SYM_ENC_STATE_FINALIZE      3'h6
`define SYM_ENC_STATE_COMPLETE      3'h7

module sym_enc (clk, reset,
                i_next, i_buf_byte,
                o_buf_addr, o_ev, o_ev_sig, o_bin1, o_bin2);

    parameter WIDTH=10;

    integer i;
    input clk, reset;
    input i_next;
    input [7:0] i_buf_byte;
    
    output reg [6:0]        o_buf_addr = 0;
    output     [2:0]        o_ev;
    output                  o_ev_sig;
    output reg [WIDTH-1:0]  o_bin1 = 0;
    output reg [WIDTH-1:0]  o_bin2 = 0;
    
    reg [2:0]       r_state = `SYM_ENC_STATE_IDLE;
    reg [7:0]       r_sfd = `SYM_ENC_DEC_SFD;
    reg [7:0]       r_len = 0;
    reg             r_crc_in = 0;
    reg             r_crc_next = 0;
    reg [7:0]       r_bit_idx = 8'h00;

    reg [2:0]       r_ev_queue[2:0];
    reg [2:0]       r_current_ev = `SYM_ENC_EV_NONE;
    reg             r_ev_sig = 0;

    wire [`SYM_ENC_DEC_PREAMBLE_SIZE-1:0]   w_preamble;
    wire [`SYM_ENC_DEC_FCS_SIZE-1:0]        w_crc;

    assign w_preamble = `SYM_ENC_DEC_PREAMBLE;

    crc16_ccitt crc_inst(.clk(clk), .reset(reset), 
                            .i_next(r_crc_next), .i_bit(r_crc_in), 
                            .o_crc(w_crc));

    assign o_ev     = r_ev_queue[0];
    assign o_ev_sig = r_ev_sig;

    always @ (posedge clk) begin
        if (reset) begin
            r_state <= `SYM_ENC_STATE_IDLE;
            r_current_ev <= `SYM_ENC_EV_NONE;
            r_ev_queue[0] <= `SYM_ENC_EV_NONE;
            r_ev_queue[1] <= `SYM_ENC_EV_NONE;
            r_ev_queue[2] <= `SYM_ENC_EV_NONE;
            clr_bins();
        end
        else begin
            if (i_next) begin
                case (r_state)
                
                    `SYM_ENC_STATE_IDLE: begin
                        // Start with first bit of the preamble
                        r_state <= `SYM_ENC_STATE_PREAMBLE;
                        set_bins(w_preamble[0]);
                        r_bit_idx <= 1;
                        // Set the TX buffer address to be zero since
                        // the first byte has the frame length
                        o_buf_addr <= 0;
                        r_ev_queue[2] <= `SYM_ENC_EV_STARTED;
                    end
                        
                    `SYM_ENC_STATE_PREAMBLE: begin
                        set_bins(w_preamble[r_bit_idx[2:0]]);
                        if (r_bit_idx == `SYM_ENC_DEC_PREAMBLE_SIZE - 1) begin
                            // We are done encoding the preamble 
                            r_state <= `SYM_ENC_STATE_SFD;
                            r_bit_idx <= 0;
                            r_ev_queue[2] <= `SYM_ENC_EV_PREAMBLE;
                        end
                        else begin
                            r_bit_idx <= r_bit_idx + 8'd1;                          
                        end
                    end                 
                    
                    `SYM_ENC_STATE_SFD: begin
                        set_bins(r_sfd[r_bit_idx[2:0]]);
                        if (r_bit_idx == `SYM_ENC_DEC_SFD_SIZE - 1) begin
                            r_state <= `SYM_ENC_STATE_PHR;
                            r_ev_queue[2] <= `SYM_ENC_EV_SFD;
                            r_bit_idx <= 0;
                            // Note that MSB of the PHR is reserved.
                            // So we copy only the first 7 bits. 
                            r_len <= {1'b0, i_buf_byte[6:0]};
                        end
                        else begin
                            r_bit_idx <= r_bit_idx + 8'd1;                          
                        end
                    end

                    `SYM_ENC_STATE_PHR: begin
                        // Now, first byte, i.e. the frame length is available to us.
                        set_bins(r_len[r_bit_idx[2:0]]);
                        if (r_bit_idx == `SYM_ENC_DEC_PHR_SIZE - 1) begin
                            r_bit_idx <= 0;
                            r_ev_queue[2] <= `SYM_ENC_EV_PHR;
                            if (r_len > 2)  begin
                                // We have data in PSDU other than the FCS  
                                r_state <= `SYM_ENC_STATE_PSDU;
                                // PSDU starts from the 2nd byte of the TX buffer.
                                o_buf_addr <= 7'd1; 
                            end
                            else begin
                                // We have only the FCS
                                r_state <= `SYM_ENC_STATE_FCS;
                            end
                        end
                        else begin
                            r_bit_idx <= r_bit_idx + 8'd1;                           
                        end
                    end
                
                    `SYM_ENC_STATE_PSDU: begin
                        set_bins(i_buf_byte[r_bit_idx[2:0]]);
                        r_crc_in <= i_buf_byte[r_bit_idx[2:0]];
                        r_crc_next <= 1;
                        if (r_bit_idx == 7) begin
                            if (o_buf_addr == r_len[6:0] - 2) begin
                                // The frame length also include the size of FCS
                                // So, we stop reading TX buffer here.
                                r_state <= `SYM_ENC_STATE_FCS;
                            end 
                            else begin
                                // Increase the address to read next
                                o_buf_addr <= o_buf_addr + 7'd1;
                            end
                            r_ev_queue[2] <= `SYM_ENC_EV_BYTE;
                            r_bit_idx <= 0;
                        end
                        else begin
                            r_bit_idx <= r_bit_idx + 8'd1;                           
                        end
                    end   
                    
                    `SYM_ENC_STATE_FCS: begin
                        set_bins(w_crc[r_bit_idx[3:0]]);
                        if (r_bit_idx == `SYM_ENC_DEC_FCS_SIZE - 1) begin
                            // We've finished encoding the FCS.
                            // We are finalizing with the frame processing.
                            r_state <= `SYM_ENC_STATE_FINALIZE;
                            r_ev_queue[2] <= `SYM_ENC_EV_COMPLETE;
                            r_bit_idx <= 0;
                        end
                        else begin
                            r_bit_idx <= r_bit_idx + 8'd1;                           
                        end
                    end  
                    
                    `SYM_ENC_STATE_FINALIZE: begin
                        // Clear the IDFT bins.
                        clr_bins();
                        r_state <= `SYM_ENC_STATE_COMPLETE;
                    end 

                    `SYM_ENC_STATE_COMPLETE: begin
                    end
                
                    default:
                        r_state <= `SYM_ENC_STATE_IDLE;
                        
                endcase

                for (i = 1; i < 3; i = i + 1) begin
                    r_ev_queue[i - 1] <= r_ev_queue[i];
                end

                if (r_ev_queue[1] != r_current_ev) begin
                    r_ev_sig <= 1'b1;
                    r_current_ev <= r_ev_queue[1];
                end
                else begin
                    r_ev_sig <= 1'b0;
                end

            end
            else begin
                // All the signals which need to be set low in the next clock cycle
                // should be set in here
                r_crc_next <= 0;
                r_ev_sig <= 1'b0;
            end



        end
    end 
    
    task set_bins (input i_bit);
    begin
        if (i_bit) begin
            o_bin1 <= 0;
            o_bin2 <= `SYM_ENC_SFD_BIN_PWR;                            
        end
        else begin
            o_bin1 <= `SYM_ENC_SFD_BIN_PWR;
            o_bin2 <= 0; 
        end        
    end
    endtask

    task clr_bins;
    begin
        o_bin1 <= 0;
        o_bin2 <= 0;                                   
    end
    endtask
    
endmodule
