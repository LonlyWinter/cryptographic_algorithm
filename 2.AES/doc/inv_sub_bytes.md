# 逆 S-Box（InvSBox）表

AES 解密过程中的 **InvSubBytes（逆字节替换）** 使用 **逆 S-Box（Inverse S-Box，简称 InvSBox）**，它是加密时 S-Box 的反函数。也就是说，对于任意字节 \( b \)：

\[
\text{InvSBox}[ \text{SBox}[b] ] = b
\]

下面提供完整的 **逆 S-Box 表（InvSBox）**，并说明其构造方式和使用方法。


## 逆 S-Box 表（16×16，十六进制）

格式：行号 = 高 4 位，列号 = 低 4 位  
输入字节 `0x52` → 查第 5 行、第 2 列 → 输出 `0x00`

```
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
0 | 52 09 6a d5 30 36 a5 38 bf 40 a3 9e 81 f3 d7 fb
1 | 7c e3 39 82 9b 2f ff 87 34 8e 43 44 c4 de e9 cb
2 | 54 7b 94 32 a6 c2 23 3d ee 4c 95 0b 42 fa c3 4e
3 | 08 2e a1 66 28 d9 24 b2 76 5b a2 49 6d 8b d1 25
4 | 72 f8 f6 64 86 68 98 16 d4 a4 5c cc 5d 65 b6 92
5 | 6c 70 48 50 fd ed b9 da 5e 15 46 57 a7 8d 9d 84
6 | 90 d8 ab 00 8c bc d3 0a f7 e4 58 05 b8 b3 45 06
7 | d0 2c 1e 8f ca 3f 0f 02 c1 af bd 03 01 13 8a 6b
8 | 3a 91 11 41 4f 67 dc ea 97 f2 cf ce f0 b4 e6 73
9 | 96 ac 74 22 e7 ad 35 85 e2 f9 37 e8 1c 75 df 6e
a | 47 f1 1a 71 1d 29 c5 89 6f b7 62 0e aa 18 be 1b
b | fc 56 3e 4b c6 d2 79 20 9a db c0 fe 78 cd 5a f4
c | 1f dd a8 33 88 07 c7 31 b1 12 10 59 27 80 ec 5f
d | 60 51 7f a9 19 b5 4a 0d 2d e5 7a 9f 93 c9 9c ef
e | a0 e0 3b 4d ae 2a f5 b0 c8 eb bb 3c 83 53 99 61
f | 17 2b 04 7e ba 77 d6 26 e1 69 14 63 55 21 0c 7d
```

> 示例：
> - `InvSBox[0x63] = 0x00`（因为 `SBox[0x00] = 0x63`）
> - `InvSBox[0xed] = 0x53`（因为 `SBox[0x53] = 0xed`）
> - `InvSBox[0x00] = 0x52`


## 逆 S-Box 的构造原理

与 S-Box 相反，InvSBox 的构造顺序是：

1. **先进行逆仿射变换（Inverse Affine Transform）**
2. **再求 GF(2⁸) 中的乘法逆元**

即：
\[
\text{InvSBox}(x) = \left( \text{InvAffine}(x) \right)^{-1}
\]
（同样规定：若结果为 0，则输出 0）

> 这保证了 `InvSBox(SBox(x)) = x` 对所有 \( x \in \{0,1\}^8 \) 成立。


## 在 AES 解密中的位置

AES 解密流程（以 AES-128 为例）：

1. **AddRoundKey**（使用最后一轮密钥）
2. **InvShiftRows**
3. **InvSubBytes**
4. **AddRoundKey**
5. **InvMixColumns**
6. 重复步骤 2–5 共 9 次
7. 最后一轮（第 10 轮解密）：**InvShiftRows → InvSubBytes → AddRoundKey**（无 InvMixColumns）

> 注意：**InvSubBytes 总是在 InvShiftRows 之后、AddRoundKey 之前**（与加密顺序相反）。


## 小结

| 项目 | 加密（SubBytes） | 解密（InvSubBytes） |
|------|------------------|---------------------|
| 使用表 | S-Box | InvS-Box |
| 作用 | 引入非线性混淆 | 撤销 SubBytes 变换 |
| 可逆性 | 是 | 是 |
| 是否依赖密钥 | 否（但整体安全依赖轮密钥） | 否 |

