# Basic Bitwise Logic Explained

Bitwise operations manipulate individual bits (0s and 1s) within binary numbers. They are the fastest operations a computer can perform, as they operate directly on the hardware level.

For these examples, we will compare two 4-bit binary numbers:

* **A:** 1010₂
* **B:** 0110₂

---

## 1. Bitwise AND (`&`)

The AND operation produces a **1** only if **both** corresponding bits are **1**. If either or both bits are 0, the result is 0.

| A | B | Result (A & B) |
| :-: | :-: | :-: |
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| **1** | **1** | **1** |

### Example:

$$
\begin{array}{rcc}
A & 1010_2 \\
\text{AND} \quad B & 0110_2 \\
\hline
\text{Result} & \mathbf{0010_2}
\end{array}
$$

### Common Use: **Masking**
AND is used to **clear specific bits** or **check the status of specific bits** by using a "mask." Any bit in the mask that is 0 will force the corresponding bit in the result to 0.

## 2. Bitwise OR (`|`)

The OR operation produces a **1** if **at least one** of the corresponding bits is **1**. The result is 0 only if both bits are 0.

| A | B | Result (A \| B) |
| :-: | :-: | :-: |
| 0 | 0 | 0 |
| 0 | 1 | **1** |
| 1 | 0 | **1** |
| 1 | 1 | **1** |

### Example:

$$
\begin{array}{rcc}
A & 1010_2 \\
\text{OR} \quad B & 0110_2 \\
\hline
\text{Result} & \mathbf{1110_2}
\end{array}
$$

### Common Use: **Setting Bits**
OR is used to **ensure specific bits are set to 1** without affecting other bits. Any bit in the mask that is 1 will force the corresponding bit in the result to 1.

## 3. Bitwise NOT (or Complement, `~`)

The NOT operation (also called one's complement) is a **unary** operation, meaning it operates on a single number. It simply **inverts** every bit: 0s become 1s, and 1s become 0s.

| A | Result (~A) |
| :-: | :-: |
| 0 | **1** |
| 1 | **0** |

### Example:

$$
\begin{array}{rcc}
\text{NOT} \quad A & 1010_2 \\
\hline
\text{Result} & \mathbf{0101_2}
\end{array}
$$

### Common Use: **Calculating Two's Complement**
NOT is the first step in calculating the two's complement, which is how computers represent negative numbers.

## 4. Bitwise XOR (Exclusive OR, `^`)

The XOR operation produces a **1** if the two corresponding bits are **different**. It produces a 0 if the two bits are the same.

| A | B | Result (A ^ B) |
| :-: | :-: | :---: |
| 0 | 0 | 0 |
| 0 | 1 | **1** |
| 1 | 0 | **1** |
| 1 | 1 | 0 |

### Example:

$$
\begin{array}{rcc}
A & 1010_2 \\
\text{XOR} \quad B & 0110_2 \\
\hline
\text{Result} & \mathbf{1100_2}
\end{array}
$$

### Common Use: **Toggling and Swapping**
* **Toggling:** XOR is used to **flip specific bits** (e.g., XORing a bit with 1 will flip it; XORing it with 0 will leave it unchanged).
* **Swapping:** You can swap the values of two variables without using a temporary third variable, which is a classic Assembly/low-level programming trick.