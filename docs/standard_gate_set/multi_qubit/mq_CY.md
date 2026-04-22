# CY gate

| Identifier | Operator | Example statement   |
|------------|----------|---------------------|
| CY         | $CY$     | **`CY q[0], q[1]`** |

## Description

The CY gate is a two-qubit gate.

### Properties


## Representation

$$\begin{align}
CY &= \left(\begin{matrix}
 1 & 0 & 0 & 0\\
 0 & 1 & 0 & 0\\
 0 & 0 & 0 & -i\\
 0 & 0 & i & 0
\end{matrix}\right)
\end{align}$$

## Operation examples

### Standard basis

$$\begin{align}
CY\,|00\rangle &= |00\rangle \\
\\
CY\,|01\rangle &= |01\rangle \\
\\
CY\,|10\rangle &= i\,|11\rangle \\
\\
CY\,|11\rangle &= -i\,|10\rangle \\
\end{align}$$

!!! Note "Qubit state ordering"

    Note that [qubits in a ket are ordered](../../language_specification/index.md#qubit-state-and-measurement-bit-ordering)
    with qubit indices decreasing from left to right, _i.e._,

    $$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$
