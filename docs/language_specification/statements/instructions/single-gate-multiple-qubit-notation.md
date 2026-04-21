It is possible to pass multiple qubits as an argument to a single-qubit gate,
by making use of the single-gate-multiple-qubit (SGMQ) notation.
The single-qubit gate will then be applied to each qubit, respectively.

!!! note

    SGMQ notation does not imply that the gates are, necessarily, executed in parallel on the target device. 
    SGMQ notation is nothing other than _syntactic sugar_,
    whereby a series of instruction statements can be written as one.
    Moreover, SGMQ notation should not be confused with multiple-qubit gates, _e.g._, 
    **`X q[0,1]`** means **`X q[0]; X q[1]`**,
    and does not represent the 2-qubit gate **`XX q[0], q[1]`**.
    Note that the latter 2-qubit gate **`XX`** is currently not supported by the cQASM language,
    see the [standard gate set](../../../standard_gate_set/index.md).

If the name of the qubit register is **`q`**,
then the following can be passed as an argument to the single-qubit gate:

- the whole qubit register **`q`**;

- a slice thereof **`q[i:j]`**, where $0 \leq i < j < N$;

- or a list of indices can be passed **`q[i,]`**, where $0 \leq i < N$,

with $N$ the size of the qubit register.
The following slicing convention is adopted: a slice **`q[i:j]`** includes qubits **`q[i]`**, **`q[j]`**,
and all qubits in between. The code block below demonstrates some examples.

!!! example "SGMQ notation for single-qubit gates"

    === "Register"
        
        ```
        qubit[5] q

        X q  // is semantically equivalent to:
        X q[0]; X q[1]; X q[2]; X q[3]; X q[4]
        ```

    === "Register slice"
        
        ```
        qubit[5] q

        X q[1:3]  // is semantically equivalent to:
        X q[1]; X q[2]; X q[3]
        ```

    === "List of register indices"
    
        ```
        qubit[5] q

        X q[0,2,4]  // is semantically equivalent to:
        X q[0]; X q[2]; X q[4] 
        ```

In the above examples we have used the semicolon **`;`** to separate statements occurring on the same line.

Multi-qubit gates also support SGMQ notation.
Note that the arguments that are passed for the qubit operands, _i.e._, a register, slice, or list of indices,
need to be of equal size.
Moreover, the arguments are unpacked per element across the qubit operands.
For instance, `CNOT q[0, 1, 2] q[2, 3, 4]` will unpack to
```
CNOT q[0], q[2]
CNOT q[1], q[3]
CNOT q[2], q[4]
```
_i.e._, the first element of the first argument `q[0]` is paired with the first element of the second argument `q[2]`
and the second element of the first argument `q[1]` is paired with the second element of the second argument `q[3]`,
and so forth. 

Below are examples of (valid) SGMQ notation for multi-qubit gates:

!!! example "SGMQ notation for multi-qubit gates"

    === "Register"
        
        ```
        qubit[3] q0
        qubit[3] q1

        CNOT q0, q1  // is semantically equivalent to:
        CNOT q0[0], q1[0]; CNOT q0[1], q1[1]; CNOT q0[2], q1[2]
        ```

    === "Regsiter slice"
        
        ```
        qubit[6] q

        CNOT q[0:2], q[3:5]   // is semantically equivalent to:
        CNOT q[0], q[3]; CNOT q[1], q[4]; CNOT q[2], q[5]
        ```

    === "List of register indices"
    
        ```
        qubit[6] q

        CNOT q[3,2,1], q[5,4,0]  // is semantically equivalent to:
        CNOT q[3], q[5]; CNOT q[2], q[4]; CNOT q[1], q[0] 
        ```

    === "Mix of argument types"
    
        ```
        qubit[3] q0
        qubit[6] q1


        CNOT q0, q1[3:5]  // is semantically equivalent to:
        CNOT q0[0], q1[3]; CNOT q0[1], q1[4]; CNOT q0[2], q1[5]

        CNOT q0, q1[0,2,1]  // is semantically equivalent to:
        CNOT q0[0], q1[0]; CNOT q0[1], q1[2]; CNOT q0[2], q1[1] 

        CNOT q0[1,2], q1[4:5]  // is semantically equivalent to:
        CNOT q0[1], q1[4]; CNOT q0[2], q1[5]
        ```

In the next example, we show **invalid** SGMQ notation for multi-qubit gates:

!!! example ""

    ```
    qubit[6] q0
    qubit[5] q1

    CNOT q0[0:2], q0[3:4]  // arguments are not of equal size
    CNOT q0[0,1], q0[0,2]  // the first qubit operand is the same
    CNOT q0, q1  // arguments are not of equal size
    ```
