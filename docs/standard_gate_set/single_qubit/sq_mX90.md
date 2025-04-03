# Minus X90 gate

| Name | Operator   | Example statement |
|------|------------|-------------------|
| mX90 | $X^{-1/2}$ | **`mX90 q[0]`**   |

## Description

Minus X90 gate

$V^\dagger = X^{-1/2}$

Rotation of $-\pi/2$ [rad] around the _x_-axis and a global phase of $-\pi/4$ [rad].

Clifford gate

## Representation

$$\begin{align}
X^{-1/2} &= R_\mathbf{n}\left([1, 0, 0]^T, -\frac{\pi}{2}, -\frac{\pi}{4}\right) = e^{-i\frac{\pi}{4}} \cdot e^{i\frac{\pi}{4}X} \\
\\
X^{-1/2} &= \frac{1}{2}\left(\begin{matrix}
1 - i & 1 + i \\
1 + i & 1 - i 
\end{matrix}\right)
\end{align}$$
