The general structure of a cQASM program is as follows:

- **[Comment(s)](whitespace_comments.md)** (_optional_)
- **[Version statement](../statements/version_statement.md)** (_mandatory_)
- **[Qubit (register) declaration statement](../statements/qubit_register_declaration_statement.md)** (_optional_)
- **[Bit (register) declaration statement](../statements/bit_register_declaration_statement.md)** (_optional_)
- **[Instruction statement(s)](../statements/instruction_statement.md)** (_optional_)
    - [Gates](../instructions/gates.md)
    - [Measure](../instructions/measure.md)

!!! example

    === "Example cQASM program"

        ```linenums="1"
        // Example program according to the cQASM language specification
        
        // Version statement
        version 3.0
        
        // Qubit register declaration statement
        qubit[2] q

        // Bit register declaration statement
        bit[2] b
        
        // Instruction statements (Gates)
        H q[0]
        CNOT q[0], q[1]
        
        // Instruction statement (Measure)
        b[0, 1] = measure q[0, 1]
        ```

    === "Smallest valid cQASM program"

        ```linenums="1"
        version 3
        ```
