In general, qubits are initialized in the $|0\rangle$ state.
Nonetheless, to explicitly initialize (particular) qubits in the $|0\rangle$ state
one can use the **`init`** instruction.
The general form of an **`init`** instruction is as follows:

!!! info ""

    &emsp;**`init`** _qubit-argument_

??? info "Grammar for **`init`** instruction"
    
    _init-instruction_:  
    &emsp; __`init`__ _qubit-argument_

    _qubit-argument_:  
    &emsp; _qubit-variable_  
    &emsp; _qubit-index_

    _qubit-variable_:  
    &emsp; _identifier_

    _qubit-index_:  
    &emsp; _index_

!!! example

    === "Initialize a single qubit"
    
        ```linenums="1", hl_lines="2"
        qubit q
        init q
        ```
    
    === "Initialize multiple qubits through their register index"
    
        ```linenums="1", hl_lines="2"
        qubit[5] q
        init q[2, 4]
        ```

!!! note

    The **`init`** instruction accepts
    [SGMQ notation](../single-gate-multiple-qubit-notation.md), similar to gates.

The following code snippet shows how the **`init`** instruction might be used in context.

```linenums="1" hl_lines="6"
version 3.0

qubit[2] q
bit[2] b

init q  // Initializes the qubits to |0>

H q[0]
CNOT q[0], q[1]

b = measure q
```

In the code example above, the qubits are first declared and subsequently initialized.
Note that the initialization of qubits needs to be done before any instructions
(excluding the [**`barrier`**](../control_instructions/barrier_instruction.md)
and [**`wait`**](../control_instructions/wait_instruction.md) control instructions)
are applied to them (see warning below).
If one wishes to _reset_ the state of the qubit to $|0\rangle$ mid-circuit,
one should use the [**`reset`**](../non_unitary_instructions/reset_instruction.md) instruction.


!!! warning
    
    Initialization of a qubit can only be done immediately after declaration of the qubit, _i.e._, 
    it is not possible to initialize a qubit, if prior to that an instruction was applied to the qubit
    (excluding the [barrier](../control_instructions/barrier_instruction.md)
    and [wait](../control_instructions/wait_instruction.md) control instructions).

    === "Invalid initialization"
        
        ```linenums="1" hl_lines="8"
        version 3.0
    
        qubit[2] q

        barrier q  // Control instructions may be applied to qubits before initialization
        H q[1]

        init q[1]  // Invalid use, since the H gate was applied to q[1] before initialization
        ```

    === "Valid initialization"
        
        ```linenums="1" hl_lines="8"
        version 3.0
    
        qubit[2] q
    
        barrier q  // Control instructions may be applied to qubits before initialization
        H q[1]

        init q[0]  // Valid use, because no instruction is applied to q[0] before initalization
        ```
    
