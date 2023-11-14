`timescale 1ns/1ps

module fft_tb();

    reg sys_clk, sys_rst_n;
	reg en_a, en_b;
	reg write, start;

	wire [255:0] a, b;
	wire [256:0] s_out, s_golden;
	wire ready;

	// System clock generator
	always begin
		#(CLOCK_PERIOD/2) sys_clk = ~sys_clk;
	end

    // VCD dump
	initial begin
		$dumpfile("mpadd.vcd");
		$dumpvars(0, DUT);
	end

    // Initial Condition
    initial begin
    sys_clk = 1'b0; sys_rst_n = 1'b0;
    
    #CLOCK_PERIOD sys_rst_n = 1'b1;
    #(CLOCK_PERIOD/2) $display("START OF SIMULATION (Time: %g ns)", $time);
    end

endmodule