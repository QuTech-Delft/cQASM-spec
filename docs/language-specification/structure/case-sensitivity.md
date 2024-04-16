cQASM is now a case-sensitive language, in contrast to previous versions. 
The following lines of code are semantically distinct

!!! example ""

    ```
    h q[0]
    H Q[0]
    ```

!!! note

    Gate names are case-sensitive.
    The recognized gates and their proper syntactic form are defined in the [cQASM standard gate set](../instructions/gates.md#standard-gate-set).
    Even though, it is common practice to write variable names or function identifiers in lowercase, we choose to define the gate names in the predefined cQASM standard gate set in UPPERCASE or CamelCase, as this is more in line with how these gates are represented in the field of quantum information processing (QIP). 
