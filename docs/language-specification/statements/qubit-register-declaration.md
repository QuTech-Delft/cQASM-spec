The general form of the declaration of a qubit reference or qubit register is given as follows:

`qubit[<number-of-qubits:INT>]? <qubit(-register)-name:ID>`

In cQASM, one can only declare either a qubit or qubit register once. 

!!! example

    === "Single qubit declaration"

        ```linenums="1"
        qubit q

        H q

        measure q


        ```
    
    === "Qubit register declaration"

        ```linenums="1"
        qubit[5] q

        H q[0]
        CNOT q[0], q[1]

        measure q


        ```

Note in the latter example, that the number of qubits, _i.e._, the size of the qubit register, needs to be defined during declaration.
For instance, the statement `qubit[5] q` declares a qubit register named `q`, consisting of 5 qubits.
Furthermore, the individual qubits of the register can be referred to by their register index, _e.g._, the gate operation `H q[0]` applies the Hadamard gate on the qubit located at index `0` in the qubit register `q`. 

Qubits, either declared as a single qubit or as elements of a register, are presumed to be initialized in the state $|0\rangle$ of the computational basis.
