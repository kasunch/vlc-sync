module div_uu(clk, reset, i_enable, i_divident, i_divisor, o_quotient, o_remainder, o_valid);

    parameter WIDTH=16;

    input   clk;
	input	reset;
    input   i_enable;
    input   [WIDTH-1:0]	i_divident;     // divident
	input   [WIDTH-1:0] i_divisor;      // divisor
	output  [WIDTH-1:0]	o_quotient;     // quotient
	output  [WIDTH-1:0] o_remainder;    // remainder
	output	reg			o_valid = 1'b0;

	reg [7:0]			r_step_ctr = 0;
	reg [WIDTH-1:0]     r_d_pipe  [WIDTH:0];
	reg [WIDTH*2-1:0]	r_qr_pipe [WIDTH:0]; 

	function [WIDTH*2-1:0] gen_qr;
		input [WIDTH*2-1:0]	i_qr;
		input [WIDTH-1:0]	i_d;
		reg  [WIDTH:0] 		r_diff;
		begin
			r_diff = i_qr[WIDTH*2-1:WIDTH-1] - {1'b0, i_d};
			if (r_diff[WIDTH]) begin
				gen_qr = {i_qr[WIDTH*2-2:0], 1'b0};
			end
			else begin
				gen_qr = {r_diff[WIDTH-1:0], i_qr[WIDTH-2:0], 1'b1};
			end
		end 	
	endfunction

    integer i;

    assign o_remainder = o_valid ? r_qr_pipe[WIDTH][WIDTH*2-1:WIDTH] : 0;
    assign o_quotient = o_valid ? r_qr_pipe[WIDTH][WIDTH-1:0] : 0;

    always @ (posedge clk) begin
		if (reset) begin
			r_step_ctr <= 8'd0;
			o_valid <= 1'b0;
		end
		else begin
			if (i_enable) begin
			
				for(i = 1; i <= WIDTH; i = i + 1) begin
					r_d_pipe[i] <= r_d_pipe[i - 1];
				end
				r_d_pipe[0] <= i_divisor;
	
				for(i = 1; i <= WIDTH; i = i + 1) begin
					r_qr_pipe[i] <= gen_qr(r_qr_pipe[i - 1], r_d_pipe[i - 1]);
				end
				r_qr_pipe[0] <= {{WIDTH{1'b0}}, i_divident}; 	

				if (r_step_ctr < WIDTH) begin
					r_step_ctr <= r_step_ctr + 8'd1;
				end
				else begin
					o_valid <= 1'b1;
				end		
			end
			else begin
				// Nothing to do
			end
		end
    end

endmodule

