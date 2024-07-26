The cQASM language specification consists of a description of its [Tokens](general_overview.md#tokens),
[Statements](general_overview.md#statements), [Types](general_overview.md#types),
and [Expressions](general_overview.md#expressions).
Additional information is provided on the [case sensitivity](general_overview.md#case-sensitivity) of the language,
the preferred [file extension](general_overview.md#file-extension) of a cQASM program,
and a brief explanation on how to interpret the [grammar sections](general_overview.md#about-the-grammar-sections).

## Tokens

A cQASM program can contain the following types of tokens:

- [Newlines](tokens/newlines.md)
- [Literals](tokens/literals.md)
- [Identifiers](tokens/identifiers.md)
- [Keywords](tokens/keywords.md)
- [Operators and punctuators](tokens/operators_and_punctuators.md)  

[Whitespace and comments](tokens/whitespace_and_comments.md) are ignored except as they serve to separate tokens.

## Statements

A cQASM program consists of a sequence of statements:

- [Version statement](statements/version_statement.md) (_mandatory_)
- [Qubit (register) declaration](statements/qubit_register_declaration.md)
- [Bit (register) declaration](statements/bit_register_declaration.md)
- [Gates](statements/gates.md)
- [Measurement statement](statements/measurement_statement.md)

!!! example ""

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

## Types

The set of types supported by cQASM can be found in the section [Types](types.md). 

## Expressions

The following expressions can appear in a statement:

- [Indices](expressions/indices.md)
- [Predefined constants](expressions/predefined_constants.md)
- [Built-in functions](expressions/builtin_functions.md)

## Case sensitivity

cQASM is now a case-sensitive language, in contrast to previous versions. 
The following lines of code are all semantically distinct

!!! example ""

    ```
    H q[0]
    h Q[0]
    ```

In the first line of the example above,
the Hadamard gate `H` is applied to the qubit at index `0` of the qubit register `q`.
The next line starts with an undefined gate `h` that operates on the qubit at index `0` of the qubit register `Q`,
which in turn does _not_ refer to the qubit register `q`.

Take care that case sensitivity not only applies to [identifiers](tokens/identifiers.md),
but also to all other lexical components of the language,
like [keywords](tokens/keywords.md), [types](types.md),
[predefined constants](expressions/predefined_constants.md),
and [built-in functions](expressions/builtin_functions.md).

!!! note

    Gate names are identifiers and are therefore case-sensitive.
    The syntax of the gates defined in cQASM are listed in the [cQASM standard gate set](statements/gates.md#standard-gate-set).
    Even though it is common practice to write variable names or function identifiers in lowercase,
    we choose to define the gate names in the predefined cQASM standard gate set in UPPERCASE or CamelCase,
    as this is more in line with how these gates are represented in the field of quantum information processing (QIP). 

## File extension

The preferred file extension for a cQASM file is `*.cq`.

## *About the grammar sections*

In the notation and grammar descriptions appearing throughout this language specification, 
syntactic categories are indicated by _italic_ type,
and literal words and characters in __`bold constant width`__ type.
Alternatives are listed on separate lines except in a few cases
where a long set of alternatives is presented on one line, with the quantifiers 'one of', 'through', or 'or'.
For example,

!!! info ""

    &emsp;one of __`a`__ through __`z`__ or __`A`__ through __`Z`__

indicates any lowercase or uppercase alphabetic character.

An optional terminal or non-terminal symbol is indicated by the subscript ~opt~, so

!!! info ""

    &emsp;__`{`__ _expression_~opt~__`}`__

indicates an optional expression enclosed in curly braces.

Names for syntactic categories have generally been chosen according to the following rules:

- _X-sequence_ is one or more _X_’s without intervening delimiters, _e.g._, _digit-sequence_ is a sequence of digits.
- _X-list_ is one or more _X_’s separated by intervening commas, _e.g._, _index-list_ is a sequence of 
indices separated by commas.
