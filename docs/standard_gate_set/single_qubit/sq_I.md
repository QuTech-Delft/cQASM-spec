# Identity gate

| Identifier | Operator | Example statement |
|------------|----------|-------------------|
| I          | $I$      | **`I q[0]`**      |

## Description

The Identity gate is a gate that leaves the qubit state unchanged
([NOP](https://en.wikipedia.org/wiki/NOP_(code))).

!!! note

    Internally, an identity gate may be defined as a rotation of $0$ radians about the _z_-axis and a global phase of
    $0$.

### Properties

- [Clifford gate](https://en.wikipedia.org/wiki/Clifford_gates);
- [Involutory](https://en.wikipedia.org/wiki/Involutory_matrix) operation (its own inverse);
- [Special Unitary $SU$](https://en.wikipedia.org/wiki/Special_unitary_group).

## Representation

$$I = \left(\begin{matrix}
1 & 0 \\
0 & 1 
\end{matrix}\right)$$

Any single-qubit operation in $U(2)$ (including global phase) can be expressed by 5 parameters in the
[canonical representation $R_\hat{\mathbf{n}}$](sq_Rn.md)

$$R_\hat{\mathbf{n}}\left([n_x, n_y, n_z]^T, \theta, \phi\right) = e^{i\phi} \cdot e^{-i\frac{\theta}{2}\left(n_x\cdot\sigma_x + n_y\cdot\sigma_y + n_z\cdot\sigma_z\right)},$$

where $\hat{\mathbf{n}}=[n_x, n_y, n_z]^T$ denotes the axis of rotation, $\theta\in(-\pi, \pi]$ the anti-clockwise angle of rotation [rad], and $\phi\in[0,2\pi)$ the global phase angle [rad].

The Identity gate can be represented in canonical form as:

$$\begin{align}
I &= R_\hat{\mathbf{n}}\left(\left[0, 0, 1\right]^T, 0, 0\right) \\
\\
 &= \left(\begin{matrix}
1 & 0 \\
0 & 1 
\end{matrix}\right).
\end{align}$$

In the [Hadamard](sq_H.md) basis $\{|+\rangle, |-\rangle\}$, the Identity gate $I_H$ is given by:

$$I_H = HIH = \left(\begin{matrix}
1 & 0 \\
0 & 1 
\end{matrix}\right)=I.$$

## Operation examples

### Standard basis

$$\begin{align}
I\,|0\rangle &= |0\rangle \\
\\
I\,|1\rangle &= |1\rangle \\
\end{align}$$

### Hadamard basis

$$\begin{align}
I\,|+\rangle &= |+\rangle \\
\\
I\,|-\rangle &= |-\rangle 
\end{align}$$
