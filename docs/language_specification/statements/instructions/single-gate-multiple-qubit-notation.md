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
    see the [standard gate set](unitary_instructions.md#standard-gate-set) below.

If the name of the qubit register is **`q`**,
then the following can be passed as an argument to the single-qubit gate:

- the whole qubit register **`q`**;

- a slice thereof **`q[i:j]`**, where $0 \leq i < j < N$;

- or a list of indices can be passed **`q[i,]`**, where $0 \leq i < N$,

with $N$ the size of the qubit register.
The following slicing convention is adopted: a slice **`q[i:j]`** includes qubits **`q[i]`**, **`q[j]`**,
and all qubits in between. The code block below demonstrates some examples.

!!! example

    === "The whole qubit register"
        
        ```
        qubit[5] q

        X q  // is semantically equivalent to:
        X q[0]; X q[1]; X q[2]; X q[3]; X q[4]
        ```

    === "A slice of the qubit register"
        
        ```
        qubit[5] q

        X q[1:3]  // is semantically equivalent to:
        X q[1]; X q[2]; X q[3]
        ```

    === "A list of indices of the qubit register"
    
        ```
        qubit[5] q

        X q[0,2,4]  // is semantically equivalent to:
        X q[0]; X q[2]; X q[4] 
        ```

In the above examples we have used the semicolon **`;`** to separate statements occurring on the same line.
