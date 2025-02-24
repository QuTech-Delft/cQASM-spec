The cQASM language specification consists of a description of its [tokens](general_overview.md#tokens),
[statements](general_overview.md#statements), [types](general_overview.md#types), and
[expressions](general_overview.md#expressions).
Additional information is provided on the [case sensitivity](general_overview.md#case-sensitivity) of the language,
the preferred [file extension](general_overview.md#file-extension) of a cQASM program,
and a brief explanation on how to interpret the [grammar sections](general_overview.md#grammar-sections)
of this specification.

## Tokens

A cQASM program can contain the following types of tokens:

- [Newlines](tokens/newlines.md)
- [Literals](tokens/literals.md)
- [Identifiers](tokens/identifiers.md)
- [Keywords](tokens/keywords.md)
- [Raw text](tokens/raw_text)
- [Operators and punctuators](tokens/operators_and_punctuators.md)  

[Whitespace and comments](tokens/whitespace_and_comments.md) are ignored except as they serve to separate tokens.

## Statements

A cQASM program consists of a list of *statements*, more concretely,
a *version statement* followed by *variable declarations* and *instructions*. 
In essence, a quantum algorithm is expressed via a sequence of unitary and non-unitary quantum operations
applied to qubit arguments
(_e.g._, the [*measure instruction*](statements/instructions/non_unitary_instructions/measure_instruction.md)).
The unitary operations, commonly know as gates, can be either
[*named gates*](statements/instructions/unitary_instructions.md#named-gates) or compositions of
[*gate modifiers*](statements/instructions/unitary_instructions.md#gate-modifiers) acting on a named gate.

!!! note

    For simplicity, throughout this documentation, we use the term *gate* to refer to a *named gate*.
    However, it is important to note that the result of applying a gate modifier is also a gate.
    When we need to refer explicitely to a named gate such as `H` or `Rz`,
    and not to a gate resulting from applying a gate modifier, we use the term *named gate*.

- [Version statement](statements/version_statement.md) (_mandatory_)
- Variable declarations:
    - [Qubit (register) declaration](statements/variable_declarations/qubit_register_declaration.md)
    - [Bit (register) declaration](statements/variable_declarations/bit_register_declaration.md)
- Instructions:
    - [Unitary instructions](statements/instructions/unitary_instructions.md) (_i.e._, gates)
    - Non-unitary instructions:
        - [Init instruction](statements/instructions/non_unitary_instructions/init_instruction.md)
        - [Measure instruction](statements/instructions/non_unitary_instructions/measure_instruction.md)
        - [Reset instruction](statements/instructions/non_unitary_instructions/reset_instruction.md)
    - Control instructions:
        - [Barrier instruction](statements/instructions/control_instructions/barrier_instruction.md)
        - [Wait instruction](statements/instructions/control_instructions/wait_instruction.md)
    - [Single-gate-multiple-qubit (SGMQ) notation](statements/instructions/single-gate-multiple-qubit-notation.md)
- [Assembly declaration](statements/assembly_declaration.md)

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
        
        // Gate
        H q[0]

        // Gate modifier
        ctrl.X q[0], q[1]
        
        // Measure instruction
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
the Hadamard gate **`H`** is applied to the qubit at index **`0`** of the qubit register **`q`**.
The next line starts with an undefined gate **`h`** 
that operates on the qubit at index **`0`** of the qubit register **`Q`**,
which in turn does _not_ refer to the qubit register **`q`**.

Take care that case sensitivity not only applies to [identifiers](tokens/identifiers.md),
but also to all other lexical components of the language,
like [keywords](tokens/keywords.md), [types](types.md),
[predefined constants](expressions/predefined_constants.md),
and [built-in functions](expressions/builtin_functions.md).

!!! note

    Gate names are identifiers and are therefore case-sensitive.
    The syntax of the gates defined in cQASM are listed in the
    [cQASM standard gate set](statements/instructions/unitary_instructions.md#standard-gate-set).
    Even though it is common practice to write variable names or function identifiers in lowercase,
    we choose to define the gate names in the predefined cQASM standard gate set in UPPERCASE or CamelCase,
    as this is more in line with how these gates are represented in the field of quantum information processing (QIP). 

## File extension

The preferred file extension for a cQASM file is `*.cq`.

## *How to read*

### *Grammar sections*

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

### *Qubit state and measurement bit ordering*

In this specification, qubit states are represented using the ket-vector notation $|\Psi\rangle$
and measurement outcomes are represented as bit strings.

Qubits in a ket-vector are ordered with qubit indices decreasing from left to right, _i.e._,
$|\Psi\rangle = \sum c_i~(|q_n\rangle\otimes |q_{n-1}\rangle\otimes~...\otimes~|q_1\rangle\otimes |q_0\rangle)_i$
$=\sum c_i~|q_nq_{n-1}~...q_1q_0\rangle_i$.
For example, given the state $|01\rangle$, $q_0$ is in state $|1\rangle$
and $q_1$ is in state $|0\rangle$. 

Measurement outcomes are represented by a bit string,
which adheres to the same ordering convention as qubit states,
_i.e._ with the (qu)bit indices decreasing from left to right.    

Consider a qubit register of size 3, `qubit[3] q`,
where each individual qubit can be referred to by its index as `q[0]`, `q[1]`, and `q[2]`.
If the state of this qubit register is $|110\rangle$,
then measuring it will result in the following bit string:

| `q[2]` | `q[1]` | `q[0]` |
|:------:|:------:|:------:|
|  `1`   |  `1`   |  `0`   |

The same ordering applies to bit registers, _i.e._, for a bit register `b`,
the ordering is given by `b[n-1]b[n]...b[1]b[0]`.
