# Toffoli gate

| Identifier | Operator | Example statement |
|------------|----------|-------------------|
| CCX        | $CCX$    | **`CCX q[0], q[1], q[2]`** |

## Description

The Toffoli gate, also known as the controlled-[CNOT](mq_CNOT.md) or CCX, gate is a three-qubit gate.
It performs an [X gate](../single_qubit/sq_X.md) on the third qubit,
conditional on both the first and second qubits being in state $|1\rangle$.
The first two qubits are referred to as the control qubits and the third qubit as the target qubit.

In the standard computational basis for three qubits
$\{|000\rangle, |001\rangle, |010\rangle, |011\rangle, |100\rangle, |101\rangle, |110\rangle, |111\rangle\}$, the CCX gate:

- leaves both control qubits unchanged;
- performs an X gate on the target qubit when both control qubits are in state $|1\rangle$;
- leaves the target qubit unchanged otherwise.

!!! note

    The notion of control qubits and a target qubit (for any controlled operation) only holds for the
    standard computational basis. Generally, in another basis, all states could be affected.

### Aliases

Also known as _controlled-controlled-X_ or _CCNOT_.

### Properties

- [Involutory](https://en.wikipedia.org/wiki/Involutory_matrix) operation (its own inverse);
- [Controlled](https://en.wikipedia.org/wiki/Quantum_logic_gate#Controlled_gates) gate;
- Universal for reversible classical computation.

## Representation

$$\begin{align}
CCX &= CCNOT = \left(\begin{matrix}
1 & 0 & 0 & 0 & 0 & 0 & 0 & 0 \\
0 & 1 & 0 & 0 & 0 & 0 & 0 & 0 \\
0 & 0 & 1 & 0 & 0 & 0 & 0 & 0 \\
0 & 0 & 0 & 1 & 0 & 0 & 0 & 0 \\
0 & 0 & 0 & 0 & 1 & 0 & 0 & 0 \\
0 & 0 & 0 & 0 & 0 & 1 & 0 & 0 \\
0 & 0 & 0 & 0 & 0 & 0 & 0 & 1 \\
0 & 0 & 0 & 0 & 0 & 0 & 1 & 0
\end{matrix}\right)
\end{align}$$

## Operation examples

### Standard basis

$$\begin{align}
CCX\,|000\rangle &= |000\rangle \\
\\
CCX\,|001\rangle &= |001\rangle \\
\\
CCX\,|010\rangle &= |010\rangle \\
\\
CCX\,|011\rangle &= |111\rangle \\
\\
CCX\,|100\rangle &= |100\rangle \\
\\
CCX\,|101\rangle &= |101\rangle \\
\\
CCX\,|110\rangle &= |110\rangle \\
\\
CCX\,|111\rangle &= |011\rangle
\end{align}$$

!!! Note "Qubit state ordering convention and matrix representation"

    Note that [qubits in a ket are ordered](../../language_specification/index.md#qubit-state-ordering-measurement-bit-ordering-and-matrix-representation)
    with qubit indices decreasing from left to right, _i.e._,

    $$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$

    Note that for matrices a **reversed** basis ordering convention is adopted, as is done in most textbooks.
    For this three-qubit controlled gate, the matrix is represented such that $q_0$ and $q_1$
    are the _control_ qubits and $q_2$ is the _target_ qubit; the state on which the matrix is applied
    should then effectively be written as $|q_0\rangle \otimes |q_1\rangle \otimes |q_2\rangle$.