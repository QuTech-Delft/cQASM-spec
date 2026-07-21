# iSWAP gate

| Identifier | Operator | Example statement     |
|------------|----------|-----------------------|
| ISWAP      | $iSWAP$  | **`ISWAP q[0], q[1]`** |

## Description

The iSWAP gate is a two-qubit gate. It swaps the state of two qubits, while adding an $$i$$ phase factor to part of the state.
### Properties

- [Clifford](https://en.wikipedia.org/wiki/Clifford_gates) gate;
- Perfect Entangler (maximally entangles specific product states);
- Maximum Entangling Power over all uniformly random product states.
### Properties

- [Clifford](https://en.wikipedia.org/wiki/Clifford_gates) gate

## Representation

$$\begin{align}
iSWAP &= \left(\begin{matrix}
 1 & 0 & 0 & 0 \\
 0 & 0 & i & 0 \\
 0 & i & 0 & 0 \\
 0 & 0 & 0 & 1
\end{matrix}\right)
\end{align}$$

## Operation examples

### Standard basis

$$\begin{align}
iSWAP\,|00\rangle &= |00\rangle \\
\\
iSWAP\,|01\rangle &= i\,|10\rangle \\
\\
iSWAP\,|10\rangle &= i\,|01\rangle \\
\\
iSWAP\,|11\rangle &= |11\rangle \\
\end{align}$$

!!! Note "Qubit state ordering and matrix representation"

Note that [qubits in a ket in OpenSquirrel are ordered](../../language_specification/index.md#qubit-state-and-measurement-bit-ordering)
with qubit indices decreasing from left to right (little endian ordering), _i.e._,

$$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$

For the matrix representation given above, we use the standard textbook _big endian ordering_ of qubits, see the [CNOT gate for a more detailed explanation](mq_CNOT.md). 
