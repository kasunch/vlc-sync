module s_to_p(clk, reset, 
              X,
              Y0,  Y1,  Y2,  Y3,  
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
              Y60, Y61, Y62, Y63, 
              o_clk);
    
    parameter WIDTH=10, OUTPUT_SIZE=64;
    
    integer             i;
    
    input               clk; 
    input               reset;
    input [WIDTH-1:0]   X;
    output [WIDTH-1:0]  Y0,  Y1,  Y2,  Y3,  
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
    output reg          o_clk = 0;
    
    reg [WIDTH-1:0]     r_mem[OUTPUT_SIZE-1:0];
      
    assign Y0 = r_mem[0];
    assign Y1 = r_mem[1];
    assign Y2 = r_mem[2];
    assign Y3 = r_mem[3];
    assign Y4 = r_mem[4];
    assign Y5 = r_mem[5];
    assign Y6 = r_mem[6];
    assign Y7 = r_mem[7];
    assign Y8 = r_mem[8];
    assign Y9 = r_mem[9];
    assign Y10 = r_mem[10];
    assign Y11 = r_mem[11];
    assign Y12 = r_mem[12];
    assign Y13 = r_mem[13];
    assign Y14 = r_mem[14];
    assign Y15 = r_mem[15];
    assign Y16 = r_mem[16];
    assign Y17 = r_mem[17];
    assign Y18 = r_mem[18];
    assign Y19 = r_mem[19];
    assign Y20 = r_mem[20];
    assign Y21 = r_mem[21];
    assign Y22 = r_mem[22];
    assign Y23 = r_mem[23];
    assign Y24 = r_mem[24];
    assign Y25 = r_mem[25];
    assign Y26 = r_mem[26];
    assign Y27 = r_mem[27];
    assign Y28 = r_mem[28];
    assign Y29 = r_mem[29];
    assign Y30 = r_mem[30];
    assign Y31 = r_mem[31];
    assign Y32 = r_mem[32];
    assign Y33 = r_mem[33];
    assign Y34 = r_mem[34];
    assign Y35 = r_mem[35];
    assign Y36 = r_mem[36];
    assign Y37 = r_mem[37];
    assign Y38 = r_mem[38];
    assign Y39 = r_mem[39];
    assign Y40 = r_mem[40];
    assign Y41 = r_mem[41];
    assign Y42 = r_mem[42];
    assign Y43 = r_mem[43];
    assign Y44 = r_mem[44];
    assign Y45 = r_mem[45];
    assign Y46 = r_mem[46];
    assign Y47 = r_mem[47];
    assign Y48 = r_mem[48];
    assign Y49 = r_mem[49];
    assign Y50 = r_mem[50];
    assign Y51 = r_mem[51];
    assign Y52 = r_mem[52];
    assign Y53 = r_mem[53];
    assign Y54 = r_mem[54];
    assign Y55 = r_mem[55];
    assign Y56 = r_mem[56];
    assign Y57 = r_mem[57];
    assign Y58 = r_mem[58];
    assign Y59 = r_mem[59];
    assign Y60 = r_mem[60];
    assign Y61 = r_mem[61];
    assign Y62 = r_mem[62];
    assign Y63 = r_mem[63];

    always @ (posedge clk) begin
        if (reset) begin
            for(i = 0; i < OUTPUT_SIZE; i = i + 1) begin
                r_mem[i] <= 10'h200;
            end
            o_clk <= 0;
        end
        else begin
            if (o_clk) begin
                // This is the negative edge of the output clock
                o_clk <= 0;
            end
            else begin
                // This is the positive edge of the output clock
                o_clk <= 1;
                // Shift register based FIFO
                for(i = 1; i < OUTPUT_SIZE; i = i + 1) begin
                    r_mem[i - 1] <= r_mem[i];
                end
                r_mem[OUTPUT_SIZE - 1] <= X ^ 10'h200;
            end
        end
    end
      
endmodule
