# Dynamic-CNOT gate

| Identifier | Operator | Example statement      |
|------------|----------|------------------------|
| DCNOT      | $DCNOT$  | **`DCNOT q[0], q[1]`** |

## Description

The dynamic-CNOT, or DCNOT, gate is a two-qubit gate.


### Properties


## Representation

$$\begin{align}
DCNOT &= \left(\begin{matrix}
 1 & 0 & 0 & 0 \\
 0 & 0 & 1 & 0 \\
 0 & 0 & 0 & 1 \\
 0 & 1 & 0 & 0
\end{matrix}\right)
\end{align}$$

## Operation examples

### Standard basis

$$\begin{align}
DCNOT\,|00\rangle &= |00\rangle \\
\\
DCNOT\,|01\rangle &= |11\rangle \\
\\
DCNOT\,|10\rangle &= |01\rangle \\
\\
DCNOT\,|11\rangle &= |10\rangle \\
\end{align}$$

!!! Note "Qubit state ordering"

    Note that [qubits in a ket are ordered](../../language_specification/index.md#qubit-state-and-measurement-bit-ordering)
    with qubit indices decreasing from left to right, _i.e._,

    $$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$
