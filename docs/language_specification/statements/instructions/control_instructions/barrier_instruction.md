The general form of the barrier instruction is as follows:

!!! info ""

    &emsp;**`barrier`** _qubit-argument_

??? info "Grammar for barrier instruction"
    
    _barrier-instruction_:  
    &emsp; __`barrier`__ _qubit-argument_

    _qubit-argument_:  
    &emsp; _qubit-variable_  
    &emsp; _qubit-index_

    _qubit-variable_:  
    &emsp; _identifier_

    _qubit-index_:  
    &emsp; _index_