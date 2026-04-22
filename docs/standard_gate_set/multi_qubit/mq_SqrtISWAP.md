# Square-root-iSWAP gate

| Identifier | Operator       | Example statement          |
|------------|----------------|----------------------------|
| SqrtISWAP  | $\sqrt{iSWAP}$ | **`SqrtISWAP q[0], q[1]`** |

## Description

The square-root-iSWAP gate is a two-qubit gate.

### Properties


## Representation

$$\begin{align}
\sqrt{iSWAP} &= \left(\begin{matrix}
 1 & 0 & 0 & 0 \\
 0 & \frac{1}{\sqrt{2}} & \frac{i}{\sqrt{2}} & 0 \\
 0 & \frac{i}{\sqrt{2}} & \frac{1}{\sqrt{2}} & 0 \\
 0 & 0 & 0 & 1 
\end{matrix}\right)
\end{align}$$

## Operation examples

### Standard basis

$$\begin{align}
\sqrt{iSWAP}\,|00\rangle &= |00\rangle \\
\\
\sqrt{iSWAP}\,|01\rangle &= \frac{1}{\sqrt{2}}\,|01\rangle + \frac{i}{\sqrt{2}}\,|10\rangle \\
\\
\sqrt{iSWAP}\,|10\rangle &= \frac{i}{\sqrt{2}}\,|01\rangle + \frac{1}{\sqrt{2}}\,|10\rangle \\
\\
\sqrt{iSWAP}\,|11\rangle &= |11\rangle \\
\end{align}$$

!!! Note "Qubit state ordering"

    Note that [qubits in a ket are ordered](../../language_specification/index.md#qubit-state-and-measurement-bit-ordering)
    with qubit indices decreasing from left to right, _i.e._,

    $$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$
