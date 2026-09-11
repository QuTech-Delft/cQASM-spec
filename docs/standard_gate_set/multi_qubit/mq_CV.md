# CV gate

| Identifier | Operator | Example statement   |
|------------|----------|---------------------|
| CV         | $CV$     | **`CV q[0], q[1]`** |

## Description

The CV gate is a two-qubit gate. Note that $V = X^{1/2}$, _i.e._, CV is the controlled-square-root-of-X (CSX) gate.
It performs an X90 gate on the second qubit, conditional on the state of the first qubit.

### Aliases

Also known as the, _controlled-V_, _controlled-X90_, or _controlled-square-root-of-X_ gate.

### Properties

- [Controlled](https://en.wikipedia.org/wiki/Quantum_logic_gate#Controlled_gates) gate;
- Ising gate.

## Representation

$$\begin{align}
CV &= \left(\begin{matrix}
 1 & 0 & 0 & 0\\
 0 & 1 & 0 & 0\\
 0 & 0 & \tfrac{1}{2} (1 + i) & \tfrac{1}{2} (1 - i)\\
 0 & 0 & \tfrac{1}{2} (1 - i) & \tfrac{1}{2} (1 + i)
\end{matrix}\right)
\end{align}$$

which is equal to:

$$CV = |0\rangle\langle 0| \otimes I + |1\rangle\langle 1| \otimes V.$$

## Operation examples

### Standard basis

$$\begin{align}
CV\,|00\rangle &= |00\rangle \\
\\
CV\,|01\rangle &= \tfrac{1}{2} (1 + i)\,|01\rangle + \tfrac{1}{2} (1 - i)\,|11\rangle \\
\\
CV\,|10\rangle &= |10\rangle \\
\\
CV\,|11\rangle &= \tfrac{1}{2} (1 - i)\,|01\rangle + \tfrac{1}{2} (1 + i)\,|11\rangle \\
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
