# 字节替换（SubBytes）

AES 加密中的 **SubBytes（字节替换）** 是一个**非线性字节代换操作**，用于提供**混淆（confusion）**，是 AES 安全性的核心之一。它对状态矩阵（State）中的**每一个字节**独立地通过一个固定的查找表（S-Box）进行替换。

下面我们从 **原理、S-Box 构造、操作步骤、示例和代码** 五个方面详细说明。


## 一、基本原理

- 输入：1 字节（8 位，0x00 ~ 0xFF）
- 输出：1 字节（通过 S-Box 映射）
- 操作：对 State 的 **16 个字节**分别查表替换
- 特点：
  - **非线性**：抵抗线性密码分析
  - **可逆**：解密时使用逆 S-Box（InvSubBytes）
  - **无密钥参与**：S-Box 是公开固定的（但由密钥扩展间接影响整体安全性）


## 二、S-Box 的数学构造（可选了解）

S-Box 并非随机设计，而是基于 **有限域 GF(2⁸)** 上的数学运算：

### 步骤：
1. **求乘法逆元**  
   对输入字节 \( b \in \text{GF}(2^8) \)，计算其在不可约多项式  
   \( m(x) = x^8 + x^4 + x^3 + x + 1 \)（即 0x11B）下的乘法逆元 \( b^{-1} \)。  
   > 规定：0x00 的逆元定义为 0x00（实际映射到 0x63）

2. **仿射变换（Affine Transform）**  
   将逆元结果 \( y = (y_7, y_6, ..., y_0) \) 进行如下线性变换（模 2）：
   \[
   z_i = y_i \oplus y_{(i+4)\bmod 8} \oplus y_{(i+5)\bmod 8} \oplus y_{(i+6)\bmod 8} \oplus y_{(i+7)\bmod 8} \oplus c_i
   \]
   其中常数向量 \( c = (1,1,0,0,0,1,1,0) \)（即 0x63）

> 这种设计确保了 S-Box **无不动点**（即 \( S(a) \ne a \)）和**无反不动点**（\( S(a) \ne \bar{a} \)），增强安全性。


## 三、S-Box 表（十六进制）

AES S-Box 是一个 16×16 的查找表。行号 = 高 4 位，列号 = 低 4 位。

例如：输入 `0x53` → 行 `5`，列 `3` → 输出 `0xed`

完整 S-Box（FIPS-197 标准）：

```
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
0 | 63 7c 77 7b f2 6b 6f c5 30 01 67 2b fe d7 ab 76
1 | ca 82 c9 7d fa 59 47 f0 ad d4 a2 af 9c a4 72 c0
2 | b7 fd 93 26 36 3f f7 cc 34 a5 e5 f1 71 d8 31 15
3 | 04 c7 23 c3 18 96 05 9a 07 12 80 e2 eb 27 b2 75
4 | 09 83 2c 1a 1b 6e 5a a0 52 3b d6 b3 29 e3 2f 84
5 | 53 d1 00 ed 20 fc b1 5b 6a cb be 39 4a 4c 58 cf
6 | d0 ef aa fb 43 4d 33 85 45 f9 02 7f 50 3c 9f a8
7 | 51 a3 40 8f 92 9d 38 f5 bc b6 da 21 10 ff f3 d2
8 | cd 0c 13 ec 5f 97 44 17 c4 a7 7e 3d 64 5d 19 73
9 | 60 81 4f dc 22 2a 90 88 46 ee b8 14 de 5e 0b db
a | e0 32 3a 0a 49 06 24 5c c2 d3 ac 62 91 95 e4 79
b | e7 c8 37 6d 8d d5 4e a9 6c 56 f4 ea 65 7a ae 08
c | ba 78 25 2e 1c a6 b4 c6 e8 dd 74 1f 4b bd 8b 8a
d | 70 3e b5 66 48 03 f6 0e 61 35 57 b9 86 c1 1d 9e
e | e1 f8 98 11 69 d9 8e 94 9b 1e 87 e9 ce 55 28 df
f | 8c a1 89 0d bf e6 42 68 41 99 2d 0f b0 54 bb 16
```

> 示例：
> - `S[0x00] = 0x63`
> - `S[0x10] = 0xca`（第1行第0列）
> - `S[0x53] = 0xed`（第5行第3列）


## 四、SubBytes 操作步骤

对状态矩阵 **每个字节** 执行：

```text
for row in 0..3:
    for col in 0..3:
        State[row][col] = S_Box[ State[row][col] ]
```

### 示例（接 AddRoundKey 后的状态）

假设当前 State（十六进制）为：

```
2b 39 89 3a
3a fb 91 be
9d 4b bf f4
da cd 66 c3
```

逐字节查 S-Box：

| 原字节 | S-Box 输出 |
|--------|------------|
| 0x2b   | 0xda       |
| 0x39   | 0x12       |
| 0x89   | 0x4f       |
| 0x3a   | 0xe2       |
| 0x3a   | 0xe2       |
| 0xfb   | 0x43       |
| 0x91   | 0x91       |
| 0xbe   | 0xc6       |
| 0x9d   | 0x4c       |
| 0x4b   | 0x8f       |
| 0xbf   | 0x6d       |
| 0xf4   | 0xf4       |
| 0xda   | 0x7d       |
| 0xcd   | 0xb0       |
| 0x66   | 0x33       |
| 0xc3   | 0xed       |

得到新的 State：

```
da 12 4f e2
e2 43 91 c6
4c 8f 6d f4
7d b0 33 ed
```

> 这就是 SubBytes 完成后的状态，下一步将进行 ShiftRows。


## 五、安全意义

- **非线性**：打破明文与密文之间的线性关系，抵抗线性/差分密码分析。
- **雪崩效应**：1 位输入变化 → 约 50% 输出位变化。
- **固定但精心设计**：虽公开，但数学结构确保无弱点（如不动点、线性结构等）。


## 总结

> **SubBytes = 对 State 中每个字节查 S-Box 替换**

- 操作简单（查表），但作用关键。
- 是 AES 唯一的非线性步骤。
- 解密时使用 [**逆 S-Box（InvSBox）**](./inv_sub_bytes.md) 进行 InvSubBytes。

