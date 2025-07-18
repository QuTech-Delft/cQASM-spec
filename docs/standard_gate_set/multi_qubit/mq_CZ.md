# C-Phase gate

| Identifier | Operator | Example statement   |
|------------|----------|---------------------|
| CZ         | $CZ$     | **`CZ q[0], q[1]`** |

## Description

The C-Phase, or CZ, gate is a two-qubit gate.
It performs a Z gate (negates the relative phase) on the second qubit, conditional on the state of the first qubit.
The first qubit is usually referred to as the control qubit and the second qubit as the target qubit.

In the standard computational basis $\{ |0\rangle ,|1\rangle \}$, the CZ gate:

- leaves the control qubit unchanged,
- performs a Z gate on the target qubit, when the control qubit is in state $|1\rangle$,
- leaves the target qubit unchanged, when the control qubit is in state $|0\rangle$.

!!! note

    The notion of a control qubit and a target qubit (for any controlled operation) only holds for the standard
    computational basis. Generally, in another basis, both the 'control' and 'target' qubit change.

The CZ gate is a specific example of the [controlled phase shift gate (CR gate)](mq_CR.md):
$CZ = CR(\pi)$.

### Aliases

Also known as _C-Phase_ , _controlled-Z_ , or _controlled phase-flip_ gate.

### Properties

- [Clifford](https://en.wikipedia.org/wiki/Clifford_gates) gate; 
- [Involutory](https://en.wikipedia.org/wiki/Involutory_matrix) operation (its own inverse);
- [Controlled](https://en.wikipedia.org/wiki/Quantum_logic_gate#Controlled_gates) gate.

## Representation

$$\begin{align}
CZ &= \left(\begin{matrix}
1 & 0 & 0 &  0 \\
0 & 1 & 0 &  0 \\
0 & 0 & 1 &  0 \\
0 & 0 & 0 & -1 
\end{matrix}\right)
\end{align}$$

which is equal to:

$$CZ = I \otimes |0\rangle\langle 0| + Z \otimes |1\rangle\langle 1|.$$

## Operation examples

### Standard basis

$$\begin{align}
CZ\,|00\rangle &= |00\rangle \\
\\
CZ\,|01\rangle &= |01\rangle \\
\\
CZ\,|10\rangle &= |10\rangle \\
\\
CZ\,|11\rangle &= -|11\rangle \\
\end{align}$$

!!! Note "Qubit state ordering"

    Note that [qubits in a ket are ordered](../../language_specification/index.md#qubit-state-and-measurement-bit-ordering)
    with qubit indices decreasing from left to right, _i.e._,

    $$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$
