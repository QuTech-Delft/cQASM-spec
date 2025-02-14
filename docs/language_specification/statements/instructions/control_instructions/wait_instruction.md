The **`wait`** instruction is a single-qubit control instruction that is used to constrain the optimization of a
scheduler.
It tells the scheduler to delay the subsequent instructions on the specified qubit(s) by a given time.
The delay time is passed along with the instruction as a dimensionless parameter,
the unit of which represents the duration of a single-qubit gate on the backend,
_i.e._, an execution cycle. 
Moreover, the **`wait`** instruction will also function as a [_barrier_](barrier_instruction.md),
telling the scheduler that instructions on the specified qubit(s) cannot be scheduled across the position of the 
**`wait`** instruction.

!!! warning

    The [**`barrier`** instruction](barrier_instruction.md) may be considered equal to the **`wait`** instruction with a
    time delay set to 0.
    Note however that for certain backends, groups of consecutive **`barrier`** instructions are linked together to
    form a _uniform_ barrier, across which no instructions on the specified qubits can be scheduled.
    This is **not** the case for the **`wait`** instruction; consecutive **`wait`** instructions on different qubits
    are considered to be independent instructions.

    Multiple successive **`wait`** instructions on the _same_ qubit,
    however, may be fused into a single **`wait`** instruction,
    where the delay time is set to the sum of the delay times of the separate instructions.
    For example, 
    ```hl_lines="1 3"
    wait(3) q[0]
    wait(4) q[1]
    wait(2) q[0]
    ```

    couble be optimized to
    
    ```hl_lines="1"
    wait(5) q[0]
    wait(4) q[1]
    ```

The general form of the **`wait`** instruction is as follows:

!!! info ""

    &emsp;__`wait(`__ _parameter_ __`)`__ _qubit-argument_

??? info "Grammar for **`wait`** instruction"
    
    _wait-instruction_:  
    &emsp;__`wait(`__ _parameter_ __`)`__ _qubit-argument_

    _parameter_:  
    &emsp; _integer-literal_ 

    _qubit-argument_:  
    &emsp; _qubit-variable_  
    &emsp; _qubit-index_

    _qubit-variable_:  
    &emsp; _identifier_

    _qubit-index_:  
    &emsp; _index_

!!! note

    The **`wait`** instruction accepts
    [SGMQ notation](../single-gate-multiple-qubit-notation.md), similar to gates.

!!! example

    === "Single qubit"
    
        ```linenums="1", hl_lines="3"
        qubit q
        X q
        wait(5) q  // time delay of 5 execution cycles
        X q
        ```
    
    === "Multiple qubits"
    
        ```linenums="1", hl_lines="3"
        qubit[3] q
        X q[0]
        wait(5) q[0, 1]  // time delay of 5 execution cycles
        H q[0]
        X q[2]
        H q[1]
        ```

In the examples above it is shown how the **`wait`** instruction can be used with a single qubit and multiple qubits.
In the case of the single qubit, the **`wait`** instruction tells the scheduler to schedule a delay of 5 execution
cycles between the successive **`X`** gates.
Note that it also implicitly places a [barrier](barrier_instruction.md) between the two **`X`** gates,
such that they cannot be fused into a single identity gate, **`I`**.
In the second example, using SGMQ notation, the **`wait`** instruction is applied to qubits **`q[0]`** and **`q[1]`**.
Enforcing a delay of 5 execution cycles on any following instructions involving those qubits,
_e.g._, here **`H q[0]`** and **`H q[1]`**.
Qubit **`q[2]`** can be optimized freely across this circuit,
_i.e._, be scheduled before or after **`wait`** instruction, regardless of any specified time delay. 

The following code snippet illustrates how the **`wait`** instruction might be used in context.

```linenums="1", hl_lines="7"
version 3.0

qubit[2] q
bit[2] b
init q

wait(100) q[0]
b[0] = measure q[0]
```

Here, the [measurement](../non_unitary_instructions/measure_instruction.md) of **`q[0]`** is forced to be scheduled at
least 100 execution cycles after the [initialization](../non_unitary_instructions/init_instruction.md)
of the qubit is complete.
