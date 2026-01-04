# %%
def mod_inv(a: int, p: int):
    u = a
    v = p
    x1 = 1
    x2 = 0

    index = 1
    cls = 0
    while u != 1:
        print("x1:", index, cls, hex(x1), hex(x2))
        index += 1
        if (u & 1) == 0:
            u >>= 1
            if (x1 & 1) == 0:
                x1 >>= 1
                cls = 1
            else:
                x1 = (x1 + p) >> 1
                cls = 2
        
        elif (v & 1) == 0:
            v >>= 1
            if (x2 & 1) == 0:
                x2 >>= 1
                cls = 3
            else:
                x2 = (x2 + p) >> 1
                cls = 4
        
        elif u >= v:
            u -= v
            x1 = x1 - x2 if x1 > x2 else (x1 + p - x2)
            cls = 5
        else:
            v -= u
            x2 = x2 - x1 if x2 > x1 else (x2 + p - x1)
            cls = 6
    print("X1:", hex(x1))
    print("P:", hex(p))
    return x1 - p if x1 >= p else x1
res = mod_inv(
    0x4de2e12850f1f10056912a0baf9931e1ca5f41d5600aefa3de1212cd5c185a5a,
    0xffffffff00000001000000000000000000000000ffffffffffffffffffffffff
)
print("Res:", hex(res))