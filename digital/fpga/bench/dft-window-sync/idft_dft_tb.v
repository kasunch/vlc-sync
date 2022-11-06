module idft_dft_tb();

    parameter WIDTH=10, FFT_SIZE=64, IDFT_OUTOUT_BLOCKS=4, DFT_SAMPLE_START_OFFSETS=128;

    reg clk, reset;
    
    integer i, j, k;
    integer f_idft_out;
    integer f_dft_out;
    
    reg [15:0] counter;
    
    reg r_idft_next;
    wire w_idft_next_out;
    reg signed [WIDTH-1:0] r_idft_in_real [FFT_SIZE-1:0];
    wire signed [WIDTH-1:0] w_idft_out_real [FFT_SIZE-1:0];
    reg [WIDTH-1:0] r_idft_out_real [FFT_SIZE*IDFT_OUTOUT_BLOCKS-1:0];
    
    reg r_dft_next;
    wire w_dft_next_out;
    reg signed [WIDTH-1:0] r_dft_in_real [FFT_SIZE-1:0];
    wire signed [WIDTH-1:0] w_dft_out_real [FFT_SIZE-1:0];
    wire signed [WIDTH-1:0] w_dft_out_imag [FFT_SIZE-1:0];

    idft_top idft_top_inst (.clk(clk), .reset(reset), .next(r_idft_next), .next_out(w_idft_next_out),
        // Assign only for the real parts of the input
        .X0(r_idft_in_real[0]), .X1(0),
        .X2(r_idft_in_real[1]), .X3(0),
        .X4(r_idft_in_real[2]), .X5(0),
        .X6(r_idft_in_real[3]), .X7(0),
        .X8(r_idft_in_real[4]), .X9(0),
        .X10(r_idft_in_real[5]), .X11(0),
        .X12(r_idft_in_real[6]), .X13(0),
        .X14(r_idft_in_real[7]), .X15(0),
        .X16(r_idft_in_real[8]), .X17(0),
        .X18(r_idft_in_real[9]), .X19(0),
        .X20(r_idft_in_real[10]), .X21(0),
        .X22(r_idft_in_real[11]), .X23(0),
        .X24(r_idft_in_real[12]), .X25(0),
        .X26(r_idft_in_real[13]), .X27(0),
        .X28(r_idft_in_real[14]), .X29(0),
        .X30(r_idft_in_real[15]), .X31(0),
        .X32(r_idft_in_real[16]), .X33(0),
        .X34(r_idft_in_real[17]), .X35(0),
        .X36(r_idft_in_real[18]), .X37(0),
        .X38(r_idft_in_real[19]), .X39(0),
        .X40(r_idft_in_real[20]), .X41(0),
        .X42(r_idft_in_real[21]), .X43(0),
        .X44(r_idft_in_real[22]), .X45(0),
        .X46(r_idft_in_real[23]), .X47(0),
        .X48(r_idft_in_real[24]), .X49(0),
        .X50(r_idft_in_real[25]), .X51(0),
        .X52(r_idft_in_real[26]), .X53(0),
        .X54(r_idft_in_real[27]), .X55(0),
        .X56(r_idft_in_real[28]), .X57(0),
        .X58(r_idft_in_real[29]), .X59(0),
        .X60(r_idft_in_real[30]), .X61(0),
        .X62(r_idft_in_real[31]), .X63(0),
        .X64(r_idft_in_real[32]), .X65(0),
        .X66(r_idft_in_real[33]), .X67(0),
        .X68(r_idft_in_real[34]), .X69(0),
        .X70(r_idft_in_real[35]), .X71(0),
        .X72(r_idft_in_real[36]), .X73(0),
        .X74(r_idft_in_real[37]), .X75(0),
        .X76(r_idft_in_real[38]), .X77(0),
        .X78(r_idft_in_real[39]), .X79(0),
        .X80(r_idft_in_real[40]), .X81(0),
        .X82(r_idft_in_real[41]), .X83(0),
        .X84(r_idft_in_real[42]), .X85(0),
        .X86(r_idft_in_real[43]), .X87(0),
        .X88(r_idft_in_real[44]), .X89(0),
        .X90(r_idft_in_real[45]), .X91(0),
        .X92(r_idft_in_real[46]), .X93(0),
        .X94(r_idft_in_real[47]), .X95(0),
        .X96(r_idft_in_real[48]), .X97(0),
        .X98(r_idft_in_real[49]), .X99(0),
        .X100(r_idft_in_real[50]), .X101(0),
        .X102(r_idft_in_real[51]), .X103(0),
        .X104(r_idft_in_real[52]), .X105(0),
        .X106(r_idft_in_real[53]), .X107(0),
        .X108(r_idft_in_real[54]), .X109(0),
        .X110(r_idft_in_real[55]), .X111(0),
        .X112(r_idft_in_real[56]), .X113(0),
        .X114(r_idft_in_real[57]), .X115(0),
        .X116(r_idft_in_real[58]), .X117(0),
        .X118(r_idft_in_real[59]), .X119(0),
        .X120(r_idft_in_real[60]), .X121(0),
        .X122(r_idft_in_real[61]), .X123(0),
        .X124(r_idft_in_real[62]), .X125(0),
        .X126(r_idft_in_real[63]), .X127(0),
        // We use only the real parts of the output
        .Y0(w_idft_out_real[0]),
        .Y2(w_idft_out_real[1]),
        .Y4(w_idft_out_real[2]),
        .Y6(w_idft_out_real[3]),
        .Y8(w_idft_out_real[4]),
        .Y10(w_idft_out_real[5]),
        .Y12(w_idft_out_real[6]),
        .Y14(w_idft_out_real[7]),
        .Y16(w_idft_out_real[8]),
        .Y18(w_idft_out_real[9]),
        .Y20(w_idft_out_real[10]),
        .Y22(w_idft_out_real[11]),
        .Y24(w_idft_out_real[12]),
        .Y26(w_idft_out_real[13]),
        .Y28(w_idft_out_real[14]),
        .Y30(w_idft_out_real[15]),
        .Y32(w_idft_out_real[16]),
        .Y34(w_idft_out_real[17]),
        .Y36(w_idft_out_real[18]),
        .Y38(w_idft_out_real[19]),
        .Y40(w_idft_out_real[20]),
        .Y42(w_idft_out_real[21]),
        .Y44(w_idft_out_real[22]),
        .Y46(w_idft_out_real[23]),
        .Y48(w_idft_out_real[24]),
        .Y50(w_idft_out_real[25]),
        .Y52(w_idft_out_real[26]),
        .Y54(w_idft_out_real[27]),
        .Y56(w_idft_out_real[28]),
        .Y58(w_idft_out_real[29]),
        .Y60(w_idft_out_real[30]),
        .Y62(w_idft_out_real[31]),
        .Y64(w_idft_out_real[32]),
        .Y66(w_idft_out_real[33]),
        .Y68(w_idft_out_real[34]),
        .Y70(w_idft_out_real[35]),
        .Y72(w_idft_out_real[36]),
        .Y74(w_idft_out_real[37]),
        .Y76(w_idft_out_real[38]),
        .Y78(w_idft_out_real[39]),
        .Y80(w_idft_out_real[40]),
        .Y82(w_idft_out_real[41]),
        .Y84(w_idft_out_real[42]),
        .Y86(w_idft_out_real[43]),
        .Y88(w_idft_out_real[44]),
        .Y90(w_idft_out_real[45]),
        .Y92(w_idft_out_real[46]),
        .Y94(w_idft_out_real[47]),
        .Y96(w_idft_out_real[48]),
        .Y98(w_idft_out_real[49]),
        .Y100(w_idft_out_real[50]),
        .Y102(w_idft_out_real[51]),
        .Y104(w_idft_out_real[52]),
        .Y106(w_idft_out_real[53]),
        .Y108(w_idft_out_real[54]),
        .Y110(w_idft_out_real[55]),
        .Y112(w_idft_out_real[56]),
        .Y114(w_idft_out_real[57]),
        .Y116(w_idft_out_real[58]),
        .Y118(w_idft_out_real[59]),
        .Y120(w_idft_out_real[60]),
        .Y122(w_idft_out_real[61]),
        .Y124(w_idft_out_real[62]),
        .Y126(w_idft_out_real[63]));        


    dft_top dft_top_inst (.clk(clk), .reset(reset), .next(r_dft_next), .next_out(w_dft_next_out),
        // We use only the real parts of the DFT input.
        .X0(r_dft_in_real[0]), .X1(0),
        .X2(r_dft_in_real[1]), .X3(0),
        .X4(r_dft_in_real[2]), .X5(0),
        .X6(r_dft_in_real[3]), .X7(0),
        .X8(r_dft_in_real[4]), .X9(0),
        .X10(r_dft_in_real[5]), .X11(0),
        .X12(r_dft_in_real[6]), .X13(0),
        .X14(r_dft_in_real[7]), .X15(0),
        .X16(r_dft_in_real[8]), .X17(0),
        .X18(r_dft_in_real[9]), .X19(0),
        .X20(r_dft_in_real[10]), .X21(0),
        .X22(r_dft_in_real[11]), .X23(0),
        .X24(r_dft_in_real[12]), .X25(0),
        .X26(r_dft_in_real[13]), .X27(0),
        .X28(r_dft_in_real[14]), .X29(0),
        .X30(r_dft_in_real[15]), .X31(0),
        .X32(r_dft_in_real[16]), .X33(0),
        .X34(r_dft_in_real[17]), .X35(0),
        .X36(r_dft_in_real[18]), .X37(0),
        .X38(r_dft_in_real[19]), .X39(0),
        .X40(r_dft_in_real[20]), .X41(0),
        .X42(r_dft_in_real[21]), .X43(0),
        .X44(r_dft_in_real[22]), .X45(0),
        .X46(r_dft_in_real[23]), .X47(0),
        .X48(r_dft_in_real[24]), .X49(0),
        .X50(r_dft_in_real[25]), .X51(0),
        .X52(r_dft_in_real[26]), .X53(0),
        .X54(r_dft_in_real[27]), .X55(0),
        .X56(r_dft_in_real[28]), .X57(0),
        .X58(r_dft_in_real[29]), .X59(0),
        .X60(r_dft_in_real[30]), .X61(0),
        .X62(r_dft_in_real[31]), .X63(0),
        .X64(r_dft_in_real[32]), .X65(0),
        .X66(r_dft_in_real[33]), .X67(0),
        .X68(r_dft_in_real[34]), .X69(0),
        .X70(r_dft_in_real[35]), .X71(0),
        .X72(r_dft_in_real[36]), .X73(0),
        .X74(r_dft_in_real[37]), .X75(0),
        .X76(r_dft_in_real[38]), .X77(0),
        .X78(r_dft_in_real[39]), .X79(0),
        .X80(r_dft_in_real[40]), .X81(0),
        .X82(r_dft_in_real[41]), .X83(0),
        .X84(r_dft_in_real[42]), .X85(0),
        .X86(r_dft_in_real[43]), .X87(0),
        .X88(r_dft_in_real[44]), .X89(0),
        .X90(r_dft_in_real[45]), .X91(0),
        .X92(r_dft_in_real[46]), .X93(0),
        .X94(r_dft_in_real[47]), .X95(0),
        .X96(r_dft_in_real[48]), .X97(0),
        .X98(r_dft_in_real[49]), .X99(0),
        .X100(r_dft_in_real[50]), .X101(0),
        .X102(r_dft_in_real[51]), .X103(0),
        .X104(r_dft_in_real[52]), .X105(0),
        .X106(r_dft_in_real[53]), .X107(0),
        .X108(r_dft_in_real[54]), .X109(0),
        .X110(r_dft_in_real[55]), .X111(0),
        .X112(r_dft_in_real[56]), .X113(0),
        .X114(r_dft_in_real[57]), .X115(0),
        .X116(r_dft_in_real[58]), .X117(0),
        .X118(r_dft_in_real[59]), .X119(0),
        .X120(r_dft_in_real[60]), .X121(0),
        .X122(r_dft_in_real[61]), .X123(0),
        .X124(r_dft_in_real[62]), .X125(0),
        .X126(r_dft_in_real[63]), .X127(0),
        // We use both real and imaginary outputs of the DFT
        .Y0(w_dft_out_real[0]), .Y1(w_dft_out_imag[0]),
        .Y2(w_dft_out_real[1]), .Y3(w_dft_out_imag[1]),
        .Y4(w_dft_out_real[2]), .Y5(w_dft_out_imag[2]),
        .Y6(w_dft_out_real[3]), .Y7(w_dft_out_imag[3]),
        .Y8(w_dft_out_real[4]), .Y9(w_dft_out_imag[4]),
        .Y10(w_dft_out_real[5]), .Y11(w_dft_out_imag[5]),
        .Y12(w_dft_out_real[6]), .Y13(w_dft_out_imag[6]),
        .Y14(w_dft_out_real[7]), .Y15(w_dft_out_imag[7]),
        .Y16(w_dft_out_real[8]), .Y17(w_dft_out_imag[8]),
        .Y18(w_dft_out_real[9]), .Y19(w_dft_out_imag[9]),
        .Y20(w_dft_out_real[10]), .Y21(w_dft_out_imag[10]),
        .Y22(w_dft_out_real[11]), .Y23(w_dft_out_imag[11]),
        .Y24(w_dft_out_real[12]), .Y25(w_dft_out_imag[12]),
        .Y26(w_dft_out_real[13]), .Y27(w_dft_out_imag[13]),
        .Y28(w_dft_out_real[14]), .Y29(w_dft_out_imag[14]),
        .Y30(w_dft_out_real[15]), .Y31(w_dft_out_imag[15]),
        .Y32(w_dft_out_real[16]), .Y33(w_dft_out_imag[16]),
        .Y34(w_dft_out_real[17]), .Y35(w_dft_out_imag[17]),
        .Y36(w_dft_out_real[18]), .Y37(w_dft_out_imag[18]),
        .Y38(w_dft_out_real[19]), .Y39(w_dft_out_imag[19]),
        .Y40(w_dft_out_real[20]), .Y41(w_dft_out_imag[20]),
        .Y42(w_dft_out_real[21]), .Y43(w_dft_out_imag[21]),
        .Y44(w_dft_out_real[22]), .Y45(w_dft_out_imag[22]),
        .Y46(w_dft_out_real[23]), .Y47(w_dft_out_imag[23]),
        .Y48(w_dft_out_real[24]), .Y49(w_dft_out_imag[24]),
        .Y50(w_dft_out_real[25]), .Y51(w_dft_out_imag[25]),
        .Y52(w_dft_out_real[26]), .Y53(w_dft_out_imag[26]),
        .Y54(w_dft_out_real[27]), .Y55(w_dft_out_imag[27]),
        .Y56(w_dft_out_real[28]), .Y57(w_dft_out_imag[28]),
        .Y58(w_dft_out_real[29]), .Y59(w_dft_out_imag[29]),
        .Y60(w_dft_out_real[30]), .Y61(w_dft_out_imag[30]),
        .Y62(w_dft_out_real[31]), .Y63(w_dft_out_imag[31]),
        .Y64(w_dft_out_real[32]), .Y65(w_dft_out_imag[32]),
        .Y66(w_dft_out_real[33]), .Y67(w_dft_out_imag[33]),
        .Y68(w_dft_out_real[34]), .Y69(w_dft_out_imag[34]),
        .Y70(w_dft_out_real[35]), .Y71(w_dft_out_imag[35]),
        .Y72(w_dft_out_real[36]), .Y73(w_dft_out_imag[36]),
        .Y74(w_dft_out_real[37]), .Y75(w_dft_out_imag[37]),
        .Y76(w_dft_out_real[38]), .Y77(w_dft_out_imag[38]),
        .Y78(w_dft_out_real[39]), .Y79(w_dft_out_imag[39]),
        .Y80(w_dft_out_real[40]), .Y81(w_dft_out_imag[40]),
        .Y82(w_dft_out_real[41]), .Y83(w_dft_out_imag[41]),
        .Y84(w_dft_out_real[42]), .Y85(w_dft_out_imag[42]),
        .Y86(w_dft_out_real[43]), .Y87(w_dft_out_imag[43]),
        .Y88(w_dft_out_real[44]), .Y89(w_dft_out_imag[44]),
        .Y90(w_dft_out_real[45]), .Y91(w_dft_out_imag[45]),
        .Y92(w_dft_out_real[46]), .Y93(w_dft_out_imag[46]),
        .Y94(w_dft_out_real[47]), .Y95(w_dft_out_imag[47]),
        .Y96(w_dft_out_real[48]), .Y97(w_dft_out_imag[48]),
        .Y98(w_dft_out_real[49]), .Y99(w_dft_out_imag[49]),
        .Y100(w_dft_out_real[50]), .Y101(w_dft_out_imag[50]),
        .Y102(w_dft_out_real[51]), .Y103(w_dft_out_imag[51]),
        .Y104(w_dft_out_real[52]), .Y105(w_dft_out_imag[52]),
        .Y106(w_dft_out_real[53]), .Y107(w_dft_out_imag[53]),
        .Y108(w_dft_out_real[54]), .Y109(w_dft_out_imag[54]),
        .Y110(w_dft_out_real[55]), .Y111(w_dft_out_imag[55]),
        .Y112(w_dft_out_real[56]), .Y113(w_dft_out_imag[56]),
        .Y114(w_dft_out_real[57]), .Y115(w_dft_out_imag[57]),
        .Y116(w_dft_out_real[58]), .Y117(w_dft_out_imag[58]),
        .Y118(w_dft_out_real[59]), .Y119(w_dft_out_imag[59]),
        .Y120(w_dft_out_real[60]), .Y121(w_dft_out_imag[60]),
        .Y122(w_dft_out_real[61]), .Y123(w_dft_out_imag[61]),
        .Y124(w_dft_out_real[62]), .Y125(w_dft_out_imag[62]),
        .Y126(w_dft_out_real[63]), .Y127(w_dft_out_imag[63]));        

       initial clk = 0;
       
       always #1 clk = ~clk;
       
       initial begin
       
          $dumpfile("idft_dft_tb.vcd");
          $dumpvars(0, idft_dft_tb);
          
          // We write the output of IDFT to this file
          f_idft_out = $fopen("output_idft_tb.csv");
          // We write the output of DFT to this file
          f_dft_out = $fopen("output_dft_tb.csv");
          
          for (i = 0; i < FFT_SIZE; i = i + 1) begin
              r_idft_in_real[i] <= 0;
              r_dft_in_real[i] <= 0;
          end
          
          r_idft_next <= 0;
          r_dft_next <= 0;
          reset <= 0;
          
          // Reset signal 
          @(posedge clk);
          reset <= 1;
          @(posedge clk);
          reset <= 0;
          
          @(posedge clk);
          
          
          for (j = 0; j < IDFT_OUTOUT_BLOCKS; j = j + 1) begin
              // Assert high to start IDFT
              r_idft_next <= 1;
              @(posedge clk);
              r_idft_next <= 0;
              
              // Start streaming input vector for IDFT
              // Create a Hermitian symmetry since we want a real valued signal
              r_idft_in_real[1] <= 25;
              r_idft_in_real[63] <= 25;

              r_idft_in_real[2] <= 25;
              r_idft_in_real[62] <= 25;
              
              r_idft_in_real[3] <= 25;
              r_idft_in_real[61] <= 25;
              
              r_idft_in_real[4] <= 25;
              r_idft_in_real[60] <= 25;
              
              // Wait until IDFT is done
              @(posedge w_idft_next_out);
              // IDFT module starts streaming output data at the next positive clock edge
              @(posedge clk);
              // We can read IDFT output at the next positive clock edge (registered access)
              @(posedge clk);
              // Print IDFT out to file
              for (i = 0; i < FFT_SIZE; i = i + 1) begin
                  $fwrite(f_idft_out, "%0d\n", (w_idft_out_real[i] ^ 10'h200));
                  r_idft_out_real[i + j * FFT_SIZE] <= w_idft_out_real[i] ^ 10'h200;
              end
          end
          
          
          for (j = 0; j < DFT_SAMPLE_START_OFFSETS; j = j + 1) begin
              // assert high to start DFT
              r_dft_next <= 1;
              @(posedge clk);
              r_dft_next <= 0;
              
              // Copy the real part of the IDFT output to the DFT input
              for (i = 0; i < FFT_SIZE; i = i + 1) begin
                  r_dft_in_real[i] <= r_idft_out_real[i + j] ^ 10'h200;
              end
              
              // Wait until DFT is done
              @(posedge w_dft_next_out);
              // DFT module starts streaming output data at the next positive clock edge
              @(posedge clk);
              // We can read DFT output at the next positive clock edge (registered access)
              @(posedge clk);

              for (i = 0; i < FFT_SIZE; i = i + 1) begin
                  $fwrite(f_dft_out, "%0d, %0d, ", w_dft_out_real[i], w_dft_out_imag[i]);
              end
              $fwrite(f_dft_out, "\n");

              @(posedge clk);
              @(posedge clk);
          end
          
          $fclose(f_idft_out);
          $fclose(f_dft_out);
          
          $finish;
          
       end

endmodule
