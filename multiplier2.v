// file to practise multiplication in verilog
module multiplier(
    input [15:0] b_real, 
    input [15:0] b_imag,
    input flag,
    output wire [15:0] result_real,
    output wire [15:0] result_imag
);
    reg [15:0] result_1     ; reg[15:0] result_2; reg[15:0] result_3; reg[15:0] result_4;
    reg [31:0] result_real_temp ; reg[31:0] result_imag_temp;
    reg  [31:0] result_temp;
    always@(flag)
      begin 
        if(flag)
          begin
            assign result_1    = b_imag + b_real;
            assign result_2    = b_imag - b_real;
            if(result_1[15] == 1'b1)
              begin
                assign result_1 = -(result_1);
                assign result_real_temp = 16'b0000000010110100 * (result_1);
                assign result_real_temp = -(result_real_temp);
              end
            else
              begin
                assign result_real_temp = 16'b0000000010110100 * (result_1);
              end
            if(result_2[15] == 1'b1)
              begin
                assign result_2 = -(result_2);
                assign result_imag_temp = 16'b0000000010110100 * (result_2);
                assign result_imag_temp = -(result_imag_temp);
              end
            else
              begin
                assign result_imag_temp = 16'b0000000010110100 * (result_2);
              end
          end
        
        
        else // flag = 0
         begin
         assign result_1    =  b_imag - b_real;
         assign result_2    = -(b_imag + b_real);
            if(result_1[15] == 1'b1)
              begin
                assign result_1 = -(result_1);
                assign result_real_temp = 16'b0000000010110100 * (result_1);
                assign result_real_temp = -(result_real_temp);
              end
            else
              begin
                assign result_real_temp = 16'b0000000010110100 * (result_1);
              end
            if(result_2[15] == 1'b1)
              begin
                assign result_2 = -(result_2);
                assign result_imag_temp = 16'b0000000010110100 * (result_2);
                assign result_imag_temp = -(result_imag_temp);
              end
            else
              begin
                assign result_imag_temp = 16'b0000000010110100 * (result_2);
              end
          end

      end
    assign result_real      = result_real_temp[23:8];
    assign result_imag      = result_imag_temp[23:8]; 
endmodule
