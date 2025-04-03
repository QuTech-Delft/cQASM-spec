# Phase gate

| Name | Operator | Example statement |
|------|----------|-------------------|
| S    | $S$      | **`S q[0]`**      |

## Description

Phase gate or S gate

Rotation of $\pi/2$ [rad] around the _z_-axis and a global phase of $\pi/4$ [rad].

Clifford gate

## Representation

$$\begin{align}
S &= R_\mathbf{n}\left([0, 0, 1]^T, \frac{\pi}{2}, \frac{\pi}{4}\right) = e^{i\frac{\pi}{4}} \cdot e^{-i\frac{\pi}{4} Z} \\
\\
S &= \left(\begin{matrix}
1 & 0 \\
0 & i 
\end{matrix}\right)
\end{align}$$
