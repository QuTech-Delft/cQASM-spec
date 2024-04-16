An identifier `ID` is a single character or a sequence characters of the following form: upper or lowercase letters from the ISO basic Latin alphabet, underscore, and digits, with the constraint that the first (or singular) character cannot be a digit. Moreover, identifiers `ID` cannot contain spaces.

??? info "Regex pattern"

    `ID`: `[_a-zA-Z][a-zA-Z0-9_]*`

!!! example

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
        +q     // the underscore '_' is only permissible special character 
        qubit  // 'qubit' is a reserved keyword
        ```

There exist certain predefined keywords that cannot be used as an identifier; a list of these keywords can be found under the section [Reserved keywords](reserved-keywords.md).
