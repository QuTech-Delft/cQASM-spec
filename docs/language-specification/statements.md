# Statements

## Version statement

The version statement indicates which version of the cQASM language the quantum program is written in.
Apart from comments, it must be the first statement of the program and occur only once.
It has the following form,

`version <M:INT>.<m:INT>`

where the version number is to be given as two period separated integers, respectively indicating the major `M` and minor `m` version of the cQASM language.
It is permitted to only specify the major version number `M`. In that case, the program is presumed to be of the latest minor `m` version.

An example of the version statement for cQASM is given below,

```
// Only comments may appear before the version statement.
version 3.0
```

## Qubit (register) declaration

The general form of the declaration of a qubit reference or qubit register is given as follows:

`qubit[<number-of-qubits:INT>]? <qubit(-register)-name:ID>`

In cQASM, one can only declare either a qubit or qubit register once. 

Example of a single qubit declaration and subsequent use:

```
qubit q;
H q;
measure q;
```

Example of a qubit register declaration and subsequent use:

```
qubit[5] q;
H q[0];
CNOT q[0], q[1];
measure q[0], q[1];
```

Note in the latter example, that the number of qubits, _i.e._, the size of the qubit register, needs to be defined during declaration.
For instance, the statement `qubit[5] q` declares a qubit register named `q`, consisting of 5 qubits.
Furthermore, the individual qubits of the register can be referred to by their register index, _e.g._, the gate operation `H q[0]` applies the Hadamard gate on the qubit located at index `0` in the qubit register `q`. 

Qubits, either declared as a single qubit or as elements of a register, are presumed to be initialized in the state $|0\rangle$ of the computational basis.

## Instructions

In cQASM, instructions are either gates or a measure instruction.

### Gates

#### Single-gate-multi-qubit (SGMQ) notation

A single qubit gate can be applied to multiple qubits by making use of single-gate-multi-qubit (SGMQ) notation. 
At the location of the (single) qubit argument either

- the whole qubit register `q`;

- a slice thereof `q[i:j]`, where $0 \leq i < j \leq N-1$;

- or a list of indices can be passed `q[i,]`, where $0 \leq i \leq N-1$,

with $N$ the size of the qubit register.
The following slicing convention is adopted: a slice `q[i:j]` includes qubits `q[i]`, `q[j]`, and all qubits in between. The code block below demonstrates some examples:

```
qubit[5] q;

X q;  // is functionally equivalent to
X q[0]; X q[1]; X q[2]; X q[3]; X q[4];

X q[1:3];  // is functionally equivalent to
X q[1]; X q[2]; X q[3];

X q[0,2,4];  // is functionally equivalent to
X q[0]; X q[2]; X q[4];  
```

### Measurement

Currently, cQASM only support the following measurement instruction:

`measure <qubit(-register)-name:ID>[<qubit-index>]?`

## cQASM standard gate set

...