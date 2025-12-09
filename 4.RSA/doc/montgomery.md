# Montgomery 乘法

Montgomery 乘法（Montgomery Multiplication）是一种**高效计算大整数模乘**（即 $ a \cdot b \mod n $）的算法，由 Peter L. Montgomery 在 1985 年提出。它在 RSA、ECC（椭圆曲线密码）、DSA 等公钥密码系统中被广泛使用，是现代密码库（如 OpenSSL、BoringSSL、Java Crypto）实现高性能模幂运算的核心技术。


### **核心目标**
> **避免昂贵的大整数除法**，用**加法、位移和简单条件操作**替代传统“先乘后除”的模运算。


## 一、为什么需要 Montgomery 乘法？

在 RSA 中，要反复计算：$ c = m^e \mod n $，这涉及成千上万次的模乘：$ (a \times b) \mod n $。

- **传统方法**：先算 $ a \times b $（结果可能长达 4096 位），再用**大数除法**求余。
- **问题**：大数除法非常慢（复杂度高，且硬件不友好）。

**Montgomery 的突破**：  
通过引入一个特殊的表示形式（Montgomery form），将模约简转化为**除以 2 的幂**（即右移），从而极大加速运算。


## 二、关键思想与定义

### 1. **选择辅助参数 $ R $**
- 令 $ R = 2^k $，其中 $ k $ 是满足 $ R > n $ 的最小整数（通常 $ k $ 为字长倍数，如 1024、2048）。
- 要求：$ \gcd(R, n) = 1 $ → 因为 $ R = 2^k $，所以 **$ n $ 必须是奇数**（RSA 的 $ n = pq $ 天然满足）。

### 2. **Montgomery 表示（Montgomery Form）**
将普通整数 $ a $ 映射为：
$$ \tilde{a} = a \cdot R \mod n $$
所有运算都在这种“扭曲”形式下进行。

### 3. **Montgomery 乘法函数（MontMul）**

定义：
$$ \text{MontMul}(\tilde{a}, \tilde{b}) = \tilde{a} \cdot \tilde{b} \cdot R^{-1} \mod n $$

注意：
- 输入是 Montgomery 形式；
- 输出仍是 Montgomery 形式；
- 效果等价于：$ \widetilde{a \cdot b} $

> **关键**：整个过程**不需要除以 $ n $**，只需除以 $ R = 2^k $（即右移 $ k $ 位）。


## 三、Montgomery Reduction 算法（核心步骤）

给定 $ T = \tilde{a} \cdot \tilde{b} $（一个最多 $ 2k $ 位的整数），计算：

$$ T \cdot R^{-1} \mod n $$

### 预计算（一次）：
- 计算 $ n' $ 满足：
    $$ n \cdot n' \equiv -1 \pmod{R} $$
    即 $ n' = -n^{-1} \mod R $（可用扩展欧几里得算法快速求出）。

### 算法流程：
```text
Input: T (0 ≤ T < R·n), precomputed n', modulus n, R = 2^k
Output: T · R⁻¹ mod n

1. m ← (T mod R) · n' mod R     // 使 T + m·n ≡ 0 (mod R)
2. t ← (T + m · n) / R          // 除以 R = 右移 k 位（无除法！）
3. if t ≥ n then t ← t - n      // 可选：归约到 [0, n)
4. return t
```

### 为什么有效？
- 第 1 步确保 $ T + m \cdot n $ 能被 $ R $ 整除；
- 第 2 步除以 $ R $ 只需**右移**（硬件极快）；
- 结果 $ t \equiv T \cdot R^{-1} \pmod{n} $，且 $ 0 \leq t < 2n $。



## 四、完整使用流程（以 RSA 为例）

### 1. **预处理（转换到 Montgomery 域）**
- 将底数 $ a $ 转为 Montgomery 形式：
    $$\tilde{a} = \text{MontMul}(a, R^2 \mod n) $$
    （因为 $ \text{MontMul}(a, R^2) = a \cdot R^2 \cdot R^{-1} = aR \mod n $）

> 实际中常预计算 $ R^2 \mod n $ 作为“转换常量”。

### 2. **模幂运算（全部在 Montgomery 域）**
- 使用快速幂算法，每次乘法调用 `MontMul`。
- 所有中间结果保持 Montgomery 形式。

### 3. **后处理（转回普通形式）**
- 将结果 $ \tilde{c} $ 转回普通值：
    $$ c = \text{MontMul}(\tilde{c}, 1) = \tilde{c} \cdot R^{-1} \mod n $$


## 五、性能优势

| 操作 | 传统方法 | Montgomery 方法 |
|------|--------|----------------|
| 模乘 | 1 次大乘 + 1 次大除 | 多次加/移位 + 1 次条件减 |
| 速度 | 慢（除法瓶颈） | **快 2–5 倍** |
| 硬件友好性 | 差 | 极好（适合 FPGA/ASIC） |

> 在 2048 位 RSA 解密中，Montgomery 可减少 **70% 以上**的模乘时间。


## 六、注意事项

1. **仅适用于奇数模 $ n $**  
   → RSA 的 $ n = pq $（两个奇质数之积）天然满足。

2. **需预计算 $ n' $ 和 $ R^2 \mod n $**  
   → 但只需一次，后续大量模乘可复用。

3. **侧信道安全**  
   - 实现必须是**恒定时间**（constant-time），否则可能泄露密钥。
   - 现代密码库均采用安全实现。


## 七、与其他技术的关系

| 技术 | 关系 |
|------|------|
| **Barrett Reduction** | 另一种模约简方法，适合固定模数，但通常比 Montgomery 慢 |
| **Montgomery 曲线** | 椭圆曲线的一种形式（如 Curve25519），也由 Montgomery 提出，但与 Montgomery 乘法不同 |
| **Karatsuba / FFT 乘法** | 用于加速大数乘法本身，可与 Montgomery 结合使用 |


### 总结

> **Montgomery 乘法不是一种加密算法，而是一种“模运算加速器”**。

- **核心思想**：用“乘 $ R^{-1} $”代替“模 $ n $”，并将除法转化为位移。
- **关键操作**：Montgomery Reduction（无需除法）。
- **应用场景**：所有依赖大数模幂的公钥密码系统。
- **实际影响**：没有它，现代 HTTPS、数字签名、区块链的性能将大幅下降。
