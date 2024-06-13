A qubit or qubit register can only be declared once and must occur before it is used.
The general form is given as follows

`qubit[<number-of-qubits:INT>] <qubit(-register)-name:ID>`

??? info "Regex pattern"
    
    ```hl_lines="6"
    LETTER=[_a-zA-Z]
    DIGIT=[0-9]
    INT={DIGIT}+
    ID={LETTER}({LETTER}|{INT})*

    qubit(\[{INT}\])? {ID}    
    ```

Its form is similar to the declaration of an arbitrary variable, whereby the type of the variable is specified first, _i.e._ [`qubit`](../type_system/types.md) denotes that the declared variable is of type _qubit_.
The size of the qubit register is declared by an integer value between square brackets `[<number-of-qubits:INT>]`, directly following the type.
A single qubit can also be declared by omitting the square brackets `[]`.
The name of the qubit (register) is defined through an [identifier](../structure/identifiers.md). 

The declaration of a qubit (register) is _optional_. 

!!! note

    The qubit (register) declaration replaces the _qubit statement_, `qubits <number-of-qubits:INT>`, of previous versions of the cQASM language.

Find below examples, respectively, of a single qubit declaration and qubit register declaration.

!!! example

    === "Single qubit declaration"

        ```linenums="1" hl_lines="1"
        qubit q  // Single qubit declaration of a qubit named 'q'.

        H q

        measure q
        ```
    
    === "Qubit register declaration"

        ```linenums="1" hl_lines="1"
        qubit[5] qreg  // Qubit register declaration of a register containing 5 qubits, named 'qreg'.

        H qreg[0]
        CNOT qreg[0], qreg[1]

        measure qreg
        ```

The individual qubits of a qubit register can be referred to by their register index, _e.g._ in the example of the _Qubit register declaration_, the statement `H qreg[0]` indicates the application of a Hadamard gate `H` on the qubit located at index `0` of the qubit register `qreg`. 
Note that in the case of a single qubit, the qubit is referred to through its identifier, not through a register index.

Qubits, either declared as a single qubit or as elements of a register, are presumed to be initialized in the state $|0\rangle$ of the standard/computational basis.