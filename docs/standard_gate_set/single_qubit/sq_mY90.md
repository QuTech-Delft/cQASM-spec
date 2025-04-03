# Minus Y90 gate

| Name | Operator   | Example statement |
|------|------------|-------------------|
| mY90 | $Y^{-1/2}$ | **`mY90 q[0]`**   |

## Description

Minus Y90 gate

Rotation of $-\pi/2$ [rad] around the _y_-axis and a global phase of $-\pi/4$ [rad].

Clifford gate

## Representation

$$\begin{align}
Y^{-1/2} &= R_\mathbf{n}\left([0, 1, 0]^T, -\frac{\pi}{2}, -\frac{\pi}{4}\right) = e^{-i\frac{\pi}{4}} \cdot e^{i\frac{\pi}{4}Y} \\
\\
Y^{-1/2} &= \frac{1}{2}\left(\begin{matrix}
1 - i  & 1 - i \\
-1 + i & 1 - i 
\end{matrix}\right)
\end{align}$$
