# from PIL import Image
# import numpy as np
# import os

# img = Image.open("test.jpg").convert("RGB")
# img_np = np.array(img)

# red_flat   = img_np[:, :, 0].T.flatten()
# green_flat = img_np[:, :, 1].T.flatten()
# blue_flat  = img_np[:, :, 2].T.flatten()

# np.savetxt("red_channel.txt", red_flat, fmt="%d")
# np.savetxt("green_channel.txt", green_flat, fmt="%d")
# np.savetxt("blue_channel.txt", blue_flat, fmt="%d")

# print("Files saved to:", os.getcwd())

import math

m = 8
n = 8
scale = 32768  # for 16-bit signed fixed-point

print("constant COS_X : cos_matrix := (")
for i in range(m):
    row = []
    for x in range(n):
        val = math.cos((2*x + 1) * i * math.pi / (2*m))
        row.append(f"to_signed({int(val*scale)}, 16)")
    print(f"    {i} => ({', '.join(row)}),")
print(");")
