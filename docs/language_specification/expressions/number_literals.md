| Literal | Size / precision          |
|:--------|:--------------------------|
| Integer | 64-bit signed             |
| Float   | IEEE 754 double precision |

??? info "Grammar definition"

    ```
    fragment Digit: [0-9];
    fragment Exponent: [eE][-+]?Digit+;

    INTEGER_LITERAL: Digit+;

    FLOAT_LITERAL:
        Digit+ '.' Digit+ Exponent?
        | Digit+ '.' Exponent?
        | '.' Digit+ Exponent?; 
    ```
