# Hadamard gate

| Name | Operator | Example statement |
|------|----------|-------------------|
| H    | $H$      | **`H q[0]`**      |

## Description

Hadamard gate

Clifford gate

## Representation

Any single-qubit operation in $U(2)$ (including global phase) can be described with 5 parameters by the following:

$$R_\hat{\mathbf{n}}\left([n_x, n_y, n_z]^T, \theta, \phi\right) = e^{i\phi} \cdot e^{-i\frac{\theta}{2}\left(n_x\cdot\sigma_x + n_y\cdot\sigma_y + n_z\cdot\sigma_z\right)},$$

where $\hat{\mathbf{n}}=[n_x, n_y, n_z]^T$ denotes the axis of rotation, $\theta\in(-\pi, \pi]$ the angle of rotation [rad], and $\phi\in[0,2\pi)$ the global phase angle [rad].

The Hadamard gate is given by:

$$\begin{align}
H &= R_\hat{\mathbf{n}}\left(\left[\frac{1}{\sqrt{2}}, 0, \frac{1}{\sqrt{2}}\right]^T, \pi, \frac{\pi}{2}\right) = e^{i\frac{\pi}{2}} \cdot e^{-i\frac{\pi}{2\sqrt{2}}\left(\sigma_x + \sigma_z\right)}, \\
\\
H &= \frac{1}{\sqrt{2}}\left(\begin{matrix}
1 & 1 \\
1 & -1 
\end{matrix}\right).
\end{align}$$

In the Hadamard basis $\{|+\rangle, |-\rangle\}$, the Hadamard gate $H_H$ is given by:

$$H_H = HHH = \frac{1}{\sqrt{2}}\left(\begin{matrix}
1 & 1 \\
1 & -1 
\end{matrix}\right)=H.$$

## Operation examples

### Standard basis

$$\begin{align}
H\,|0\rangle &= \frac{1}{\sqrt{2}}|0\rangle + \frac{1}{\sqrt{2}}|1\rangle = |+\rangle \\
\\
H\,|1\rangle &= \frac{1}{\sqrt{2}}|0\rangle - \frac{1}{\sqrt{2}}|1\rangle = |-\rangle \\
\end{align}$$

### Hadamard basis

$$\begin{align}
H\,|+\rangle &=  \frac{1}{\sqrt{2}}|+\rangle + \frac{1}{\sqrt{2}}|-\rangle = |0\rangle \\
\\
H\,|-\rangle &=  \frac{1}{\sqrt{2}}|+\rangle - \frac{1}{\sqrt{2}}|-\rangle = |1\rangle 
\end{align}$$
