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
def single(X1: int, Y1: int, a: int, p: int, k = None):
    if k is None:
        k = p.bit_length()
    R, p_prime, RR = montgomery_precompute(p, k)

    print("k:", k)
    print("a:", hex(a))
    print("p:", hex(p))
    print("p_prime:", hex(p_prime))
    print("r2:", hex(RR))

    # All operations mod p
    B = (Y1 * Y1) % p
    S = (4 * X1 * B) % p
    A = (X1 * X1) % p
    M = (3 * A + a) % p
    X3 = (M * M - 2 * S) % p
    C = (B * B) % p
    Y3 = (M * ((S - X3) % p) - 8 * C) % p
    Z3 = (2 * Y1) % p
    print("X3:", hex(X3))
    print("Y3:", hex(Y3))
    print("Z3:", hex(Z3))

    Z3_sq_inv = pow(Z3, -2, p)
    t = (Z3 * Z3) % p
    print("t:", hex(t))
    tt = pow(t, -1, p)
    print("tt:", hex(tt))
    print("Z3_2_Inv:", hex(Z3_sq_inv))

    Z3_cu_inv = pow(Z3, -3, p)
    print("Z3_3_Inv:", hex(Z3_cu_inv))
    
    x_affine = (X3 * Z3_sq_inv) % p
    print("X:", hex(x_affine))
    
    y_affine = (Y3 * Z3_cu_inv) % p
    print("Y:", hex(y_affine))
    
# %%
single(
    X1 = 0x6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296,
    Y1 = 0x4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5,
    a = 0xffffffff00000001000000000000000000000000fffffffffffffffffffffffc,
    p = 0xffffffff00000001000000000000000000000000ffffffffffffffffffffffff
)