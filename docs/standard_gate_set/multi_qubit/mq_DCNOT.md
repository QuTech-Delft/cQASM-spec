# Double-CNOT gate

| Identifier | Operator | Example statement      |
|------------|----------|------------------------|
| DCNOT      | $DCNOT$  | **`DCNOT q[0], q[1]`** |

## Description

The double-CNOT, or DCNOT, gate is a two-qubit gate. 
It is defined as a sequence of two anti-parallel CNOT gates,
where the first CNOT gate takes the first qubit as the control qubit and the second CNOT gate is anti-parallel and 
takes the second qubit as the control qubit.

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

!!! Note "Qubit state ordering convention and matrix representation"

    Note that [qubits in a ket are ordered](../../language_specification/index.md#qubit-state-and-measurement-bit-ordering)
    with qubit indices decreasing from left to right, _i.e._,

    $$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$

    Note that for matrices a **reversed** basis ordering convention is adopted, as is done in most textbooks.
    For instance, in the case of a two-qubit control gate, 
    the matrix is represented such that $q_0$ is the _control_ qubit
    and $q_1$ is the _target_ qubit;
    the state on which the matrix is applied should then effectively be written as $|q_0\rangle \otimes |q_1\rangle$.
