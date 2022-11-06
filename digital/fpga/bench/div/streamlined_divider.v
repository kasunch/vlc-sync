module streamlined_divider(clk, reset, i_start, i_divident, i_divider, o_quotient, o_remainder, o_ready);

    parameter WIDTH=16;

    input               clk;
    input               reset;

    input               i_start;
    output              o_ready;

    input [WIDTH-1:0]   i_divident;
    input [WIDTH-1:0]   i_divider;

    output [WIDTH-1:0]  o_quotient;
    output [WIDTH-1:0]  o_remainder;

//
//              0000 1011
//  """"""""|
//     1011 |   0001 0110     <- qr reg
// -0011    |  -0011          <- divider (never changes)
//  """"""""|
//     1011 |   0010 110o     <- qr reg
//  -0011   |  -0011
//  """"""""|
//     1011 |   0101 10oo     <- qr reg
//   -0011  |  -0011
//  """"""""|   0010 1000     <- qr reg before shift
//     0101 |   0101 0ooi     <- after shift
//    -0011 |  -0011
//  """"""""|   0010 ooii
//       10 |
//
// Quotient, 3 (0011); remainder 2 (10).

    reg [WIDTH*2-1:0]   r_qr;
    reg [WIDTH:0]       r_diff;
    reg [4:0]           r_bit = 0;
    reg                 r_started = 0;

    wire [WIDTH:0]      w_diff;

    assign o_remainder = r_qr[WIDTH*2-1:WIDTH];
    assign o_quotient = r_qr[WIDTH-1:0];
    assign o_ready = (r_bit == 0);

    assign w_diff = r_qr[WIDTH*2-1:WIDTH-1] - {1'b0, i_divider};


    always @ (posedge clk) begin
        if (i_start) begin
            r_bit <= WIDTH;
            r_qr <= {{WIDTH{1'b0}}, i_divident};
            r_started <= 1'b1;
        end
        else begin
            if (!o_ready && r_started) begin
                if (w_diff[WIDTH]) begin
                    r_qr <= {r_qr[WIDTH*2-2:0], 1'b0};
                end
                else begin
                    r_qr <= {w_diff[WIDTH-1:0], r_qr[WIDTH-2:0], 1'b1};
                end

                r_bit <= r_bit - 1;
            end

        end
    end


endmodule