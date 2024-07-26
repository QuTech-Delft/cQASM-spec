The general form of a measurement statement is as follows:

!!! info ""

    &emsp;_bit-argument_ **`= measure`** _qubit-argument_

??? info "Grammar for measure statement"
    
    _measure_:  
    &emsp; _bit-argument_ __`= measure`__ _qubit-argument_

    _bit-argument_:  
    &emsp; _bit-variable_  
    &emsp; _bit-index_

    _bit-variable_:  
    &emsp; _identifier_

    _bit-index_:  
    &emsp; _index_

    _qubit-argument_:  
    &emsp; _qubit-variable_  
    &emsp; _qubit-index_

    _qubit-variable_:  
    &emsp; _identifier_

    _qubit-index_:  
    &emsp; _index_  

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

b = measure q  // Measurement in the standard basis.
```

On the last line of this simple cQASM program,
the respective states of both qubits in the qubit register are measured along the standard/computational basis.
