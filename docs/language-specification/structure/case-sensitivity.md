cQASM is now a case-sensitive language, in contrast to previous versions. 
The following lines of code need not be equivalent

```
h q[0]
H Q[0]
```

Note that gate names are case-sensitive.
Even though, it is common practice to write variable names or function identifiers in lowercase, we choose to define the gate names of the predefined standard gate set in PascalCase or UPPERCASE, as this is more in line with how these gates are represented in the field of quantum information processing (QIP).
A list of the predefined cQASM standard gate set can be found in section below.
