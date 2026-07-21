# Square-root-SWAP gate

| Identifier | Operator      | Example statement         |
|------------|---------------|---------------------------|
| SqrtSWAP   | $\sqrt{SWAP}$ | **`SqrtSWAP q[0], q[1]`** |

## Description

The square-root-SWAP gate is a two-qubit gate. Where as the SWAP gate exchanges the state of two qubits, the square-root-SWAP gate performs half of this exchange, putting pure separable states into a maximally entangled state.

## Representation

$$\begin{align}
\sqrt{SWAP} &= \left(\begin{matrix}
 1 & 0 & 0 & 0 \\
 0 & \frac{1}{2} \left ( i+1 \right ) & \frac{1}{2} \left ( i-1 \right ) & 0 \\
 0 & \frac{1}{2} \left ( i-1 \right ) & \frac{1}{2} \left ( i+1 \right ) & 0 \\
 0 & 0 & 0 & 1 
\end{matrix}\right)
\end{align}$$

## Operation examples

### Standard basis

$$\begin{align}
\sqrt{SWAP}\,|00\rangle &= |00\rangle \\
\\
\sqrt{SWAP}\,|01\rangle &= \tfrac{1}{2} \left ( i+1 \right )\,|01\rangle + \tfrac{1}{2} \left ( i-1 \right )\,|10\rangle \\
\\
\sqrt{SWAP}\,|10\rangle &= \tfrac{1}{2} \left ( i-1 \right )\,|01\rangle + \tfrac{1}{2} \left ( i+1 \right )\,|10\rangle \\
\\
\sqrt{SWAP}\,|11\rangle &= |11\rangle \\
\end{align}$$

!!! Note "Qubit state ordering and matrix representation"

Note that [qubits in a ket in OpenSquirrel are ordered](../../language_specification/index.md#qubit-state-and-measurement-bit-ordering)
with qubit indices decreasing from left to right (little endian ordering), _i.e._,

$$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$

For the matrix representation given above, we use the standard textbook _big endian ordering_ of qubits, see the [CNOT gate for a more detailed explanation](mq_CNOT.md). 
