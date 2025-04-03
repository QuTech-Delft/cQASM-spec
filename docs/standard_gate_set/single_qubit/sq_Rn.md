# Rn gate

| Name | Operator                                      | Example statement            |
|------|-----------------------------------------------|------------------------------|
| Rn   | $R_\mathbf{n}(n_x, n_y, n_z, \theta, \phi_g)$ | **`Rn(1,0,0,pi,pi/2) q[0]`** |

## Description

Rotation of angle $\theta$ around specified axis $[n_x, n_y, n_z]^T$ and a global phase of $\phi$.

## Representation

$$\begin{align}
R_\mathbf{n} = R_\mathbf{n}\left([n_x, n_y, n_z]^T, \theta, \phi_g\right) = e^{i\phi_g} \cdot e^{i\theta\left(n_xX + n_yY + n_zZ\right)} \\
\\
R_\mathbf{n} &= \left(\begin{matrix}
\cos\left(\theta / 2\right) - i n_z \sin\left(\theta / 2\right) & -n_y \sin\left(\theta / 2\right) - i n_x \sin\left(\theta / 2\right) \\
n_y \sin\left(\theta / 2\right) - i n_x \sin\left(\theta / 2\right) &  \cos\left(\theta / 2\right) + i n_z \sin\left(\theta / 2\right)
\end{matrix}\right)
\end{align}$$
