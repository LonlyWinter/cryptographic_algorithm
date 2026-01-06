def rotl32(x, n):
    return ((x << n) | (x >> (32 - n))) & 0xFFFFFFFF

def P1(x):
    return x ^ rotl32(x, 15) ^ rotl32(x, 23)

# 第二分组 B^(1) 的 16 个字
W = [0] * 68
W[0] = 0x80000000
for i in range(1, 15):
    W[i] = 0
W[15] = 0x00000200

# 扩展 W[16] ～ W[67]
for j in range(16, 20):
    w = W[j-16] ^ W[j-9] ^ rotl32(W[j-3], 15)
    w = P1(w)
    w ^= rotl32(W[j-13], 7)
    w ^= W[j-6]
    W[j] = w
    print(f"W[{j-1:2d}] = {W[j-1]:08x}")
    print(f"msg1 = {W[j-16]:08x}")
    print(f"msg2 = {W[j-9]:08x}")
    print(f"msg3 = {W[j-3]:08x}")
    print(f"msg4 = {W[j-13]:08x}")
    print(f"msg5 = {W[j-6]:08x}")
    print(f"W[{j:2d}] = {W[j]:08x}\n")
