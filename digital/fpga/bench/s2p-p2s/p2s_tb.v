module p2s_tb();

    parameter WIDTH=10;

    integer i, j;

    reg clk = 0;
    
    reg [2:0]         r_next_req_cnt = 0;
    reg               r_start = 0;
    reg [WIDTH-1:0]   r_in [63:0];
    
    wire              reset;
    wire              w_next_req;
    wire              w_output_clk;
    wire [WIDTH-1:0]  w_p2s_out;
    wire [WIDTH-1:0]  X0,  X1,  X2,  X3,  X4,  X5,  X6,  X7,
                      X8,  X9,  X10, X11, X12, X13, X14, X15,
                      X16, X17, X18, X19, X20, X21, X22, X23,
                      X24, X25, X26, X27, X28, X29, X30, X31,
                      X32, X33, X34, X35, X36, X37, X38, X39,
                      X40, X41, X42, X43, X44, X45, X46, X47,
                      X48, X49, X50, X51, X52, X53, X54, X55,
                      X56, X57, X58, X59, X60, X61, X62, X63;   
  
    assign X0 = r_in[0];
    assign X1 = r_in[1];
    assign X2 = r_in[2];
    assign X3 = r_in[3];
    assign X4 = r_in[4];
    assign X5 = r_in[5];
    assign X6 = r_in[6];
    assign X7 = r_in[7];
    assign X8 = r_in[8];
    assign X9 = r_in[9];
    assign X10 = r_in[10];
    assign X11 = r_in[11];
    assign X12 = r_in[12];
    assign X13 = r_in[13];
    assign X14 = r_in[14];
    assign X15 = r_in[15];
    assign X16 = r_in[16];
    assign X17 = r_in[17];
    assign X18 = r_in[18];
    assign X19 = r_in[19];
    assign X20 = r_in[20];
    assign X21 = r_in[21];
    assign X22 = r_in[22];
    assign X23 = r_in[23];
    assign X24 = r_in[24];
    assign X25 = r_in[25];
    assign X26 = r_in[26];
    assign X27 = r_in[27];
    assign X28 = r_in[28];
    assign X29 = r_in[29];
    assign X30 = r_in[30];
    assign X31 = r_in[31];
    assign X32 = r_in[32];
    assign X33 = r_in[33];
    assign X34 = r_in[34];
    assign X35 = r_in[35];
    assign X36 = r_in[36];
    assign X37 = r_in[37];
    assign X38 = r_in[38];
    assign X39 = r_in[39];
    assign X40 = r_in[40];
    assign X41 = r_in[41];
    assign X42 = r_in[42];
    assign X43 = r_in[43];
    assign X44 = r_in[44];
    assign X45 = r_in[45];
    assign X46 = r_in[46];
    assign X47 = r_in[47];
    assign X48 = r_in[48];
    assign X49 = r_in[49];
    assign X50 = r_in[50];
    assign X51 = r_in[51];
    assign X52 = r_in[52];
    assign X53 = r_in[53];
    assign X54 = r_in[54];
    assign X55 = r_in[55];
    assign X56 = r_in[56];
    assign X57 = r_in[57];
    assign X58 = r_in[58];
    assign X59 = r_in[59];
    assign X60 = r_in[60];
    assign X61 = r_in[61];
    assign X62 = r_in[62];
    assign X63 = r_in[63];
  
    auto_reset auto_reset_inst(.clk(clk), .reset(reset));
      
    p_to_s  p2s_inst(.clk(clk), .reset(reset), .i_start(r_start), 
                    .X0(X0),   .X1(X1),   .X2(X2),   .X3(X3),   
                    .X4(X4),   .X5(X5),   .X6(X6),   .X7(X7),   
                    .X8(X8),   .X9(X9),   .X10(X10), .X11(X11), 
                    .X12(X12), .X13(X13), .X14(X14), .X15(X15), 
                    .X16(X16), .X17(X17), .X18(X18), .X19(X19), 
                    .X20(X20), .X21(X21), .X22(X22), .X23(X23), 
                    .X24(X24), .X25(X25), .X26(X26), .X27(X27), 
                    .X28(X28), .X29(X29), .X30(X30), .X31(X31), 
                    .X32(X32), .X33(X33), .X34(X34), .X35(X35), 
                    .X36(X36), .X37(X37), .X38(X38), .X39(X39), 
                    .X40(X40), .X41(X41), .X42(X42), .X43(X43), 
                    .X44(X44), .X45(X45), .X46(X46), .X47(X47), 
                    .X48(X48), .X49(X49), .X50(X50), .X51(X51), 
                    .X52(X52), .X53(X53), .X54(X54), .X55(X55), 
                    .X56(X56), .X57(X57), .X58(X58), .X59(X59), 
                    .X60(X60), .X61(X61), .X62(X62), .X63(X63),
                    .o_next_req(w_next_req), .Y(w_p2s_out), .o_clk(w_output_clk));
  
    always #1 clk = ~clk;
    
    always @ (posedge w_output_clk) begin
        $display("%3d", w_p2s_out);
    end

    always @ (posedge clk) begin
        if(reset) begin
            r_start <= 1;
        end
        else begin 
            r_start <= 0;
            if(w_next_req) begin
                if(r_next_req_cnt == 3'd3) begin 
                    $finish;
                end
                else begin
                    // Load the next input vector
                    for(i = 0; i < 64; i = i + 1) begin
                        r_in[i] <= i + (r_next_req_cnt << 6);
                    end
                    r_next_req_cnt <= r_next_req_cnt + 3'd1;
                end
            end
        end
    
    end
      
    initial begin
    
        $dumpfile("p2s_tb.vcd");
        $dumpvars(0, p2s_tb);
    end
endmodule
