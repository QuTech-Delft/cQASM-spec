# Controlled-NOT gate

| Identifier | Operator | Example statement     |
|------------|----------|-----------------------|
| CNOT       | $CNOT$   | **`CNOT q[0], q[1]`** |

## Description

Controlled-NOT, CNOT, Controlled-X, or CX gate

$CNOT = CX = I \otimes |0\rangle\langle 0| + X \otimes |1\rangle\langle 1|$

Clifford gate

## Representation

$$\begin{align}
CNOT &= \left(\begin{matrix}
1 & 0 & 0 & 0 \\
0 & 0 & 0 & 1 \\
0 & 0 & 1 & 0 \\
0 & 1 & 0 & 0 
\end{matrix}\right)
\end{align}$$

## Operation examples

### Standard basis

$$\begin{align}
CNOT\,|00\rangle &= |00\rangle \\
\\
CNOT\,|01\rangle &= |11\rangle \\
\\
CNOT\,|10\rangle &= |10\rangle \\
\\
CNOT\,|11\rangle &= |01\rangle \\
\end{align}$$

!!! Note "Qubit state ordering"

    Note that [qubits in a ket are ordered](../../language_specification/general_overview.md/#qubit-state-and-measurement-bit-ordering)
    with qubit indices decreasing from left to right, _i.e._,

    $$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$