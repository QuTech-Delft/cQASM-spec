# Rz gate

| Name | Operator      | Example statement |
|------|---------------|-------------------|
| Rz   | $R_z(\theta)$ | **`Rz(pi) q[0]`** |

## Description

Rotation of angle $\theta$ around the _z_-axis and a global phase of $0$.

## Representation

$$\begin{align}
R_z &= R_\textbf{n}\left([0, 0, 1]^T, \theta, 0\right) = e^{-i\frac{\theta}{2} Z} \\
\\
R_z &= \left(\begin{matrix}
\cos\left(\theta / 2\right) - i \sin\left(\theta / 2\right) & 0 \\
0 &  \cos\left(\theta / 2\right) + i \sin\left(\theta / 2\right)
\end{matrix}\right)
\end{align}$$
