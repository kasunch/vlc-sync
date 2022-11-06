`define IDFT_GEN_STATE_WAIT_SLIP_INIT    2'd0
`define IDFT_GEN_STATE_WAIT_SLIP_RX      2'd1
`define IDFT_GEN_STATE_SLIP_DATA         2'd2
`define IDFT_GEN_STATE_SLIP_DONE         2'd3


module idft_gen_slip(clk, 
                        reset, 
                        // TX output
                        o_tx_out, 
                        o_clk,
                        // UART RX
                        i_uart_rx);

    parameter WIDTH=10;

    input               clk;
    input               reset;
    input               i_uart_rx;
    output [WIDTH-1:0]  o_tx_out;
    output              o_clk;

    // Registers and wires for SLIP RX
    wire                w_slip_rx_started;
    wire                w_slip_rx_ended;
    wire                w_slip_rx_byte_done;
    wire [7:0]          w_slip_rx_byte;

    reg                 r_start = 0;
    reg [2:0]           r_slip_rx_cnt = 0;
    reg [7:0]           r_buffer [5:0];

    reg [WIDTH-1:0]   r_symenc_bin0 = 0;
    reg [WIDTH-1:0]   r_symenc_bin1 = 0;
    reg [WIDTH-1:0]   r_symenc_vc = 0;
    wire              w_p2s_next_req;
    wire [WIDTH-1:0]  w_idft_p2s0,  w_idft_p2s1,  w_idft_p2s2,  w_idft_p2s3,  
                      w_idft_p2s4,  w_idft_p2s5,  w_idft_p2s6,  w_idft_p2s7,  
                      w_idft_p2s8,  w_idft_p2s9,  w_idft_p2s10, w_idft_p2s11, 
                      w_idft_p2s12, w_idft_p2s13, w_idft_p2s14, w_idft_p2s15, 
                      w_idft_p2s16, w_idft_p2s17, w_idft_p2s18, w_idft_p2s19, 
                      w_idft_p2s20, w_idft_p2s21, w_idft_p2s22, w_idft_p2s23, 
                      w_idft_p2s24, w_idft_p2s25, w_idft_p2s26, w_idft_p2s27, 
                      w_idft_p2s28, w_idft_p2s29, w_idft_p2s30, w_idft_p2s31, 
                      w_idft_p2s32, w_idft_p2s33, w_idft_p2s34, w_idft_p2s35, 
                      w_idft_p2s36, w_idft_p2s37, w_idft_p2s38, w_idft_p2s39, 
                      w_idft_p2s40, w_idft_p2s41, w_idft_p2s42, w_idft_p2s43, 
                      w_idft_p2s44, w_idft_p2s45, w_idft_p2s46, w_idft_p2s47, 
                      w_idft_p2s48, w_idft_p2s49, w_idft_p2s50, w_idft_p2s51, 
                      w_idft_p2s52, w_idft_p2s53, w_idft_p2s54, w_idft_p2s55, 
                      w_idft_p2s56, w_idft_p2s57, w_idft_p2s58, w_idft_p2s59, 
                      w_idft_p2s60, w_idft_p2s61, w_idft_p2s62, w_idft_p2s63;


    reg [1:0] r_state = `IDFT_GEN_STATE_WAIT_SLIP_INIT;
                      
            
                      
    p_to_s_no_cp  p2s_inst(.clk(clk), .reset(reset), .i_start(r_start), 
                      .X0(w_idft_p2s0),   .X1(w_idft_p2s1),   .X2(w_idft_p2s2),   .X3(w_idft_p2s3),   
                      .X4(w_idft_p2s4),   .X5(w_idft_p2s5),   .X6(w_idft_p2s6),   .X7(w_idft_p2s7),   
                      .X8(w_idft_p2s8),   .X9(w_idft_p2s9),   .X10(w_idft_p2s10), .X11(w_idft_p2s11), 
                      .X12(w_idft_p2s12), .X13(w_idft_p2s13), .X14(w_idft_p2s14), .X15(w_idft_p2s15), 
                      .X16(w_idft_p2s16), .X17(w_idft_p2s17), .X18(w_idft_p2s18), .X19(w_idft_p2s19), 
                      .X20(w_idft_p2s20), .X21(w_idft_p2s21), .X22(w_idft_p2s22), .X23(w_idft_p2s23), 
                      .X24(w_idft_p2s24), .X25(w_idft_p2s25), .X26(w_idft_p2s26), .X27(w_idft_p2s27), 
                      .X28(w_idft_p2s28), .X29(w_idft_p2s29), .X30(w_idft_p2s30), .X31(w_idft_p2s31), 
                      .X32(w_idft_p2s32), .X33(w_idft_p2s33), .X34(w_idft_p2s34), .X35(w_idft_p2s35), 
                      .X36(w_idft_p2s36), .X37(w_idft_p2s37), .X38(w_idft_p2s38), .X39(w_idft_p2s39), 
                      .X40(w_idft_p2s40), .X41(w_idft_p2s41), .X42(w_idft_p2s42), .X43(w_idft_p2s43), 
                      .X44(w_idft_p2s44), .X45(w_idft_p2s45), .X46(w_idft_p2s46), .X47(w_idft_p2s47), 
                      .X48(w_idft_p2s48), .X49(w_idft_p2s49), .X50(w_idft_p2s50), .X51(w_idft_p2s51), 
                      .X52(w_idft_p2s52), .X53(w_idft_p2s53), .X54(w_idft_p2s54), .X55(w_idft_p2s55), 
                      .X56(w_idft_p2s56), .X57(w_idft_p2s57), .X58(w_idft_p2s58), .X59(w_idft_p2s59), 
                      .X60(w_idft_p2s60), .X61(w_idft_p2s61), .X62(w_idft_p2s62), .X63(w_idft_p2s63),
                      .o_next_req(w_p2s_next_req), .Y(o_tx_out), .o_clk(o_clk));

    idft_top idft_top_inst(.clk(clk), .reset(reset), 
                            .next(w_p2s_next_req),
                            .X0(10'h000),         .X1(10'h000),   .X2(10'h000),         .X3(10'h000),               
                            .X4(10'h000),         .X5(10'h000),   .X6(10'h000),         .X7(10'h000),               
                            .X8(10'h000),         .X9(10'h000),   .X10(10'h000),        .X11(10'h000),              
                            .X12(10'h000),        .X13(10'h000),  .X14(r_symenc_bin0),  .X15(10'h000),              
                            .X16(r_symenc_vc),    .X17(10'h000),  .X18(r_symenc_bin1),  .X19(10'h000),              
                            .X20(10'h000),        .X21(10'h000),  .X22(10'h000),        .X23(10'h000),              
                            .X24(10'h000),        .X25(10'h000),  .X26(10'h000),        .X27(10'h000),              
                            .X28(10'h000),        .X29(10'h000),  .X30(10'h000),        .X31(10'h000),              
                            .X32(10'h000),        .X33(10'h000),  .X34(10'h000),        .X35(10'h000),              
                            .X36(10'h000),        .X37(10'h000),  .X38(10'h000),        .X39(10'h000),              
                            .X40(10'h000),        .X41(10'h000),  .X42(10'h000),        .X43(10'h000),              
                            .X44(10'h000),        .X45(10'h000),  .X46(10'h000),        .X47(10'h000),              
                            .X48(10'h000),        .X49(10'h000),  .X50(10'h000),        .X51(10'h000),              
                            .X52(10'h000),        .X53(10'h000),  .X54(10'h000),        .X55(10'h000),              
                            .X56(10'h000),        .X57(10'h000),  .X58(10'h000),        .X59(10'h000),              
                            .X60(10'h000),        .X61(10'h000),  .X62(10'h000),        .X63(10'h000),              
                            .X64(10'h000),        .X65(10'h000),  .X66(10'h000),        .X67(10'h000),              
                            .X68(10'h000),        .X69(10'h000),  .X70(10'h000),        .X71(10'h000),              
                            .X72(10'h000),        .X73(10'h000),  .X74(10'h000),        .X75(10'h000),              
                            .X76(10'h000),        .X77(10'h000),  .X78(10'h000),        .X79(10'h000),              
                            .X80(10'h000),        .X81(10'h000),  .X82(10'h000),        .X83(10'h000),              
                            .X84(10'h000),        .X85(10'h000),  .X86(10'h000),        .X87(10'h000),              
                            .X88(10'h000),        .X89(10'h000),  .X90(10'h000),        .X91(10'h000),              
                            .X92(10'h000),        .X93(10'h000),  .X94(10'h000),        .X95(10'h000),              
                            .X96(10'h000),        .X97(10'h000),  .X98(10'h000),        .X99(10'h000),              
                            .X100(10'h000),       .X101(10'h000), .X102(10'h000),       .X103(10'h000),             
                            .X104(10'h000),       .X105(10'h000), .X106(10'h000),       .X107(10'h000),             
                            .X108(10'h000),       .X109(10'h000), .X110(r_symenc_bin1), .X111(10'h000),             
                            .X112(r_symenc_vc),   .X113(10'h000), .X114(r_symenc_bin0), .X115(10'h000),             
                            .X116(10'h000),       .X117(10'h000), .X118(10'h000),       .X119(10'h000),             
                            .X120(10'h000),       .X121(10'h000), .X122(10'h000),       .X123(10'h000),             
                            .X124(10'h000),       .X125(10'h000), .X126(10'h000),       .X127(10'h000),                            
                            .Y0(w_idft_p2s0),    .Y2(w_idft_p2s1),    .Y4(w_idft_p2s2),    .Y6(w_idft_p2s3),    
                            .Y8(w_idft_p2s4),    .Y10(w_idft_p2s5),   .Y12(w_idft_p2s6),   .Y14(w_idft_p2s7),   
                            .Y16(w_idft_p2s8),   .Y18(w_idft_p2s9),   .Y20(w_idft_p2s10),  .Y22(w_idft_p2s11),  
                            .Y24(w_idft_p2s12),  .Y26(w_idft_p2s13),  .Y28(w_idft_p2s14),  .Y30(w_idft_p2s15),  
                            .Y32(w_idft_p2s16),  .Y34(w_idft_p2s17),  .Y36(w_idft_p2s18),  .Y38(w_idft_p2s19),  
                            .Y40(w_idft_p2s20),  .Y42(w_idft_p2s21),  .Y44(w_idft_p2s22),  .Y46(w_idft_p2s23),  
                            .Y48(w_idft_p2s24),  .Y50(w_idft_p2s25),  .Y52(w_idft_p2s26),  .Y54(w_idft_p2s27),  
                            .Y56(w_idft_p2s28),  .Y58(w_idft_p2s29),  .Y60(w_idft_p2s30),  .Y62(w_idft_p2s31),  
                            .Y64(w_idft_p2s32),  .Y66(w_idft_p2s33),  .Y68(w_idft_p2s34),  .Y70(w_idft_p2s35),  
                            .Y72(w_idft_p2s36),  .Y74(w_idft_p2s37),  .Y76(w_idft_p2s38),  .Y78(w_idft_p2s39),  
                            .Y80(w_idft_p2s40),  .Y82(w_idft_p2s41),  .Y84(w_idft_p2s42),  .Y86(w_idft_p2s43),  
                            .Y88(w_idft_p2s44),  .Y90(w_idft_p2s45),  .Y92(w_idft_p2s46),  .Y94(w_idft_p2s47),  
                            .Y96(w_idft_p2s48),  .Y98(w_idft_p2s49),  .Y100(w_idft_p2s50), .Y102(w_idft_p2s51), 
                            .Y104(w_idft_p2s52), .Y106(w_idft_p2s53), .Y108(w_idft_p2s54), .Y110(w_idft_p2s55), 
                            .Y112(w_idft_p2s56), .Y114(w_idft_p2s57), .Y116(w_idft_p2s58), .Y118(w_idft_p2s59), 
                            .Y120(w_idft_p2s60), .Y122(w_idft_p2s61), .Y124(w_idft_p2s62), .Y126(w_idft_p2s63));


    slip_rx rx_inst(.clk(clk), .reset(reset),
                    .i_uart_line(i_uart_rx),
                    .o_rx_started(w_slip_rx_started), 
                    .o_rx_ended(w_slip_rx_ended), 
                    .o_rx_byte_done(w_slip_rx_byte_done), 
                    .o_rx_byte(w_slip_rx_byte));

    always @ (posedge clk) begin
        if (reset) begin
            r_state <= `IDFT_GEN_STATE_WAIT_SLIP_INIT;
            r_symenc_bin0 <= 0;
            r_symenc_vc <= 0;
            r_symenc_bin1 <= 0;
        end
        else begin
            case (r_state)

                `IDFT_GEN_STATE_WAIT_SLIP_INIT: begin
                    r_start <= 1'b1;
                    r_state <= `IDFT_GEN_STATE_WAIT_SLIP_RX;
                end

                `IDFT_GEN_STATE_WAIT_SLIP_RX: begin
                    r_start <= 0;
                    r_slip_rx_cnt <= 0;
                    if (w_slip_rx_started)
                        r_state <= `IDFT_GEN_STATE_SLIP_DATA;
                    else
                        r_state <= `IDFT_GEN_STATE_WAIT_SLIP_RX;
                end

                `IDFT_GEN_STATE_SLIP_DATA: begin
                    if (w_slip_rx_byte_done) begin
                        r_buffer[r_slip_rx_cnt] <= w_slip_rx_byte;
                        r_slip_rx_cnt <= r_slip_rx_cnt + 3'd1;
                        r_state <= `IDFT_GEN_STATE_SLIP_DATA;
                    end
                    else if (w_slip_rx_ended) begin
                        r_state <= `IDFT_GEN_STATE_SLIP_DONE;
                    end
                    else begin
                        r_state <= `IDFT_GEN_STATE_SLIP_DATA;
                    end
                end

                `IDFT_GEN_STATE_SLIP_DONE: begin
                    r_symenc_bin0 <= {r_buffer[1][1:0], r_buffer[0]};
                    r_symenc_vc <=   {r_buffer[3][1:0], r_buffer[2]};
                    r_symenc_bin1 <= {r_buffer[5][1:0], r_buffer[4]};
                    r_state <= `IDFT_GEN_STATE_WAIT_SLIP_RX;
                end

                default: begin
                    // Nothing to do
                end
            endcase

        end
    end

endmodule