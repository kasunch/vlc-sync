`define TX_STATE_IDLE        2'h0
`define TX_STATE_DATA        2'h1
`define TX_STATE_STOP_WAIT   2'h2

module slip_tx_tb(i_clk);

    input i_clk;

    wire reset;

    // Registers and wires for SLIP TX
    reg       r_tx_start = 0;
    reg       r_tx_end = 0;
    reg       r_tx_dv = 0;
    reg [7:0] r_tx_byte = 0;

    wire w_tx_done;
    wire w_tx_line;

    // Registers and wires for SLIP RX
    wire       w_rx_line;
    wire       w_rx_started;
    wire       w_rx_ended;
    wire       w_rx_byte_done;
    wire [7:0] w_rx_byte;

    // test bench registers and wires
    reg [1:0]   r_tx_state = `TX_STATE_IDLE;
    
    auto_reset auto_reset_inst(.clk(i_clk), .reset(reset));

    slip_tx tx_inst(.clk(i_clk), .reset(reset),
                    .i_start(r_tx_start), 
                    .i_end(r_tx_end), 
                    .i_tx_dv(r_tx_dv),
                    .i_tx_byte(r_tx_byte),
                    .o_tx_byte_done(w_tx_done),
                    .o_uart_line(w_tx_line));

    slip_rx rx_inst(.clk(i_clk), .reset(reset),
                    .i_uart_line(w_rx_line),
                    .o_rx_started(w_rx_started), 
                    .o_rx_ended(w_rx_ended), 
                    .o_rx_byte_done(w_rx_byte_done), 
                    .o_rx_byte(w_rx_byte));

    assign w_rx_line = w_tx_line;

    // RX loop
    always @ (posedge i_clk) begin
        if (reset) begin
        end
        else begin
            if (w_rx_started) begin
                $write("| ");
            end
            else if (w_rx_ended) begin
                $write("|\n");
            end
            else if (w_rx_byte_done) begin
                $write("%2x ", w_rx_byte);
            end
            else begin
                // Nothing to be done
            end
        end
    end

    // TX loop
    always @ (posedge i_clk) begin
        if (reset) begin
        end
        else begin
            case (r_tx_state)
                `TX_STATE_IDLE: begin
                    r_tx_byte <= 8'd0;
                    r_tx_start <= 1'b1; // Start SLIP TX
                    r_tx_end <= 1'b0; 
                    r_tx_dv <= 1'b0;
                    r_tx_state <= `TX_STATE_DATA;
                end
                `TX_STATE_DATA: begin
                    r_tx_start <= 1'b0;
                    if (w_tx_done) begin
                        if (r_tx_byte == 8'd20) begin
                            r_tx_state <= `TX_STATE_STOP_WAIT;
                            r_tx_end <= 1'b1;
                        end
                        else begin
                            r_tx_byte <= r_tx_byte + 8'd1;
                            r_tx_dv <= 1'b1;
                            r_tx_state <= `TX_STATE_DATA;
                        end
                    end
                    else begin
                        r_tx_dv <= 1'b0;
                        r_tx_state <= `TX_STATE_DATA;
                    end
                end
                `TX_STATE_STOP_WAIT: begin
                    r_tx_end <= 1'b0;
                    if (w_tx_done) begin
                        r_tx_state <= `TX_STATE_IDLE;
                    end
                    else begin
                        r_tx_state <= `TX_STATE_STOP_WAIT;
                    end
                end
                default: begin
                    // Nothing to do
                end
            endcase  
        end
    end

    
endmodule
