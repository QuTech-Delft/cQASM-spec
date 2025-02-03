The general form of the **`wait`** instruction is as follows:

!!! info ""

    &emsp;__`wait(`__ _parameter_ __`)`__ _qubit-argument_

??? info "Grammar for **`wait`** instruction"
    
    _wait-instruction_:  
    &emsp;__`wait(`__ _parameter_ __`)`__ _qubit-argument_

    _parameter_:  
    &emsp; _integer-literal_ 

    _qubit-argument_:  
    &emsp; _qubit-variable_  
    &emsp; _qubit-index_

    _qubit-variable_:  
    &emsp; _identifier_

    _qubit-index_:  
    &emsp; _index_

!!! note

    The **`wait`** instruction accepts
    [SGMQ notation](../single-gate-multiple-qubit-notation.md), similar to gates.
