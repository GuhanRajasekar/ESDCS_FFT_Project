# PROGRAM TO VERIFY THE OUTPUT OF VERILOG CODE

import numpy as np

# Create an array of 8 complex points
data = np.array([0,1,2,3,4,5,6,7])

# Calculate the FFT
fft_result = np.fft.fft(data)

# Print the result
print("Original data:")
print(data)
print("\nFFT result:")
print(fft_result)
