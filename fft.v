module stage1(input reg[15:0] x,y;

              input flag;

              output reg [15:0] z);

              

  if(flag == 1)   // flag 1 => indicates addition of two 16 bit registers

    begin

      z = x+y;

    end

  else

    begin

      z = x-y;

    end



endmodule





module main();

    reg [15:0] g_real[0:7];   // to store the real part of Stage 0 results

    reg [15:0] g_imag[0:7];   // to store the imaginary part of Stage 0 results

    

    always@*

      begin

         stage1 inst_stage1 (.x(in0_real) , .y(in4_real) , .flag(1) , g_real[0]);    // g0_real = in0_real + in4_real

         stage1 inst_stage2 (.x(in0_imag) , .y(in4_imag) , .flag(1) , g_imag[0]);    // g0_imag = in0_imag + in4_imag

         

         stage1 inst_stage3 (.x(in0_real) , .y(in4_real) , .flag(0) , g_real[1]);    // g1_real = in0_real - in4_real

         stage1 inst_stage4 (.x(in0_real) , .y(in4_real) , .flag(0) , g_imag[1]);    // g1_imag = in0_imag - in4_imag

         

         stage1 inst_stage5 (.x(in2_real) , .y(in6_real) , .flag(1) , g_real[2]);    // g2_real = in2_real + in6_real

         stage1 inst_stage6 (.x(in2_imag) , .y(in6_imag) , .flag(1) , g_imag[2]);    // g2_imag = in2_imag + in6_imag

         

         stage1 inst_stage7 (.x(in2_real) , .y(in6_real) , .flag(0) , g_real[3]);    // g3_real = in2_real - in6_real

         stage1 inst_stage8 (.x(in2_imag) , .y(in6_imag) , .flag(0) , g_imag[3]);    // g3_imag = in2_imag - in6_imag

         

         stage1 inst_stage9 (.x(in1_real) , .y(in5_real) , .flag(1) , g_real[4]);    // g4_real = in1_real + in5_real

         stage1 inst_stage10(.x(in1_imag) , .y(in5_imag) , .flag(1) , g_imag[4]);    // g4_imag = in1_imag + in5_imag

         

         stage1 inst_stage11(.x(in1_real) , .y(in5_real) , .flag(0) , g_real[5]);    // g5_real = in1_real - in5_real

         stage1 inst_stage12(.x(in1_imag) , .y(in5_imag) , .flag(0) , g_imag[5]);    // g5_imag = in1_imag - in5_imag

         

         stage1 inst_stage13(.x(in3_real) , .y(in7_real) , .flag(1) , g_real[6]);    // g6_real = in3_real + in7_real

         stage1 inst_stage14(.x(in3_imag) , .y(in7_imag) , .flag(1) , g_imag[6]);    // g6_imag = in3_imag + in7_imag

         

         stage1 inst_stage15(.x(in3_real) , .y(in7_real) , .flag(0) , g_real[7]);    // g7_real = in3_real - in7_real

         stage1 inst_stage16(.x(in3_imag) , .y(in7_imag) , .flag(0) , g_imag[7]);    // g7_imag = in3_imag - in7_imag

      end

endmodule

              