import numpy as np

quant_matrix = np.array([
    [16, 11, 10, 16, 24, 40, 51, 61],
    [12, 12, 14, 19, 26, 58, 60, 55],
    [14, 13, 16, 24, 40, 57, 69, 56],
    [14, 17, 22, 29, 51, 87, 80, 62],
    [18, 22, 37, 56, 68,109,103, 77],
    [24, 35, 55, 64, 81,104,113, 92],
    [49, 64, 78, 87,103,121,120,101],
    [72, 92, 95, 98,112,100,103, 99]
])

def quantize_dct(dct_matrix, q_matrix=quant_matrix):
    
    dct = np.array(dct_matrix)
    quantized = np.round(dct / q_matrix).astype(int)
    
    return quantized

# # Define the quantization matrix as a plain list of lists
# quant_matrix = [
#     [16, 11, 10, 16, 24, 40, 51, 61],
#     [12, 12, 14, 19, 26, 58, 60, 55],
#     [14, 13, 16, 24, 40, 57, 69, 56],
#     [14, 17, 22, 29, 51, 87, 80, 62],
#     [18, 22, 37, 56, 68,109,103, 77],
#     [24, 35, 55, 64, 81,104,113, 92],
#     [49, 64, 78, 87,103,121,120,101],
#     [72, 92, 95, 98,112,100,103, 99]
# ]

# def quantize_dct(dct_matrix, q_matrix=quant_matrix):
#     rows = len(dct_matrix)
#     cols = len(dct_matrix[0])
#     quantized = [[0 for _ in range(cols)] for _ in range(rows)]

#     for i in range(rows):
#         for j in range(cols):
#             num = dct_matrix[i][j]
#             den = q_matrix[i][j]
#             # integer division with rounding
#             if num >= 0:
#                 quantized[i][j] = int((num + den/2) // den)
#             else:
#                 quantized[i][j] = int((num - den/2) // den)
#     return quantized