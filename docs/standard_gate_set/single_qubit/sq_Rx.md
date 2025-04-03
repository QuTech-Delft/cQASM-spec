# Rx gate

| Name | Operator      | Example statement |
|------|---------------|-------------------|
| Rx   | $R_x(\theta)$ | **`Rx(pi) q[0]`** |

## Description

Rotation of angle $\theta$ around the _x_-axis and a global phase of $0$.

## Representation

$$\begin{align}
R_x &= R_\textbf{n}\left([1, 0, 0]^T, \theta, 0\right) = e^{-i\frac{\theta}{2} X} \\
\\
R_x &= \left(\begin{matrix}
\cos\left(\theta / 2\right) & - i \sin\left(\theta / 2\right) \\
- i \sin\left(\theta / 2\right) &  \cos\left(\theta / 2\right)
\end{matrix}\right)
\end{align}$$
