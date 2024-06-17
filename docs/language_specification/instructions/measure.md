The general form of a measurement instruction statement is as follows:

`<bit-name:BIT> = measure <qubit-argument:QUBIT>`

??? info "Syntax definition"
    
    ```hl_lines="8"
    LETTER: [a-zA-Z_]
    DIGIT: [0-9]
    INT: DIGIT+
    ID: LETTER (LETTER | DIGIT)*
    BIT: ID('[' INT ']')?
    QUBIT: ID('[' INT ']')?

    (ID | BIT) = measure (ID | QUBIT)
    ```

!!! example
    
    === "Measurement of a single qubit"
    
        ```hl_lines="3"
        qubit q
        bit b
        b = measure q
        ```
    
    === "Measurement of multiple qubits through their register index"
    
        ```hl_lines="3"
        qubit[5] qreg
        bit[2] breg
        breg[0, 1] = measure qreg[2, 4]
        ```

!!! note

    The measure instruction accepts [SGMQ notation](gates.md#single-gate-multi-qubit-sgmq-notation), similar to gates.

The following code snippet shows how the measure instruction might be used in context

```linenums="1" hl_lines="9"
version 3.0

qubit[2] q
bit[2] b

H q[0]
CNOT q[0], q[1]

b[0, 1] = measure q[0, 1]  // Measurement in the standard basis.
```

On the last line of this simple cQASM program, the respective states of both qubits in the qubit register are measured along the standard/computational basis.
