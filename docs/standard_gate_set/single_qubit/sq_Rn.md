# Rn gate

| Identifier | Operator                                      | Example statement            |
|------------|-----------------------------------------------|------------------------------|
| Rn         | $R_\mathbf{n}(n_x, n_y, n_z, \theta, \phi_g)$ | **`Rn(1,0,0,pi,pi/2) q[0]`** |

## Description

Rotation of angle $\theta$ about the specified axis $[n_x, n_y, n_z]^T$ and a global phase of $\phi$.

## Representation

Any single-qubit operation in $U(2)$ (including global phase) can be described with 5 parameters by the following:

$$R_\hat{\mathbf{n}}\left([n_x, n_y, n_z]^T, \theta, \phi\right) = e^{i\phi} \cdot e^{-i\frac{\theta}{2}\left(n_x\cdot\sigma_x + n_y\cdot\sigma_y + n_z\cdot\sigma_z\right)},$$

where $\hat{\mathbf{n}}=[n_x, n_y, n_z]^T$ denotes the axis of rotation, $\theta\in(-\pi, \pi]$ the angle of rotation [rad], and $\phi\in[0,2\pi)$ the global phase angle [rad].

The Rn gate is given by:

$$
R_\hat{\mathbf{n}}(\theta) = \left(\begin{matrix}
\cos\left(\theta / 2\right) - i n_z \sin\left(\theta / 2\right) & -n_y \sin\left(\theta / 2\right) - i n_x \sin\left(\theta / 2\right) \\
n_y \sin\left(\theta / 2\right) - i n_x \sin\left(\theta / 2\right) &  \cos\left(\theta / 2\right) + i n_z \sin\left(\theta / 2\right)
\end{matrix}\right).
$$

In the Hadamard basis $\{|+\rangle, |-\rangle\}$, the Rn gate $R_{\hat{\mathbf{n}},H}(\theta)$ is given by:

$$R_{\hat{\mathbf{n}},H}(\theta) = HR_\hat{\mathbf{n}}(\theta) H = \left(\begin{matrix}
\cos\left(\theta / 2\right) - i n_x \sin\left(\theta / 2\right) & n_y \sin\left(\theta / 2\right) - i n_z \sin\left(\theta / 2\right) \\
-n_y \sin\left(\theta / 2\right) - i n_z \sin\left(\theta / 2\right) &  \cos\left(\theta / 2\right) + i n_x \sin\left(\theta / 2\right)
\end{matrix}\right).$$

## Operation examples

### Standard basis

$$\begin{align}
R_\hat{\mathbf{n}}(\theta)\,|0\rangle &= \left[\cos\left(\theta / 2\right) - i n_z \sin\left(\theta / 2\right)\right]|0\rangle + \left[n_y \sin\left(\theta / 2\right) - i n_x \sin\left(\theta / 2\right)\right]|1\rangle \\
\\
R_\hat{\mathbf{n}}(\theta)\,|1\rangle &= \left[-n_y \sin\left(\theta / 2\right) - i n_x \sin\left(\theta / 2\right)\right]|0\rangle + \left[\cos\left(\theta / 2\right) + i n_z \sin\left(\theta / 2\right)\right]|1\rangle \\
\end{align}$$

### Hadamard basis

$$\begin{align}
R_\hat{\mathbf{n}}(\theta)\,|+\rangle &= \left[\cos\left(\theta / 2\right) - i n_x \sin\left(\theta / 2\right)\right]|+\rangle + \left[-n_y \sin\left(\theta / 2\right) - i n_z \sin\left(\theta / 2\right)\right]|-\rangle \\
\\
R_\hat{\mathbf{n}}(\theta)\,|-\rangle &= \left[n_y \sin\left(\theta / 2\right) - i n_z \sin\left(\theta / 2\right)\right]|+\rangle + \left[\cos\left(\theta / 2\right) + i n_x \sin\left(\theta / 2\right)\right]|-\rangle \\
\end{align}$$
