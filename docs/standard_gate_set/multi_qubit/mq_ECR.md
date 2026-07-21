# Echoed Cross-Resonance gate

| Identifier | Operator | Example statement    |
|------------|----------|----------------------|
| ECR        | $ECR$    | **`ECR q[0], q[1]`** |

## Description

The echoed cross-resonance, or ECR, gate is a two-qubit gate. It is an entangling two-qubit gate commonly used in in superconducting QPU's. such as IBM quantum systems.
### Properties

- Perfect Entangler (maximally entangles specific product states);
- Maximum Entangling Power over all uniformly random product states;
- Ising gate.
## Representation

$$\begin{align}
ECR &= \frac{1}{\sqrt{2}} \left(\begin{matrix}
 0 & 0 & 1 & i \\
 0 & 0 & i & 1 \\
 1 & -i & 0 & 0 \\
 -i & 1 & 0 & 0
\end{matrix}\right)
\end{align}$$

## Operation examples

### Standard basis

$$\begin{align}
ECR\,|00\rangle &= \tfrac{1}{\sqrt{2}} |01\rangle - \tfrac{i}{\sqrt{2}} \,|11\rangle \\
\\
ECR\,|01\rangle &= \tfrac{1}{\sqrt{2}} |00\rangle + \tfrac{i}{\sqrt{2}} \,|10\rangle \\
\\
ECR\,|10\rangle &= -\tfrac{i}{\sqrt{2}} \,|01\rangle + \tfrac{1}{\sqrt{2}} |11\rangle \\
\\
ECR\,|11\rangle &= \tfrac{i}{\sqrt{2}} \,|00\rangle + \tfrac{1}{\sqrt{2}} |10\rangle \\
\end{align}$$

!!! Note "Qubit state ordering and matrix representation"

Note that [qubits in a ket in OpenSquirrel are ordered](../../language_specification/index.md#qubit-state-and-measurement-bit-ordering)
with qubit indices decreasing from left to right (little endian ordering), _i.e._,

$$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$

For the matrix representation given above, we use the standard textbook _big endian ordering_ of qubits, see the [CNOT gate for a more detailed explanation](mq_CNOT.md). 
