The first character of an identifier may either be an upper or lowercase letter from the ISO basic Latin alphabet or an underscore, _i.e._, it cannot be a digit.
Any following character(s) follow the same rule as the first character, but now may also be a digit.
Identifiers cannot contain spaces.
Identifiers ID must follow the following regular expression pattern,

`[_a-zA-Z][a-zA-Z0-9_]*`

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

Note that there exist certain predefined keywords that cannot be used as an identifier; a list of these keywords can be found under the section [Reserved keywords](reserved-keywords.md).
