# Double-CNOT gate

| Identifier | Operator | Example statement      |
|------------|----------|------------------------|
| DCNOT      | $DCNOT$  | **`DCNOT q[0], q[1]`** |

## Description

The double-CNOT, or DCNOT, gate is a two-qubit gate. It is defined as a sequence of two anti-parallel CNOT gates, where the first CNOT gate takes the first qubit as the control qubit and the second CNOT gate is anti-parallel and takes the second qubit as the control qubit.
### Properties

- [Involutory](https://en.wikipedia.org/wiki/Involutory_matrix) operation (its own inverse);
- Perfect Entangler (maximally entangles specific product states).
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
DCNOT\,|01\rangle &= |10\rangle \\
\\
DCNOT\,|10\rangle &= |11\rangle \\
\\
DCNOT\,|11\rangle &= |01\rangle \\
\end{align}$$

!!! Note "Qubit state ordering and matrix representation"

Note that [qubits in a ket in OpenSquirrel are ordered](../../language_specification/index.md#qubit-state-and-measurement-bit-ordering)
with qubit indices decreasing from left to right (little endian ordering), _i.e._,

$$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$

For the matrix representation given above, we use the standard textbook _big endian ordering_ of qubits, see the [CNOT gate for a more detailed explanation](mq_CNOT.md). 
