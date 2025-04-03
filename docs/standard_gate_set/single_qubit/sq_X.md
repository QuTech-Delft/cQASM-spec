# Pauli-X gate

| Name | Operator | Example statement |
|------|----------|-------------------|
| X    | $X$      | **`X q[0]`**      |

## Description

Pauli-X gate

Rotation of $\pi$ [rad] around the _x_-axis and a global phase of $\pi/2$ [rad].

Clifford gate

## Representation

$$\begin{align}
X &= R_\mathbf{n}\left([1, 0, 0]^T, \pi, \frac{\pi}{2}\right) = e^{i\frac{\pi}{2}} \cdot e^{-i\frac{\pi}{2} X} \\
\\
X &= \left(\begin{matrix}
0 & 1 \\
1 & 0 
\end{matrix}\right)
\end{align}$$
