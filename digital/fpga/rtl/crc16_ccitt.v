module crc16_ccitt (clk, reset, i_next, i_bit, o_crc);
    input clk;
    input reset;
    input i_next;
    input i_bit;

    output [15:0] o_crc;

    reg   [15:0] r_lfsr = 16'hFFFF;

    assign o_crc = r_lfsr;

    always @ (posedge clk) begin
        if (reset) begin
          r_lfsr <= 16'hFFFF;
        end 
        else begin
            if (i_next) begin 
                r_lfsr[0]  <= i_bit ^ r_lfsr[15];
                r_lfsr[1]  <= r_lfsr[0];
                r_lfsr[2]  <= r_lfsr[1];
                r_lfsr[3]  <= r_lfsr[2];
                r_lfsr[4]  <= r_lfsr[3];
                r_lfsr[5]  <= r_lfsr[4] ^ i_bit ^ r_lfsr[15];
                r_lfsr[6]  <= r_lfsr[5];
                r_lfsr[7]  <= r_lfsr[6];
                r_lfsr[8]  <= r_lfsr[7];
                r_lfsr[9]  <= r_lfsr[8];
                r_lfsr[10] <= r_lfsr[9];
                r_lfsr[11] <= r_lfsr[10];
                r_lfsr[12] <= r_lfsr[11] ^ i_bit ^ r_lfsr[15];
                r_lfsr[13] <= r_lfsr[12];
                r_lfsr[14] <= r_lfsr[13];
                r_lfsr[15] <= r_lfsr[14];
            end
        end
    end

endmodule
