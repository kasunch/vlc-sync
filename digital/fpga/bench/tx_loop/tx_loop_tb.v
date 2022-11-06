module tx_loop_tb(i_clk);

    parameter WIDTH=10;

    input i_clk;
  
    integer f_output = 0;

    wire             w_auto_reset;
    wire             w_tx_ind;
    wire [WIDTH-1:0] w_tx_out;

    
    auto_reset auto_reset_inst(.clk(i_clk), .reset(w_auto_reset));

    tx_loop tx_loop_inst(.clk(i_clk), .reset(w_auto_reset), 
                         .o_tx_ind(w_tx_ind), .o_tx_out(w_tx_out));
              
    initial begin
        f_output = $fopen("output_tx_loop_tb.csv", "w");
    end
                      
    always @ (posedge i_clk) begin
        if (w_auto_reset) begin
        end
        else begin
            // Dump tx_data at every cycle
            $fdisplay(f_output, "%3x", w_tx_out);
            if (w_tx_ind)
                finish();
        end
    end
    
    task finish;
    begin
        $fclose(f_output);
        $finish;
    end
    endtask
    
endmodule








