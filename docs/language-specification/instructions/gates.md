Gates are unitary quantum instructions that define particular operations on qubit.
Individual gates are designed to operate on a fixed number of qubits, comprising either single or $n$-qubit gates, that modify the state of the qubit(s) in a deterministic fashion.

In essence, a quantum algorithm consists of a sequence of gates and non-unitary quantum instructions, _e.g._, the [measurement instruction](measure-instruction.md).

The general form of a gate instruction statement is given by the following:

`<gate-name:ID> <qubit-argument(s):QUBIT,>`

Parentheses are used for specifying parameterized gates:

`<gate-name:ID>(<parameter(s):FLOAT|INT,>) <qubit-argument(s):QUBIT,>`

??? info "Regex pattern"
    
    ```hl_lines="9"
    LETTER=[_a-zA-Z]
    DIGIT=[0-9]
    INT={DIGIT}+
    EXPONENT=[eE][-+]?{INT} 
    FLOAT=({INT}?[.])?{INT}{EXPONENT}?
    ID={LETTER}({LETTER}|{INT})*
    QUBIT={ID}(\[{INT}\])?
    
    ID(\((INT|FLOAT)(,(INT|FLOAT))*\))? QUBIT(,QUBIT)*
    ```

```
H q[0]

CZ q[0], q[1]

Rx(pi/2) q[0]

CRk(2) q[1], q[0]
```

The gates that are supported by the language are listed below in the [standard gate set](gates.md#standard-gate-set).

## Single-gate-multi-qubit (SGMQ) notation

It is possible to pass multiple qubits as an argument to a single-qubit gate, by making use of the single-gate-multi-qubit (SGMQ) notation.
The single-qubit gate will then be applied to each qubit, respectively.
If the name of the qubit register is `q`, then the following can be passed as an argument to the single-qubit gate:

- the whole qubit register `q`;

- a slice thereof `q[i:j]`, where $0 \leq i < j \leq N-1$;

- or a list of indices can be passed `q[i,]`, where $0 \leq i \leq N-1$,

with $N$ the size of the qubit register.
The following slicing convention is adopted: a slice `q[i:j]` includes qubits `q[i]`, `q[j]`, and all qubits in between. The code block below demonstrates some examples.

!!! example

    === "The whole qubit register"
        
        ```
        qubit[5] q

        X q  // is semantically equivalent to:
        X q[0]; X q[1]; X q[2]; X q[3]; X q[4]
        ```

    === "A slice of the qubit register"
        
        ```
        qubit[5] q

        X q[1:3]  // is semantically equivalent to:
        X q[1]; X q[2]; X q[3]
        ```

    === "A list of indices of the qubit register"
    
        ```
        qubit[5] q

        X q[0,2,4]  // is semantically equivalent to:
        X q[0]; X q[2]; X q[4] 
        ```

In the above examples we have used the semicolon `;` to separate statements occurring on the same line.

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
