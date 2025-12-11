

def rgb_to_YCbCr_converter(R: int, G: int, B: int) -> tuple[int, int, int]:
    """
    This module provides functions to convert images between RGB and YCBCr.
    Y represents Luminance, Cb represents the Blue-difference Chroma component,
    and Cr represents the Red-difference chroma component.
    """
    
    Y = 16 + ( (65.81 * R) +  (129.057 * G) + (25.064 * B) ) / 256
    Cb = 128 - ( (37.945 * R) +  (74.494 * G) - (112.439 * B) ) / 256
    Cr = 128 + ( (112.439 * R) -  (94.154 * G) - (18.285 * B) ) / 256

    return (int(round(Y)), int(round(Cb)), int(round(Cr)))

def YCbCr_to_rgb_converter(Y, Cb, Cr):
    
    R = Y + 1.402 * (Cr - 128)
    G = Y - 0.344136 * (Cb - 128) - 0.714136 * (Cr - 128)
    B = Y + 1.772 * (Cb - 128)
    
    R = max(0, min(255, round(R)))
    G = max(0, min(255, round(G)))
    B = max(0, min(255, round(B)))
    
    return R, G, B