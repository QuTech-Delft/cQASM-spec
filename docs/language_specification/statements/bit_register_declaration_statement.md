A bit or bit register must be declared before they can be used.
The general form is given as follows

`bit[<number-of-bits:INT>] <bit(-register)-name:ID>`

??? info "Syntax definition"
    
    ```hl_lines="6"
    LETTER: [a-zA-Z_]
    DIGIT: [0-9]
    INT: DIGIT+  
    ID: LETTER (LETTER | DIGIT)*

    bit('[' INT ']')? ID     
    ```

Its form is similar to the declaration of an arbitrary variable, whereby the type of the variable is specified first, _i.e._ [`bit`](../type_system/types.md) denotes that the declared variable is of type _bit_.
The size of the bit register is declared by an integer value between square brackets `[<number-of-bits:INT>]`, directly following the type.
A single bit can also be declared by omitting the square brackets `[]`.
The name of the bit (register) is defined through an [identifier](../structure/identifiers.md). 

The declaration of a bit (register) is _optional_,
Nevertheless, since measurement outcomes are stored as bits, [measurement instruction statements](../instructions/measure.md) require a previously declared bit (register).

Find below examples, respectively, of a single qubit declaration and qubit register declaration.

!!! example

    === "Single bit declaration"

        ```linenums="1" hl_lines="4"
        version 3

        qubit q
        qubit b  // Single bit declaration of a bit named 'b'.

        H q

        b = measure q
        ```
    
    === "Bit register declaration"

        ```linenums="1" hl_lines="4"
        version 3

        qubit[5] q
        bit[2] b  // Bit register declaration of a register containing 2 bits, named 'b'.

        H q[0]
        CNOT q[0], q[1]

        b[0] = measure q[0]
        b[1] = measure q[1]
        ```

The individual bits of a bit register can be referred to by their register index, _e.g._ in the example of the _Bit register declaration_, the statement `b[0] = measure q[0]` indicates that the measurement outcome is stored at the bit located at index `0` of the bit register `b`. 
Note that in the case of a single bit, the bit is referred to through its identifier, not through a register index.