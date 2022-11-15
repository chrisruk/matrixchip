#!/usr/bin/python3

"""
    Simple binary font
"""

# Zero
zero = [[0, 0, 0, 1, 1, 0, 0, 0],
        [0, 0, 1, 0, 0, 1, 0, 0],
        [0, 1, 1, 0, 0, 1, 1, 0],
        [0, 0, 1, 0, 0, 1, 0, 0],
        [0, 0, 0, 1, 1, 0, 0, 0]]

# One
one =  [[0, 0, 0, 1, 1, 0, 0, 0],
        [0, 0, 1, 0, 1, 0, 0, 0],
        [0, 0, 0, 0, 1, 0, 0, 0],
        [0, 0, 0, 0, 1, 0, 0, 0],
        [0, 0, 1, 1, 1, 1, 1, 0]]

def verilog(data, digit):
    rowvalues = []
    for row in data:
        rowsum = 0
        for i, bindigit in enumerate(row[::-1]):
            rowsum += bindigit * (2**i)
        rowvalues += [f"{rowsum:02x}"]
    rowvalueshex = "_".join(rowvalues)     
    return f"fonts[{digit}] <= {len(data)*8}'h{rowvalueshex}; // {digit}"

print(verilog(zero, 0))
print(verilog(one, 1))
