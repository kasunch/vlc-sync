`define TB_STATE_IDLE             4'd0
`define TB_STATE_INIT             4'd1
`define TB_STATE_WAIT             4'd2

module glossy_app_tb(i_clk);

    parameter WIDTH=10;

    input   i_clk;
    wire    w_auto_reset;

    reg       r_start = 0;

    reg [3:0]  r_state = `TB_STATE_IDLE;

    wire [WIDTH-1:0] w_ini_to_recv_loop;
    wire [WIDTH-1:0] w_recv_to_ini_loop;

    reg [7:0] r_ini_done_count = 0;

    auto_reset auto_reset_inst(.clk(i_clk), .reset(w_auto_reset));

    glossy_app app_ini(.clk(i_clk), .reset(w_auto_reset), 
                        .i_start(r_start),
                        .i_mode(1'b1),
                        // TX/RX lines
                        .i_rx_in(w_recv_to_ini_loop),
                        .o_tx_out(w_ini_to_recv_loop));

    glossy_app app_rcv(.clk(i_clk), .reset(w_auto_reset),
                        .i_start(r_start), 
                        .i_mode(0),
                        // TX/RX lines
                        .i_rx_in(w_ini_to_recv_loop),
                        .o_tx_out(w_recv_to_ini_loop));

    always @ (posedge app_ini.glossy_inst.o_done) begin
        if (r_ini_done_count == 3) begin
            $finish;
        end
        else begin
            r_ini_done_count <= r_ini_done_count + 8'd1; 
            $display("INI: Glossy done");
        end
    end

    always @ (posedge i_clk) begin
        if (w_auto_reset) begin
            r_state <= `TB_STATE_INIT;
        end
        else begin
            case (r_state)
                `TB_STATE_IDLE: begin
                end

                `TB_STATE_INIT: begin
                    r_start <= 1'b1;
                end
            
                `TB_STATE_WAIT: begin
                    r_start <= 0;
                end

                default: begin
                    // Nothing to be done here
                end
            endcase
        end
    end
endmodule