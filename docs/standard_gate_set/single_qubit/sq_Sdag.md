# S dagger gate

| Name | Operator    | Example statement |
|------|-------------|-------------------|
| Sdag | $S^\dagger$ | **`Sdag q[0]`**   |

## Description

S dagger gate

Rotation of $-\pi/2$ [rad] around the _z_-axis and a global phase of $-\pi/4$ [rad].

Clifford gate

## Representation

$$\begin{align}
S^\dagger &= R_\mathbf{n}\left([0, 0, 1]^T, -\frac{\pi}{2}, -\frac{\pi}{4}\right) = e^{-i\frac{\pi}{4}} \cdot e^{i\frac{\pi}{4} Z} \\
\\
S^\dagger &= \left(\begin{matrix}
1 & 0 \\
0 & -i 
\end{matrix}\right)
\end{align}$$
