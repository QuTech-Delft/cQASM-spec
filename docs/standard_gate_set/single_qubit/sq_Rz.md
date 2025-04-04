# Rz gate

| Name | Operator      | Example statement |
|------|---------------|-------------------|
| Rz   | $R_z(\theta)$ | **`Rz(pi) q[0]`** |

## Description

Rotation of angle $\theta$ about the _z_-axis and a global phase of $0$.

## Representation

Any single-qubit operation in $U(2)$ (including global phase) can be described with 5 parameters by the following:

$$R_\hat{\mathbf{n}}\left([n_x, n_y, n_z]^T, \theta, \phi\right) = e^{i\phi} \cdot e^{-i\frac{\theta}{2}\left(n_x\cdot\sigma_x + n_y\cdot\sigma_y + n_z\cdot\sigma_z\right)},$$

where $\hat{\mathbf{n}}=[n_x, n_y, n_z]^T$ denotes the axis of rotation, $\theta\in(-\pi, \pi]$ the angle of rotation [rad], and $\phi\in[0,2\pi)$ the global phase angle [rad].

The Rz gate is given by:

$$\begin{align}
R_z &= R_\hat{\mathbf{n}}\left([0, 0, 1]^T, \theta, 0\right) = e^{-i\frac{\theta}{2}\sigma_z}, \\
\\
R_z &= \left(\begin{matrix}
\cos\left(\theta / 2\right) - i \sin\left(\theta / 2\right) & 0 \\
0 &  \cos\left(\theta / 2\right) + i \sin\left(\theta / 2\right)
\end{matrix}\right).
\end{align}$$
