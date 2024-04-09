The general structure of a cQASM program is as follows:

- **Comment(s)** 
    - _optional_ 
    - _at any location in the program_
- **Version statement**
    - _mandatory_
    - _at the top, save for some potential comment(s)_
- **Qubit (register) declaration statement**
    - _optional_
- **Instruction(s)**
    - Gate(s)
        - _optional_ 
        - _requires a qubit (register) declaration_ 
    - Measure instruction
        - _optional_ 
        - _requires a qubit (register) declaration_ 
        - _at the end, save for some potential following comment(s)_

An example cQASM program may look accordingly:

```
// Example program according to the cQASM language specification

// Version statement
version 3.0

// Qubit register declaration statement
qubit[2] q;

// Instructions (Gates)
Rx(1.57) q[0];
H q[0]; H q[1];
CNOT q[0], q[1];

// Instructions (Measure instruction)
H q[0];
measure q[0];

```

Incidentally, the smallest valid cQASM program is given as follows:

```
version 3.0
```
