// stage1 module  performs addition if flag = 1 and subtraction if flag = 0
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

module multiplier(
    input [15:0] b_real, 
    input [15:0] b_imag,
    input flag,
    output wire [15:0] result_real,
    output wire [15:0] result_imag
);
    reg [15:0] result_1         ; reg[15:0] result_2;
    reg [31:0] result_real_temp ; reg[31:0] result_imag_temp;
    reg  [31:0] result_temp;
    always@(flag)
      begin 
        if(flag) // flag 1 => multiplication with W8^1 = 0.707 - j0.707
          begin
            result_1    = b_imag + b_real;
            result_2    = b_imag - b_real;
            if(result_1[15] == 1'b1)
              begin
                result_1 = -(result_1);
                result_real_temp = 16'b0000000010110100 * (result_1);
                result_real_temp = -(result_real_temp);
              end
            else
              begin
                result_real_temp = 16'b0000000010110100 * (result_1);
              end
            if(result_2[15] == 1'b1)
              begin
                result_2 = -(result_2);
                result_imag_temp = 16'b0000000010110100 * (result_2);
                result_imag_temp = -(result_imag_temp);
              end
            else
              begin
                result_imag_temp = 16'b0000000010110100 * (result_2);
              end
          end
        
        
        else // flag 0 => multiplication with W8^3 = -(0.707 + j0.707)
         begin
         result_1    =  b_imag - b_real;
         result_2    = -(b_imag + b_real);
            if(result_1[15] == 1'b1)
              begin
                result_1 = -(result_1);
                result_real_temp = 16'b0000000010110100 * (result_1);
                result_real_temp = -(result_real_temp);

              end
            else
              begin
                result_real_temp = 16'b0000000010110100 * (result_1);
              end
            if(result_2[15] == 1'b1)
              begin
                result_2 = -(result_2);
                result_imag_temp = 16'b0000000010110100 * (result_2);
                result_imag_temp = -(result_imag_temp);
              end
            else
              begin
                result_imag_temp = 16'b0000000010110100 * (result_2);
              end
          end

      end
    assign result_real      = result_real_temp[23:8];
    assign result_imag      = result_imag_temp[23:8]; 
endmodule

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
  output [15:0] out7_real , output [15:0] out6_imag,
);
  wire [15:0] g_real [0:7];   // Declare g_real as an array of registers to store real part of stage 1 results
  wire [15:0] g_imag [0:7];   // Declare g_imag as an array of registers to store imag part of stage 1 results
  wire [15:0] h_real [0:7];   // Declare h_real as an array of registers to store real part of stage 2 results
  wire [15:0] h_imag [0:7];   // Declare h_imag as an array of registers to store imag part of stage 2 results
  wire [15:0] i_real [0:7];   // Declare i_real as an array of registers to store real part of stage 3 results
  wire [15:0] i_imag [0:7];   // Declare i_imag as an array of registers to store imag part of stage 3 results

  wire [15:0] h5_prime_real;  // to store real part of h[5] * (W8 ^ 1)
  wire [15:0] h5_prime_imag;  // to store imag part of h[5] * (W8 ^ 1)
  wire [15:0] h7_prime_real;  // to store real part of h[7] * (W8 ^ 3)
  wire [15:0] h7_prime_imag;  // to store imag part of h[7] * (W8 ^ 3)
         
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

  multiplier m1(.b_real(h_real[5]) , .b_imag(h_imag[5]) , .flag(1) , .result_real(h5_prime_real) , .result_imag(h5_prime_imag));  // h[5]_prime =  h[5] * (W8 ^ 1)
  multiplier m2(.b_real(h_real[7]) , .b_imag(h_imag[7]) , .flag(0) , .result_real(h7_prime_real) , .result_imag(h7_prime_imag));  // h[7]_prime =  h[7] * (W8 ^ 3)

  stage1 inst_i0_real (.x(h_real[0]), .y(h_real[4]),     .flag(1), .z(i_real[0]));  // i0_real = h0_real + h4_real
  stage1 inst_i0_imag (.x(h_imag[0]), .y(h_imag[4]),     .flag(1), .z(i_imag[0]));  // i0_imag = h0_imag + h4_imag
  stage1 inst_i1_real (.x(h_real[1]), .y(h5_prime_real), .flag(1), .z(i_real[1]));  // i1_real = h[1]_real + Re((W8 ^ 1)*h[5])
  stage1 inst_i1_imag (.x(h_imag[1]), .y(h5_prime_imag), .flag(1), .z(i_imag[1]));  // i1_imag = h[1]_imag + Im((W8 ^ 1)*h[5])
  stage1 inst_i2_real (.x(h_real[2]), .y(-(h_imag[6])),  .flag(0), .z(i_real[2]));  // i2_real = h2_real - (j*h6_real)
  stage1 inst_i2_imag (.x(h_imag[2]), .y(h_real[6]),     .flag(0), .z(i_imag[2]));  // i2_imag = h2_imag - (j*h6_imag)
  stage1 inst_i3_real (.x(h_real[3]), .y(h7_prime_real), .flag(1), .z(i_real[3]));  // i3_real = h[3]_real + Re((W8^3)*h[7])
  stage1 inst_i3_imag (.x(h_imag[3]), .y(h7_prime_imag), .flag(1), .z(i_imag[3]));  // i3_imag = h[3]_imag + Im((W8^3)*h[7])  
  stage1 inst_i4_real (.x(h_real[0]), .y(h_real[4]),     .flag(0), .z(i_real[4]));  // i4_real = h0_real - h4_real
  stage1 inst_i4_imag (.x(h_imag[0]), .y(h_imag[4]),     .flag(0), .z(i_imag[4]));  // i4_imag = h0_imag - h4_imag
  stage1 inst_i5_real (.x(h_real[1]), .y(h5_prime_real), .flag(0), .z(i_real[5]));  // i5_real = h[1]_real - Re((W8^1)*h[5])
  stage1 inst_i5_imag (.x(h_imag[1]), .y(h5_prime_imag), .flag(0), .z(i_imag[5]));  // i5_imag = h[1]_imag - Im((W8^1)*h[5])
  stage1 inst_i6_real (.x(h_real[2]), .y(-(h_imag[6])),  .flag(1), .z(i_real[6]));  // i6_real = h2_real + (j*h6_real)
  stage1 inst_i6_imag (.x(h_imag[2]), .y(h_real[6]),     .flag(1), .z(i_imag[6]));  // i6_imag = h2_imag + (j*h6_imag)
  stage1 inst_i7_real (.x(h_real[3]), .y(h7_prime_real), .flag(0), .z(i_real[7]));  // i7_real = h[3]_real - Re((W8^3)*h[7])
  stage1 inst_i7_imag (.x(h_imag[3]), .y(h7_prime_imag), .flag(0), .z(i_imag[7]));  // i7_imag = h[3]_imag - Im((W8^3)*h[7])

  // Final step is store the values from the wires to register variables

  always@*
   begin
     out0_real = i_real[0]; out0_imag = i_imag[0];
     out1_real = i_real[0]; out1_imag = i_imag[0];
     out2_real = i_real[0]; out2_imag = i_imag[0];
     out3_real = i_real[0]; out3_imag = i_imag[0];
     out4_real = i_real[0]; out4_imag = i_imag[0];
     out5_real = i_real[0]; out5_imag = i_imag[0];
     out6_real = i_real[0]; out6_imag = i_imag[0];
     out7_real = i_real[0]; out7_imag = i_imag[0];
   end



endmodule