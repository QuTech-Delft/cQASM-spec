# Ry gate

| Identifier | Operator      | Example statement |
|------------|---------------|-------------------|
| Ry         | $R_y(\theta)$ | **`Ry(pi) q[0]`** |

## Description

Rotation of angle $\theta$ about the _y_-axis and a global phase of $0$.

## Representation

Any single-qubit operation in $U(2)$ (including global phase) can be described with 5 parameters by the following:

$$R_\hat{\mathbf{n}}\left([n_x, n_y, n_z]^T, \theta, \phi\right) = e^{i\phi} \cdot e^{-i\frac{\theta}{2}\left(n_x\cdot\sigma_x + n_y\cdot\sigma_y + n_z\cdot\sigma_z\right)},$$

where $\hat{\mathbf{n}}=[n_x, n_y, n_z]^T$ denotes the axis of rotation, $\theta\in(-\pi, \pi]$ the angle of rotation [rad], and $\phi\in[0,2\pi)$ the global phase angle [rad].

The Ry gate is given by:

$$\begin{align}
R_y &= R_\hat{\mathbf{n}}\left([0, 1, 0]^T, \theta, 0\right) = e^{-i\frac{\theta}{2}\sigma_y}, \\
\\
R_y &= \left(\begin{matrix}
\cos\left(\theta / 2\right) & -\sin\left(\theta / 2\right) \\
\sin\left(\theta / 2\right) &  \cos\left(\theta / 2\right)
\end{matrix}\right).
\end{align}$$

In the Hadamard basis $\{|+\rangle, |-\rangle\}$, the Ry gate $R_{y,H}$ is given by:

$$R_{y,H}(\theta) = HR_z(\theta) H = \left(\begin{matrix}
\cos\left(\theta / 2\right) & \sin\left(\theta / 2\right) \\
-\sin\left(\theta / 2\right) &  \cos\left(\theta / 2\right)
\end{matrix}\right) = R_y(-\theta) = R_y(\theta)^T.$$

## Operation examples

### Standard basis

$$\begin{align}
R_y(\theta)\,|0\rangle &= \cos\left(\theta / 2\right)|0\rangle + \sin\left(\theta / 2\right)|1\rangle \\
\\
R_y(\theta)\,|1\rangle &= -\sin\left(\theta / 2\right)|0\rangle + \cos\left(\theta / 2\right)|1\rangle \\
\end{align}$$

### Hadamard basis

$$\begin{align}
R_y(\theta)\,|+\rangle &= \cos\left(\theta / 2\right)|+\rangle - \sin\left(\theta / 2\right)|-\rangle \\
\\
R_y(\theta)\,|-\rangle &= \sin\left(\theta / 2\right)|+\rangle + \cos\left(\theta / 2\right)|-\rangle \\
\end{align}$$

