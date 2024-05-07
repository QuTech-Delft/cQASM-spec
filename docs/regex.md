LETTER: `[_a-zA-Z]`
DIGIT `[0-9]`
INT: `{DIGIT}+`
EXPONENT: `[eE][-+]?<INT>`, `[eE][+-]?[0-9]+`
FLOAT: `({INT}?[.])?{INT}{EXPONENT}?`, `[+-]?([0-9]*[.])?[0-9]+([eE][+-]?[0-9]+)?`
ID: `{LETTER}({LETTER}|{DIGIT}+)*`, `[_a-zA-Z][_a-zA-Z0-9]*`

QUBIT: `{ID}(\[{INT}\])?`, `[_a-zA-Z][_a-zA-Z0-9]*(\[[0-9]+\])?`
VERSION_STATEMENT: `version {INT}(.{INT})?`, `version [0-9](.[0-9])?`
QUBIT_DECLARATION_STATEMENT: `qubit(\[{INT}\])? {ID}`, `qubit(\[[0-9]+\])? [_a-zA-Z][_a-zA-Z0-9]*` 

GATE_INSTRUCTION: `{ID}(\(({INT}|{FLOAT})(,({INT}|{FLOAT}))*\))? {QUBIT}(,{QUBIT})*`
MEASURE_INSTRUCTION: `measure QUBIT`


```
LETTER=[_a-zA-Z]
DIGIT=[0-9]
INT={DIGIT}+
EXPONENT=[eE][-+]?{INT} 
FLOAT=({INT}?[.])?{INT}{EXPONENT}?
ID={LETTER}({LETTER}|{INT})*

QUBIT={ID}(\[{INT}\])?

VERSION_STATEMENT=version {INT}(.{INT})?
QUBIT_DECLARATION_STATEMENT=qubit(\[{INT}\])? {ID} 

GATE_INSTRUCTION_STATEMENT={ID}(\(({INT}|{FLOAT})(,({INT}|{FLOAT}))*\))? {QUBIT}(,{QUBIT})*
MEASURE_INSTRUCTION_STATEMENT=measure (ID | QUBIT)
```

