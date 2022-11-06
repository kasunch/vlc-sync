module ram_single(clk, i_w_enable, i_w_addr, i_w_byte, i_r_addr, o_r_byte);
    parameter ADDR_WIDTH=7, RAM_SIZE=128;

    input [7:0] i_w_byte;
    input [ADDR_WIDTH-1:0] i_w_addr;
    input [ADDR_WIDTH-1:0] i_r_addr;
    input i_w_enable, clk;

    output reg [7:0] o_r_byte;

    reg [7:0] mem [RAM_SIZE-1:0];

    always @(posedge clk) begin
        if (i_w_enable)
            mem[i_w_addr] <= i_w_byte;

        o_r_byte <= mem[i_r_addr];
    end
endmodule