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
    print("t:", hex(T))
    return montgomery_reduce(T, n, n_prime, k)

# %%
def single(a: int, b: int, n: int, k = None):
    if k is None:
        k = n.bit_length()
    R, n_prime, RR = montgomery_precompute(n, k)

    print("k:", k)
    print("a:", hex(a))
    print("b:", hex(b))
    print("n:", hex(n))
    print("n_prime:", hex(n_prime))
    print("r2:", hex(RR))
    
    result = montgomery_mul(a, b, n, n_prime, k)
    print("Result:", hex(result), "\n", result)

# %%
single(
    a = 0xa1b2c3d4e5f67890123456789012345678901234567890123456789012345678,
    b = 0xfedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210,
    n = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f
)