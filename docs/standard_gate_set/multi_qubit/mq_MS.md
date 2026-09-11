# Mølmer-Sørensen gate

| Identifier | Operator | Example statement   |
|------------|----------|---------------------|
| MS         | $MS$     | **`MS q[0], q[1]`** |

## Description

The Mølmer-Sørensen, or MS, gate is a two-qubit gate.
It is a maximally entangling gate, most commonly used in ion-trap quantum computers.

## Properties

- Perfect Entangler (maximally entangles specific product states);
- Maximum Entangling Power over all uniformly random product states;
- Ising gate.

## Representation

$$\begin{align}
MS &= \frac{1}{\sqrt{2}} \left(\begin{matrix}
 1 & 0 & 0 & i \\
 0 & 1 & i & 0 \\
 0 & i & 1 & 0 \\
 i & 0 & 0 & 1 
\end{matrix}\right)
\end{align}$$

## Operation examples

### Standard basis

$$\begin{align}
MS\,|00\rangle &= \tfrac{1}{\sqrt{2}}|00\rangle + \tfrac{i}{\sqrt{2}}|11\rangle \\
\\
MS\,|01\rangle &= \tfrac{1}{\sqrt{2}}|01\rangle + \tfrac{i}{\sqrt{2}}|10\rangle \\
\\
MS\,|10\rangle &= \tfrac{i}{\sqrt{2}}|01\rangle + \tfrac{1}{\sqrt{2}}|10\rangle \\
\\
MS\,|11\rangle &= \tfrac{i}{\sqrt{2}}|00\rangle + \tfrac{1}{\sqrt{2}}|11\rangle \\
\end{align}$$

!!! Note "Qubit state ordering convention and matrix representation"

    Note that [qubits in a ket are ordered](../../language_specification/index.md#qubit-state-ordering-measurement-bit-ordering-and-matrix-representation)
    with qubit indices decreasing from left to right, _i.e._,

    $$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$

    Note that for matrices a **reversed** basis ordering convention is adopted, as is done in most textbooks.
    For instance, in the case of a two-qubit control gate, 
    the matrix is represented such that $q_0$ is the _control_ qubit
    and $q_1$ is the _target_ qubit;
    the state on which the matrix is applied should then effectively be written as $|q_0\rangle \otimes |q_1\rangle$.
