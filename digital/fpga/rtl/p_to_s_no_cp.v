`define P2S_STATE_IDLE  0
`define P2S_STATE_DATA  1

module p_to_s_no_cp(clk, reset,
              i_start,
              X0,  X1,  X2,  X3,  X4,  X5,  X6,  X7,
              X8,  X9,  X10, X11, X12, X13, X14, X15,
              X16, X17, X18, X19, X20, X21, X22, X23,
              X24, X25, X26, X27, X28, X29, X30, X31,
              X32, X33, X34, X35, X36, X37, X38, X39,
              X40, X41, X42, X43, X44, X45, X46, X47,
              X48, X49, X50, X51, X52, X53, X54, X55,
              X56, X57, X58, X59, X60, X61, X62, X63,
              Y, o_next_req, o_clk);
    
    parameter WIDTH=10;
    
    input clk; 
    input reset;    
    input i_start;
    input [WIDTH-1:0] X0,  X1,  X2,  X3,  X4,  X5,  X6,  X7,
                      X8,  X9,  X10, X11, X12, X13, X14, X15,
                      X16, X17, X18, X19, X20, X21, X22, X23,
                      X24, X25, X26, X27, X28, X29, X30, X31,
                      X32, X33, X34, X35, X36, X37, X38, X39,
                      X40, X41, X42, X43, X44, X45, X46, X47,
                      X48, X49, X50, X51, X52, X53, X54, X55,
                      X56, X57, X58, X59, X60, X61, X62, X63;
      
    output reg          o_next_req = 0;
    output [WIDTH-1:0]  Y;
    output reg          o_clk = 0;
      
    reg [WIDTH-1:0]   r_Y = 0;
    reg               r_active = 0;
    reg [1:0]         r_state = `P2S_STATE_IDLE;
    reg [5:0]         r_cnt = 0;
    reg [WIDTH-1:0]   r_mem[63:0];
    integer           i;
       
    // Flip the MSB to get signed (two's complement) from unsigned value (full range)
    assign Y = r_Y ^ 10'h200;

    always @ (posedge clk) begin
        if (reset) begin
            for(i = 0; i < 64; i = i + 1) begin
                r_mem[i] <= 0;
            end
            r_active <= 0;
            r_state <= `P2S_STATE_IDLE;
            r_cnt <= 0;
            r_Y <= 0;
            o_clk <= 0;
        end
        else begin

            if (i_start) begin
                r_active <= 1;
            end
            else begin
                // Nothing to do here
            end

            if (o_clk) begin 
                // This is the negative edge of the output clock
                o_clk <= 0;
                o_next_req <= 0;
            end
            else begin
                // This is the positive edge of the output clock
                o_clk <= 1;
                if (r_active) begin
                    case (r_state)
                        `P2S_STATE_IDLE: begin
                            r_state <= `P2S_STATE_DATA;
                            o_next_req <= 1;
                            r_cnt <= 0;
                        end

                        `P2S_STATE_DATA: begin
                            r_Y <= r_mem[r_cnt];    
                            if (r_cnt == 6'd63) begin
                                r_mem[0] <= X0;
                                r_mem[1] <= X1;
                                r_mem[2] <= X2;
                                r_mem[3] <= X3;
                                r_mem[4] <= X4;
                                r_mem[5] <= X5;
                                r_mem[6] <= X6;
                                r_mem[7] <= X7;
                                r_mem[8] <= X8;
                                r_mem[9] <= X9;
                                r_mem[10] <= X10;
                                r_mem[11] <= X11;
                                r_mem[12] <= X12;
                                r_mem[13] <= X13;
                                r_mem[14] <= X14;
                                r_mem[15] <= X15;
                                r_mem[16] <= X16;
                                r_mem[17] <= X17;
                                r_mem[18] <= X18;
                                r_mem[19] <= X19;
                                r_mem[20] <= X20;
                                r_mem[21] <= X21;
                                r_mem[22] <= X22;
                                r_mem[23] <= X23;
                                r_mem[24] <= X24;
                                r_mem[25] <= X25;
                                r_mem[26] <= X26;
                                r_mem[27] <= X27;
                                r_mem[28] <= X28;
                                r_mem[29] <= X29;
                                r_mem[30] <= X30;
                                r_mem[31] <= X31;
                                r_mem[32] <= X32;
                                r_mem[33] <= X33;
                                r_mem[34] <= X34;
                                r_mem[35] <= X35;
                                r_mem[36] <= X36;
                                r_mem[37] <= X37;
                                r_mem[38] <= X38;
                                r_mem[39] <= X39;
                                r_mem[40] <= X40;
                                r_mem[41] <= X41;
                                r_mem[42] <= X42;
                                r_mem[43] <= X43;
                                r_mem[44] <= X44;
                                r_mem[45] <= X45;
                                r_mem[46] <= X46;
                                r_mem[47] <= X47;
                                r_mem[48] <= X48;
                                r_mem[49] <= X49;
                                r_mem[50] <= X50;
                                r_mem[51] <= X51;
                                r_mem[52] <= X52;
                                r_mem[53] <= X53;
                                r_mem[54] <= X54;
                                r_mem[55] <= X55;
                                r_mem[56] <= X56;
                                r_mem[57] <= X57;
                                r_mem[58] <= X58;
                                r_mem[59] <= X59;
                                r_mem[60] <= X60;
                                r_mem[61] <= X61;
                                r_mem[62] <= X62;
                                r_mem[63] <= X63;
                                r_cnt <= 0;
                                r_state <= `P2S_STATE_DATA;
                                o_next_req <= 1; // Make the next request
                            end
                            else begin
                                r_cnt <= r_cnt + 6'd1;
                                r_state <= `P2S_STATE_DATA;
                                o_next_req <= 0;
                            end
                        end

                        default: begin
                            // We've handled all the states. 
                        end

                    endcase
                end
                else begin
                    // Nothing to do here 
                end
            end
        end
    end
        
endmodule
