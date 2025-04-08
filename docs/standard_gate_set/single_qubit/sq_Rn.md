# Rn gate

| Identifier | Operator                                             | Example statement            |
|------------|------------------------------------------------------|------------------------------|
| Rn         | $R_\hat{\mathbf{n}}(\hat{\mathbf{n}}, \theta, \phi)$ | **`Rn(1,0,0,pi,pi/2) q[0]`** |

## Description

Rn gate

Rotation of angle $\theta$ about the specified axis $\hat{\mathbf{n}}=[n_x, n_y, n_z]^T$ and a global phase of $\phi$.

!!! note
    
    The **`Rn`** instruction expects the separate components of the axis $\hat{\mathbf{n}}$,
    _i.e._ $n_x$, $n_y$, and $n_z$, as input arguments: 

    **`Rn(`**$n_x$**`,`** $n_y$**`,`** $n_z$**`,`** $\theta$**`,`** $\phi$**`)`** _qubit-argument_

    as shown in the _**Example statement**_ in the table above.

## Representation

Any single-qubit operation in $U(2)$ (including global phase) can be described with 5 parameters by the following
[$R_\hat{\mathbf{n}}$ operation](../single_qubit/sq_Rn.md):

$$R_\hat{\mathbf{n}}\left([n_x, n_y, n_z]^T, \theta, \phi\right) = e^{i\phi} \cdot e^{-i\frac{\theta}{2}\left(n_x\cdot\sigma_x + n_y\cdot\sigma_y + n_z\cdot\sigma_z\right)},$$

where $\hat{\mathbf{n}}=[n_x, n_y, n_z]^T$ denotes the axis of rotation, $\theta\in(-\pi, \pi]$ the angle of rotation [rad], and $\phi\in[0,2\pi)$ the global phase angle [rad].

The Rn gate is given by:

$$
R_\hat{\mathbf{n}}\left(\hat{\mathbf{n}}, \theta, \phi\right) = \left(\begin{matrix}
\cos\left(\theta / 2\right) - i n_z \sin\left(\theta / 2\right) & -n_y \sin\left(\theta / 2\right) - i n_x \sin\left(\theta / 2\right) \\
n_y \sin\left(\theta / 2\right) - i n_x \sin\left(\theta / 2\right) &  \cos\left(\theta / 2\right) + i n_z \sin\left(\theta / 2\right)
\end{matrix}\right).
$$

In the [Hadamard](../single_qubit/sq_H.md) basis $\{|+\rangle, |-\rangle\}$, the Rn gate $R_{\hat{\mathbf{n}},H}(\theta)$ is given by:

$$R_\hat{\mathbf{n}}\left(\hat{\mathbf{n}}, \theta, \phi\right) = HR_\hat{\mathbf{n}}(\theta) H = \left(\begin{matrix}
\cos\left(\theta / 2\right) - i n_x \sin\left(\theta / 2\right) & n_y \sin\left(\theta / 2\right) - i n_z \sin\left(\theta / 2\right) \\
-n_y \sin\left(\theta / 2\right) - i n_z \sin\left(\theta / 2\right) &  \cos\left(\theta / 2\right) + i n_x \sin\left(\theta / 2\right)
\end{matrix}\right).$$

## Operation examples

### Standard basis

$$\begin{align}
R_\hat{\mathbf{n}}\left(\hat{\mathbf{n}}, \theta, \phi\right)\,|0\rangle &= \left[\cos\left(\theta / 2\right) - i n_z \sin\left(\theta / 2\right)\right]|0\rangle + \left[n_y \sin\left(\theta / 2\right) - i n_x \sin\left(\theta / 2\right)\right]|1\rangle \\
\\
R_\hat{\mathbf{n}}\left(\hat{\mathbf{n}}, \theta, \phi\right)\,|1\rangle &= \left[-n_y \sin\left(\theta / 2\right) - i n_x \sin\left(\theta / 2\right)\right]|0\rangle + \left[\cos\left(\theta / 2\right) + i n_z \sin\left(\theta / 2\right)\right]|1\rangle \\
\end{align}$$

### Hadamard basis

$$\begin{align}
R_\hat{\mathbf{n}}\left(\hat{\mathbf{n}}, \theta, \phi\right)\,|+\rangle &= \left[\cos\left(\theta / 2\right) - i n_x \sin\left(\theta / 2\right)\right]|+\rangle + \left[-n_y \sin\left(\theta / 2\right) - i n_z \sin\left(\theta / 2\right)\right]|-\rangle \\
\\
R_\hat{\mathbf{n}}\left(\hat{\mathbf{n}}, \theta, \phi\right)\,|-\rangle &= \left[n_y \sin\left(\theta / 2\right) - i n_z \sin\left(\theta / 2\right)\right]|+\rangle + \left[\cos\left(\theta / 2\right) + i n_x \sin\left(\theta / 2\right)\right]|-\rangle \\
\end{align}$$
