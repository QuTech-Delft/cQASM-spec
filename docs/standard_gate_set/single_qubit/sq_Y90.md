# Y90 gate

| Name | Operator  | Example statement |
|------|-----------|-------------------|
| Y90  | $Y^{1/2}$ | **`Y90 q[0]`**    |

## Description

Y90 gate

$Y^{1/2}$

Rotation of $\pi/2$ [rad] about the _y_-axis and a global phase of $\pi/4$ [rad].

Clifford gate

## Representation

Any single-qubit operation in $U(2)$ (including global phase) can be described with 5 parameters by the following:

$$R_\hat{\mathbf{n}}\left([n_x, n_y, n_z]^T, \theta, \phi\right) = e^{i\phi} \cdot e^{-i\frac{\theta}{2}\left(n_x\cdot\sigma_x + n_y\cdot\sigma_y + n_z\cdot\sigma_z\right)},$$

where $\hat{\mathbf{n}}=[n_x, n_y, n_z]^T$ denotes the axis of rotation, $\theta\in(-\pi, \pi]$ the angle of rotation [rad], and $\phi\in[0,2\pi)$ the global phase angle [rad].

The Y90 gate is given by:

$$\begin{align}
Y^{1/2} &= R_\hat{\mathbf{n}}\left([0, 1, 0]^T, \frac{\pi}{2}, \frac{\pi}{4}\right) = e^{i\frac{\pi}{4}} \cdot e^{-i\frac{\pi}{4}\sigma_y}, \\
\\
Y^{1/2} &= \frac{1}{2}\left(\begin{matrix}
1 + i & -1 - i \\
1 + i & 1 + i 
\end{matrix}\right).
\end{align}$$

In the Hadamard basis $\{|+\rangle, |-\rangle\}$, the Y90 gate $Y^{1/2}_H$ is given by:

$$Y^{1/2}_H = HY^{1/2}H = \frac{1}{2}\left(\begin{matrix}
1 + i & 1 + i \\
-1 - i & 1 + i 
\end{matrix}\right)=(Y^{1/2})^T.$$

## Operation examples

### Standard basis

$$\begin{align}
Y^{1/2}\,|0\rangle &= \frac{1 + i}{2}|0\rangle + \frac{1 + i}{2}|1\rangle \\
\\
Y^{1/2}\,|1\rangle &= \frac{-1 - i}{2}|0\rangle + \frac{1 + i}{2}|1\rangle \\
\end{align}$$

### Hadamard basis

$$\begin{align}
Y^{1/2}\,|+\rangle &= \frac{1 + i}{2}|+\rangle + \frac{-1 - i}{2}|-\rangle \\
\\
Y^{1/2}\,|-\rangle &= \frac{1 + i}{2}|+\rangle + \frac{1 + i}{2}|-\rangle \\
\end{align}$$
