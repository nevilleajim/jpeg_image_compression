
# Standard JPEG Luminance DC Huffman Table
DC_LUMA_HUFF = {
    0: ("00", 2), 1: ("010", 3), 2: ("011", 3), 3: ("100", 3),
    4: ("101", 3), 5: ("110", 3), 6: ("1110", 4), 7: ("11110", 5),
    8: ("111110", 6), 9: ("1111110", 7), 10: ("11111110", 8), 
    11: ("111111110", 9)
}

# Standard JPEG Luminance AC Huffman Table
AC_LUMA_HUFF = {
    (0, 0): ("1010", 4),
    (0, 1): ("00", 2),
    (0, 2): ("01", 2),
    (1, 1): ("110", 3),
    (2, 1): ("11100", 5),
    (15, 0): ("11111111001", 11)
}

def category(value):
    """JPEG category = number of bits needed to store magnitude."""
    if value == 0:
        return 0
    v = abs(value)
    c = 0
    while v > 0:
        v >>= 1
        c += 1
    return c

def value_bits(value, size):
    """Return JPEG value bits with sign encoding."""
    if size == 0:
        return ""
    
    if value >= 0:
        return format(value, f"0{size}b")
    
    mask = (1 << size) - 1
    return format(value & mask, f"0{size}b")

def encode_block(coeffs, last_dc): 
    """coeffs: kist 64 quantized value (zigzag ordered)
    last_dc: previous DC coefficient
    
    Returns bitstring and new last_dc
    """
    
    bits = ""
    
    dc = coeffs[0]
    diff = dc - last_dc
    cat = category(diff)
    huff_code, _ = DC_LUMA_HUFF[cat]
    bits += huff_code
    bits += value_bits(diff, cat)
    
    zero_run = 0
    
    for ac in coeffs[1:]:
        if ac == 0:
            zero_run += 1
            
            if zero_run == 16:
                huff, _ = AC_LUMA_HUFF[(15, 0)]
                bits += huff
                zero_run = 0
        
        else:
            size = category(ac)
            key = (zero_run, size)
            
            if key not in AC_LUMA_HUFF:
                raise ValueError(f"Huffman code for {key} not found.")
            
            huff, _ = AC_LUMA_HUFF[key]
            bits += huff
            
            bits += value_bits(ac, size)
            zero_run = 0
            
    if zero_run > 0:
        huff, _ = AC_LUMA_HUFF[(0, 0)]
        bits += huff
    return bits, dc

if __name__ == "__main__":
    test_block = [
        52, -3, 0, 0, 0, 0, 0, 0,
        2, -1, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0
    ]
    
    stream, new_dc = encode_block(test_block, last_dc=50)
    
    print("Huffman Encoded Bitstream:")
    print(stream)
    print("Final DC:", new_dc)