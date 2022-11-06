`define SCHMIDL_COX_TX_STATE_IDLE          1'd0
`define SCHMIDL_COX_TX_STATE_STARTED       1'd1

module schmidl_cox_tx(clk, reset, i_start, o_data, o_end);

    parameter WIDTH=10, PREAMBLE_HALF_LEN=64;

    input       clk;
    input       reset;

    input       i_start;
    output reg  o_end = 0;

    output [WIDTH-1:0]   o_data;

    reg         r_state = `SCHMIDL_COX_TX_STATE_IDLE;
    reg [7:0]   r_addr = 0;

    schmidl_cox_preamble preamble_inst (.clk(clk), .reset(reset), 
                                        .i_r_addr(r_addr), .o_data(o_data));

    always @ (posedge clk) begin
        if (reset) begin
            r_state <= `SCHMIDL_COX_TX_STATE_IDLE;
            r_addr <= 0;
            o_end <= 0;
        end
        else begin
            case (r_state)
                `SCHMIDL_COX_TX_STATE_IDLE: begin
                    if (i_start) begin
                        r_state <= `SCHMIDL_COX_TX_STATE_STARTED;
                    end
                    else begin
                        r_state <= `SCHMIDL_COX_TX_STATE_IDLE;
                    end
                    r_addr <= 0;
                    o_end <= 0;
                end 
                `SCHMIDL_COX_TX_STATE_STARTED: begin
                    if (r_addr == PREAMBLE_HALF_LEN * 2 - 1) begin
                        o_end <= 1'b1;
                        r_state <= `SCHMIDL_COX_TX_STATE_IDLE;
                    end
                    else begin
                        r_addr <= r_addr + 8'd1;
                        r_state <= `SCHMIDL_COX_TX_STATE_STARTED;
                    end
                end 
                default: begin
                end
            endcase
        end
    end

endmodule