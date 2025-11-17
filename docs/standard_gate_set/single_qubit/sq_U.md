# U gate

| Identifier | Operator                   | Example statement           |
|------------|----------------------------|-----------------------------|
| U          | $U(\theta, \phi, \lambda)$ | **`U(pi/2,0,pi) q[0]`** |

## Description

The U gate can describe any element of $U(2)$ through the specification of the input parameters $\theta$, $\phi$,
and $\lambda$.
Notable examples of single-qubit operations in terms of $U(\theta, \phi, \lambda)$ are:

- [Identity gate](sq_I.md): $I = U(0,0,0)$,
- [Hadamard gate](sq_H.md): $H = U(\pi/2, 0, \pi)$,
- [Pauli-X gate](sq_X.md): $X = U(\pi, 0, \pi)$,
- [Pauli-Y gate](sq_Y.md): $Y = U(\pi, \pi / 2, \pi / 2)$,
- [Pauli-Z gate](sq_Z.md): $Z = U(0, \pi, 0)$.

## Representation

$$\begin{align}
U(\theta, \phi, \lambda) = \left(\begin{matrix}
\cos\left(\theta / 2\right) & -e^{i\lambda}\sin\left(\theta / 2\right) \\
e^{i\phi}\sin\left(\theta / 2\right) & e^{i\left(\phi + \lambda\right)}\cos\left(\theta / 2\right) 
\end{matrix}\right)
\end{align}$$

Any single-qubit operation in $U(2)$ (including global phase) can be expressed by 5 parameters in the
[canonical representation $R_\hat{\mathbf{n}}$](sq_Rn.md)

$$R_\hat{\mathbf{n}}\left([n_x, n_y, n_z]^T, \theta, \phi\right) = e^{i\phi} \cdot e^{-i\frac{\theta}{2}\left(n_x\cdot\sigma_x + n_y\cdot\sigma_y + n_z\cdot\sigma_z\right)},$$

where $\hat{\mathbf{n}}=[n_x, n_y, n_z]^T$ denotes the axis of rotation, $\theta\in(-\pi, \pi]$ the angle of rotation [rad], and $\phi\in[0,2\pi)$ the global phase angle [rad].

The U gate is given by:

$$\begin{equation}
U(\theta, \phi, \lambda) = R_\hat{\mathbf{n}}\left([0, 0, 1]^T, \phi, \frac{\phi + \lambda}{2}\right)\cdot R_\hat{\mathbf{n}}\left([0, 1, 0]^T, \theta, 0\right)\cdot R_\hat{\mathbf{n}}\left([0, 0, 1]^T, \lambda, 0\right), \\
\end{equation}$$

In the [Hadamard](sq_H.md) basis $\{|+\rangle, |-\rangle\}$, the U gate $U_H$ is given by:

$$U_H = HUH = \frac{1}{2}\left(\begin{matrix}
\,[e^{i \phi} - e^{i \lambda}] \sin(\theta/2) + [1 + e^{i \lambda + i \phi}] \cos(\theta/2) & [e^{i \lambda} + e^{i \phi}] \sin(\theta/2) + [1 - e^{i \lambda + i \phi}] \cos(\theta/2) \\
-[e^{i \lambda} + e^{i \phi}] \sin(\theta/2) + [1 - e^{i \lambda + i \phi}] \cos(\theta/2) & [e^{i \lambda} - e^{i \phi}] \sin(\theta/2) + [1 + e^{i \lambda + i \phi}] \cos(\theta/2)
\end{matrix}\right)$$

## Operation examples

### Standard basis

$$\begin{align}
U(\theta, \phi, \lambda)\,|0\rangle &= \cos\left(\theta / 2\right)|0\rangle  + e^{i\phi}\sin\left(\theta / 2\right)|1\rangle \\
\\
U(\theta, \phi, \lambda)\,|1\rangle &= -e^{i\lambda}\sin\left(\theta / 2\right)|0\rangle + e^{i\left(\phi + \lambda\right)}\cos\left(\theta / 2\right)|1\rangle \\
\end{align}$$

### Hadamard basis

$$\begin{align}
U(\theta, \phi, \lambda)\,|+\rangle &= \frac{[e^{i \phi} - e^{i \lambda}] \sin(\theta/2) + [1 + e^{i \lambda + i \phi}] \cos(\theta/2)}{2}|+\rangle - \frac{[e^{i \lambda} + e^{i \phi}] \sin(\theta/2) - [1 - e^{i \lambda + i \phi}] \cos(\theta/2)}{2}|-\rangle  \\
\\
U(\theta, \phi, \lambda)\,|-\rangle &= \frac{[e^{i \lambda} + e^{i \phi}] \sin(\theta/2) + [1 - e^{i \lambda + i \phi}] \cos(\theta/2)}{2}|+\rangle  + \frac{[e^{i \lambda} - e^{i \phi}] \sin(\theta/2) + [1 + e^{i \lambda + i \phi}] \cos(\theta/2)}{2}|-\rangle 
\end{align}$$
