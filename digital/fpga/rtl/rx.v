`include "rx.vh"
`include "sym_dec.vh"

module rx(clk, reset, 
            // RX input
            i_rx_in,
            o_clk,
            // RX enable(1)/disable(0)
            i_enable,
            // Buffer access interface  
            i_buf_r_addr,
            o_buf_r_byte, 
            // RX events 
            o_ev, 
            o_ev_sig, 
            // Status
            o_sfd,
            o_fcs_ok, 
            o_active);

    parameter WIDTH=10;

    input clk; 
    input reset;
    // RX input
    input [WIDTH-1:0]   i_rx_in;
    output              o_clk;
    // RX enable(1)/disable(0)
    input               i_enable;
    // Buffer access interface
    input [6:0]         i_buf_r_addr;
    output[7:0]         o_buf_r_byte;
    // RX events 
    output reg [2:0] o_ev = `RX_EVENT_NONE;
    output reg       o_ev_sig;
    // Status
    output reg       o_sfd = 0;
    output           o_fcs_ok;
    output reg       o_active = 0;

    reg [7:0] r_buf_w_byte = 0;
    reg [6:0] r_buf_w_addr = 0;
    reg       r_buf_w_en = 0;
    reg       r_dft_next = 0;
    reg       r_sym_dec_next = 0;
    reg       r_sym_dec_reset = 0;
    
    wire        w_dft_next_out;
    wire [WIDTH-1:0]  w_s2p_dft0,  w_s2p_dft1,  w_s2p_dft2,  w_s2p_dft3,  
                      w_s2p_dft4,  w_s2p_dft5,  w_s2p_dft6,  w_s2p_dft7,  
                      w_s2p_dft8,  w_s2p_dft9,  w_s2p_dft10, w_s2p_dft11, 
                      w_s2p_dft12, w_s2p_dft13, w_s2p_dft14, w_s2p_dft15, 
                      w_s2p_dft16, w_s2p_dft17, w_s2p_dft18, w_s2p_dft19, 
                      w_s2p_dft20, w_s2p_dft21, w_s2p_dft22, w_s2p_dft23, 
                      w_s2p_dft24, w_s2p_dft25, w_s2p_dft26, w_s2p_dft27, 
                      w_s2p_dft28, w_s2p_dft29, w_s2p_dft30, w_s2p_dft31, 
                      w_s2p_dft32, w_s2p_dft33, w_s2p_dft34, w_s2p_dft35, 
                      w_s2p_dft36, w_s2p_dft37, w_s2p_dft38, w_s2p_dft39, 
                      w_s2p_dft40, w_s2p_dft41, w_s2p_dft42, w_s2p_dft43, 
                      w_s2p_dft44, w_s2p_dft45, w_s2p_dft46, w_s2p_dft47, 
                      w_s2p_dft48, w_s2p_dft49, w_s2p_dft50, w_s2p_dft51, 
                      w_s2p_dft52, w_s2p_dft53, w_s2p_dft54, w_s2p_dft55, 
                      w_s2p_dft56, w_s2p_dft57, w_s2p_dft58, w_s2p_dft59, 
                      w_s2p_dft60, w_s2p_dft61, w_s2p_dft62, w_s2p_dft63;
                      
    wire [WIDTH-1:0]  w_bin1_i, w_bin1_q, 
                      w_bin2_i, w_bin2_q,
                      w_bin3_i, w_bin3_q;
                      
    wire [WIDTH-1:0]  w_bin1_m, w_bin2_m, w_bin3_m;
    wire [15:0]  w_fir_bin1_m, w_fir_bin2_m, w_fir_bin3_m;

    wire [7:0]  w_rcvd_byte;
    wire [2:0]  w_sym_dec_ev;
    wire        w_sym_dec_ev_sig;
    
    cmplx_to_mag  cmplx_mag_bin1(w_bin1_i, w_bin1_q, w_bin1_m);
    cmplx_to_mag  cmplx_mag_bin2(w_bin2_i, w_bin2_q, w_bin2_m);
    cmplx_to_mag  cmplx_mag_bin3(w_bin3_i, w_bin3_q, w_bin3_m);
      
    s_to_p  s2p_inst(.clk(clk), .reset(reset), .X(i_rx_in),
                      .Y0(w_s2p_dft0),   .Y1(w_s2p_dft1),   .Y2(w_s2p_dft2),   .Y3(w_s2p_dft3),   
                      .Y4(w_s2p_dft4),   .Y5(w_s2p_dft5),   .Y6(w_s2p_dft6),   .Y7(w_s2p_dft7),   
                      .Y8(w_s2p_dft8),   .Y9(w_s2p_dft9),   .Y10(w_s2p_dft10), .Y11(w_s2p_dft11), 
                      .Y12(w_s2p_dft12), .Y13(w_s2p_dft13), .Y14(w_s2p_dft14), .Y15(w_s2p_dft15), 
                      .Y16(w_s2p_dft16), .Y17(w_s2p_dft17), .Y18(w_s2p_dft18), .Y19(w_s2p_dft19), 
                      .Y20(w_s2p_dft20), .Y21(w_s2p_dft21), .Y22(w_s2p_dft22), .Y23(w_s2p_dft23), 
                      .Y24(w_s2p_dft24), .Y25(w_s2p_dft25), .Y26(w_s2p_dft26), .Y27(w_s2p_dft27), 
                      .Y28(w_s2p_dft28), .Y29(w_s2p_dft29), .Y30(w_s2p_dft30), .Y31(w_s2p_dft31), 
                      .Y32(w_s2p_dft32), .Y33(w_s2p_dft33), .Y34(w_s2p_dft34), .Y35(w_s2p_dft35), 
                      .Y36(w_s2p_dft36), .Y37(w_s2p_dft37), .Y38(w_s2p_dft38), .Y39(w_s2p_dft39), 
                      .Y40(w_s2p_dft40), .Y41(w_s2p_dft41), .Y42(w_s2p_dft42), .Y43(w_s2p_dft43), 
                      .Y44(w_s2p_dft44), .Y45(w_s2p_dft45), .Y46(w_s2p_dft46), .Y47(w_s2p_dft47), 
                      .Y48(w_s2p_dft48), .Y49(w_s2p_dft49), .Y50(w_s2p_dft50), .Y51(w_s2p_dft51), 
                      .Y52(w_s2p_dft52), .Y53(w_s2p_dft53), .Y54(w_s2p_dft54), .Y55(w_s2p_dft55), 
                      .Y56(w_s2p_dft56), .Y57(w_s2p_dft57), .Y58(w_s2p_dft58), .Y59(w_s2p_dft59), 
                      .Y60(w_s2p_dft60), .Y61(w_s2p_dft61), .Y62(w_s2p_dft62), .Y63(w_s2p_dft63),
                      .o_clk(o_clk));    
    
          
    dft_top dft_top_inst(.clk(clk), .reset(reset), .next(r_dft_next),
                          .X0(w_s2p_dft0),    .X1(10'h000),   .X2(w_s2p_dft1),    .X3(10'h000),   
                          .X4(w_s2p_dft2),    .X5(10'h000),   .X6(w_s2p_dft3),    .X7(10'h000),   
                          .X8(w_s2p_dft4),    .X9(10'h000),   .X10(w_s2p_dft5),   .X11(10'h000),  
                          .X12(w_s2p_dft6),   .X13(10'h000),  .X14(w_s2p_dft7),   .X15(10'h000),  
                          .X16(w_s2p_dft8),   .X17(10'h000),  .X18(w_s2p_dft9),   .X19(10'h000),  
                          .X20(w_s2p_dft10),  .X21(10'h000),  .X22(w_s2p_dft11),  .X23(10'h000),  
                          .X24(w_s2p_dft12),  .X25(10'h000),  .X26(w_s2p_dft13),  .X27(10'h000),  
                          .X28(w_s2p_dft14),  .X29(10'h000),  .X30(w_s2p_dft15),  .X31(10'h000),  
                          .X32(w_s2p_dft16),  .X33(10'h000),  .X34(w_s2p_dft17),  .X35(10'h000),  
                          .X36(w_s2p_dft18),  .X37(10'h000),  .X38(w_s2p_dft19),  .X39(10'h000),  
                          .X40(w_s2p_dft20),  .X41(10'h000),  .X42(w_s2p_dft21),  .X43(10'h000),  
                          .X44(w_s2p_dft22),  .X45(10'h000),  .X46(w_s2p_dft23),  .X47(10'h000),  
                          .X48(w_s2p_dft24),  .X49(10'h000),  .X50(w_s2p_dft25),  .X51(10'h000),  
                          .X52(w_s2p_dft26),  .X53(10'h000),  .X54(w_s2p_dft27),  .X55(10'h000),  
                          .X56(w_s2p_dft28),  .X57(10'h000),  .X58(w_s2p_dft29),  .X59(10'h000),  
                          .X60(w_s2p_dft30),  .X61(10'h000),  .X62(w_s2p_dft31),  .X63(10'h000),  
                          .X64(w_s2p_dft32),  .X65(10'h000),  .X66(w_s2p_dft33),  .X67(10'h000),  
                          .X68(w_s2p_dft34),  .X69(10'h000),  .X70(w_s2p_dft35),  .X71(10'h000),  
                          .X72(w_s2p_dft36),  .X73(10'h000),  .X74(w_s2p_dft37),  .X75(10'h000),  
                          .X76(w_s2p_dft38),  .X77(10'h000),  .X78(w_s2p_dft39),  .X79(10'h000),  
                          .X80(w_s2p_dft40),  .X81(10'h000),  .X82(w_s2p_dft41),  .X83(10'h000),  
                          .X84(w_s2p_dft42),  .X85(10'h000),  .X86(w_s2p_dft43),  .X87(10'h000),  
                          .X88(w_s2p_dft44),  .X89(10'h000),  .X90(w_s2p_dft45),  .X91(10'h000),  
                          .X92(w_s2p_dft46),  .X93(10'h000),  .X94(w_s2p_dft47),  .X95(10'h000),  
                          .X96(w_s2p_dft48),  .X97(10'h000),  .X98(w_s2p_dft49),  .X99(10'h000),  
                          .X100(w_s2p_dft50), .X101(10'h000), .X102(w_s2p_dft51), .X103(10'h000), 
                          .X104(w_s2p_dft52), .X105(10'h000), .X106(w_s2p_dft53), .X107(10'h000), 
                          .X108(w_s2p_dft54), .X109(10'h000), .X110(w_s2p_dft55), .X111(10'h000), 
                          .X112(w_s2p_dft56), .X113(10'h000), .X114(w_s2p_dft57), .X115(10'h000), 
                          .X116(w_s2p_dft58), .X117(10'h000), .X118(w_s2p_dft59), .X119(10'h000), 
                          .X120(w_s2p_dft60), .X121(10'h000), .X122(w_s2p_dft61), .X123(10'h000), 
                          .X124(w_s2p_dft62), .X125(10'h000), .X126(w_s2p_dft63), .X127(10'h000),
                          .Y14(w_bin1_i), .Y15(w_bin1_q),
                          .Y16(w_bin2_i), .Y17(w_bin2_q),
                          .Y18(w_bin3_i), .Y19(w_bin3_q),
                          .next_out(w_dft_next_out));


    fir_filter fir_b1 (.clk(r_sym_dec_next), .i_in(w_bin1_m), .o_out(w_fir_bin1_m));
    fir_filter fir_b2 (.clk(r_sym_dec_next), .i_in(w_bin2_m), .o_out(w_fir_bin2_m));
    fir_filter fir_b3 (.clk(r_sym_dec_next), .i_in(w_bin3_m), .o_out(w_fir_bin3_m));
                          
    sym_dec sym_dec_inst(.clk(clk), .reset(reset | r_sym_dec_reset), 
                          .i_next(r_sym_dec_next), 
                          .i_bin0_mag(w_fir_bin1_m), .i_binvsc_mag(w_fir_bin2_m), .i_bin1_mag(w_fir_bin3_m),
                          .o_byte(w_rcvd_byte),
                          .o_ev(w_sym_dec_ev),
                          .o_ev_sig(w_sym_dec_ev_sig),
                          .o_fcs_ok(o_fcs_ok));

    ram_single ram_inst(.clk(clk), 
                        .i_w_enable(r_buf_w_en), .i_w_addr(r_buf_w_addr), .i_w_byte(r_buf_w_byte),
                        .i_r_addr(i_buf_r_addr), .o_r_byte(o_buf_r_byte));

    always @ (posedge clk) begin
        if (reset) begin
            r_dft_next <= 0;
            r_sym_dec_next <= 0;
            r_sym_dec_reset <= 0;
            o_ev <= `RX_EVENT_NONE;
            o_ev_sig <= 0;
            o_active <= 0;
        end
        else begin
            // We have to have one cycle gap between beginning of two input vectors
            r_dft_next <= ~r_dft_next;
            if (i_enable) begin
                o_active <= 1'b1;
                if (w_dft_next_out) begin
                    // DFT module's output becomes valid in the next clock cycle.
                    r_sym_dec_next <= 1;
                end
                else begin
                    r_sym_dec_next <= 0;
                end
                // Below, we handle symbol decoder events
                if (w_sym_dec_ev_sig) begin
                    case (w_sym_dec_ev)
                        `SYM_DEC_EV_PREAMBLE: begin
                            o_ev <= `RX_EVENT_PREAMBLE;
                            o_ev_sig <= 1;
                        end
                        `SYM_DEC_EV_SFD: begin
                            o_ev <= `RX_EVENT_SFD;
                            o_ev_sig <= 1;
                            o_sfd <= 1'b1;
                        end
                        `SYM_DEC_EV_PHR: begin
                            o_ev <= `RX_EVENT_PHR;
                            o_ev_sig <= 1;
                            // We write the frame length byte to the RX buffer
                            r_buf_w_addr <= 0;
                            r_buf_w_byte <= w_rcvd_byte;
                            r_buf_w_en <= 1;
                        end
                        `SYM_DEC_EV_BYTE: begin
                            o_ev <= `RX_EVENT_BYTE;
                            o_ev_sig <= 1;
                            r_buf_w_addr <= r_buf_w_addr + 7'd1;
                            r_buf_w_byte <= w_rcvd_byte;
                            r_buf_w_en <= 1;
                        end
                        `SYM_DEC_EV_COMPLETE: begin
                            // Reception complete
                            o_ev <= `RX_EVENT_END;
                            o_ev_sig <= 1;
                            // Reset the symbol decoder after the reception ends
                            r_sym_dec_reset <= 1; 
                            o_sfd <= 0;
                        end
                        default: begin
                        end 
                    endcase
                end
                else begin
                    // Set all the lines to low in the next cycle
                    r_sym_dec_reset <= 0;
                    o_ev_sig <= 0;
                    r_buf_w_en <= 0;
                end
            end 
            else begin
                // RX is not enabled
                r_sym_dec_reset <= 1;
                o_ev_sig <= 0;
                r_buf_w_en <= 0;
                o_active <= 0; 
            end

        end
    end
      

endmodule
