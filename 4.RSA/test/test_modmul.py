# %%
import time

# %%
def montgomery_modmul(a, b, n):
    """
    Compute (a * b) % n using Montgomery reduction.
    Assumes: 0 <= a, b < n, and n is odd (so gcd(n, R) = 1).
    """
    if n <= 1:
        return 0
    if a == 0 or b == 0:
        return 0

    # Step 1: Choose R = 2^k where k = bit length of n
    k = n.bit_length()
    R = 1 << k  # R = 2^k

    print("a:", hex(a))
    print("b:", hex(b))
    print("n:", hex(n))
    print("r:", hex(R))

    # Step 2: Precompute R2 = R^2 mod n
    RR = R * R
    print("rr:", hex(RR))

    R2 = RR % n
    
    print("r2:", hex(R2))

    # Step 3: Compute n' = -n^{-1} mod R
    # Since R is power of 2, we can use Newton's method or pow with modulus
    # We need n_inv such that (n * n_inv) % R == 1, then n' = (-n_inv) % R
    # But easier: solve n * x ≡ -1 (mod R) → x = (-inverse(n, R)) mod R
    # Use extended Euclidean or built-in pow (Python 3.8+ supports mod inverse for coprime)
    try:
        n_inv = pow(n, -1, R)  # n^{-1} mod R
    except ValueError:
        raise ValueError("n must be odd (so invertible modulo R=2^k)")
    n_prime = (-n_inv) % R
    
    print("n_prime:", hex(n_prime))

    # Step 4: Montgomery reduction function
    def redc(T):
        # m = (T mod R) * n' mod R
        m = ((T & (R - 1)) * n_prime) & (R - 1)  # T mod R == T & (R-1) since R=2^k
        t = (T + m * n) >> k  # divide by R (right shift)
        if t >= n:
            t -= n
        return t
    
    aaaa = a * R2
    print("a_r2:", hex(aaaa))
    
    bbbb = b * R2
    print("b_r2:", hex(bbbb))

    # Step 5: Convert a, b to Montgomery form: aR mod n, bR mod n
    a_mont = redc(aaaa)  # because redc(a * R^2) = aR mod n
    b_mont = redc(bbbb)
    print("a_mont:", hex(a_mont))
    print("b_mont:", hex(b_mont))

    # Step 6: Multiply in Montgomery domain
    t = a_mont * b_mont  # This is < n^2 < n*R (since R > n)
    print("t:", hex(t))

    # Step 7: Reduce to get abR mod n
    ab_mont = redc(t)
    print("ab_mont:", hex(ab_mont))

    # Step 8: Convert back to normal domain: redc(abR) = ab mod n
    result = redc(ab_mont)
    print("res:", hex(result))
    return result
# # %%
# def move_bit(a: int, b: int, n: int, km: int = 16):
#     if n <= 1:
#         return 0
#     if a == 0 or b == 0:
#         return 0
    
#     kmr = 1 << km
#     kmc = 1 << km - 1

#     def mod_single(a: int, n: int) -> int:
#         if a < n:
#             return a
        
#         if a.bit_length() < km:
#             return a % n
        
#         a1 = a >> km
#         a2 = a & kmc
#         return mod_single(a1, n) * kmr + mod_single(a2, n)
    
#     t = mod_single(a, n) * mod_single(b, n)
#     return t if t < n else t - n
# %%
# Example
a = 0xA1B2C3D4E5F67890123456789012345678901234567890123456789012345678
b = 0xFEDCBA9876543210FEDCBA9876543210FEDCBA9876543210FEDCBA9876543210
n = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F

# Using Montgomery
time_start = time.time()
res_mont = montgomery_modmul(a, b, n)
print("Montgomery cost:", time.time() - time_start)

# # Using MoveBit
# time_start = time.time()
# res_bit = move_bit(a, b, n)
# print("MoveBit cost:", time.time() - time_start)

# Using built-in
time_start = time.time()
res_builtin = (a * b) % n
print("built-in cost:", time.time() - time_start)

print("Montgomery result :", res_mont)
# print("MoveBit result    :", res_bit)
print("Built-in result   :", res_builtin)
print("result            :", hex(res_builtin))
print("Equal?            :", res_mont == res_builtin)
