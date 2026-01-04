# %%
from ecdsa import NIST256p, ellipticcurve
# %%
cur = NIST256p.curve
g = ellipticcurve.Point(
    curve=cur,
    x = 0x6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296,
    y = 0x4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5,
)
# %%
k = 137
# %%
r = k * g
# %%
print(
    "k =", k,
    "\nx =", hex(r.x()),
    "\ny =", hex(r.y())
)
# %%
