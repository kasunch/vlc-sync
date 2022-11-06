// http://dspguru.com/dsp/tricks/magnitude-estimator
// alpha = 1, beta = 1/4
// avg err 0.006

module cmplx_to_mag(i_i, i_q, o_mag);

    parameter WIDTH=10;
    
    input signed [WIDTH-1:0] i_i;
    input signed [WIDTH-1:0] i_q;
    output [WIDTH-1:0] o_mag;
    
    wire [WIDTH-1:0] w_abs_i;
    wire [WIDTH-1:0] w_abs_q;
    wire [WIDTH-1:0] w_max;
    wire [WIDTH-1:0] w_min;        

    
    // We adjust the width of 1 beased on the parameter WIDTH.
    // e.g. if WIDTH=10 it will be 0000000001 
    assign w_abs_i = i_i[WIDTH-1]? (~i_i + {{(WIDTH-1){1'b0}}, 1'b1}): i_i;
    assign w_abs_q = i_q[WIDTH-1]? (~i_q + {{(WIDTH-1){1'b0}}, 1'b1}): i_q;

    assign w_max = w_abs_i > w_abs_q? w_abs_i: w_abs_q;
    assign w_min = w_abs_i > w_abs_q? w_abs_q: w_abs_i;
    
    assign o_mag = w_max + (w_min >> 2);

endmodule
