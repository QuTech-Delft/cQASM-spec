# SWAP gate

| Identifier | Operator | Example statement     |
|------------|----------|-----------------------|
| SWAP       | $SWAP$   | **`SWAP q[0], q[1]`** |

## Description

The SWAP gate is a two-qubit gate.
It _swaps_ the state of the two qubits.

### Properties

- [Clifford](https://en.wikipedia.org/wiki/Clifford_gates) gate; 
- [Involutory](https://en.wikipedia.org/wiki/Involutory_matrix) operation (its own inverse).

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

!!! Note "Qubit state ordering convention and matrix representation"

    Note that [qubits in a ket are ordered](../../language_specification/index.md#qubit-state-ordering-measurement-bit-ordering-and-matrix-representation)
    with qubit indices decreasing from left to right, _i.e._,

    $$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$

    Note that for matrices a **reversed** basis ordering convention is adopted, as is done in most textbooks.
    For instance, in the case of a two-qubit control gate, 
    the matrix is represented such that $q_0$ is the _control_ qubit
    and $q_1$ is the _target_ qubit;
    the state on which the matrix is applied should then effectively be written as $|q_0\rangle \otimes |q_1\rangle$.
