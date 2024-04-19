An identifier `ID` is a single character or a sequence characters of the following form: upper or lowercase letters from the ISO basic Latin alphabet, underscore, and digits, with the constraint that the first (or singular) character cannot be a digit. Moreover, identifiers `ID` cannot contain spaces.

??? info "Regex pattern"

    ```hl_lines="4"
    LETTER=[_a-zA-Z]
    DIGIT=[0-9]
    
    ID={LETTER}({LETTER}|{DIGIT}+)*
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

There exist certain predefined keywords that cannot be used as an identifier; a list of these keywords can be found under the section [Reserved keywords](reserved-keywords.md).
