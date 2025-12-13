ZIGZAG_INDEX = [
    0,  1,  5,  6, 14, 15, 27, 28,
    2,  4,  7, 13, 16, 26, 29, 42,
    3,  8, 12, 17, 25, 30, 41, 43,
    9, 11, 18, 24, 31, 40, 44, 53,
   10, 19, 23, 32, 39, 45, 52, 54,
   20, 22, 33, 38, 46, 51, 55, 60,
   21, 34, 37, 47, 50, 56, 59, 61,
   35, 36, 48, 49, 57, 58, 62, 63
]

def zizag_ordering(block):
    """
    Block: 8x8 list of lists
    returns: list of 64 values in zigzag order
    """
    out = [0] * 64
    
    for k in range(64):
        index = ZIGZAG_INDEX[k]
        row = index // 8
        col = index % 8
        out[k] = block[row][col]
        
    return out

def inverse_zigzag_ordering(vector):
    """
    vector: list of 64 values
    returns: 8x8 list of lists
    """
    block = [[0 for _ in range(8)] for _ in range(8)]
    
    for k in range(64):
        index = ZIGZAG_INDEX[k]
        row = index // 8
        col = index % 8
        block[row][col] = vector[k]
        
    return block