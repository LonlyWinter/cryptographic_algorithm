# %%
data = """
133457799BBCDFF1
0123456789ABCDEF
85E813540F0AB405
"""
data_head = """
FF
0F
F0
"""
# %%
data_zip = tuple(map(
    lambda d: ''.join(f'{byte:08b}' for byte in bytes.fromhex("{}{}".format(*d))),
    zip(
        data_head.strip().split("\n"),
        data.strip().split("\n"),
    )
))
# %%
data_list = "\n\n\n".join(map(
    lambda d: "{}#2000;".format("".join(map(
        lambda dd: "rx = {}; #16;\n".format(dd),
        "".join(["0{}1".format("".join(reversed(d[i*8:i*8+8]))) for i in range(9)])
    ))),
    data_zip
))
# %%
with open("temp.txt", "w") as f:
    f.write(data_list)
# %%
