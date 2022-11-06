`include "tx.vh"

`define STATE_LOAD_INIT 2'd0
`define STATE_LOAD      2'd1
`define STATE_TX        2'd2
`define STATE_WAIT      2'd3

module tx_tb(i_clk);
    input i_clk;
    
    parameter WIDTH=10, PLD_LEN=7'd4;
  
    integer f_output = 0;

    reg       r_start = 0;
    reg [1:0] r_state = `STATE_LOAD_INIT;
    reg       r_buf_w_en = 0;
    reg [7:0] r_buf_byte = 8'h00;
    reg [6:0] r_buf_w_addr = 7'h00;
    reg       r_start_dump = 0;
    reg [7:0] r_buf [PLD_LEN-1:0];

    wire                w_auto_reset;
    wire                w_tx_ev_sig;
    wire [WIDTH-1:0]    w_tx_out;
    wire                w_output_clk;
    wire [2:0]          w_tx_ev;
    
    auto_reset auto_reset_inst(.clk(i_clk), .reset(w_auto_reset));
  
    tx tx_inst(.clk(i_clk), .reset(w_auto_reset), .i_start(r_start),
                .i_buf_w_en(r_buf_w_en), .i_buf_w_addr(r_buf_w_addr), .i_buf_byte(r_buf_byte), 
                .o_ev(w_tx_ev), .o_ev_sig(w_tx_ev_sig), .o_tx_out(w_tx_out), .o_clk(w_output_clk));
                            
    initial begin
        f_output = $fopen("output_tx_tb.csv", "w");
    end

    always @ (posedge w_output_clk) begin
        if (r_start_dump)
            $fdisplay(f_output, "%03x", w_tx_out);
        else begin
            // Nothing to do
        end
    end
              
    always @ (posedge i_clk) begin
        if (w_auto_reset) begin
        end
        else begin

            case (r_state)
                `STATE_LOAD_INIT: begin
                    r_state <= `STATE_LOAD;
                    // Set some values
                    r_buf[0] <= 8'h01;
                    r_buf[1] <= 8'h02;
                    r_buf[2] <= 8'h03;
                    r_buf[3] <= 8'h04;
                    // First byte in the TX buffer is the length
                    // Length should also include the size of FCS
                    r_buf_byte <= PLD_LEN + 2;
                    r_buf_w_addr <= 0;
                    r_buf_w_en <= 1;
                end
                `STATE_LOAD: begin
                    if (r_buf_w_addr == PLD_LEN) begin
                        r_state <= `STATE_TX;
                        r_buf_w_en <= 0;
                        r_start <= 1; // Start transmission  
                    end
                    else begin
                        r_buf_w_addr <= r_buf_w_addr + 7'd1;
                        r_buf_byte <= r_buf[r_buf_w_addr[1:0]];
                    end
                end

                `STATE_TX: begin
                    r_start <= 0;
                    if (w_tx_ev_sig) begin
                        if (w_tx_ev == `TX_EVENT_STARTED) begin
                            r_start_dump <= 1;
                        end
                        else if (w_tx_ev == `TX_EVENT_END) begin
                            $display("Transmission completed");  
                            r_start_dump <= 0;
                            //finish();
                        end
                        else begin
                            // Nothing to do here  
                        end
                    end
                    else begin
                        // Nothing to do here
                    end
                end

                default: begin
                    // Nothing to be done here
                end
            endcase
            
        end
    end
    
    task finish;
    begin
        $fclose(f_output);
        $finish;
    end
    endtask
    
endmodule








