# Pauli-Y gate

| Name | Operator | Example statement |
|------|----------|-------------------|
| Y    | $Y$      | **`Y q[0]`**      |

## Description

Pauli-Y gate

Rotation of $\pi$ [rad] around the _y_-axis and a global phase of $\pi/2$ [rad].

Clifford gate

## Representation

$$\begin{align}
Y &= R_\mathbf{n}\left([0, 1, 0]^T, \pi, \frac{\pi}{2}\right) = e^{i\frac{\pi}{2}} \cdot e^{-i\frac{\pi}{2} Y} \\
\\
Y &= \left(\begin{matrix}
0 & -i \\
i & 0 
\end{matrix}\right)
\end{align}$$
