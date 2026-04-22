# Mølmer-Sørensen gate

| Identifier | Operator | Example statement   |
|------------|----------|---------------------|
| MS         | $MS$     | **`MS q[0], q[1]`** |

## Description

The Mølmer-Sørensen, or MS, gate is a two-qubit gate.


### Properties


## Representation

$$\begin{align}
MS &= \left(\begin{matrix}
 1 & 0 & 0 & i \\
 0 & 1 & i & 0 \\
 0 & i & 1 & 0 \\
 i & 0 & 0 & 1 
\end{matrix}\right)
\end{align}$$

## Operation examples

### Standard basis

$$\begin{align}
MS\,|00\rangle &= |00\rangle + i\,|11\rangle \\
\\
MS\,|01\rangle &= |01\rangle + i\,|10\rangle \\
\\
MS\,|10\rangle &= i\,|01\rangle + |10\rangle \\
\\
MS\,|11\rangle &= i\,|00\rangle + |11\rangle \\
\end{align}$$

!!! Note "Qubit state ordering"

    Note that [qubits in a ket are ordered](../../language_specification/index.md#qubit-state-and-measurement-bit-ordering)
    with qubit indices decreasing from left to right, _i.e._,

    $$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$
