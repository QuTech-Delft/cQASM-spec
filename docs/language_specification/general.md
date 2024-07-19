## Tokens

A cQASM program can contain the following type of tokens:

- [Newlines](tokens/newlines.md)
- [Literals](tokens/literals.md)
- [Keywords](tokens/keywords.md)
- [Identifiers](tokens/identifiers.md)
- [Operators and other separators](tokens/operators_and_punctuators.md)  

[Whitespace and comments](tokens/whitespace_and_comments.md) are ignored except as they serve to separate tokens.

## Statements

A cQASM program consists of a sequence of statements:

- [Version statement](statements/version_statement.md) (_mandatory_)
- [Qubit (register) declaration](statements/qubit_register_declaration.md)
- [Bit (register) declaration](statements/bit_register_declaration.md)
- [Gates](statements/gates.md)
- [Measure statement](statements/measure_statement.md)

## Types

A cQASM program allows using this set of [Types](types.md). 

## Expressions

The following expressions can appear in a statement:

- [Indices](expressions/indices.md)
- [Predefined constants](expressions/predefined_constants.md)
- [Builtin functions](expressions/builtin_functions.md)

## File extension

The preferred file extension for a cQASM file is `*.cq`.

## Case sensitivity

cQASM is now a [case-sensitive](case_sensitivity.md) language, in contrast to previous versions.

!!! example

    === "Example cQASM program"

        ```linenums="1"
        // Example program according to the cQASM language specification
        
        // Version statement
        version 3.0
        
        // Qubit register declaration
        qubit[2] q

        // Bit register declaration
        bit[2] b
        
        // Gates
        H q[0]
        CNOT q[0], q[1]
        
        // Measure statement
        b[0, 1] = measure q[0, 1]
        ```

    === "Smallest valid cQASM program"

        ```linenums="1"
        version 3
        ```
