# Inverse-square-root-SWAP gate

| Identifier  | Operator              | Example statement            |
|-------------|-----------------------|------------------------------|
| InvSqrtSWAP | $\sqrt{SWAP}^\dagger$ | **`InvSqrtSWAP q[0], q[1]`** |

## Description

The inverse-square-root-SWAP gate is a two-qubit gate. It reverses the action of the square-root-SWAP gate. 

## Representation

$$\begin{align}
\sqrt{SWAP}^\dagger &= \left(\begin{matrix}
 1 & 0 & 0 & 0 \\
 0 & \frac{1}{2} \left ( i-1 \right ) & \frac{1}{2} \left ( i+1 \right ) & 0 \\
 0 & \frac{1}{2} \left ( i+1 \right ) & \frac{1}{2} \left ( i-1 \right ) & 0 \\
 0 & 0 & 0 & 1
\end{matrix}\right)
\end{align}$$

## Operation examples

### Standard basis

$$\begin{align}
\sqrt{SWAP}^\dagger\,|00\rangle &= |00\rangle \\
\\
\sqrt{SWAP}^\dagger\,|01\rangle &= \tfrac{1}{2} \left ( i+1 \right )\,|10\rangle + \tfrac{1}{2} \left ( i-1 \right )\,|01\rangle \\
\\
\sqrt{SWAP}^\dagger\,|10\rangle &= \tfrac{1}{2} \left ( i-1 \right )\,|10\rangle + \tfrac{1}{2} \left ( i+1 \right )\,|01\rangle \\
\\
\sqrt{SWAP}^\dagger\,|11\rangle &= |11\rangle \\
\end{align}$$

!!! Note "Qubit state ordering and matrix representation"

Note that [qubits in a ket in OpenSquirrel are ordered](../../language_specification/index.md#qubit-state-and-measurement-bit-ordering)
with qubit indices decreasing from left to right (little endian ordering), _i.e._,

$$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$

For the matrix representation given above, we use the standard textbook _big endian ordering_ of qubits, see the [CNOT gate for a more detailed explanation](mq_CNOT.md). 
