# Pauli-Y gate

| Identifier | Operator | Example statement |
|------------|----------|-------------------|
| Y          | $Y$      | **`Y q[0]`**      |

## Description

The Pauli-Y, or Y, gate is an anti-clockwise rotation of $\pi$ [rad] about the $\hat{\mathbf{y}}$-axis and a global
phase of $\pi/2$ [rad].

### Properties

- [Clifford gate](https://en.wikipedia.org/wiki/Clifford_gates)

## Representation

$$Y = \sigma_y = \sigma_2 = \left(\begin{matrix}
0 & -i \\
i & 0 
\end{matrix}\right)$$

Any single-qubit operation in $U(2)$ (including global phase) can be expressed by 5 parameters in the
[canonical representation $R_\hat{\mathbf{n}}$](sq_Rn.md)

$$R_\hat{\mathbf{n}}\left([n_x, n_y, n_z]^T, \theta, \phi\right) = e^{i\phi} \cdot e^{-i\frac{\theta}{2}\left(n_x\cdot\sigma_x + n_y\cdot\sigma_y + n_z\cdot\sigma_z\right)},$$

where $\hat{\mathbf{n}}=[n_x, n_y, n_z]^T$ denotes the axis of rotation, $\theta\in(-\pi, \pi]$ the angle of rotation [rad], and $\phi\in[0,2\pi)$ the global phase angle [rad].

The Pauli-Y gate is given by:

$$\begin{align}
Y &= R_\hat{\mathbf{n}}\left([0, 1, 0]^T, \pi, \frac{\pi}{2}\right) = e^{i\frac{\pi}{2}} \cdot e^{-i\frac{\pi}{2}\sigma_y}, \\
\\
Y &= \left(\begin{matrix}
0 & -i \\
i & 0 
\end{matrix}\right).
\end{align}$$

In the [Hadamard](sq_H.md) basis $\{|+\rangle, |-\rangle\}$, the Pauli-Y gate $Y_H$ is given by:

$$Y_H = HYH = \left(\begin{matrix}
0 & i \\
-i & 0 
\end{matrix}\right)=-Y=Y^T.$$

## Operation examples

### Standard basis

$$\begin{align}
Y\,|0\rangle &= i|1\rangle \\
\\
Y\,|1\rangle &= -i|0\rangle \\
\end{align}$$

### Hadamard basis

$$\begin{align}
Y\,|+\rangle &= -i|-\rangle \\
\\
Y\,|-\rangle &= i|+\rangle 
\end{align}$$
