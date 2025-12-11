
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