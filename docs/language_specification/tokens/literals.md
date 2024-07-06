| Literal | Size / precision          |
|:--------|:--------------------------|
| Integer | 64-bit signed             |
| Float   | IEEE 754 double precision |

??? info "Grammar of number literals" 

    _digit_: one of</br>
    &nbsp;&nbsp;&nbsp;&nbsp;<code>__0__</code> through <code>__9__</code></br>
    _digit-sequence_:</br>
    &nbsp;&nbsp;&nbsp;&nbsp;_digit_</br>
    &nbsp;&nbsp;&nbsp;&nbsp;_digit-sequence_ _digit_</br>
    _integer-literal_:</br>
    &nbsp;&nbsp;&nbsp;&nbsp;_digit-sequence_</br>
    _floating-literal_:</br>
    &nbsp;&nbsp;&nbsp;&nbsp;_digit-sequence_ <code>__.__</code> _digit-sequence exponent<sub>opt</sub>_</br>
    &nbsp;&nbsp;&nbsp;&nbsp;_digit-sequence_ <code>__.__</code> _exponent<sub>opt</sub>_</br>
    &nbsp;&nbsp;&nbsp;&nbsp;<code>__.__</code> _digit-sequence_ _exponent<sub>opt</sub>_</br>
    _exponent_:</br>
    &nbsp;&nbsp;&nbsp;&nbsp;<code>__e__</code> _sign<sub>opt</sub>_ _digit-sequence_</br>
    &nbsp;&nbsp;&nbsp;&nbsp;<code>__E__</code> _sign<sub>opt</sub>_ _digit-sequence_</br>
    _sign_: one of</br>
    &nbsp;&nbsp;&nbsp;&nbsp;<code>__+__</code> <code>__-__</code>

??? info "Grammar for character literals"

    _letter_: one of</br>
    &nbsp;&nbsp;&nbsp;&nbsp;<code>__a__</code> through <code>__z__</code> or <code>__A__</code> through <code>__Z__</code> or <code>**_**</code></br>
