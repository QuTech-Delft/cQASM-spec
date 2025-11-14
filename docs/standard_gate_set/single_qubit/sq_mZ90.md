# minus-Z90 gate

| Identifier | Operator   | Example statement |
|------------|------------|-------------------|
| mZ90       | $Z^{-1/2}$ | **`mZ90 q[0]`**   |

## Description

The minus-Z90 gate, _i.e._, the complex conjugate (inverse) of the [Z90 gate](sq_Z90.md),
is an anti-clockwise rotation of $-\pi / 2$ [rad] about the $\hat{\mathbf{z}}$-axis
and a global phase of $-\pi / 4$ [rad].

It is equal to the complex conjugate (inverse) of the S gate, the [S-dagger gate](sq_Sdag.md): $S^{\dagger} = Z^{-1/2}$.

### Aliases

Also known as the _S-dagger_ gate.

### Properties

- [Clifford gate](https://en.wikipedia.org/wiki/Clifford_gates)

## Representation

$$\begin{align}
Z^{-1/2} &= \left(\begin{matrix}
1 & 0 \\
0 & -i 
\end{matrix}\right)
\end{align}$$

Any single-qubit operation in $U(2)$ (including global phase) can be expressed by 5 parameters in the
[canonical representation $R_\hat{\mathbf{n}}$](sq_Rn.md)

$$R_\hat{\mathbf{n}}\left([n_x, n_y, n_z]^T, \theta, \phi\right) = e^{i\phi} \cdot e^{-i\frac{\theta}{2}\left(n_x\cdot\sigma_x + n_y\cdot\sigma_y + n_z\cdot\sigma_z\right)},$$

where $\hat{\mathbf{n}}=[n_x, n_y, n_z]^T$ denotes the axis of rotation, $\theta\in(-\pi, \pi]$ the angle of rotation [rad], and $\phi\in[0,2\pi)$ the global phase angle [rad].

The mZ90 gate is given by:

$$\begin{align}
Z^{-1/2} &= R_\hat{\mathbf{n}}\left([0, 0, 1]^T, -\frac{\pi}{2}, -\frac{\pi}{4}\right) = e^{-i\frac{\pi}{4}} \cdot e^{i\frac{\pi}{4}\sigma_z}, \\
\\
Z^{-1/2} &= \left(\begin{matrix}
1 & 0 \\
0 & -i 
\end{matrix}\right).
\end{align}$$

In the [Hadamard](sq_H.md) basis $\{|+\rangle, |-\rangle\}$, the mZ90 gate $Z^{-1/2}_H$ is given by:

$$Z^{-1/2}_H = HS^\dagger H = \frac{1}{2}\left(\begin{matrix}
1 - i & 1 + i \\ 
1 + i & 1 - i 
\end{matrix}\right)=X^{-1/2}.$$

## Operation examples

### Standard basis

$$\begin{align}
Z^{-1/2}\,|0\rangle &= |0\rangle \\
\\
Z^{-1/2}\,|1\rangle &= -i|1\rangle \\
\end{align}$$

### Hadamard basis

$$\begin{align}
Z^{-1/2}\,|+\rangle &= \frac{1 - i}{2}|+\rangle + \frac{1 + i}{2}|-\rangle \\
\\
Z^{-1/2}\,|-\rangle &= \frac{1 + i}{2}|+\rangle + \frac{1 - i}{2}|-\rangle \\
\end{align}$$
