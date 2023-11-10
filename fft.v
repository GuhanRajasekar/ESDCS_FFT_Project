module stage1(
  input [15:0] x,
  input [15:0] y,
  input   flag,
  output reg[15:0] z
);
always@(x,y,flag)
    begin
    if (flag)
      z = x + y;
    else
      z = x - y;
    end
endmodule

module main(
  input [15:0] in0_real, input [15:0] in0_imag,
  input [15:0] in1_real, input [15:0] in1_imag,
  input [15:0] in2_real, input [15:0] in2_imag,
  input [15:0] in3_real, input [15:0] in3_imag,
  input [15:0] in4_real, input [15:0] in4_imag,
  input [15:0] in5_real, input [15:0] in5_imag,
  input [15:0] in6_real, input [15:0] in6_imag,
  input [15:0] in7_real, input [15:0] in7_imag
);
  wire [15:0] g_real [0:7];   // Declare g_real as an array of registers to store real part of stage 1 results
  wire [15:0] g_imag [0:7];   // Declare g_imag as an array of registers to store imag part of stage 1 results
  wire [15:0] h_real [0:7];   // Declare h_real as an array of registers to store real part of stage 2 results
  wire [15:0] h_imag [0:7];   // Declare h_imag as an array of registers to store imag part of stage 2 results
  wire [15:0] i_real [0:7];   // Declare i_real as an array of registers to store real part of stage 3 results
  wire [15:0] i_imag [0:7];   // Declare i_imag as an array of registers to store imag part of stage 3 results
         
  stage1 inst_g0_real (.x(in0_real) , .y(in4_real) , .flag(1) , .z(g_real[0]));    // g0_real = in0_real + in4_real
  stage1 inst_g0_imag (.x(in0_imag) , .y(in4_imag) , .flag(1) , .z(g_imag[0]));    // g0_imag = in0_imag + in4_imag
  stage1 inst_g1_real (.x(in0_real) , .y(in4_real) , .flag(0) , .z(g_real[1]));    // g1_real = in0_real - in4_real
  stage1 inst_g1_imag (.x(in0_imag) , .y(in4_imag) , .flag(0) , .z(g_imag[1]));    // g1_imag = in0_imag - in4_imag
  stage1 inst_g2_real (.x(in2_real) , .y(in6_real) , .flag(1) , .z(g_real[2]));    // g2_real = in2_real + in6_real
  stage1 inst_g2_imag (.x(in2_imag) , .y(in6_imag) , .flag(1) , .z(g_imag[2]));    // g2_imag = in2_imag + in6_imag
  stage1 inst_g3_real (.x(in2_real) , .y(in6_real) , .flag(0) , .z(g_real[3]));    // g3_real = in2_real - in6_real
  stage1 inst_g3_imag (.x(in2_imag) , .y(in6_imag) , .flag(0) , .z(g_imag[3]));    // g3_imag = in2_imag - in6_imag
  stage1 inst_g4_real (.x(in1_real) , .y(in5_real) , .flag(1) , .z(g_real[4]));    // g4_real = in1_real + in5_real
  stage1 inst_g4_imag (.x(in1_imag) , .y(in5_imag) , .flag(1) , .z(g_imag[4]));    // g4_imag = in1_imag + in5_imag
  stage1 inst_g5_real (.x(in1_real) , .y(in5_real) , .flag(0) , .z(g_real[5]));    // g5_real = in1_real - in5_real
  stage1 inst_g5_imag (.x(in1_imag) , .y(in5_imag) , .flag(0) , .z(g_imag[5]));    // g5_imag = in1_imag - in5_imag
  stage1 inst_g6_real (.x(in3_real) , .y(in7_real) , .flag(1) , .z(g_real[6]));    // g6_real = in3_real + in7_real
  stage1 inst_g6_imag (.x(in3_imag) , .y(in7_imag) , .flag(1) , .z(g_imag[6]));    // g6_imag = in3_imag + in7_imag
  stage1 inst_g7_real (.x(in3_real) , .y(in7_real) , .flag(0) , .z(g_real[7]));    // g7_real = in3_real - in7_real
  stage1 inst_g7_imag (.x(in3_imag) , .y(in7_imag) , .flag(0) , .z(g_imag[7]));    // g7_imag = in3_imag - in7_imag

  
  stage1 inst_h0_real (.x(g_real[0]), .y(g_real[2]),    .flag(1), .z(h_real[0]));  // h0_real = g0_real + g2_real
  stage1 inst_h0_imag (.x(g_imag[0]), .y(g_imag[2]),    .flag(1), .z(h_imag[0]));  // h0_imag = g0_imag + g2_imag
  stage1 inst_h1_real (.x(g_real[1]), .y(-(g_imag[3])), .flag(0), .z(h_real[1]));  // h1_real = g1_real - (j*g3_real)  
  stage1 inst_h1_imag (.x(g_imag[1]), .y(g_real[3]),    .flag(0), .z(h_imag[1]));  // h1_imag = g1_imag - (j*g3_imag)
  stage1 inst_h2_real (.x(g_real[0]), .y(g_real[2]),    .flag(0), .z(h_real[2]));  // h2_real = g0_real - g2_real
  stage1 inst_h2_imag (.x(g_imag[0]), .y(g_imag[2]),    .flag(0), .z(h_imag[2]));  // h2_imag = g0_imag - g2_imag
  stage1 inst_h3_real (.x(g_real[1]), .y(-(g_imag[3])), .flag(1), .z(h_real[3]));  // h3_real = g1_real + (j*g3_real)
  stage1 inst_h3_imag (.x(g_imag[1]), .y(g_real[3]),    .flag(1), .z(h_imag[3]));  // h3_imag = g1_imag + (j*g3_imag)
  stage1 inst_h4_real (.x(g_real[4]), .y(g_real[6]),    .flag(1), .z(h_real[4]));  // h4_real = g4_real + g6_real
  stage1 inst_h4_imag (.x(g_imag[4]), .y(g_imag[6]),    .flag(1), .z(h_imag[4]));  // h4_imag = g4_imag + g6_imag
  stage1 inst_h5_real (.x(g_real[5]), .y(-(g_imag[7])), .flag(0), .z(h_real[5]));  // h5_real = g5_real - (j*g7_real)
  stage1 inst_h5_imag (.x(g_imag[5]), .y(g_real[7]),    .flag(0), .z(h_imag[5]));  // h5_imag = g5_imag - (j*g7_imag)
  stage1 inst_h6_real (.x(g_real[4]), .y(g_real[6]),    .flag(0), .z(h_real[6]));  // h6_real = g4_real - g6_real
  stage1 inst_h6_imag (.x(g_imag[4]), .y(g_imag[6]),    .flag(0), .z(h_imag[6]));  // h6_imag = g4_imag - g6_imag
  stage1 inst_h7_real (.x(g_real[5]), .y(-(g_imag[7])), .flag(1), .z(h_real[7]));  // h7_real = g5_real + (j*g7_real)
  stage1 inst_h7_imag (.x(g_imag[5]), .y(g_real[7]),    .flag(1), .z(h_imag[7]));  // h7_imag = g5_imag + (j*g7_imag)

  stage1 inst_i0_real (.x(h_real[0]), .y(h_real[4]),    .flag(1), .z(i_real[0]));  // i0_real = h0_real + h4_real
  stage1 inst_i0_imag (.x(h_imag[0]), .y(h_imag[4]),    .flag(1), .z(i_imag[0]));  // i0_imag = h0_imag + h4_imag
  stage1 inst_i2_real (.x(h_real[2]), .y(-(h_imag[6])), .flag(0), .z(i_real[2]));  // i2_real = h2_real - (j*h6_real)
  stage1 inst_i2_imag (.x(h_imag[2]), .y(h_real[6]),    .flag(0), .z(i_imag[2]));  // i2_imag = h2_imag - (j*h6_imag) 
  stage1 inst_i4_real (.x(h_real[0]), .y(h_real[4]),    .flag(0), .z(i_real[4]));  // i4_real = h0_real - h4_real
  stage1 inst_i4_imag (.x(h_imag[0]), .y(h_imag[4]),    .flag(0), .z(i_imag[4]));  // i4_imag = h0_imag - h4_imag
  stage1 inst_i6_real (.x(h_real[2]), .y(-(h_imag[6])), .flag(1), .z(i_real[6]));  // i6_real = h2_real + (j*h6_real)
  stage1 inst_i6_imag (.x(h_imag[2]), .y(h_real[6]),    .flag(1), .z(i_imag[6]));  // i6_imag = h2_imag + (j*h6_imag)

endmodule