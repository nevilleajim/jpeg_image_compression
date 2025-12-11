from color_space_conversion import rgb_to_YCbCr_converter, YCbCr_to_rgb_converter
import numpy as np
from PIL import Image
from discrete_cosine_transform import dctTransform
from quantization import quantize_dct


img = Image.open("test.jpg").convert("RGB")
rgb_array = np.array(img)

# YCbCr color Conversion
h, w, _ = rgb_array.shape
ycbcr_array = np.zeros_like(rgb_array)

for i in range(h):
    for j in range(w):
        r, g, b = rgb_array[i, j]
        y, cb, cr = rgb_to_YCbCr_converter(r, g, b)
        ycbcr_array[i, j] = [y, cb, cr]
        
ycbcr_img = Image.fromarray(ycbcr_array.astype(np.uint8), "RGB")
ycbcr_img.save("output_ycbcr.jpeg")
print("Saved image.")


luma_array = ycbcr_array[:,:,0]

luma_img = Image.fromarray(luma_array.astype(np.uint8), mode='L')
luma_img.save("luma_component.jpeg")

# DCT Transform
block_size = 8
dct = np.zeros_like(luma_array, dtype=float)

for i in range(0, h, block_size):
    for j in range(0, w, block_size):
        block = luma_array[i: i+block_size, j:j+block_size] 
        if block.shape == (8, 8):
            dct_block = dctTransform(block.tolist())
            for x in range(8):
                for y in range(8):
                    dct[i+x, j+y] = dct_block[x][y]


# dct_array = np.array(dct)
dct_coeff = np.array(dct)
normalized = np.log1p(np.abs(dct_coeff))

normalized = (normalized / normalized.max()) * 255
dct_image = Image.fromarray(normalized.astype(np.uint8))
dct_image.save("dct_image.jpeg")

# Quantization
# quantized_result = quantize_dct(dct_coeff)
quantized_result = np.zeros_like(dct_coeff, dtype=int)

for i in range(0, h, block_size):
    for j in range(0, w, block_size):
        block = dct_coeff[i:i+8, j:j+8]
        if block.shape == (8, 8):
            q_block = quantize_dct(block)
            quantized_result[i:i+8, j:j+8] = q_block
            
normalized_quantized_result = quantized_result - quantized_result.min()
normalized_quantized_result = (normalized_quantized_result / normalized_quantized_result.max() * 255).astype(np.uint8)

quantized_image = Image.fromarray(normalized_quantized_result)
quantized_image.save("quantized_image.jpeg")