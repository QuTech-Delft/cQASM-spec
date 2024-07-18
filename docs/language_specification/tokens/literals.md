The only literals accepted as tokens are integer and float numbers. 

| Literal | Size / precision          |
|:--------|:--------------------------|
| Integer | 64-bit signed             |
| Float   | IEEE 754 double precision |

??? info "Grammar of number literals" 

    _integer-literal_:  
    &nbsp;&nbsp;&nbsp;&nbsp;_digit-sequence_  
    _floating-literal_:  
    &nbsp;&nbsp;&nbsp;&nbsp;_digit-sequence_ <code>__.__</code> _digit-sequence exponent<sub>opt</sub>_  
    &nbsp;&nbsp;&nbsp;&nbsp;_digit-sequence_ <code>__.__</code> _exponent<sub>opt</sub>_  
    &nbsp;&nbsp;&nbsp;&nbsp;<code>__.__</code> _digit-sequence_ _exponent<sub>opt</sub>_  
    _exponent_:  
    &nbsp;&nbsp;&nbsp;&nbsp;<code>__e__</code> _sign<sub>opt</sub>_ _digit-sequence_  
    &nbsp;&nbsp;&nbsp;&nbsp;<code>__E__</code> _sign<sub>opt</sub>_ _digit-sequence_  
    _sign_: one of  
    &nbsp;&nbsp;&nbsp;&nbsp;<code>__+__</code> <code>__-__</code>
    _digit-sequence_:  
    &nbsp;&nbsp;&nbsp;&nbsp;_digit_  
    &nbsp;&nbsp;&nbsp;&nbsp;_digit-sequence_ _digit_  
    _digit_: one of  
    &nbsp;&nbsp;&nbsp;&nbsp;<code>__0__</code> through <code>__9__</code>  
