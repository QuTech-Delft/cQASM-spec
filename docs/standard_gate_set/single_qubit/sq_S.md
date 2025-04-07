# S gate

| Identifier | Operator | Example statement |
|------------|----------|-------------------|
| S          | $S$      | **`S q[0]`**      |

## Description

Phase gate or S gate

$S = Z^{1/2}$

Rotation of $\pi/2$ [rad] about the _z_-axis and a global phase of $\pi/4$ [rad].

Clifford gate

## Representation

Any single-qubit operation in $U(2)$ (including global phase) can be described with 5 parameters by the following:

$$R_\hat{\mathbf{n}}\left([n_x, n_y, n_z]^T, \theta, \phi\right) = e^{i\phi} \cdot e^{-i\frac{\theta}{2}\left(n_x\cdot\sigma_x + n_y\cdot\sigma_y + n_z\cdot\sigma_z\right)},$$

where $\hat{\mathbf{n}}=[n_x, n_y, n_z]^T$ denotes the axis of rotation, $\theta\in(-\pi, \pi]$ the angle of rotation [rad], and $\phi\in[0,2\pi)$ the global phase angle [rad].

The Phase gate is given by:

$$\begin{align}
S &= R_\hat{\mathbf{n}}\left([0, 0, 1]^T, \frac{\pi}{2}, \frac{\pi}{4}\right) = e^{i\frac{\pi}{4}} \cdot e^{-i\frac{\pi}{4}\sigma_z}, \\
\\
S &= \left(\begin{matrix}
1 & 0 \\
0 & i 
\end{matrix}\right).
\end{align}$$

In the Hadamard basis $\{|+\rangle, |-\rangle\}$, the Phase gate $S_H$ is given by:

$$S_H = HSH = \frac{1}{2}\left(\begin{matrix}
1 + i & 1 - i \\ 
1 - i & 1 + i 
\end{matrix}\right)=X^{1/2}.$$

## Operation examples

### Standard basis

$$\begin{align}
S\,|0\rangle &= |0\rangle \\
\\
S\,|1\rangle &= i|1\rangle \\
\end{align}$$

### Hadamard basis

$$\begin{align}
S\,|+\rangle &= \frac{1 + i}{2}|+\rangle + \frac{1 - i}{2}|-\rangle \\
\\
S\,|-\rangle &= \frac{1 - i}{2}|+\rangle + \frac{1 + i}{2}|-\rangle \\
\end{align}$$
