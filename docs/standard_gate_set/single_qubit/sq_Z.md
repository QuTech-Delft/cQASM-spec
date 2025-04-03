# Pauli-Z gate

| Name | Operator | Example statement |
|------|----------|-------------------|
| Z    | $Z$      | **`Z q[0]`**      |

## Description

Pauli-Z gate

Rotation of $\pi$ [rad] around the _z_-axis and a global phase of $\pi/2$ [rad].

Clifford gate

## Representation

$$\begin{align}
Z &= R_\mathbf{n}\left([0, 0, 1]^T, \pi, \frac{\pi}{2}\right) = e^{i\frac{\pi}{2}} \cdot e^{-i\frac{\pi}{2} Z} \\
\\
Z &= \left(\begin{matrix}
1 & 0 \\
0 & -1 
\end{matrix}\right)
\end{align}$$
