Gates define single-qubit or multi-qubit unitary operations
that change the state of a qubit register in a deterministic fashion.
The general form of a gate is given by the gate name
followed by the (comma-separated list of) qubit operand(s), _e.g._, **`X q[0]`**:

!!! info ""
    
    &emsp;_gate qubit-arguments_

Parameterized unitary operations are represented by parameterized gates.
The general form of a parameterized gate is given by the gate name
followed by its (comma-separated list of) parameter(s) that is enclosed in parentheses,
which in turn is followed by the (comma-separated list of) qubit operand(s), _e.g._, **`CRk(2) q[0], q[1]`**:

!!! info ""
    
    &emsp;_gate_**`(`**_parameters_**`)`**_ qubit-arguments_

Note that the parameters, either single or a list of multiple parameters,
appear within parentheses directly following the gate name.
We distinguish between the _parameters_ of a parameterized gate,
in terms of number [literals](../tokens/literals.md),
and the _qubit arguments_ that a (parameterized) gate acts on.

??? info "Grammar for gates"
    
    _gate_:  
    &emsp; _identifier_ _parameters_~opt~ _qubit-arguments_

    _parameters_:  
    &emsp; __`(`__ _parameter-list_ __`)`__

    _parameter-list_:  
    &emsp; _parameter_  
    &emsp; _parameter-list_ __`,`__ _parameter_

    _parameter_:  
    &emsp; _integer-literal_  
    &emsp; _floating-literal_

    _qubit-arguments_:  
    &emsp; _qubit-argument-list_

    _qubit-argument-list_:  
    &emsp; _qubit-argument_  
    &emsp; _qubit-argument-list_ __`,`__ _qubit-argument_

    _qubit-argument_:  
    &emsp; _qubit-variable_  
    &emsp; _qubit-index_

    _qubit-variable_:  
    &emsp; _identifier_

    _qubit-index_:  
    &emsp; _index_

A few examples of gates are shown below.

!!! example ""

    ```
    // A single-qubit Hadamard gate
    H q[0]
    
    // A two-qubit controlled-Z gate (control: q[0], target: q[1])
    CZ q[0], q[1]
    
    // A parameterized single-qubit Rx gate (with π/2 rotation around the x-axis)
    Rx(pi/2) q[0]
    
    // A parametrized two-qubit controlled phase-shift gate (control: q[1], target: q[0])
    CRk(2) q[1], q[0]
    ```

The gates that are supported by the cQASM language
are listed in the [standard gate set](gates.md#standard-gate-set).

## Single-gate-multi-qubit (SGMQ) notation

It is possible to pass multiple qubits as an argument to a single-qubit gate,
by making use of the single-gate-multi-qubit (SGMQ) notation.
The single-qubit gate will then be applied to each qubit, respectively.

!!! note

    SGMQ notation does not imply that the gates are, necessarily, executed in parallel on the target device. 
    SGMQ notation is nothing other than _syntactic sugar_,
    whereby a series of instruction statements can be written as one.
    Moreover, SGMQ notation should not be confused with multiple-qubit gates, _e.g._, 
    **`X q[0,1]`** means **`X q[0]; X q[1]`**,
    and does not represent the 2-qubit gate **`XX q[0], q[1]`**.
    Note that the latter 2-qubit gate **`XX`** is currently not supported by the cQASM language,
    see the [standard gate set](gates.md#standard-gate-set) below.

If the name of the qubit register is **`q`**,
then the following can be passed as an argument to the single-qubit gate:

- the whole qubit register **`q`**;

- a slice thereof **`q[i:j]`**, where $0 \leq i < j < N$;

- or a list of indices can be passed **`q[i,]`**, where $0 \leq i < N$,

with $N$ the size of the qubit register.
The following slicing convention is adopted: a slice **`q[i:j]`** includes qubits **`q[i]`**, **`q[j]`**,
and all qubits in between. The code block below demonstrates some examples.

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

In the above examples we have used the semicolon **`;`** to separate statements occurring on the same line.

## Standard gate set

| Name | Description                              | Example statement       |
|------|------------------------------------------|-------------------------|
| I    | Identity gate                            | **`I q[0]`**            |
| H    | Hadamard gate                            | **`H q[0]`**            |
| X    | Pauli-X                                  | **`X q[0]`**            |
| X90  | Rotation around the _x_-axis of $\pi/2$  | **`X90 q[0]`**          |
| mX90 | Rotation around the _x_-axis of $-\pi/2$ | **`mX90 q[0]`**         |
| Y    | Pauli-Y                                  | **`Y q[0]`**            |
| Y90  | Rotation around the _y_-axis of $\pi/2$  | **`Y90 q[0]`**          |
| mY90 | Rotation around the _y_-axis of $-\pi/2$ | **`mY90 q[0]`**         |
| Z    | Pauli-Z                                  | **`Z q[0]`**            |
| S    | Phase gate                               | **`S q[0]`**            |
| Sdag | S dagger gate                            | **`Sdag q[0]`**         |
| T    | T                                        | **`T q[0]`**            |
| Tdag | T dagger gate                            | **`Tdag q[0]`**         |
| Rx   | Arbitrary rotation around _x_-axis       | **`Rx(pi) q[0]`**       |
| Ry   | Arbitrary rotation around _y_-axis       | **`Ry(pi) q[0]`**       |
| Rz   | Arbitrary rotation around _z_-axis       | **`Rz(pi) q[0]`**       |
| CNOT | Controlled-NOT gate                      | **`CNOT q[0], q[1]`**   |
| CZ   | Controlled-Z, Controlled-Phase           | **`CZ q[0], q[1]`**     |
| CR   | Controlled phase shift (arbitrary angle) | **`CR(pi) q[0], q[1]`** |
| CRk  | Controlled phase shift ($\pi/2^k$)       | **`CRk(2) q[0], q[1]`** |
