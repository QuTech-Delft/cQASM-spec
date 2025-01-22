A **`reset`** instruction resets the state of the qubit to $|0\rangle$.
It does this by first measuring the qubit and then, conditioned on the outcome being 1, applying a Pauli X gate.

!!! note
    
    Even though the `reset` instruction internally measures the qubit state,
    it does not store the measurement outcome in the measurement register,
    _i.e._, the measurement register is unaffected by the `reset` instruction.
    The measurement outcome is only used to determine whether or not
    a Pauli X gate needs to be performed, in order to bring the qubit
    into the state $|0\rangle$.

The general form of a reset instruction is as follows:

!!! info ""

    &emsp;**`reset`** _qubit-argument_

??? info "Grammar for reset instruction"
    
    _reset-instruction_:  
    &emsp; __`reset`__ _qubit-argument_

    _qubit-argument_:  
    &emsp; _qubit-variable_  
    &emsp; _qubit-index_

    _qubit-variable_:  
    &emsp; _identifier_

    _qubit-index_:  
    &emsp; _index_

!!! example
    
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

    The reset instruction accepts
    [SGMQ notation](../single-gate-multiple-qubit-notation.md), similar to gates.

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
The result of the subsequent `measure` instruction will be `00` in roughly half of the cases
and `10` in the remaining cases,
with the qubit register indices decreasing from left to right, _i.e._, `q[n]...q[0]`.

!!! info
    
    Qubits that are part of an entangled state,
    are disentangled from that state,
    when the `reset` instruction is applied to them.
