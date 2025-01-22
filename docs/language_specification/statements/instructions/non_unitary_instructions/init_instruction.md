A **`init`** instruction initializes the state of the qubit to $|0\rangle$.

The general form of an init instruction is as follows:

!!! info ""

    &emsp;**`init`** _qubit-argument_

??? info "Grammar for init instruction"
    
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

    The init instruction accepts
    [SGMQ notation](../single-gate-multiple-qubit-notation.md), similar to gates.

The following code snippet shows how the reset instruction might be used in context.

```linenums="1" hl_lines="6"
version 3.0

qubit[2] q
bit[2] b

init q  // Initializes the qubits to |0>

H q[0]
CNOT q[0], q[1]

b = measure q
```

_explanation_

!!! info
    
    _Initialization of qubits can only be done immediately after declaration._
