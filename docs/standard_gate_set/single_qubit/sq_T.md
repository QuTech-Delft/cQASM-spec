# T gate

| Name | Operator | Example statement |
|------|----------|-------------------|
| T    | $T$      | **`T q[0]`**      |

## Description

T gate

Rotation of $\pi/4$ [rad] around the _z_-axis and a global phase of $\pi/8$ [rad].

## Representation

$$\begin{align}
T &= R_\mathbf{n}\left([0, 0, 1]^T, \frac{\pi}{4}, \frac{\pi}{8}\right) = e^{i\frac{\pi}{8}} \cdot e^{-i\frac{\pi}{8} Z} \\
\\
T &= \left(\begin{matrix}
1 & 0 \\
0 & \frac{1 + i}{\sqrt{2}} 
\end{matrix}\right)
\end{align}$$
