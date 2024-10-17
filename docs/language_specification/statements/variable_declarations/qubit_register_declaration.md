A qubit (register) must be declared before it can be used.
The general form is given as follows:

!!! info "" 
    
    &emsp;**`qubit[`**_size_**`] `**_identifier_

??? info "Grammar for bit (register) declaration"
    
    _qubit-declaration_:  
    &emsp; __`qubit`__ _array-size-declaration_~opt~ _identifier_

    _array-size-declaration_:  
    &emsp; __`[`__ _integer-literal_ __`]`__  

Its form is similar to the declaration of an arbitrary variable,
whereby the type of the variable is specified first, _i.e._ 
**`qubit`** denotes that the declared variable is of type [Qubit](../../types.md).
and **`qubit[`**_size_**`]`**
denotes that the declared variable is of type [QubitArray](../../types.md).
The size of a qubit register is declared by an integer value between square brackets **`[`**_size_**`]`**.
The name of the qubit (register) is defined through an [identifier](../../tokens/identifiers.md). 

The declaration of a qubit (register) is _optional_. 

!!! note

    The qubit (register) declaration replaces the qubit statement, _i.e._, 
    
    &emsp;**`qubits`** _size_
    
    of previous versions of the cQASM language.

Find below examples, respectively, of a single qubit declaration and qubit register declaration.

!!! example

    === "Single qubit declaration"

        ```linenums="1" hl_lines="3"
        version 3

        qubit q  // Single qubit declaration of a qubit named 'q'.
        qubit b

        H q

        b = measure q
        ```
    
    === "Qubit register declaration"

        ```linenums="1" hl_lines="3"
        version 3

        qubit[5] q  // Qubit register declaration of a register containing 5 qubits, named 'q'.
        bit[2] b

        H q[0]
        CNOT q[0], q[1]

        b[0, 1] = measure q[0, 1]
        ```

The individual qubits of a qubit register can be referred to by their register index,
_e.g._, in the example of the _Qubit register declaration_,
the statement **`H q[0]`** indicates the application of a Hadamard gate **`H`** on the qubit located at index **`0`**
of the qubit register **`q`**. 
Note that in the case of a single qubit, 
the qubit is referred to through its identifier, not through a register index.

Qubits, either declared as a single qubit or as elements of a register,
are presumed to be initialized in the state $|0\rangle$ of the standard/computational basis.
