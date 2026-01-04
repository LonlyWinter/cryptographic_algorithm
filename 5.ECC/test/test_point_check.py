def montgomery_precompute(n, k):
    """预计算 Montgomery 参数"""
    R = 1 << k  # R = 2^k
    assert R > n and n % 2 == 1, "n must be odd and R > n"
    
    # 计算 n' = -n^{-1} mod R
    # 因为 R 是 2^k，可用扩展欧几里得或牛顿迭代
    # 这里用简单方法（仅适用于小 k）
    inv = pow(-n, -1, R)  # Python 3.8+ 支持负底数模逆
    n_prime = inv % R
    RR = (R * R) % n 
    return R, n_prime, RR

# %%
def single(X1: int, Y1: int, a: int, b: int, p: int, k = None):
    if k is None:
        k = p.bit_length()
    R, p_prime, RR = montgomery_precompute(p, k)

    print("k:", k)
    print("a:", hex(a))
    print("b:", hex(b))
    print("p:", hex(p))
    print("p_prime:", hex(p_prime))
    print("r2:", hex(RR))

    # All operations mod p
    y2_left = (Y1 * Y1) % p
    print("y2:", hex(y2_left))

    x2 = (X1 * X1) % p
    print("x2:", hex(x2))
    
    x3 = (x2 * X1) % p
    print("x3:", hex(x3))
    
    ax = (a * X1) % p
    print("ax:", hex(ax))
    
    add_ax = (x3 + ax) % p
    print("add_ax:", hex(add_ax))
    
    y2_right = (add_ax + b) % p
    print("Valid:", y2_left == y2_right)
    

# %%
single(
    X1 = 0x6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296,
    Y1 = 0x4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5,
    a = 0xffffffff00000001000000000000000000000000fffffffffffffffffffffffc,
    b = 0x5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b,
    p = 0xffffffff00000001000000000000000000000000ffffffffffffffffffffffff
)