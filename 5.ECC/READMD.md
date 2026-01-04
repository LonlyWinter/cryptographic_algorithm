# ECC 算法

ECC（Elliptic Curve Cryptography，椭圆曲线密码学）是一种基于椭圆曲线数学结构的公钥密码系统。与传统的 RSA 等公钥算法相比，ECC 在提供相同安全强度的前提下，使用更短的密钥长度，从而带来更高的效率和更低的资源消耗，特别适用于移动设备、物联网（IoT）等资源受限环境。


### 一、基本原理

ECC 的安全性依赖于**椭圆曲线离散对数问题**（ECDLP, Elliptic Curve Discrete Logarithm Problem）的计算难度：

- 给定椭圆曲线上的点 $ P $ 和整数 $ k $，计算 $ Q = kP $（即点 $ P $ 自加 $ k $ 次）是容易的；
- 但给定 $ P $ 和 $ Q $，要找出 $ k $ 使得 $ Q = kP $ 是极其困难的（目前没有已知的多项式时间算法）。


### 二、椭圆曲线定义（有限域上）

在密码学中，通常使用定义在有限域 $ \mathbb{F}_p $（$ p $ 为大素数）或 $ \mathbb{F}_{2^m} $ 上的椭圆曲线。最常见形式为：

$$
y^2 \equiv x^3 + ax + b \pmod{p}
$$

其中，满足 $ 4a^3 + 27b^2 \not\equiv 0 \pmod{p} $（确保[曲线无奇点](./doc/singular_point.md)）。

曲线上所有满足该方程的点 $ (x, y) $ 加上一个“无穷远点” $ \mathcal{O} $ 构成一个阿贝尔群，在此群上定义点加法和标量乘法。


### 三、ECC 密钥生成

1. **选择公开参数**（域参数）：
   - 素数 $ p $（定义有限域 $ \mathbb{F}_p $）
   - 系数 $ a, b $（定义曲线方程）
   - 基点 $ G $（曲线上一个具有大素数阶 $ n $ 的点）
   - 阶 $ n $（即 $ nG = \mathcal{O} $）
   - 辅助参数 $ h = \#E / n $（通常取 $ h = 1 $）

2. **私钥**：随机选择整数 $ d \in [1, n-1] $

3. **公钥**：计算 $ Q = dG $


### 四、ECC 应用场景

#### 1. **ECDH**（Elliptic Curve Diffie-Hellman）
用于密钥协商。双方各自生成私钥 $ d_A, d_B $，交换公钥 $ Q_A = d_A G, Q_B = d_B G $，则共享密钥为：
\[
K = d_A Q_B = d_B Q_A = d_A d_B G
\]

#### 2. **ECDSA**（Elliptic Curve Digital Signature Algorithm）
用于数字签名。比传统 DSA 更高效，广泛用于比特币、TLS 等。

#### 3. **加密**（如 ECIES）
虽然 ECC 本身不直接用于加密，但可结合对称加密构建混合加密方案（如 ECIES：Elliptic Curve Integrated Encryption Scheme）。


### 五、安全强度与密钥长度对比

| 安全强度（等效 RSA） | RSA 密钥长度 | ECC 密钥长度 |
|---------------------|--------------|---------------|
| 80 bits             | 1024 bits    | 160 bits      |
| 112 bits            | 2048 bits    | 224 bits      |
| 128 bits            | 3072 bits    | 256 bits      |
| 192 bits            | 7680 bits    | 384 bits      |
| 256 bits            | 15360 bits   | 521 bits      |

> 例如：256 位 ECC 密钥 ≈ 3072 位 RSA 密钥的安全性。


### 六、优点与挑战

**优点**：
- 密钥短，计算快，带宽和存储需求低
- 能耗低，适合嵌入式和移动设备
- 安全性高（目前无有效量子外经典攻击）

**挑战**：
- 实现复杂，易受侧信道攻击（如时序、功耗分析）
- 参数选择需谨慎（避免弱曲线，如 NIST 曾因某些曲线被质疑后门）
- 抗量子能力仍不足（Shor 算法可破解 ECC，需转向后量子密码）


### 七、常见标准与曲线

- **NIST 曲线**：P-256（secp256r1）、P-384、P-521
- **SECG 曲线**：secp256k1（比特币使用）
- **[Curve25519](./doc/Curve25519.md) / Ed25519**：由 Daniel J. Bernstein 设计，性能高、安全性强，广泛用于现代协议（如 Signal、SSH、TLS 1.3）

