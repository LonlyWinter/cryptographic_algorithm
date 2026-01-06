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
def single(n: int, k = None):
    if k is None:
        k = n.bit_length()
    R, n_prime, RR = montgomery_precompute(n, k)

    print("k:", k)
    print("n:", hex(n))
    print("n_prime:", hex(n_prime))
    print("r2:", hex(RR))

# %%
single(
    n = 101,
    k = 64
)
# %%
print("g =", pow(3, 78, 7879))
print("y =", pow(170, 75, 7879))
print("r_temp =", pow(170, 50, 7879))
print("r =", pow(170, 50, 7879) % 101)
print("k_inv =", pow(50, -1, 101))
print("s =", (99 * (42 + 75 * 94)) % 101)
print("w =", pow(57, -1, 101))
print("u1 =", (42 * 39) % 101)
print("u2 =", (94 * 39) % 101)
print("v1 =", pow(170, 22, 7879))
print("v2 =", pow(4567, 30, 7879))
print("v3 =", (7019 * 6795) % 7879)
print("v =",  2518 % 101)