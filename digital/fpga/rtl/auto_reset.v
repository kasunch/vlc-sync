module auto_reset(clk, reset);

    input clk;
    output reset;

    reg r_ready = 1'b1;
    reg r_reset = 1'b0;
    
    assign reset = r_reset;
    
    always @(posedge clk) begin
        if (r_ready) begin 
            r_ready <= 1'b0;
            r_reset <= 1'b1;
        end 
        else if (r_reset) begin
            r_reset <= 1'b0;
        end
        else begin
            r_ready <= 1'b0;
            r_reset <= 1'b0;
        end
      
    end

endmodule
