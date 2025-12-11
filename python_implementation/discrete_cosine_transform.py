import math
from math import pi

m = 8
n = 8

cos_x = [[math.cos((2 * x + 1) * i * pi / (2 * m)) for x in range(m)] for i in range(m)]
cos_y = [[math.cos((2 * y + 1) * j * pi / (2 * n)) for y in range(n)] for j in range(n)]

def dctTransform(matrix):
    
    dct = []
    for i in range(m):
        dct.append([None for _ in range(n)])
    
    for i in range(m):
        for j in range(n):
            
            ci = (1 / math.sqrt(m)) if i == 0 else math.sqrt(2 / m)
            cj = (1 / math.sqrt(n)) if j == 0 else math.sqrt(2 / n)

            s = 0.0
            for x in range(m):
                for y in range(n):
                    
                    dct1 = matrix[x][y] * cos_x[i][x] * cos_y[j][y]
                    s = s + dct1
                    
            dct[i][j] = ci * cj * s
            
    
    return dct

for i in range(8):
    print(f"constant COS_X_ROW_{i} : cos_array := (", end="")
    print(", ".join(f"{cos_x[i][x]:.8f}" for x in range(8)), end=");\n")


# m & n is always 8, pi is constant as well as ci, cj, x and y. Create a dct matrix using the cosine matrix
