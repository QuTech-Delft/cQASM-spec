# Inverse-square-root-SWAP gate

| Identifier  | Operator              | Example statement            |
|-------------|-----------------------|------------------------------|
| InvSqrtSWAP | $\sqrt{SWAP}^\dagger$ | **`InvSqrtSWAP q[0], q[1]`** |

## Description

The inverse-square-root-SWAP gate is a two-qubit gate.

### Properties


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
\sqrt{SWAP}^\dagger\,|01\rangle &= \frac{1}{2} \left ( i-1 \right )\,|01\rangle + \frac{1}{2} \left ( i+1 \right )\,|10\rangle \\
\\
\sqrt{SWAP}^\dagger\,|10\rangle &= \frac{1}{2} \left ( i+1 \right )\,|01\rangle + \frac{1}{2} \left ( i-1 \right )\,|10\rangle \\
\\
\sqrt{SWAP}^\dagger\,|11\rangle &= |11\rangle \\
\end{align}$$

!!! Note "Qubit state ordering"

    Note that [qubits in a ket are ordered](../../language_specification/index.md#qubit-state-and-measurement-bit-ordering)
    with qubit indices decreasing from left to right, _i.e._,

    $$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$
