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

def montgomery_reduce(T, n, n_prime, k):
    """Montgomery Reduction: returns T * R^{-1} mod n"""
    R = 1 << k
    m = (T & (R - 1)) * n_prime & (R - 1)  # T mod R == T & (R-1)
    t = (T + m * n) >> k                   # 除以 R = 右移 k 位
    if t >= n:
        t -= n
    return t

def montgomery_mul(a_bar, b_bar, n, n_prime, k):
    """Montgomery multiplication"""
    T = a_bar * b_bar
    return montgomery_reduce(T, n, n_prime, k)

def to_montgomery(a, RR, n, n_prime, k):
    """Convert a to Montgomery form: a * R mod n"""
    return montgomery_reduce(a * RR, n, n_prime, k)

def from_montgomery(a_bar, n, n_prime, k):
    """Convert back: a_bar * R^{-1} mod n"""
    return montgomery_reduce(a_bar, n, n_prime, k)

# %%
def single(a: int, e: int, n: int, k = None):
    if k is None:
        k = n.bit_length()
    R, n_prime, RR = montgomery_precompute(n, k)

    print("k:", k)
    print("a:", hex(a))
    print("e:", hex(e))
    print("n:", hex(n))
    print("n_prime:", hex(n_prime))
    print("r2:", hex(RR))

    # 转换到 Montgomery 域
    a_bar = to_montgomery(a, RR, n, n_prime, k)

    print("a_bar:", hex(a_bar))

    res_bar = to_montgomery(1, RR, n, n_prime, k)  # 单位元

    print("res_bar:", hex(res_bar))

    # 快速幂（在 Montgomery 域中）
    exp = e
    base_bar = a_bar
    i = 0
    while exp:
        if exp & 1:
            res_bar = montgomery_mul(res_bar, base_bar, n, n_prime, k)
        base_bar = montgomery_mul(base_bar, base_bar, n, n_prime, k)
        
        print("bool:", exp & 1)
        print("base_bar:", i, hex(base_bar))
        print("res_bar:", i, hex(res_bar))
        exp >>= 1
        i += 1

    # 转回普通域
    result = from_montgomery(res_bar, n, n_prime, k)
    print("Result:", hex(result), "\n", result)
    res = pow(a, e, n)
    print("Res   :", hex(res), "\n", res)

# %%
single(
    a = 0x07,
    e = 0x05,
    n = 0x0d,
    k = 8
)
single(
    a = 0xa1b2c3d4e5f67890123456789012345678901234567890123456789012345678,
    e = 65537,
    n = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f
)