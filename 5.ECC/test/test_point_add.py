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
def single(X1: int, Y1: int, X2: int, Y2: int, p: int, k = None):
    if k is None:
        k = p.bit_length()
    R, p_prime, RR = montgomery_precompute(p, k)

    print("k:", k)
    print("p:", hex(p))
    print("p_prime:", hex(p_prime))
    print("r2:", hex(RR))

    # All operations mod p
    Z1 = 1
    Z2 = 1
    U1 = (X1 * (Z2**2)) % p
    print("U1:", hex(U1))

    U2 = (X2 * (Z1**2)) % p
    print("U2:", hex(U2))
    
    S1 = (Y1 * (Z2**3)) % p
    print("S1:", hex(S1))
    
    S2 = (Y2 * (Z1**3)) % p
    print("S2:", hex(S2))
    

    H  = (U2 - U1) % p
    print("H:", hex(H))
    
    r  = (S2 - S1) % p
    print("r:", hex(r))
    

    H2 = (H * H) % p
    print("H2:", hex(H2))
    
    H3 = (H * H2) % p
    print("H3:", hex(H3))
    
    V  = (U1 * H2) % p
    print("V:", hex(V))
    

    X3 = (r*r - H3 - 2*V) % p
    print("X3:", hex(X3))
    
    Y3 = (r*(V - X3) - S1*H3) % p
    print("Y3:", hex(Y3))
    
    Z3 = (H * Z1 * Z2) % p
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
    X2 = 0x7cf27b188d034f7e8a52380304b51ac3c08969e277f21b35a60b48fc47669978,
    Y2 = 0x07775510db8ed040293d9ac69f7430dbba7dafb84c35826416c97624876e55a4,
    p = 0xffffffff00000001000000000000000000000000ffffffffffffffffffffffff
)
# %%
# mod_inv
tt = pow(
    2,
    -1,
    0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f
)
print("tt:", hex(tt))
tt = pow(
    0x4de2e12850f1f10056912a0baf9931e1ca5f41d5600aefa3de1212cd5c185a5a,
    -1,
    0xffffffff00000001000000000000000000000000ffffffffffffffffffffffff
)
print("tt:", hex(tt))
# %%
def gcd(a: int, b: int):
    m = max(a, b)
    n = min(a, b)
    r = m % n
    while r != 0:
        m = n
        n = r
        r = m % n
    print(a, "和", b, "的最大公约数为", n)
gcd(
    0x4de2e12850f1f10056912a0baf9931e1ca5f41d5600aefa3de1212cd5c185a5a,
    0xffffffff00000001000000000000000000000000ffffffffffffffffffffffff
)