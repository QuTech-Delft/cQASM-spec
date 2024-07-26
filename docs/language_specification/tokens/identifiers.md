An identifier is a single character or a sequence of characters of the following form:
upper or lowercase letters from the ISO basic Latin alphabet, underscore, and digits,
with the constraint that the first (or singular) character cannot be a digit.

For now, they are used to name a (qu)bit (registers) by the user,
and predefine the names of useful [mathematical constants](../expressions/predefined_constants.md),
[built-in functions](../expressions/builtin_functions.md),
and [gates](../statements/gates.md).
Note that identifiers are not protected, _i.e._ they can be reused. 
For example, it is permissible, however discouraged, to name a (qu)bit (register) `pi`, `cos`, or `Rx`.

Reserved [keywords](keywords.md) cannot be used as an identifier.

??? info "Grammar for identifiers"

    _identifier_:  
    &emsp; _letter_  
    &emsp; _identifier_ _letter_  
    &emsp; _identifier_ _digit_

    _letter_:  one of  
    &emsp; __`a`__ through __`z`__ or __`A`__ through __`Z`__ or __`_`__  

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
