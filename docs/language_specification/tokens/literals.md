The only literals accepted as tokens are integer and float numbers. 

| Literal | Size / precision          |
|:--------|:--------------------------|
| Integer | 64-bit signed             |
| Float   | IEEE 754 double precision |

??? info "Grammar of number literals" 

    _integer-literal_:  
    &emsp; _digit-sequence_

    _floating-literal_:  
    &emsp; _digit-sequence_ __`.`__ _digit-sequence exponent_~opt~  
    &emsp; _digit-sequence_ __`.`__ _exponent_~opt~  
    &emsp; __`.`__ _digit-sequence_ _exponent_~opt~

    _exponent_:  
    &emsp; __`e`__ _sign_~opt~ _digit-sequence_  
    &emsp; __`E`__ _sign_~opt~ _digit-sequence_

    _sign_: one of  
    &emsp; __`+`__ __`-`__

    _digit-sequence_:  
    &emsp; _digit_  
    &emsp; _digit-sequence_ _digit_

    _digit_: one of  
    &emsp; __`0`__ through __`9`__  
