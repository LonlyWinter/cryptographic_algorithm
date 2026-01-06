# %%
def rol(value, bits, shift):
    shift %= bits
    if shift == 0:
        return value
    return ((value << shift) & (2**bits - 1)) | (value >> (bits - shift))

v = 0x79CC4519
for i in range(16):
    r = rol(v, 32, i)
    print(hex(r))
v = 0x7A879D8A
for i in range(16, 64):
    r = rol(v, 32, i)
    print(hex(r))