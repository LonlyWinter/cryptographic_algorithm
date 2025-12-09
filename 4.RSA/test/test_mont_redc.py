# %%
def redc(T, n, k):
    R = 1 << k  # R = 2^k
    try:
        n_inv = pow(n, -1, R)  # n^{-1} mod R
    except ValueError:
        raise ValueError("n must be odd (so invertible modulo R=2^k)")
    n_prime = (-n_inv) % R

    print("T:     ", hex(T), k)
    print("n:     ", hex(n))
    print("Prime: ", hex(n_prime))

    # m = (T mod R) * n' mod R
    u_i = ((T & (R - 1)) * n_prime) & (R - 1)  # T mod R == T & (R-1) since R=2^k
    print("u_i:   ", hex(u_i))

    temp0 = u_i * n
    print("temp0: ", hex(temp0))

    temp1 = T + temp0
    print("temp1: ", hex(temp1))
    
    temp2 = temp1 >> k  # divide by R (right shift)
    print("temp2: ", hex(temp2))

    print("b:     ", temp2 >= n)
    if temp2 >= n:
        temp3 = temp2 - n
    else:
        temp3 = temp2
    
    print("Res:   ", hex(temp3))

redc(
    0xa0fac9c9b64ab578361181fef55d4ae50ef6949462362ff7a4636d7974cb9ccf590cf086ca09bed7c3f638518af7296aeb1125bc1e1e445855a44cd70b88d780,
    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F,
    256
)