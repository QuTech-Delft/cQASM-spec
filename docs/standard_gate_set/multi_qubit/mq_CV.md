# CV gate

| Identifier | Operator | Example statement   |
|------------|----------|---------------------|
| CV         | $CV$     | **`CV q[0], q[1]`** |

## Description

The CV gate is a two-qubit gate.

### Properties

- [Controlled](https://en.wikipedia.org/wiki/Quantum_logic_gate#Controlled_gates) gate;
- Ising gate.

## Representation

$$\begin{align}
CV &= \left(\begin{matrix}
 1 & 0 & 0 & 0\\
 0 & 1 & 0 & 0\\
 0 & 0 & 1 + i & 1 - i\\
 0 & 0 & 1 - i & 1 + i
\end{matrix}\right)
\end{align}$$

which is equal to:

$$CNOT = CX = |0\rangle\langle 0| \otimes I + |1\rangle\langle 1| \otimes 2V.$$

## Operation examples

### Standard basis

$$\begin{align}
CV\,|00\rangle &= |00\rangle \\
\\
CV\,|01\rangle &= (1 + i)\,|01\rangle + (1 - i)\,|11\rangle \\
\\
CV\,|10\rangle &= |10\rangle \\
\\
CV\,|11\rangle &= (1 - i)\,|01\rangle + (1 + i)\,|11\rangle \\
\end{align}$$

!!! Note "Qubit state ordering"

    Note that [qubits in a ket are ordered](../../language_specification/index.md#qubit-state-and-measurement-bit-ordering)
    with qubit indices decreasing from left to right, _i.e._,

    $$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$
