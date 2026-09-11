# Controlled phase shift gate

| Identifier | Operator     | Example statement       |
|------------|--------------|-------------------------|
| CR         | $CR(\theta)$ | **`CR(pi) q[0], q[1]`** |

## Description

The Controlled phase shift, or CR, gate is a two-qubit gate.
It is the controlled version of the phase shift gate, with angle $\theta$ (radians). 

The CR gate is a generalization of the [CZ gate](mq_CZ.md): $CZ = CR(\pi)$

## Properties

- Ising gate.

## Representation

$$\begin{align}
CR(\theta) &= \left(\begin{matrix}
1 & 0 & 0 &  0 \\
0 & 1 & 0 &  0 \\
0 & 0 & 1 &  0 \\
0 & 0 & 0 & e^{i\theta} 
\end{matrix}\right)
\end{align}$$

which is equal to:

$$CR(\theta) = |0\rangle\langle 0| \otimes I + |1\rangle\langle 1| \otimes R(\theta),$$

with

$$R(\theta) = \left(\begin{matrix}
1 & 0  \\
0 & e^{i\theta}  
\end{matrix}\right).$$

## Operation examples

### Standard basis

$$\begin{align}
CR(\theta)\,|00\rangle &= |00\rangle \\
\\
CR(\theta)\,|01\rangle &= |01\rangle \\
\\
CR(\theta)\,|10\rangle &= |10\rangle \\
\\
CR(\theta)\,|11\rangle &= e^{i\theta}|11\rangle \\
\end{align}$$

!!! Note "Qubit state ordering convention and matrix representation"

    Note that [qubits in a ket are ordered](../../language_specification/index.md#qubit-state-ordering-measurement-bit-ordering-and-matrix-representation)
    with qubit indices decreasing from left to right, _i.e._,

    $$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$

    Note that for matrices a **reversed** basis ordering convention is adopted, as is done in most textbooks.
    For instance, in the case of a two-qubit control gate, 
    the matrix is represented such that $q_0$ is the _control_ qubit
    and $q_1$ is the _target_ qubit;
    the state on which the matrix is applied should then effectively be written as $|q_0\rangle \otimes |q_1\rangle$.
