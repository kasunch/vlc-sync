`include "tx.vh"

`define TX_ON_TRG_STATE_IDLE      3'd0
`define TX_ON_TRG_STATE_LOAD_INIT 3'd1
`define TX_ON_TRG_STATE_LOAD      3'd2
`define TX_ON_TRG_STATE_TX        3'd3

module tx_on_trigger(clk, reset,
                    i_trigger,
                    o_tx_sfd, 
                    o_tx_out,
                    o_tx_out_clk);

    parameter WIDTH=10;

    input clk;
    input reset;
    input              i_trigger;
    output             o_tx_sfd;
    output [WIDTH-1:0] o_tx_out;
    output             o_tx_out_clk;

    reg [2:0] r_state = `TX_ON_TRG_STATE_IDLE;
    reg       r_trigger_r = 0;
    reg       r_trigger = 0;
    reg       r_start = 0;
    reg [7:0] r_buf [121:0];
    reg       r_buf_w_en = 0;
    reg [6:0] r_buf_w_addr = 7'h00;
    reg [7:0] r_buf_byte = 8'h00;

    wire        w_tx_ev_sig;
    wire [2:0]  w_tx_ev;

    tx tx_inst(.clk(clk), 
                .reset(reset), 
                .i_start(r_start),
                // Buffer access interface
                .i_buf_w_en(r_buf_w_en), 
                .i_buf_w_addr(r_buf_w_addr), 
                .i_buf_byte(r_buf_byte), 
                // TX events
                .o_ev(w_tx_ev), 
                .o_ev_sig(w_tx_ev_sig),
                // TX output 
                .o_tx_out(o_tx_out),
                .o_clk(o_tx_out_clk),
                // TX status
                .o_sfd(o_tx_sfd));

    // Purpose: Double-register the trigger input.
    // This removes problems caused by metastability
    always @(posedge clk) begin
        r_trigger_r <= i_trigger;
        r_trigger <= r_trigger_r;
    end

    always @ (posedge clk) begin
        if (reset) begin
            r_state <= `TX_ON_TRG_STATE_IDLE;
        end
        else begin
            case (r_state)
                `TX_ON_TRG_STATE_IDLE: begin
                    if (r_trigger) begin
                        r_state <= `TX_ON_TRG_STATE_LOAD_INIT;
                    end
                    else begin
                        r_state <= `TX_ON_TRG_STATE_IDLE;
                    end  
                end
                `TX_ON_TRG_STATE_LOAD_INIT: begin
                    r_state <= `TX_ON_TRG_STATE_LOAD;
                    // Set some values
                    r_buf[0] <= 8'h00;
                    r_buf[1] <= 8'h00;
                    r_buf[2] <= 8'h01;
                    r_buf[3] <= 8'h02;
                    r_buf[4] <= 8'h1e;
                    r_buf[5] <= 8'h10;
                    r_buf[6] <= 8'h02;
                    r_buf[7] <= 8'h04;
                    r_buf[8] <= 8'h3c;
                    r_buf[9] <= 8'h20;
                    r_buf[10] <= 8'h04;
                    r_buf[11] <= 8'h08;
                    r_buf[12] <= 8'h78;
                    r_buf[13] <= 8'h40;
                    r_buf[14] <= 8'h09;
                    r_buf[15] <= 8'h10;
                    r_buf[16] <= 8'h70;
                    r_buf[17] <= 8'h00;
                    r_buf[18] <= 8'h12;
                    r_buf[19] <= 8'h20;
                    r_buf[20] <= 8'h60;
                    r_buf[21] <= 8'h01;
                    r_buf[22] <= 8'h24;
                    r_buf[23] <= 8'h40;
                    r_buf[24] <= 8'h40;
                    r_buf[25] <= 8'h03;
                    r_buf[26] <= 8'h48;
                    r_buf[27] <= 8'h00;
                    r_buf[28] <= 8'h00;
                    r_buf[29] <= 8'h07;
                    r_buf[30] <= 8'h10;
                    r_buf[31] <= 8'h00;
                    r_buf[32] <= 8'h01;
                    r_buf[33] <= 8'h0f;
                    r_buf[34] <= 8'h21;
                    r_buf[35] <= 8'h01;
                    r_buf[36] <= 8'h02;
                    r_buf[37] <= 8'h1e;
                    r_buf[38] <= 8'h43;
                    r_buf[39] <= 8'h02;
                    r_buf[40] <= 8'h04;
                    r_buf[41] <= 8'h3c;
                    r_buf[42] <= 8'h07;
                    r_buf[43] <= 8'h04;
                    r_buf[44] <= 8'h08;
                    r_buf[45] <= 8'h78;
                    r_buf[46] <= 8'h0e;
                    r_buf[47] <= 8'h09;
                    r_buf[48] <= 8'h10;
                    r_buf[49] <= 8'h70;
                    r_buf[50] <= 8'h1d;
                    r_buf[51] <= 8'h12;
                    r_buf[52] <= 8'h20;
                    r_buf[53] <= 8'h60;
                    r_buf[54] <= 8'h3b;
                    r_buf[55] <= 8'h24;
                    r_buf[56] <= 8'h40;
                    r_buf[57] <= 8'h40;
                    r_buf[58] <= 8'h77;
                    r_buf[59] <= 8'h48;
                    r_buf[60] <= 8'h00;
                    r_buf[61] <= 8'h00;
                    r_buf[62] <= 8'h6e;
                    r_buf[63] <= 8'h10;
                    r_buf[64] <= 8'h00;
                    r_buf[65] <= 8'h01;
                    r_buf[66] <= 8'h5c;
                    r_buf[67] <= 8'h21;
                    r_buf[68] <= 8'h01;
                    r_buf[69] <= 8'h02;
                    r_buf[70] <= 8'h38;
                    r_buf[71] <= 8'h43;
                    r_buf[72] <= 8'h02;
                    r_buf[73] <= 8'h04;
                    r_buf[74] <= 8'h70;
                    r_buf[75] <= 8'h07;
                    r_buf[76] <= 8'h04;
                    r_buf[77] <= 8'h08;
                    r_buf[78] <= 8'h61;
                    r_buf[79] <= 8'h0e;
                    r_buf[80] <= 8'h09;
                    r_buf[81] <= 8'h10;
                    r_buf[82] <= 8'h42;
                    r_buf[83] <= 8'h1d;
                    r_buf[84] <= 8'h12;
                    r_buf[85] <= 8'h20;
                    r_buf[86] <= 8'h04;
                    r_buf[87] <= 8'h3b;
                    r_buf[88] <= 8'h24;
                    r_buf[89] <= 8'h40;
                    r_buf[90] <= 8'h09;
                    r_buf[91] <= 8'h77;
                    r_buf[92] <= 8'h48;
                    r_buf[93] <= 8'h00;
                    r_buf[94] <= 8'h12;
                    r_buf[95] <= 8'h6e;
                    r_buf[96] <= 8'h10;
                    r_buf[97] <= 8'h00;
                    r_buf[98] <= 8'h24;
                    r_buf[99] <= 8'h5c;
                    r_buf[100] <= 8'h21;
                    r_buf[101] <= 8'h01;
                    r_buf[102] <= 8'h48;
                    r_buf[103] <= 8'h38;
                    r_buf[104] <= 8'h43;
                    r_buf[105] <= 8'h02;
                    r_buf[106] <= 8'h10;
                    r_buf[107] <= 8'h70;
                    r_buf[108] <= 8'h07;
                    r_buf[109] <= 8'h04;
                    r_buf[110] <= 8'h20;
                    r_buf[111] <= 8'h61;
                    r_buf[112] <= 8'h0e;
                    r_buf[113] <= 8'h09;
                    r_buf[114] <= 8'h41;
                    r_buf[115] <= 8'h42;
                    r_buf[116] <= 8'h1d;
                    r_buf[117] <= 8'h12;
                    r_buf[118] <= 8'h02;
                    r_buf[119] <= 8'h04;
                    r_buf[120] <= 8'h3b;
                    r_buf[121] <= 8'h24;

                    // First byte in the TX buffer is the length of the frame.
                    // Length should also include the size of FCS
                    r_buf_byte <= 8'd124;
                    r_buf_w_addr <= 0;
                    r_buf_w_en <= 1;
                end

                `TX_ON_TRG_STATE_LOAD: begin
                    // Load the frame to TX buffer
                    if (r_buf_w_addr == 7'd122) begin
                        r_state <= `TX_ON_TRG_STATE_TX;
                        r_buf_w_en <= 0;
                        r_start <= 1; // Start transmission  
                    end
                    else begin
                        r_buf_w_addr <= r_buf_w_addr + 7'd1;
                        r_buf_byte <= r_buf[r_buf_w_addr[6:0]];
                        r_state <= `TX_ON_TRG_STATE_LOAD;
                    end
                end
                
                `TX_ON_TRG_STATE_TX: begin
                    r_start <= 0;
                    if (w_tx_ev_sig) begin
                        if (w_tx_ev == `TX_EVENT_END) begin
                            r_state <= `TX_ON_TRG_STATE_IDLE;
                        end
                        else begin
                            r_state <= `TX_ON_TRG_STATE_TX;
                        end
                    end
                    else begin
                        r_state <= `TX_ON_TRG_STATE_TX;
                    end
                end
                
                default: begin
                    // We handled all the status. So nothing to be done here.
                end
            endcase

        end
    end

endmodule