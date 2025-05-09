# Controlled-NOT gate

| Identifier | Operator | Example statement     |
|------------|----------|-----------------------|
| CNOT       | $CNOT$   | **`CNOT q[0], q[1]`** |

## Description

The controlled-NOT, or CNOT, gate is a two-qubit gate.
It performs an X gate on the second qubit, conditional on the state of the first qubit.
The first qubit is usually referred to as the control qubit and the second qubit as the target qubit.

In the standard computational basis $\{|0\rangle ,|1\rangle \}$ , the CNOT gate:

- leaves the control qubit unchanged,
- performs an X gate on the target qubit, when the control qubit is in state $|1\rangle$,
- leaves the target qubit unchanged, when the control qubit is in state $|0\rangle$.

!!! note

    The notion of a control qubit and a target qubit (for any controlled operation) only holds for the
    standard computational basis. Generally, in another basis, both the 'control' and 'target' qubit change.

### Aliases

Also known as _controlled-X_, _CX_, or _controlled bit-flip_ gate.

### Properties

- [Clifford](https://en.wikipedia.org/wiki/Clifford_gates) gate; 
- [Involutory](https://en.wikipedia.org/wiki/Involutory_matrix) operation (its own inverse);
- [Controlled](https://en.wikipedia.org/wiki/Quantum_logic_gate#Controlled_gates) gate.

## Representation

$$\begin{align}
CNOT &= \left(\begin{matrix}
1 & 0 & 0 & 0 \\
0 & 0 & 0 & 1 \\
0 & 0 & 1 & 0 \\
0 & 1 & 0 & 0 
\end{matrix}\right)
\end{align}$$

which is equal to:

$$CNOT = CX = I \otimes |0\rangle\langle 0| + X \otimes |1\rangle\langle 1|.$$

## Operation examples

### Standard basis

$$\begin{align}
CNOT\,|00\rangle &= |00\rangle \\
\\
CNOT\,|01\rangle &= |11\rangle \\
\\
CNOT\,|10\rangle &= |10\rangle \\
\\
CNOT\,|11\rangle &= |01\rangle \\
\end{align}$$

!!! Note "Qubit state ordering"

    Note that [qubits in a ket are ordered](../../language_specification/general_overview.md/#qubit-state-and-measurement-bit-ordering)
    with qubit indices decreasing from left to right, _i.e._,

    $$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$