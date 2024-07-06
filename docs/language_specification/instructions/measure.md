The general form of a measurement instruction statement is as follows:

`bit-argument = measure qubit-argument`

??? info "Grammar for measure"
    
    _measure_:</br>
    &nbsp;&nbsp;&nbsp;&nbsp;_bit-argument_ <code>__=__</code> _measure_ _qubit-argument_</br>
    _bit-argument_:</br>
    &nbsp;&nbsp;&nbsp;&nbsp;_bit-variable_</br>
    &nbsp;&nbsp;&nbsp;&nbsp;_bit-index_</br>
    _bit-variable_:</br>
    &nbsp;&nbsp;&nbsp;&nbsp;_identifier_</br>
    _bit-index_:</br>
    &nbsp;&nbsp;&nbsp;&nbsp;_index_</br>
    _qubit-argument_:</br>
    &nbsp;&nbsp;&nbsp;&nbsp;_qubit-variable_</br>
    &nbsp;&nbsp;&nbsp;&nbsp;_qubit-index_</br>
    _qubit-variable_:</br>
    &nbsp;&nbsp;&nbsp;&nbsp;_identifier_</br>
    _qubit-index_:</br>
    &nbsp;&nbsp;&nbsp;&nbsp;_index_</br>

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
