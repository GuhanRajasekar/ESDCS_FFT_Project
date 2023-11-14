module main(CLK, RST_N, write, start, in0_real , in0_imag, in1_real, in1_imag, 
  in2_real  ,in2_imag, in3_real  ,in3_imag, in4_real  ,in4_imag, in5_real  ,in5_imag
  , in6_real  ,in6_imag, in7_real  ,in7_imag, ready, out0_real ,out0_imag, out1_real 
  ,out1_imag, out2_real ,out2_imag, out3_real ,out3_imag, out4_real ,out4_imag, 
  out5_real ,out5_imag, out6_real ,out6_imag, out7_real ,out7_imag);

  input CLK, RST_N;
  input write, start;
  input signed wire [15:0]  in0_real  ,in0_imag;
  input signed wire [15:0]  in1_real  ,in1_imag;
  input signed wire [15:0]  in2_real  ,in2_imag;
  input signed wire [15:0]  in3_real  ,in3_imag;
  input signed wire [15:0]  in4_real  ,in4_imag;
  input signed wire [15:0]  in5_real  ,in5_imag;
  input signed wire [15:0]  in6_real  ,in6_imag;
  input signed wire [15:0]  in7_real  ,in7_imag;
  output reg ready;
  output signed wire [15:0] out0_real ,out0_imag;
  output signed wire [15:0] out1_real ,out1_imag;
  output signed wire [15:0] out2_real ,out2_imag;
  output signed wire [15:0] out3_real ,out3_imag;
  output signed wire [15:0] out4_real ,out4_imag;
  output signed wire [15:0] out5_real ,out5_imag;
  output signed wire [15:0] out6_real ,out6_imag;
  output signed wire [15:0] out7_real ,out7_imag;

  reg signed [15:0] i0_real, i0_imag;
  reg signed [15:0] i1_real, i1_imag;
  reg signed [15:0] i2_real, i2_imag;
  reg signed [15:0] i3_real, i3_imag;
  reg signed [15:0] i4_real, i4_imag;
  reg signed [15:0] i5_real, i5_imag;
  reg signed [15:0] i6_real, i6_imag;
  reg signed [15:0] i7_real, i7_imag;
  reg signed [1:0] stage;

  reg signed [15:0] g_real [0:7];   // Declare g_real as an array of registers to store real part of stage 1 results
  reg signed [15:0] g_imag [0:7];   // Declare g_imag as an array of registers to store imag part of stage 1 results
  reg signed [15:0] h_real [0:7];   // Declare h_real as an array of registers to store real part of stage 2 results
  reg signed [15:0] h_imag [0:7];   // Declare h_imag as an array of registers to store imag part of stage 2 results
  reg signed [15:0] i_real [0:7];   // Declare i_real as an array of registers to store real part of stage 3 results
  reg signed [15:0] i_imag [0:7];   // Declare i_imag as an array of registers to store imag part of stage 3 results

  reg signed [15:0] temp1,temp2,temp3,temp4;
  reg signed [31:0] h5_prime_real;  // 32 bit register to store real part of h[5] * (W8 ^ 1)
  reg signed [31:0] h5_prime_imag;  // 32 bit register to store imag part of h[5] * (W8 ^ 1)
  reg signed [31:0] h7_prime_real;  // 32 bit register to store real part of h[7] * (W8 ^ 3)
  reg signed [31:0] h7_prime_imag;  // 32 bit register to store imag part of h[7] * (W8 ^ 3)

  reg signed [15:0] h5_prime_real_16;  // 16 bit register to store real part of h[5] * (W8 ^ 1)
  reg signed [15:0] h5_prime_imag_16;  // 16 bit register to store imag part of h[5] * (W8 ^ 1)
  reg signed [15:0] h7_prime_real_16;  // 16 bit register to store real part of h[7] * (W8 ^ 3)
  reg signed [15:0] h7_prime_imag_16;  // 16 bit register to store imag part of h[7] * (W8 ^ 3)

  always @(posedge CLK) begin
		if (~RST_N) begin
			ready <= 1'b0;
			stage <= 2'b00;
      i_real[0] <= 0; i_imag[0]<=0;
      i_real[1] <= 0; i_imag[1]<=0;
      i_real[2] <= 0; i_imag[2]<=0;
      i_real[3] <= 0; i_imag[3]<=0;
      i_real[4] <= 0; i_imag[4]<=0;
      i_real[5] <= 0; i_imag[5]<=0;
      i_real[6] <= 0; i_imag[6]<=0;
      i_real[7] <= 0; i_imag[7]<=0;
		end
		else begin
			if (start) begin
				case(stage)
          2'b00: begin
            g_real[0] <= i0_real + i4_real;
            g_imag[0] <= i0_imag + i4_imag;
            g_real[1] <= i0_real - i4_real;
            g_imag[1] <= i0_imag - i4_imag;
            g_real[2] <= i2_real + i6_real;
            g_imag[2] <= i2_imag + i6_imag;
            g_real[3] <= i2_real - i6_real;
            g_imag[3] <= i2_imag - i6_imag;
            g_real[4] <= i1_real + i5_real;
            g_imag[4] <= i1_imag + i5_imag;
            g_real[5] <= i1_real - i5_real;
            g_imag[5] <= i1_imag - i5_imag;
            g_real[6] <= i3_real + i7_real;
            g_imag[6] <= i3_imag + i7_imag;
            g_real[7] <= i3_real - i7_real;
            g_imag[7] <= i3_imag - i7_imag; 
          end
          2'b01:begin
            h_real[0] <= g_real[0] + g_real[2];        // h0_real = g0_real + g2_real
            h_imag[0] <= g_imag[0] + g_imag[2];        // h0_imag = g0_imag + g2_imag
            h_real[1] <= g_real[1] - (-(g_imag[3]));   // h1_real = g1_real - (j*g3_real)  
            h_imag[1] <= g_imag[1] - g_real[3];        // h1_imag = g1_imag - (j*g3_imag)
            h_real[2] <= g_real[0] - g_real[2];        // h2_real = g0_real - g2_real
            h_imag[2] <= g_imag[0] - g_imag[2];        // h2_imag = g0_imag - g2_imag
            h_real[3] <= g_real[1] + (-(g_imag[3]));   // h3_real = g1_real + (j*g3_real)
            h_imag[3] <= g_imag[1] + g_real[3];        // h3_imag = g1_imag + (j*g3_imag)
            h_real[4] <= g_real[4] + g_real[6];        // h4_real = g4_real + g6_real
            h_imag[4] <= g_imag[4] + g_imag[6];        // h4_imag = g4_imag + g6_imag
            h_real[5] <= g_real[5] - (-(g_imag[7]));   // h5_real = g5_real - (j*g7_real)
            h_imag[5] <= g_imag[5] - g_real[7];        // h5_imag = g5_imag - (j*g7_imag)
            h_real[6] <= g_real[4] - g_real[6];        // h6_real = g4_real - g6_real
            h_imag[6] <= g_imag[4] - g_imag[6];        // h6_imag = g4_imag - g6_imag
            h_real[7] <= g_real[5] + (-(g_imag[7]));   // h7_real = g5_real + (j*g7_real)
            h_imag[7] <= g_imag[5] + g_real[7];        // h7_imag = g5_imag + (j*g7_imag)
          end
          2'b10:begin
            h5_prime_real_16 <= ((h_real[5] + h_imag[5]) * 16'b0000000010110100)[23:8];
            h5_prime_imag_16 <= ((h_imag[5] - h_real[5]) * 16'b0000000010110100)[23:8];
            h7_prime_real_16 <= ((h_imag[7] - h_real[7]) * 16'b0000000010110100)[23:8];
            h7_prime_imag_16 <= ((-(h_imag[7] + h_real[7])) * 16'b0000000010110100)[23:8];
          end
          2'b11:begin
            i_real[0] <= h_real[0] + h_real[4];  // i0_real = h0_real + h4_real
            i_imag[0] <= h_imag[0] + h_imag[4];  // i0_imag = h0_imag + h4_imag
            i_real[1] <= h_real[1] + h5_prime_real_16;  // i1_real = h[1]_real + Re((W8 ^ 1)*h[5])
            i_imag[1] <= h_imag[1] + h5_prime_imag_16;  // i1_imag = h[1]_imag + Im((W8 ^ 1)*h[5])
            i_real[2] <= h_real[2] - (-(h_imag[6]));  // i2_real = h2_real - (j*h6_real)
            i_imag[2] <= h_imag[2] - h_real[6];  // i2_imag = h2_imag - (j*h6_imag)
            i_real[3] <= h_real[3] + h7_prime_real_16;  // i3_real = h[3]_real + Re((W8^3)*h[7])
            i_imag[3] <= h_imag[3] + h7_prime_imag_16;  // i3_imag = h[3]_imag + Im((W8^3)*h[7]) 
            i_real[4] <= h_real[0] - h_real[4];  // i4_real = h0_real - h4_real
            i_imag[4] <= h_imag[0] - h_imag[4];  // i4_imag = h0_imag - h4_imag
            i_real[5] <= h_real[1] - h5_prime_real_16;  // i5_real = h[1]_real - Re((W8^1)*h[5])
            i_imag[5] <= h_imag[1] - h5_prime_imag_16;  // i5_imag = h[1]_imag - Im((W8^1)*h[5])
            i_real[6] <= h_real[2] + (-(h_imag[6]));  // i6_real = h2_real + (j*h6_real)
            i_imag[6] <= h_imag[2] + h_real[6];  // i6_imag = h2_imag + (j*h6_imag)
            i_real[7] <= h_real[3] - h7_prime_real_16;  // i7_real = h[3]_real - Re((W8^3)*h[7])
            i_imag[7] <= h_imag[3] - h7_prime_imag_16;  // i7_imag = h[3]_imag - Im((W8^3)*h[7])
            ready <= 1'b1;
          end
        endcase
				stage <= stage + 2'b01;
			end
			else begin
				if (write) begin
          i0_real<= in0_real;  i0_imag <= in0_imag;
          i1_real<= in1_real;  i1_imag <= in1_imag;
          i2_real<= in2_real;  i2_imag <= in2_imag;
          i3_real<= in3_real;  i3_imag <= in3_imag;
          i4_real<= in4_real;  i4_imag <= in4_imag;
          i5_real<= in5_real;  i5_imag <= in5_imag;
          i6_real<= in6_real;  i6_imag <= in6_imag;
          i7_real<= in7_real;  i7_imag <= in7_imag;
				end
				ready <= 1'b0;
			end
		end
	end

  assign out0_real = i_real[0]; assign out0_imag = i_imag[0];
  assign out1_real = i_real[1]; assign out1_imag = i_imag[1];
  assign out2_real = i_real[2]; assign out2_imag = i_imag[2];
  assign out3_real = i_real[3]; assign out3_imag = i_imag[3];
  assign out4_real = i_real[4]; assign out4_imag = i_imag[4];
  assign out5_real = i_real[5]; assign out5_imag = i_imag[5];
  assign out6_real = i_real[6]; assign out6_imag = i_imag[6];
  assign out7_real = i_real[7]; assign out7_imag = i_imag[7];

endmodule