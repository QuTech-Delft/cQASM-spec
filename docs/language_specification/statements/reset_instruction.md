A **`reset`** instruction performs a measurement plus a Pauli X on the qubit argument.
The general form of a reset instruction is as follows:

!!! info ""

    &emsp;**`reset`** _qubit-argument_

??? info "Grammar for reset instruction"
    
    _reset_:  
    &emsp; __`reset`__  
    &emsp; __`reset`__ _qubit-argument_

    _qubit-argument_:  
    &emsp; _qubit-variable_  
    &emsp; _qubit-index_

    _qubit-variable_:  
    &emsp; _identifier_

    _qubit-index_:  
    &emsp; _index_

!!! example
    
    === "Reset of all the qubits"
    
        ```linenums="1", hl_lines="3"
        qubit q
        qubit[5] qq
        reset
        ```
    
    === "Reset of a single qubit"
    
        ```linenums="1", hl_lines="2"
        qubit q
        reset q
        ```
    
    === "Reset of multiple qubits through their register index"
    
        ```linenums="1", hl_lines="2"
        qubit[5] q
        reset q[2, 4]
        ```

!!! note

    The reset instruction accepts [SGMQ notation](gates.md#single-gate-multi-qubit-sgmq-notation), similar to gates.

The following code snippet shows how the reset instruction might be used in context.

```linenums="1" hl_lines="8"
version 3.0

qubit[2] q

H q[0]
CNOT q[0], q[1]

reset q  // Measurement in the standard basis, plus a Pauli X on q
```

On the last line of this simple cQASM program,
the respective states of both qubits in the qubit register are measured along the standard/computational basis.
Then a Pauli X is performed on both qubits.
