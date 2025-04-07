# Rx gate

| Identifier | Operator      | Example statement |
|------------|---------------|-------------------|
| Rx         | $R_x(\theta)$ | **`Rx(pi) q[0]`** |

## Description

Rotation of angle $\theta$ about the _x_-axis and a global phase of $0$.

## Representation

Any single-qubit operation in $U(2)$ (including global phase) can be described with 5 parameters by the following:

$$R_\hat{\mathbf{n}}\left([n_x, n_y, n_z]^T, \theta, \phi\right) = e^{i\phi} \cdot e^{-i\frac{\theta}{2}\left(n_x\cdot\sigma_x + n_y\cdot\sigma_y + n_z\cdot\sigma_z\right)},$$

where $\hat{\mathbf{n}}=[n_x, n_y, n_z]^T$ denotes the axis of rotation, $\theta\in(-\pi, \pi]$ the angle of rotation [rad], and $\phi\in[0,2\pi)$ the global phase angle [rad].

The Rx gate is given by:

$$\begin{align}
R_x(\theta) &= R_\hat{\mathbf{n}}\left([1, 0, 0]^T, \theta, 0\right) = e^{-i\frac{\theta}{2}\sigma_x}, \\
\\
R_x(\theta) &= \left(\begin{matrix}
\cos\left(\theta / 2\right) & - i \sin\left(\theta / 2\right) \\
- i \sin\left(\theta / 2\right) &  \cos\left(\theta / 2\right)
\end{matrix}\right).
\end{align}$$

In the Hadamard basis $\{|+\rangle, |-\rangle\}$, the Rx gate $R_{x,H}$ is given by:

$$R_{x,H}(\theta) = HR_x(\theta) H = \left(\begin{matrix}
\cos\left(\theta / 2\right) - i \sin\left(\theta / 2\right) & 0 \\
0 &  \cos\left(\theta / 2\right) + i \sin\left(\theta / 2\right)
\end{matrix}\right) = R_z(\theta).$$

## Operation examples

### Standard basis

$$\begin{align}
R_x(\theta)\,|0\rangle &= \cos\left(\theta / 2\right)|0\rangle - i \sin\left(\theta / 2\right)|1\rangle\\
\\
R_x(\theta)\,|1\rangle &= - i \sin\left(\theta / 2\right)|0\rangle + \cos\left(\theta / 2\right)|1\rangle\\
\end{align}$$

### Hadamard basis

$$\begin{align}
R_x(\theta)\,|+\rangle &= \left[\cos\left(\theta / 2\right) - i \sin\left(\theta / 2\right)\right]|+\rangle \\
\\
R_x(\theta)\,|-\rangle &= \left[\cos\left(\theta / 2\right) + i \sin\left(\theta / 2\right)\right]|-\rangle \\
\end{align}$$
