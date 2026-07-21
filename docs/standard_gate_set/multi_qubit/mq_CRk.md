# Parametrized controlled phase shift gate

| Identifier | Operator      | Example statement       |
|------------|---------------|-------------------------|
| CRk        | $CRk(\theta)$ | **`CRk(2) q[0], q[1]`** |

## Description

The parametrized controlled phase shift, or CRk, gate is a two-qubit gate. 
It is the parametrized version of the [controlled phase shift gate](mq_CRk.md), with angle $\theta$,
parametrized by an integer $k$: $\theta(k) = \frac{2\pi}{2^k}$.

The CRk gate is especially useful for calculating the Quantum Fourier Transform.

Special cases of the CRk gate include:

- $I = CR_k(0)$,
- $CZ = CR_k(1)$,
- $CR(2\pi/2^k) = CR_k(k)$.

## Properties

- Ising gate.

## Representation

$$\begin{align}
CR_k(k) &= \left(\begin{matrix}
1 & 0 & 0 &  0 \\
0 & 1 & 0 &  0 \\
0 & 0 & 1 &  0 \\
0 & 0 & 0 & e^{i\frac{2\pi}{2^k}} 
\end{matrix}\right)
\end{align}$$

which is equal to:

$$CR_k(k) = |0\rangle\langle 0| \otimes I + |1\rangle\langle 1| \otimes R_k(k),$$

with

$$R_k(k) = \left(\begin{matrix}
1 & 0  \\
0 & e^{i\frac{2\pi}{2^k}}  
\end{matrix}\right).$$

## Operation examples

### Standard basis

$$\begin{align}
CR_k(k)\,|00\rangle &= |00\rangle \\
\\
CR_k(k)\,|01\rangle &= |01\rangle \\
\\
CR_k(k)\,|10\rangle &= |10\rangle \\
\\
CR_k(k)\,|11\rangle &= e^{i\frac{2\pi}{2^k}}|11\rangle \\
\end{align}$$

!!! Note "Qubit state ordering"

    Note that [qubits in a ket are ordered](../../language_specification/index.md#qubit-state-and-measurement-bit-ordering)
    with qubit indices decreasing from left to right, _i.e._,

!!! Note "Qubit state ordering and matrix representation"

Note that [qubits in a ket in OpenSquirrel are ordered](../../language_specification/index.md#qubit-state-and-measurement-bit-ordering)
with qubit indices decreasing from left to right (little endian ordering), _i.e._,

$$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$

For the matrix representation given above, we use the standard textbook _big endian ordering_ of qubits, see the [CNOT gate for a more detailed explanation](mq_CNOT.md). 
