| Literal | Size / precision          |
|:--------|:--------------------------|
| Integer | 64-bit signed             |
| Float   | IEEE 754 double precision |

??? info "Syntax definition"

    

    ```hl_lines="4-5"
    DIGIT: [0-9]
    EXPONENT: [eE][-+]?DIGIT+

    INT: DIGIT+
    FLOAT: DIGIT+ '.' DIGIT+ EXPONENT? | DIGIT+ '.' EXPONENT? | '.' DIGIT+ EXPONENT? 
    ```
