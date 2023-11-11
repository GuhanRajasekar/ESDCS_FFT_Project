`timescale 1ns/1ps

module mpadd256_parallel (CLK, RST_N, s_out, a_in, b_in, write, start, ready);
	input CLK, RST_N;
	input [255:0] a_in, b_in;
	input write, start;
	output [256:0] s_out;
	output ready;
	reg [256:0] sum;
	reg [255:0] a, b;
	reg ready;
	assign s_out = sum;
	always @(posedge CLK) begin
		if (~RST_N) begin
			ready <= 1'b0;
		end
		else begin
			if (start) begin
				sum <= {1'b0, a} + {1'b0, b};
				ready <= 1'b1;
			end
			else begin
				if (write) begin
					a <= a_in;
					b <= b_in;
				end
				ready <= 1'b0;
			end
		end
	end
endmodule

module mpadd256_serial (CLK, RST_N, s_out, a_in, b_in, write, start, ready);
	input CLK, RST_N;
	input [255:0] a_in, b_in;
	input write, start;
	output [256:0] s_out;
	output ready;
	reg [256:0] sum;
	reg [255:0] a, b;
	reg ready;
	reg [2:0] state;
	reg [31:0] a_int, b_int;
    wire [32:0] s_int;
	always @(a, state) begin
		case (state)
			3'd0:	a_int = a[031:000];
			3'd1:	a_int = a[063:032];
			3'd2:	a_int = a[095:064];
			3'd3:	a_int = a[127:096];
			3'd4:	a_int = a[159:128];
			3'd5:	a_int = a[191:160];
			3'd6:	a_int = a[223:192];
			3'd7:	a_int = a[255:224];
		endcase
	end

	always @(b, state) begin
		case (state)
			3'd0:	b_int = b[031:000];
			3'd1:	b_int = b[063:032];
			3'd2:	b_int = b[095:064];
			3'd3:	b_int = b[127:096];
			3'd4:	b_int = b[159:128];
			3'd5:	b_int = b[191:160];
			3'd6:	b_int = b[223:192];
			3'd7:	b_int = b[255:224];
		endcase
    end
	assign s_out = sum;
    assign s_int = {1'b0, a_int} + {1'b0, b_int} + sum[256];

	always @(posedge CLK) begin
		if (~RST_N) begin
			ready <= 1'b0;
		end
		else begin
			if (start) begin
                sum[031:000] <= s_int[31:0]; sum[256] <= s_int[32];
				state <= state + 1;
            end

			else begin
				if (write) begin
					a <= a_in;
					b <= b_in;
				end
				ready <= 1'b0;
				state <= 3'd0;
				sum[256] <= 1'b0;
			end
            
            if (state > 3'd0) begin
                if (state == 3'd1) begin
                    sum[063:032] <= s_int[31:0]; sum[256] <= s_int[32];
                end
                
                else if (state == 3'd2) begin
                    sum[095:064] <= s_int[31:0]; sum[256] <= s_int[32];
                end

                else if (state == 3'd3) begin
                    sum[127:096] <= s_int[31:0]; sum[256] <= s_int[32];
                end

                else if (state == 3'd4) begin
                    sum[159:128] <= s_int[31:0]; sum[256] <= s_int[32];
                end

                else if (state == 3'd5) begin
                    sum[191:160] <= s_int[31:0]; sum[256] <= s_int[32];
                end

                else if (state == 3'd6) begin
                    sum[223:192] <= s_int[31:0]; sum[256] <= s_int[32];
                end

                else begin
                    sum[255:224] <= s_int[31:0]; sum[256] <= s_int[32];
                end

				state <= state + 1;
				if (state == 3'd7) begin
					ready <= 1'b1;
				end
			end
		end
	end

endmodule

