Gates define single-qubit or multi-qubit unitary operations that change the state of a qubit register in a deterministic fashion.
In essence, a quantum algorithm consists of a sequence of gates and non-unitary quantum instructions, _e.g._, the [measurement instruction](measure.md).
The general form of a gate instruction statement is given by the following:

`<gate-name:ID> <qubit-argument(s):QUBIT,>`

Parameterized unitary operations are represented by parameterized gates.
The general form of a parameterized gate instruction statement is given as follows:

`<gate-name:ID>(<parameter(s):FLOAT|INT,>) <qubit-argument(s):QUBIT,>`

Note that the parameters, either single or a list of multiple parameters, appear within parentheses directly following the gate name.
We distinguish between the _parameters_ of a parameterized gate, in terms of [number literals](../expressions/number_literals.md), and the _qubit arguments_ a (parameterized) gate instruction acts on.

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

A few examples of gate instruction statements are shown below.

!!! example ""

    ```
    // A single-qubit Hadamard gate
    H q[0]
    
    // A two-qubit controlled-Z gate (control: q[0], target: q[1])
    CZ q[0], q[1]
    
    // A paramterized single-qubit Rx gate (with π/2 rotation around the x-axis)
    Rx(pi/2) q[0]
    
    // A parametrized two-qubit controlled phase-shift gate (control: q[1], target: q[0])
    CRk(2) q[1], q[0]
    ```

The gates that are supported by the language are listed below in the [standard gate set](gates.md#standard-gate-set).

## Single-gate-multi-qubit (SGMQ) notation

It is possible to pass multiple qubits as an argument to a single-qubit gate, by making use of the single-gate-multi-qubit (SGMQ) notation.
The single-qubit gate will then be applied to each qubit, respectively.

!!! note

    SGMQ notation does not imply that the gates are, necessarily, executed in parallel on the target device. 
    SGMQ notation is nothing other than _syntactic sugar_, whereby a series of instruction statements can be written as one.
    Moreover, SGMQ notation should not be confused with multiple-qubit gates, _e.g._, `X q[0,1]` means `X q[0]; X q[1]`, and does not represent the 2-qubit gate statement `XX q[0], q[1]`.
    Note that the latter 2-qubit gate `XX` is currently not supported by the cQASM language, see the [standard gate set](gates.md#standard-gate-set) below.

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
