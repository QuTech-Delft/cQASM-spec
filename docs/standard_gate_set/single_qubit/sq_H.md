# Hadamard gate

| Identifier | Operator | Example statement |
|------------|----------|-------------------|
| H          | $H$      | **`H q[0]`**      |

## Description

The Hadamard, or H, gate is an anti-clockwise rotation with an angle of $\pi$ [rad] about the combined
$(\hat{\mathbf{x}}+\hat{\mathbf{z}})$-axis.

It is a single-qubit operation that maps the computational basis state $|0\rangle \to
\left(|0\rangle + |1\rangle\right)/\sqrt{2}$ and $|1\rangle \to \left(|0\rangle - |1\rangle\right)/\sqrt{2}$,
thus creating an equal superposition of the two basis states.

The $X$-basis states:

$$|+\rangle = \frac{|0\rangle + |1\rangle}{\sqrt{2}},~~~~|-\rangle =|\frac{|0\rangle - |1\rangle}{\sqrt{2}},$$

form the Hadamard basis $\{|+\rangle ,|-\rangle \}$.

### Properties

- [Clifford gate](https://en.wikipedia.org/wiki/Clifford_gates); 
- [Involutory](https://en.wikipedia.org/wiki/Involutory_matrix) operation (its own inverse).

### Decompositions

#### XY-basis

The Hadamard gate can be expressed as an anti-clockwise $\pi/2$ [rad] rotation around the $\hat{\mathbf{y}}$-axis,
equivalent to a [Y90 gate](sq_Y90.md),
followed by a [Pauli-X gate](sq_X.md): 

$$H = X \cdot R_y\left(\frac{\pi}{2}\right) \simeq XY^{1/2},$$

or -from the anti-commutation relation- by: 

$$H = R_y\left(-\frac{\pi}{2}\right) \cdot X \simeq Y^{-1/2}X,$$

where a [minus-Y90 gate](sq_mY90.md) is used.

#### YZ-basis

Similarly, the Hadamard gate can be decomposed in the $YZ$-basis:

$$H = Z \cdot R_y\left(-\frac{\pi}{2}\right) \simeq ZY^{-1/2},$$

or by: 

$$H = R_y\left(\frac{\pi}{2}\right) \cdot Z \simeq Y^{1/2}Z.$$

!!! note

    The _equals_ symbol ($=$) signifies that the decomposition is equal including the global phase.
    The _similar-equals_ symbol ($\simeq$) signifies that the decomposition is equal up to a global phase difference.

## Representation

$$H = \frac{1}{\sqrt{2}}\left(\begin{matrix}
1 & 1 \\
1 & -1 
\end{matrix}\right)$$

Any single-qubit operation in $U(2)$ (including global phase) can be expressed by 5 parameters in the
[canonical representation $R_\hat{\mathbf{n}}$](sq_Rn.md)

$$R_\hat{\mathbf{n}}\left([n_x, n_y, n_z]^T, \theta, \phi\right) = e^{i\phi} \cdot e^{-i\frac{\theta}{2}\left(n_x\cdot\sigma_x + n_y\cdot\sigma_y + n_z\cdot\sigma_z\right)},$$

where $\hat{\mathbf{n}}=[n_x, n_y, n_z]^T$ denotes the axis of rotation, $\theta\in(-\pi, \pi]$ the anti-clockwise angle of rotation [rad], and $\phi\in[0,2\pi)$ the global phase angle [rad].

The Hadamard gate is given by:

$$\begin{align}
H &= R_\hat{\mathbf{n}}\left(\left[\frac{1}{\sqrt{2}}, 0, \frac{1}{\sqrt{2}}\right]^T, \pi, \frac{\pi}{2}\right) = e^{i\frac{\pi}{2}} \cdot e^{-i\frac{\pi}{2\sqrt{2}}\left(\sigma_x + \sigma_z\right)} \\
\\
 &= \frac{1}{\sqrt{2}}\left(\begin{matrix}
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
