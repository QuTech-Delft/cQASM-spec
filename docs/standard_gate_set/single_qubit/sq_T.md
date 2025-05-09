# T gate

| Identifier | Operator | Example statement |
|------------|----------|-------------------|
| T          | $T$      | **`T q[0]`**      |

## Description

The T gate is an anti-clockwise rotation of $\pi / 4$ [rad] about the $\hat{\mathbf{z}}$-axis and
a global phase of $\pi / 8$ [rad]. 

It is equal to _half_ the $S$ rotation and a _quarter_ of the $Z$ rotation: $T = S^{1/2} = Z^{1/4}$.

## Representation

$$\begin{align}
T &= \left(\begin{matrix}
1 & 0 \\
0 & \frac{1 + i}{\sqrt{2}} 
\end{matrix}\right)
\end{align}$$

Any single-qubit operation in $U(2)$ (including global phase) can be expressed by 5 parameters in the
[canonical representation $R_\hat{\mathbf{n}}$](sq_Rn.md)

$$R_\hat{\mathbf{n}}\left([n_x, n_y, n_z]^T, \theta, \phi\right) = e^{i\phi} \cdot e^{-i\frac{\theta}{2}\left(n_x\cdot\sigma_x + n_y\cdot\sigma_y + n_z\cdot\sigma_z\right)},$$

where $\hat{\mathbf{n}}=[n_x, n_y, n_z]^T$ denotes the axis of rotation, $\theta\in(-\pi, \pi]$ the angle of rotation [rad], and $\phi\in[0,2\pi)$ the global phase angle [rad].

The T gate is given by:

$$\begin{align}
T &= R_\hat{\mathbf{n}}\left([0, 0, 1]^T, \frac{\pi}{4}, \frac{\pi}{8}\right) = e^{i\frac{\pi}{8}} \cdot e^{-i\frac{\pi}{8}\sigma_z}, \\
\\
T &= \left(\begin{matrix}
1 & 0 \\
0 & \frac{1 + i}{\sqrt{2}} 
\end{matrix}\right).
\end{align}$$

In the [Hadamard](sq_H.md) basis $\{|+\rangle, |-\rangle\}$, the T gate $T_H$ is given by:

$$T_H = HT H = \frac{1}{2\sqrt{2}}\left(\begin{matrix}
\sqrt{2} + 1 + i & \sqrt{2} - 1 - i \\ 
\sqrt{2} - 1 - i & \sqrt{2} + 1 + i
\end{matrix}\right).$$

## Operation examples

### Standard basis

$$\begin{align}
T\,|0\rangle &= |0\rangle \\
\\
T\,|1\rangle &= \frac{1 + i}{\sqrt{2}} |1\rangle \\
\end{align}$$

### Hadamard basis

$$\begin{align}
T\,|+\rangle &= \frac{\sqrt{2} + 1 + i}{2\sqrt{2}}|+\rangle + \frac{\sqrt{2} - 1 - i}{2\sqrt{2}}|-\rangle \\
\\
T\,|-\rangle &= \frac{\sqrt{2} - 1 - i}{2\sqrt{2}}|+\rangle + \frac{\sqrt{2} + 1 + i}{2\sqrt{2}}|-\rangle \\
\end{align}$$
