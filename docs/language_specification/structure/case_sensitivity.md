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

Take care that case sensitivity not only applies to [identifiers](../tokens/identifiers.md),
but also to all other lexical components of the language,
like [keywords](../tokens/keywords), [types](../type_system/types.md),
[predefined constants](../expressions/predefined_constants.md),
and [built-in functions](../expressions/builtin_functions.md).



!!! note

    Gate names are identifiers and are therefore case-sensitive.
    The syntax of the gates defined in cQASM are listed in the [cQASM standard gate set](../instructions/gates.md#standard-gate-set).
    Even though it is common practice to write variable names or function identifiers in lowercase,
    we choose to define the gate names in the predefined cQASM standard gate set in UPPERCASE or CamelCase,
    as this is more in line with how these gates are represented in the field of quantum information processing (QIP). 
