`include "fft.v"
`timescale 1ns/1ps

module fft_tb();

	parameter CLOCK_PERIOD = 5; // 10 MHz clock

    reg sys_clk, sys_rst_n;
	reg write, start;

	reg signed [15:0]  in0_real  ,in0_imag;
	reg signed [15:0]  in1_real  ,in1_imag;
	reg signed [15:0]  in2_real  ,in2_imag;
	reg signed [15:0]  in3_real  ,in3_imag;
	reg signed [15:0]  in4_real  ,in4_imag;
	reg signed [15:0]  in5_real  ,in5_imag;
	reg signed [15:0]  in6_real  ,in6_imag;
	reg signed [15:0]  in7_real  ,in7_imag;
	wire ready;

	wire signed [15:0] out0_real ,out0_imag;
	wire signed [15:0] out1_real ,out1_imag;
	wire signed [15:0] out2_real ,out2_imag;
	wire signed [15:0] out3_real ,out3_imag;
	wire signed [15:0] out4_real ,out4_imag;
	wire signed [15:0] out5_real ,out5_imag;
	wire signed [15:0] out6_real ,out6_imag;
	wire signed [15:0] out7_real ,out7_imag;

	fft DUT(.CLK(sys_clk), .RST_N(sys_rst_n), .write(write), .start(start), .in0_real(in0_real) , .in0_imag(in0_imag), .in1_real(in1_real), .in1_imag(in1_imag), 
 .in2_real(in2_real)  ,.in2_imag(in2_imag), .in3_real(in3_real)  ,.in3_imag(in3_imag), .in4_real(in4_real)  ,.in4_imag(in4_imag), .in5_real(in5_real)  ,.in5_imag(in5_imag),
 .in6_real(in6_real)  ,.in6_imag(in6_imag), .in7_real(in7_real)  ,.in7_imag(in7_imag), .ready(ready), .out0_real(out0_real) ,.out0_imag(out0_imag), .out1_real(out1_real), 
 .out1_imag(out1_imag), .out2_real(out2_real) ,.out2_imag(out2_imag), .out3_real(out3_real) ,.out3_imag(out3_imag), .out4_real(out4_real) ,.out4_imag(out4_imag), 
 .out5_real(out5_real) ,.out5_imag(out5_imag), .out6_real(out6_real) ,.out6_imag(out6_imag), .out7_real(out7_real) ,.out7_imag(out7_imag));

	// VCD dump
	initial begin
		$dumpfile("fft.vcd");
		$dumpvars(0, DUT);
	end

	// System clock generator
	always begin
		#(CLOCK_PERIOD/2) sys_clk = ~sys_clk;
	end

    // Initial Condition
    initial begin
		sys_clk = 1'b0; sys_rst_n = 1'b0;
		write = 1'b0; start = 1'b0;
		in0_real=16'h00_00  ;in0_imag = 0;
		in1_real=16'h01_00  ;in1_imag = 0;
		in2_real=16'h02_00  ;in2_imag = 0;
		in3_real=16'h03_00  ;in3_imag = 0;
		in4_real=16'h04_00  ;in4_imag = 0;
		in5_real=16'h05_00  ;in5_imag = 0;
		in6_real=16'h06_00  ;in6_imag = 0;
		in7_real=16'h07_00  ;in7_imag = 0;
		#CLOCK_PERIOD sys_rst_n = 1'b1;
		#CLOCK_PERIOD write = 1'b1;
		#CLOCK_PERIOD start = 1'b1;
		#(CLOCK_PERIOD/2) $display("START OF SIMULATION (Time: %g ns)", $time);
		#10000;
		$finish;
	end

endmodule