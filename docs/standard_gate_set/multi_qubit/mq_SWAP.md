# SWAP gate

| Identifier | Operator | Example statement     |
|------------|----------|-----------------------|
| SWAP       | $SWAP$   | **`SWAP q[0], q[1]`** |

## Description

SWAP gate

Clifford gate

## Representation

$$\begin{align}
SWAP &= \left(\begin{matrix}
1 & 0 & 0 & 0 \\
0 & 0 & 1 & 0 \\
0 & 1 & 0 & 0 \\
0 & 0 & 0 & 1 
\end{matrix}\right)
\end{align}$$

## Operation examples

### Standard basis

$$\begin{align}
SWAP\,|00\rangle &= |00\rangle \\
\\
SWAP\,|01\rangle &= |10\rangle \\
\\
SWAP\,|10\rangle &= |01\rangle \\
\\
SWAP\,|11\rangle &= |11\rangle \\
\end{align}$$

!!! Note "Qubit state ordering"

    Note that [qubits in a ket are ordered](../../language_specification/general_overview.md/#qubit-state-and-measurement-bit-ordering)
    with qubit indices decreasing from left to right, _i.e._,

    $$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$
