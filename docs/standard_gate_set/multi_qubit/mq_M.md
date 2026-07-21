# Magic gate

| Identifier | Operator | Example statement  |
|------------|----------|--------------------|
| M          | $M$      | **`M q[0], q[1]`** |

## Description

The Magic, or M, gate is a two-qubit gate. Its columns are the magic-basis vectors, which are equal to the four Bell states with specific phase factors.  The magic gate is an important component in KAK circuit decomposition and is used to transform any two-qubit unitary from the standard basis to the magic basis, which makes the extraction of canonical parameters much easier than working in the computational basis.

## Properties

- Perfect Entangler (maximally entangles specific product states);
- Ising gate.

## Representation

$$\begin{align}
M &= \frac{1}{\sqrt{2}} \left(\begin{matrix}
  1 & i & 0 & 0 \\
  0 & 0 & i & 1 \\
  0 & 0 & i & -1 \\
  1 & -i & 0 & 0
\end{matrix}\right)
\end{align}$$

## Operation examples

### Standard basis

$$\begin{align}
M\,|00\rangle &= \tfrac{1}{\sqrt{2}}|00\rangle + \tfrac{1}{\sqrt{2}}|11\rangle \\
\\
M\,|01\rangle &= \tfrac{i}{\sqrt{2}}|10\rangle + \tfrac{i}{\sqrt{2}}|01\rangle \\
\\
M\,|10\rangle &= \tfrac{i}{\sqrt{2}}|00\rangle - \tfrac{i}{\sqrt{2}}|11\rangle \\
\\
M\,|11\rangle &= \tfrac{1}{\sqrt{2}}|10\rangle - \tfrac{1}{\sqrt{2}}|01\rangle \\
\end{align}$$

!!! Note "Qubit state ordering and matrix representation"

Note that [qubits in a ket in OpenSquirrel are ordered](../../language_specification/index.md#qubit-state-and-measurement-bit-ordering)
with qubit indices decreasing from left to right (little endian ordering), _i.e._,

$$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$

For the matrix representation given above, we use the standard textbook _big endian ordering_ of qubits, see the [CNOT gate for a more detailed explanation](mq_CNOT.md). 
