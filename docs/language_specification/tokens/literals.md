The only literals accepted as tokens are integer and float numbers. 

| Literal | Size / precision          |
|:--------|:--------------------------|
| Integer | 64-bit signed             |
| Float   | IEEE 754 double precision |

??? info "Grammar of number literals" 

    _integer-literal_:  
    &emsp; _digit-sequence_

    _floating-literal_:  
    &emsp; _digit-sequence_`.`_digit-sequence exponent_~opt~  
    &emsp; _digit-sequence_`.`_exponent_~opt~  
    &emsp; `.` _digit-sequence_ _exponent_~opt~

    _exponent_:  
    &emsp; `e` _sign_~opt~ _digit-sequence_  
    &emsp; `E` _sign_~opt~ _digit-sequence_

    _sign_: one of  
    &emsp; `+` `-`

    _digit-sequence_:  
    &emsp; _digit_  
    &emsp; _digit-sequence_ _digit_

    _digit_: one of  
    &emsp; `0` through `9`  
