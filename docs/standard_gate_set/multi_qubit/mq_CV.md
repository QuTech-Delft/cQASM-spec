# CV gate

| Identifier | Operator | Example statement   |
|------------|----------|---------------------|
| CV         | $CV$     | **`CV q[0], q[1]`** |

## Description

The CV gate is a two-qubit gate.

### Properties


## Representation

$$\begin{align}
CV &= \left(\begin{matrix}
 1 & 0 & 0 & 0\\
 0 & 1 & 0 & 0\\
 0 & 0 & e^{\frac{i \pi }{4}} \sqrt{2} & e^{- \frac{i \pi }{4}} \sqrt{2}\\
 0 & 0 & e^{- \frac{i \pi }{4}} \sqrt{2} & e^{\frac{i \pi }{4}} \sqrt{2}
\end{matrix}\right)
\end{align}$$

## Operation examples

### Standard basis

$$\begin{align}
CV\,|00\rangle &= |00\rangle \\
\\
CV\,|01\rangle &= |01\rangle \\
\\
CV\,|10\rangle &= e^{\frac{i \pi }{4}} \sqrt{2}\,|10\rangle + e^{- \frac{i \pi }{4}} \sqrt{2}\,|11\rangle \\
\\
CV\,|11\rangle &= e^{- \frac{i \pi }{4}} \sqrt{2}\,|10\rangle + e^{\frac{i \pi }{4}} \sqrt{2}\,|11\rangle \\
\end{align}$$

!!! Note "Qubit state ordering"

    Note that [qubits in a ket are ordered](../../language_specification/index.md#qubit-state-and-measurement-bit-ordering)
    with qubit indices decreasing from left to right, _i.e._,

    $$|\psi\rangle = \sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$$
