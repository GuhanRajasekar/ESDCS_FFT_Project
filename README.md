# ESDCS_FFT_Project
Project for the partial grading of Course: Efficient and Secure Digital Systems

## Project Objectives
1. Design a digital circuit for Fast Fourier Transform (FFT) in Verilog
2. Create an appropriate test bench in Verilog to test the design
3. Simulate the design using Icarus Verilog and visualize the simulated VCD waveforms using GTKWave to verify functionality
4. Synthesize the design using Yosys with the Nangate Open Cell 45nm standard cell library in the typical TT corner
5. Analyze timing and power of the implementation using OpenSTA

## Project Statement

- Input 𝑥 = {𝑥0, 𝑥1, ⋯ , 𝑥7}
- Output 𝑋 = {𝑋0, 𝑋1, ⋯ , 𝑋7}
- Output 𝑋 is the 8-point FFT of input x
- Each input element 𝑥𝑚 (for 𝑚 = 0,1, … , 7 ) is a complex number with real and imaginary parts each represented as a signed 16-bit fixed point quantity with 1 sign bit, 7 bits for decimal part and 8 bits for fractional part
- Each output element 𝑋𝑘 (for 𝑘 = 0,1, … , 7 ) is a complex number with real and imaginary parts each represented as a signed 16-bit fixed-point quantity with 1 sign bit, 7 bits for decimal part and 8 bits for fractional part
- Additional Signals
    - |CLK |Input| Clock| signal|
      |----|-----|------|-------|
      | RST_N | Input | Active-low | reset signal |
      | write | Input | Input | write signal |
      | start | Input | FFT computation | start signal |
      | ready | Output | FFT computation | done signa  |
