# C-Phase gate

| Identifier | Operator | Example statement   |
|------------|----------|---------------------|
| CZ         | $CZ$     | **`CZ q[0], q[1]`** |

## Description

C-Phase gate, Controlled-Z or CZ gate

$CZ = I \otimes |0\rangle\langle 0| + Z \otimes |1\rangle\langle 1|$

Clifford gate

## Representation

$$\begin{align}
CZ &= \left(\begin{matrix}
1 & 0 & 0 &  0 \\
0 & 1 & 0 &  0 \\
0 & 0 & 1 &  0 \\
0 & 0 & 0 & -1 
\end{matrix}\right)
\end{align}$$

## Operation examples

### Standard basis

$$\begin{align}
CZ\,|00\rangle &= |00\rangle \\
\\
CZ\,|01\rangle &= |01\rangle \\
\\
CZ\,|10\rangle &= |10\rangle \\
\\
CZ\,|11\rangle &= -|11\rangle \\
\end{align}$$

!!! Note "Qubit state ordering"

    Note that [qubits in a ket are ordered](../../language_specification/general_overview.md/#qubit-state-and-measurement-bit-ordering)
    with qubit indices decreasing from left to right, _i.e._,

    $$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$
