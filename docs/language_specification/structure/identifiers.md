An identifier `ID` is a single character or a sequence of characters of the following form: upper or lowercase letters from the ISO basic Latin alphabet, underscore, and digits, with the constraint that the first (or singular) character cannot be a digit.

For now, they are used to define the names of (qu)bits or (qu)bit registers by the user, and predefine the names of useful [mathematical constants](../expressions/predefined_constants.md), [built-in functions](../expressions/builtin_functions.md), and [gates](../instructions/gates.md).
Note that identifiers are not protected, _i.e._ they can be reused. 
For example, it is permissible, however discouraged, to name a (qu)bit or (qu)bit register`pi`, `cos`, or `X`.

[Reserved keywords](reserved_keywords.md) cannot be used as an identifier.

??? info "Syntax definition"

    ```hl_lines="4"
    LETTER: [a-zA-Z_]
    DIGIT: [0-9]
    
    ID: LETTER (LETTER | DIGIT)*
    ```

!!! example "Examples"

    === "Valid identifiers"

        ```
        q
        _i
        ID
        b01
        ```
    
    === "Invalid identifiers" 
        
        ```
        1q	   // first character cannot be a digit
        +q     // the underscore '_' is the only permissible special character 
        qubit  // 'qubit' is a reserved keyword
        ```
