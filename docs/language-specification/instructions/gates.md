`<gate-name:ID>(<parameter(s):FLOAT|INT,>)? <qubit-argument(s):QUBIT,>`

```
H q[0]

CZ q[0], q[1]

Rx(pi/2) q[0]

CRk(2) q[1], q[0]
```

## Single-gate-multi-qubit (SGMQ) notation

A single qubit gate can be applied to multiple qubits by making use of single-gate-multi-qubit (SGMQ) notation. 
At the location of the (single) qubit argument either

- the whole qubit register `q`;

- a slice thereof `q[i:j]`, where $0 \leq i < j \leq N-1$;

- or a list of indices can be passed `q[i,]`, where $0 \leq i \leq N-1$,

with $N$ the size of the qubit register.
The following slicing convention is adopted: a slice `q[i:j]` includes qubits `q[i]`, `q[j]`, and all qubits in between. The code block below demonstrates some examples:

```
qubit[5] q


// the whole qubit register 

X q  // is semantically equivalent to
X q[0]; X q[1]; X q[2]; X q[3]; X q[4]


// a slice of the qubit register

X q[1:3]  // is semantically equivalent to
X q[1]; X q[2]; X q[3]


// a list of indices of the qubit register

X q[0,2,4]  // is semantically equivalent to
X q[0]; X q[2]; X q[4]

```

In the above example we have used the semicolon `;` to separate statements occurring on the same line.

## Standard gate set


| Name | Description                              | Example use          |
|------|------------------------------------------|----------------------|
| I    | Identity gate                            | `I q[0]`             |
| H    | Hadamard gate                            | `H q[0]`             |
| X    | Pauli-X                                  | `X q[0]`             |
| X90  | Rotation around the _x_-axis of $\pi/2$  | `X90 q[0]`           |
| mX90 | Rotation around the _x_-axis of $-\pi/2$ | `mX90 q[0]`          |
| Y    | Pauli-Y                                  | `Y q[0]`             |
| Y90  | Rotation around the _y_-axis of $\pi/2$  | `Y90 q[0]`           |
| mY90 | Rotation around the _y_-axis of $-\pi/2$ | `mY90 q[0]`          |
| Z    | Pauli-Z                                  | `Z q[0]`             |
| S    | Phase gate                               | `S q[0]`             |
| Sdag | S dagger gate                            | `Sdag q[0]`          |
| T    | T                                        | `T q[0]`             |
| Tdag | T dagger gate                            | `Tdag q[0]`          |
| Rx   | Arbitrary rotation around _x_-axis       | `Rx(pi) q[0]`        |
| Ry   | Arbitrary rotation around _y_-axis       | `Ry(pi) q[0]`        |
| Rz   | Arbitrary rotation around _z_-axis       | `Rz(pi) q[0]`        |
| CNOT | Controlled-NOT gate                      | `CNOT q[0], q[1]`    |
| CZ   | Controlled-Z, Controlled-Phase           | `CZ q[0], q[1]`      |
| CR   | Controlled phase shift (arbitrary angle) | `CR(pi) q[0], q[1]`  |
| CRk  | Controlled phase shift ($\pi/2^k$)       | `CRk(2) q[0], q[1]`  |
