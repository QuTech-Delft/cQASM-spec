# Pauli-Z gate

| Name | Operator | Example statement |
|------|----------|-------------------|
| Z    | $Z$      | **`Z q[0]`**      |

## Description

Pauli-Z gate

Phase-flip

Rotation of $\pi$ [rad] about the _z_-axis and a global phase of $\pi/2$ [rad].

Clifford gate

## Representation

Any single-qubit operation in $U(2)$ (including global phase) can be described with 5 parameters by the following:

$$R_\hat{\mathbf{n}}\left([n_x, n_y, n_z]^T, \theta, \phi\right) = e^{i\phi} \cdot e^{-i\frac{\theta}{2}\left(n_x\cdot\sigma_x + n_y\cdot\sigma_y + n_z\cdot\sigma_z\right)},$$

where $\hat{\mathbf{n}}=[n_x, n_y, n_z]^T$ denotes the axis of rotation, $\theta\in(-\pi, \pi]$ the angle of rotation [rad], and $\phi\in[0,2\pi)$ the global phase angle [rad].

The Pauli-Z gate is given by:

$$\begin{align}
Z &= R_\hat{\mathbf{n}}\left([0, 0, 1]^T, \pi, \frac{\pi}{2}\right) = e^{i\frac{\pi}{2}} \cdot e^{-i\frac{\pi}{2}\sigma_z}, \\
\\
Z &= \left(\begin{matrix}
1 & 0 \\
0 & -1 
\end{matrix}\right).
\end{align}$$

In the Hadamard basis $\{|+\rangle, |-\rangle\}$, the Pauli-Z gate $Z_H$ is given by:

$$Z_H = HZH = \left(\begin{matrix}
0 & 1 \\
1 & 0 
\end{matrix}\right)=X.$$

## Operation examples

### Standard basis

$$\begin{align}
Z\,|0\rangle &= |0\rangle \\
\\
Z\,|1\rangle &= -|1\rangle \\
\end{align}$$

### Hadamard basis

$$\begin{align}
Z\,|+\rangle &= |-\rangle \\
\\
Z\,|-\rangle &= |+\rangle 
\end{align}$$
