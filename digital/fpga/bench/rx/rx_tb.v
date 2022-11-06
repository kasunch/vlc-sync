`include "verilated.v"

`include "rx_tb.vh"
`include "rx.vh"

`define STATE_IDLE      2'd0
`define STATE_RCVD      2'd1
`define STATE_PRINT     2'd2


module rx_tb(i_clk);

    parameter WIDTH=10;

    input i_clk;
    
    reg             r_rx_enable = 0;
    reg [6:0]       r_buf_r_addr = 0;
    reg [6:0]       r_pyld_len = 0;
    reg [1:0]       r_state = `STATE_IDLE;
    
    wire        w_output_clk;
    wire        w_auto_reset;
    wire        w_event_sig;
    wire [2:0]  w_rx_event;
    wire [7:0]  w_buf_byte;

    reg [WIDTH-1:0] r_rx_in = 0;
    reg [WIDTH-1:0] r_rx_mem[`RX_INPUT_DATA_SIZE-1:0];
    reg [$clog2(`RX_INPUT_DATA_SIZE)-1:0] r_rx_in_cnt = 0;
    
    auto_reset auto_reset_inst(.clk(i_clk), .reset(w_auto_reset));
  
    rx rx_inst(.clk(i_clk), 
                .reset(w_auto_reset), 
                .i_enable(r_rx_enable),
                .i_rx_in(r_rx_in),
                .i_buf_r_addr(r_buf_r_addr),
                .o_buf_r_byte(w_buf_byte),
                .o_ev(w_rx_event),
                .o_ev_sig(w_event_sig),
                .o_clk(w_output_clk));

    initial begin
        $readmemh("input_rx_tb.csv", r_rx_mem);
    end

    always @ (posedge w_output_clk) begin
        if (r_rx_enable) begin
            if (r_rx_in_cnt == `RX_INPUT_DATA_SIZE - 1) begin
                r_rx_in_cnt <= 0;
                $display("End of input data");
                finish();
            end
            else begin
                r_rx_in_cnt <= r_rx_in_cnt + 1;
            end
            r_rx_in <= r_rx_mem[r_rx_in_cnt];
        end
        else begin
            // Nothing to do
        end
    end
              
              
    always @ (posedge i_clk) begin
        if (w_auto_reset) begin
            r_rx_enable <= 0;
        end
        else begin

            // Followings handle RX events
            case (r_state)

                `STATE_IDLE: begin
                    r_rx_enable <= 1;
                    if (w_event_sig) begin
                        if (w_rx_event == `RX_EVENT_PHR) begin
                            // Set the RX buffer address to zero, so we can 
                            // read the frame length when the reception completed.
                            r_buf_r_addr <= 0;
                        end
                        else if (w_rx_event == `RX_EVENT_END) begin
                            r_pyld_len <= w_buf_byte[6:0];
                            $display("Reception completed. Frame length %0d", w_buf_byte);
                            r_buf_r_addr <= r_buf_r_addr + 7'd1;
                            r_state <= `STATE_RCVD; 
                        end
                        else begin
                            // Nothing to do
                        end
                    end
                    else begin
                        // Nothing to do
                    end
                end

                `STATE_RCVD: begin
                    if (r_buf_r_addr == r_pyld_len + 7'd1) begin
                        r_state <= `STATE_IDLE; 
                        r_buf_r_addr <= 0;
                        $write("\n");
                    end
                    else begin
                        r_buf_r_addr <= r_buf_r_addr + 7'd1;
                        r_state <= `STATE_PRINT;
                    end
                end

                `STATE_PRINT: begin
                    $write("%x ", w_buf_byte);
                    r_state <= `STATE_RCVD; 
                end

                default: begin
                    // Nothing to be done here.
                end
            endcase

        end
    end
    
    task finish;
    begin
        $finish;
    end
    endtask
    
endmodule








