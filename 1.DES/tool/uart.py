# %%
data = """
0000000100100011010001010110011110001001101010111100110111101111
0110001101101111011011010111000001110101011101000110010101110010
0110101001111101011100100111010000011000000111010110100010011111
"""
data_head = """
11111111
00001111
11110000
"""
# %%
data_zip = tuple(map(
    lambda d: "{}{}".format(*d),
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
