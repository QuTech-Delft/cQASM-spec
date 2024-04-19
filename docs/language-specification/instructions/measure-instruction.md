Currently, cQASM only supports a measurement statement at the end of the circuit, _i.e._, only comments or additional measurement statements may follow. The general form of a measurement statement is as follows:

`measure <qubit-argument:QUBIT>`

??? info "Regex pattern"
    
    ```hl_lines="7"
    LETTER=[_a-zA-Z]
    DIGIT=[0-9]
    INT={DIGIT}+
    ID={LETTER}({LETTER}|{INT})*
    QUBIT={ID}(\[{INT}\])?

    measure (ID | QUBIT)
    ```

!!! example
    
    === "Qubit measurement"
    
        ```hl_lines="2"
        qubit q
        measure q
        ```
    
    === "Qubit measurement (register index)"
    
        ```hl_lines="2"
        qubit[5] qreg
        measure qreg[0]
        ```

!!! note

    The measure instruction accepts [SGMQ notation](gates.md#single-gate-multi-qubit-sgmq-notation), similar to gates.

The following code snippet shows how the measure instruction might be used in context

```linenums="1" hl_lines="8"
version 3.0

qubit[2] q

H q[0]
CNOT q[0], q[1]

measure q  // Measurement of the qubit states in the standard basis.
```

On the last line of this simple cQASM program, the respective states of both qubits in the qubit register are measured along the standard/computational basis.

!!! warning

    Neither intermediate nor midcircuit measurements are supported at this stage.

