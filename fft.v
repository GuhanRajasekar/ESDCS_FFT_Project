module main(
  input [15:0]  in0_real  , input [15:0] in0_imag,
  input [15:0]  in1_real  , input [15:0] in1_imag,
  input [15:0]  in2_real  , input [15:0] in2_imag,
  input [15:0]  in3_real  , input [15:0] in3_imag,
  input [15:0]  in4_real  , input [15:0] in4_imag,
  input [15:0]  in5_real  , input [15:0] in5_imag,
  input [15:0]  in6_real  , input [15:0] in6_imag,
  input [15:0]  in7_real  , input [15:0] in7_imag,
  output [15:0] out0_real , output [15:0] out0_imag,
  output [15:0] out1_real , output [15:0] out1_imag,
  output [15:0] out2_real , output [15:0] out2_imag,
  output [15:0] out3_real , output [15:0] out3_imag,
  output [15:0] out4_real , output [15:0] out4_imag,
  output [15:0] out5_real , output [15:0] out5_imag,
  output [15:0] out6_real , output [15:0] out6_imag,
  output [15:0] out7_real , output [15:0] out7_imag
);
  reg [15:0] g_real [0:7];   // Declare g_real as an array of registers to store real part of stage 1 results
  reg [15:0] g_imag [0:7];   // Declare g_imag as an array of registers to store imag part of stage 1 results
  reg [15:0] h_real [0:7];   // Declare h_real as an array of registers to store real part of stage 2 results
  reg [15:0] h_imag [0:7];   // Declare h_imag as an array of registers to store imag part of stage 2 results
  reg [15:0] i_real [0:7];   // Declare i_real as an array of registers to store real part of stage 3 results
  reg [15:0] i_imag [0:7];   // Declare i_imag as an array of registers to store imag part of stage 3 results

  reg [15:0] temp1,temp2,temp3,temp4;
  reg [31:0] h5_prime_real;  // 32 bit register to store real part of h[5] * (W8 ^ 1)
  reg [31:0] h5_prime_imag;  // 32 bit register to store imag part of h[5] * (W8 ^ 1)
  reg [31:0] h7_prime_real;  // 32 bit register to store real part of h[7] * (W8 ^ 3)
  reg [31:0] h7_prime_imag;  // 32 bit register to store imag part of h[7] * (W8 ^ 3)

  reg [15:0] h5_prime_real_16;  // 16 bit register to store real part of h[5] * (W8 ^ 1)
  reg [15:0] h5_prime_imag_16;  // 16 bit register to store imag part of h[5] * (W8 ^ 1)
  reg [15:0] h7_prime_real_16;  // 16 bit register to store real part of h[7] * (W8 ^ 3)
  reg [15:0] h7_prime_imag_16;  // 16 bit register to store imag part of h[7] * (W8 ^ 3)

  assign out0_real = i_real[0]; assign out0_imag = i_imag[0];
  assign out1_real = i_real[0]; assign out1_imag = i_imag[0];
  assign out2_real = i_real[0]; assign out2_imag = i_imag[0];
  assign out3_real = i_real[0]; assign out3_imag = i_imag[0];
  assign out4_real = i_real[0]; assign out4_imag = i_imag[0];
  assign out5_real = i_real[0]; assign out5_imag = i_imag[0];
  assign out6_real = i_real[0]; assign out6_imag = i_imag[0];
  assign out7_real = i_real[0]; assign out7_imag = i_imag[0];

  always
    begin
      g_real[0] = in0_real + in4_real;
      g_imag[0] = in0_imag + in4_imag;
      g_real[1] = in0_real - in4_real;
      g_imag[1] = in0_imag - in4_imag;
      g_real[2] = in2_real + in6_real;
      g_imag[2] = in2_imag + in6_imag;
      g_real[3] = in2_real - in6_real;
      g_imag[3] = in2_imag - in6_imag;
      g_real[4] = in1_real + in5_real;
      g_imag[4] = in1_imag + in5_imag;
      g_real[5] = in1_real - in5_real;
      g_imag[5] = in1_imag - in5_imag;
      g_real[6] = in3_real + in7_real;
      g_imag[6] = in3_imag + in7_imag;
      g_real[7] = in3_real - in7_real;
      g_imag[7] = in3_imag - in7_imag ;     
      
      h_real[0] = g_real[0] + g_real[2];        // h0_real = g0_real + g2_real
      h_imag[0] = g_imag[0] + g_imag[2];        // h0_imag = g0_imag + g2_imag
      h_real[1] = g_real[1] - (-(g_imag[3]));   // h1_real = g1_real - (j*g3_real)  
      h_imag[1] = g_imag[1] - g_real[3];        // h1_imag = g1_imag - (j*g3_imag)
      h_real[2] = g_real[0] - g_real[2];        // h2_real = g0_real - g2_real
      h_imag[2] = g_imag[0] - g_imag[2];        // h2_imag = g0_imag - g2_imag
      h_real[3] = g_real[1] + (-(g_imag[3]));   // h3_real = g1_real + (j*g3_real)
      h_imag[3] = g_imag[1] + g_real[3];        // h3_imag = g1_imag + (j*g3_imag)
      h_real[4] = g_real[4] + g_real[6];        // h4_real = g4_real + g6_real
      h_imag[4] = g_imag[4] + g_imag[6];        // h4_imag = g4_imag + g6_imag
      h_real[5] = g_real[5] - (-(g_imag[7]));   // h5_real = g5_real - (j*g7_real)
      h_imag[5] = g_imag[5] - g_real[7];        // h5_imag = g5_imag - (j*g7_imag)
      h_real[6] = g_real[4] - g_real[6];        // h6_real = g4_real - g6_real
      h_imag[6] = g_imag[4] - g_imag[6];        // h6_imag = g4_imag - g6_imag
      h_real[7] = g_real[5] + (-(g_imag[7]));   // h7_real = g5_real + (j*g7_real)
      h_imag[7] = g_imag[5] + g_real[7];        // h7_imag = g5_imag + (j*g7_imag)

      temp1 = h_real[5] + h_imag[5];
      temp2 = h_imag[5] - h_real[5];
      temp3 = h_imag[7] - h_real[7];
      temp4 = -(h_imag[7] + h_real[7]);
      

          if(temp1[15] == 1'b1)
            begin
              temp1 = -(temp1);
              h5_prime_real = temp1 * 16'b0000000010110100;
              h5_prime_real = -(h5_prime_real);
            end
          else
            begin
              h5_prime_real = temp1 * 16'b0000000010110100;
            end
              h5_prime_real_16 = h5_prime_real[23:8];
          
          if(temp2[15] == 1'b1)
            begin
              temp2 = -(temp2);
              h5_prime_imag = temp2 * 16'b0000000010110100;
              h5_prime_imag = -(h5_prime_imag);
            end
          else
            begin
              h5_prime_imag = temp2 * 16'b0000000010110100;
            end
              h5_prime_imag_16 = h5_prime_imag[23:8];
          
          if(temp3[15] == 1'b1)
            begin
              temp3 = -(temp3);
              h7_prime_real = temp3 * 16'b0000000010110100;
              h7_prime_real = -(h7_prime_real);
            end
          else
            begin
              h7_prime_real = temp3 * 16'b0000000010110100;
            end
              h7_prime_real_16 = h7_prime_real[23:8];
          
          if(temp4[15] == 1'b1)
            begin
              temp4 = -(temp4);
              h7_prime_imag = temp4 * 16'b0000000010110100;
              h7_prime_imag = -(h7_prime_imag);
            end
          else
            begin
              h7_prime_imag = temp4 * 16'b0000000010110100;
            end
              h7_prime_imag_16 = h7_prime_imag[23:8];
      
      i_real[0] = h_real[0] + h_real[4];  // i0_real = h0_real + h4_real
      i_imag[0] = h_imag[0] + h_imag[4];  // i0_imag = h0_imag + h4_imag
      i_real[1] = h_real[1] + h5_prime_real_16;  // i1_real = h[1]_real + Re((W8 ^ 1)*h[5])
      i_imag[1] = h_imag[1] + h5_prime_imag_16;  // i1_imag = h[1]_imag + Im((W8 ^ 1)*h[5])
      i_real[2] = h_real[2] - (-(h_imag[6]));  // i2_real = h2_real - (j*h6_real)
      i_imag[2] = h_imag[2] - h_real[6];  // i2_imag = h2_imag - (j*h6_imag)
      i_real[3] = h_real[3] + h7_prime_real_16;  // i3_real = h[3]_real + Re((W8^3)*h[7])
      i_imag[3] = h_imag[3] + h7_prime_imag_16;  // i3_imag = h[3]_imag + Im((W8^3)*h[7]) 
      i_real[4] = h_real[0] - h_real[4];  // i4_real = h0_real - h4_real
      i_imag[4] = h_imag[0] - h_imag[4];  // i4_imag = h0_imag - h4_imag
      i_real[5] = h_real[1] - h5_prime_real_16;  // i5_real = h[1]_real - Re((W8^1)*h[5])
      i_imag[5] = h_imag[1] - h5_prime_imag_16;  // i5_imag = h[1]_imag - Im((W8^1)*h[5])
      i_real[6] = h_real[2] + (-(h_imag[6]));  // i6_real = h2_real + (j*h6_real)
      i_imag[6] = h_imag[2] + h_real[6];  // i6_imag = h2_imag + (j*h6_imag)
      i_real[7] = h_real[3] - h7_prime_real_16;  // i7_real = h[3]_real - Re((W8^3)*h[7])
      i_imag[7] = h_imag[3] - h7_prime_imag_16;  // i7_imag = h[3]_imag - Im((W8^3)*h[7])

    end


endmodule