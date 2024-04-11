The general structure of a cQASM program is as follows:

- **[Comment(s)](whitespace-comments.md)** 
    - _optional_ 
    - _at any location in the program_
- **[Version statement](../statements/version-statement.md)**
    - _mandatory_
    - _at the top, save for some potential comment(s)_
- **[Qubit (register) declaration statement](../statements/qubit-register-declaration.md)**
    - _optional_
- **Instruction(s)**
    - [Gate(s)](../instructions/gates.md)
        - _optional_ 
        - _requires a qubit (register) declaration_ 
    - [Measure instruction](../instructions/measure-instruction.md)
        - _optional_ 
        - _requires a qubit (register) declaration_ 
        - _at the end, save for some potential following comment(s)_
        - only a single measure instruction

!!! example

    === "Example cQASM program"

        ```linenums="1"
        // Example program according to the cQASM language specification
        
        // Version statement
        version 3.0
        
        // Qubit register declaration statement
        qubit[2] q
        
        // Instructions (Gates)
        Rx(pi/2) q[0]
        H q[0]; H q[1]
        CNOT q[0], q[1]
        
        // Instructions (Measure instruction)
        H q[0]
        measure q[0, 1]
        
        ```

    === "Smallest valid cQASM program"

        ```linenums="1"
        version 3
        ```
