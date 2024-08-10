A **`reset`** instruction resets the state of the qubit to $|0\rangle$.
It does this by first measuring the qubit and, conditioned on the outcome being 1, applying a Pauli X gate.
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

```linenums="1" hl_lines="9"
version 3.0

qubit[2] q
bit[2] b

H q[0]
CNOT q[0], q[1]

reset q[0]  // Resets the state of qubit q[0] to |0>

b = measure q
```

The `reset` instruction is performed by measuring `q[0]` along the computational basis.
Based on the measurement outcome, either no operation is performed (in case the outcome is 0) or
a Pauli X gate is applied (in case the outcome is 1).

The `measure` instruction should report $|00\rangle$ in 50% of the cases and $|10\rangle$ in the other 50% of the cases
(where lower qubit indices are shown here at the right of the string and higher indices at the left).
