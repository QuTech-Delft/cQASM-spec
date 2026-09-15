# Fredkin gate

| Identifier | Operator | Example statement |
|------------|----------|-------------------|
| CSWAP      | $CSWAP$  | **`CSWAP q[0], q[1], q[2]`** |

## Description

The Fredkin gate, also known as the controlled-[SWAP](mq_SWAP.md) or CSWAP, gate is a three-qubit gate.
It swaps the states of the second and third qubits, conditional on the state of the first qubit.
The first qubit is referred to as the control qubit and the second and third qubits as the swap qubits.

In the standard computational basis for three qubits
$\{|000\rangle, |001\rangle, |010\rangle, |011\rangle, |100\rangle, |101\rangle, |110\rangle, |111\rangle\}$, the CSWAP gate:

- leaves the control qubit unchanged;
- swaps the states of the two swap qubits when the control qubit is in state $|1\rangle$;
- leaves both swap qubits unchanged when the control qubit is in state $|0\rangle$.

!!! note

    The notion of a control qubit and swap qubits (for any controlled operation) only holds for the
    standard computational basis. Generally, in another basis, all states could be affected.

### Aliases

Also known as the _controlled-SWAP_ or _CSWAP_ gate.

### Properties

- [Involutory](https://en.wikipedia.org/wiki/Involutory_matrix) operation (its own inverse);
- [Controlled](https://en.wikipedia.org/wiki/Quantum_logic_gate#Controlled_gates) gate;
- Universal for reversible classical computation.

## Representation

$$\begin{align}
CSWAP &= \left(\begin{matrix}
1 & 0 & 0 & 0 & 0 & 0 & 0 & 0 \\
0 & 1 & 0 & 0 & 0 & 0 & 0 & 0 \\
0 & 0 & 1 & 0 & 0 & 0 & 0 & 0 \\
0 & 0 & 0 & 1 & 0 & 0 & 0 & 0 \\
0 & 0 & 0 & 0 & 1 & 0 & 0 & 0 \\
0 & 0 & 0 & 0 & 0 & 0 & 1 & 0 \\
0 & 0 & 0 & 0 & 0 & 1 & 0 & 0 \\
0 & 0 & 0 & 0 & 0 & 0 & 0 & 1
\end{matrix}\right)
\end{align}$$

## Operation examples

### Standard basis

$$\begin{align}
CSWAP\,|000\rangle &= |000\rangle \\
\\
CSWAP\,|001\rangle &= |001\rangle \\
\\
CSWAP\,|010\rangle &= |010\rangle \\
\\
CSWAP\,|011\rangle &= |101\rangle \\
\\
CSWAP\,|100\rangle &= |100\rangle \\
\\
CSWAP\,|101\rangle &= |011\rangle \\
\\
CSWAP\,|110\rangle &= |110\rangle \\
\\
CSWAP\,|111\rangle &= |111\rangle
\end{align}$$

!!! Note "Qubit state ordering convention and matrix representation"

    Note that [qubits in a ket are ordered](../../language_specification/index.md#qubit-state-ordering-measurement-bit-ordering-and-matrix-representation)
    with qubit indices decreasing from left to right, _i.e._,

    $$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$

    Note that for matrices a **reversed** basis ordering convention is adopted, as is done in most textbooks.
    For this three-qubit controlled gate, the matrix is represented such that $q_0$ is the _control_ qubit
    and $q_1$ and $q_2$ are the _swap_ qubits; the state on which the matrix is applied should then effectively
    be written as $|q_0\rangle \otimes |q_1\rangle \otimes |q_2\rangle$.