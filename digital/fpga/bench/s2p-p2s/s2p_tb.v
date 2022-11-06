module s2p_tb();

    parameter WIDTH=10, INPUT_SIZE=64;

    integer i;
    
    reg clk = 0;
    
    reg [WIDTH-1:0]   r_mem [INPUT_SIZE-1:0];
    reg [7:0]         r_cnt = 0;
    
    wire [WIDTH-1:0]  w_in;
    wire              w_output_clk;
    wire              w_auto_reset;
    wire [WIDTH-1:0]  Y0,  Y1,  Y2,  Y3,  
                      Y4,  Y5,  Y6,  Y7,  
                      Y8,  Y9,  Y10, Y11, 
                      Y12, Y13, Y14, Y15, 
                      Y16, Y17, Y18, Y19, 
                      Y20, Y21, Y22, Y23, 
                      Y24, Y25, Y26, Y27, 
                      Y28, Y29, Y30, Y31, 
                      Y32, Y33, Y34, Y35, 
                      Y36, Y37, Y38, Y39, 
                      Y40, Y41, Y42, Y43, 
                      Y44, Y45, Y46, Y47, 
                      Y48, Y49, Y50, Y51, 
                      Y52, Y53, Y54, Y55, 
                      Y56, Y57, Y58, Y59, 
                      Y60, Y61, Y62, Y63;
  
    always #1 clk = ~clk;
      
      
    assign w_in = r_mem[0];
    
    auto_reset auto_reset_inst(.clk(clk), .reset(w_auto_reset));
    
    s_to_p  s2p_inst(.clk(clk), .reset(w_auto_reset), .X(w_in),
                      .Y0(Y0),   .Y1(Y1),   .Y2(Y2),   .Y3(Y3),   
                      .Y4(Y4),   .Y5(Y5),   .Y6(Y6),   .Y7(Y7),   
                      .Y8(Y8),   .Y9(Y9),   .Y10(Y10), .Y11(Y11), 
                      .Y12(Y12), .Y13(Y13), .Y14(Y14), .Y15(Y15), 
                      .Y16(Y16), .Y17(Y17), .Y18(Y18), .Y19(Y19), 
                      .Y20(Y20), .Y21(Y21), .Y22(Y22), .Y23(Y23), 
                      .Y24(Y24), .Y25(Y25), .Y26(Y26), .Y27(Y27), 
                      .Y28(Y28), .Y29(Y29), .Y30(Y30), .Y31(Y31), 
                      .Y32(Y32), .Y33(Y33), .Y34(Y34), .Y35(Y35), 
                      .Y36(Y36), .Y37(Y37), .Y38(Y38), .Y39(Y39), 
                      .Y40(Y40), .Y41(Y41), .Y42(Y42), .Y43(Y43), 
                      .Y44(Y44), .Y45(Y45), .Y46(Y46), .Y47(Y47), 
                      .Y48(Y48), .Y49(Y49), .Y50(Y50), .Y51(Y51), 
                      .Y52(Y52), .Y53(Y53), .Y54(Y54), .Y55(Y55), 
                      .Y56(Y56), .Y57(Y57), .Y58(Y58), .Y59(Y59), 
                      .Y60(Y60), .Y61(Y61), .Y62(Y62), .Y63(Y63),
                      .o_clk(w_output_clk));
    
    always @ (posedge w_output_clk) begin
        for(i = 1; i < INPUT_SIZE; i = i + 1) begin
            r_mem[i -1] <= r_mem[i];
        end
        r_mem[INPUT_SIZE -1] <= 0;
        
        if (r_cnt == INPUT_SIZE - 1) begin
            finish();
        end
        else begin
            r_cnt <= r_cnt + 1;
        end
    end

    always @(posedge clk) begin
        if (w_auto_reset) begin
            // Nothing to do
        end
        else begin
            // Nothing to do
        end
    end
      
    initial begin
        $dumpfile("s2p_tb.vcd");
        $dumpvars(0, s2p_tb); 

        for(i = 0; i < INPUT_SIZE; i = i + 1) begin
            r_mem[i] <= i;
        end
        r_cnt <= 0;              
    end
    
    task finish;
    begin
        $finish;
    end
    endtask
    
endmodule
