Backend code is any _raw text_ that can appear in the body of an 
[assembly declaration](../statements/assembly_declaration.md).
Its syntax and semantics are wholly determined by the backend for which the text is written.
The only restriction is described in the warning below and
stems from the syntax of the assembly declaration.

!!! warning "Curly brace sequences within backend code, if any, must match"

    Backend code, if not empty,
    starts right after the opening curly brace `{` of an assembly declaration,
    and ends right before the first matching closing curly brace `}`.
    That means that inner closing curly braces can be used
    as long as they correctly match other inner opening curly braces. 
    
    The following sequences are all valid for a backend code text:

    ```
    asm(Backend) {}
    asm(Backend) { a {b} }  // '{b}' is a correct inner curly brace sequence
    asm(Backend) { a {} {{b}} c }  // '{}' and '{{b}}' are correct inner curly brace sequences
    ```

    While these other would result in a parsing error:

    ```
    asm(Backend) { a } b }  // 'b }' would be treated as an invalid sequence of tokens
    asm(Backend) { a }{}{ b }  // '{}{ b }' would be treated as an invalid sequence of tokens
    ```

    
    