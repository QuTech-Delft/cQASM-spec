# Ry gate

| Name | Operator      | Example statement |
|------|---------------|-------------------|
| Ry   | $R_y(\theta)$ | **`Ry(pi) q[0]`** |

## Description

Rotation of angle $\theta$ around the _y_-axis and a global phase of $0$.

## Representation

$$\begin{align}
R_y &= R_\textbf{n}\left([0, 1, 0]^T, \theta, 0\right) = e^{-i\frac{\theta}{2} Y} \\
\\
R_y &= \left(\begin{matrix}
\cos\left(\theta / 2\right) & -\sin\left(\theta / 2\right) \\
\sin\left(\theta / 2\right) &  \cos\left(\theta / 2\right)
\end{matrix}\right)
\end{align}$$
