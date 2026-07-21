# CY gate

| Identifier | Operator | Example statement   |
|------------|----------|---------------------|
| CY         | $CY$     | **`CY q[0], q[1]`** |

## Description

The CY gate is a two-qubit gate. It is the controlled-Y gate.
It performs a Y gate on the second qubit, conditional on the state of the first qubit.

### Properties

- [Clifford](https://en.wikipedia.org/wiki/Clifford_gates) gate; 
- [Controlled](https://en.wikipedia.org/wiki/Quantum_logic_gate#Controlled_gates) gate;
- Ising gate.

## Representation

$$\begin{align}
CY &= \left(\begin{matrix}
 1 & 0 & 0 & 0\\
 0 & 1 & 0 & 0\\
 0 & 0 & 0 & -i\\
 0 & 0 & i & 0
\end{matrix}\right)
\end{align}$$

which is equal to:

$$CY = |0\rangle\langle 0| \otimes I + |1\rangle\langle 1| \otimes Y.$$

## Operation examples

### Standard basis

$$\begin{align}
CY\,|00\rangle &= |00\rangle \\
\\
CY\,|01\rangle &= i\,|11\rangle \\
\\
CY\,|10\rangle &= |10\rangle \\
\\
CY\,|11\rangle &= -i\,|01\rangle \\
\end{align}$$

!!! Note "Qubit state ordering and matrix representation"

Note that [qubits in a ket in OpenSquirrel are ordered](../../language_specification/index.md#qubit-state-and-measurement-bit-ordering)
with qubit indices decreasing from left to right (little endian ordering), _i.e._,

$$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$

For the matrix representation given above, we use the standard textbook _big endian ordering_ of qubits, see the [CNOT gate for a more detailed explanation](mq_CNOT.md). 
