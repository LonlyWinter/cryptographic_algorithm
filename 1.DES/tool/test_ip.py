def des_initial_permutation(block_hex):
    block_bin = bin(int(block_hex, 16))[2:].zfill(64)
    
    # IP table (1-indexed)
    ip_table = [
        58, 50, 42, 34, 26, 18, 10, 2,
        60, 52, 44, 36, 28, 20, 12, 4,
        62, 54, 46, 38, 30, 22, 14, 6,
        64, 56, 48, 40, 32, 24, 16, 8,
        57, 49, 41, 33, 25, 17, 9,  1,
        59, 51, 43, 35, 27, 19, 11, 3,
        61, 53, 45, 37, 29, 21, 13, 5,
        63, 55, 47, 39, 31, 23, 15, 7
    ]
    
    permuted = ''.join(block_bin[pos - 1] for pos in ip_table)
    return hex(int(permuted, 2))[2:].upper().zfill(16)

# Test
print(des_initial_permutation('0123456789ABCDEF'))  # 输出: CC00CCFFF0AAF0AA