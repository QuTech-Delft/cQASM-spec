A **`measure`** instruction performs a measurement to its qubit argument and
assigns the outcome to a bit variable.

The `measure` instruction can either

- have no parameters `measure`, which corresponds to a measurement in the Z-basis, or
- accept 3 floating-point parameters `measure(0,0,1)`, which define the axis of the basis along which the measurement is to be performed.

The following aliases for the (parameterized) `measure` instruction also exist:

- `measureX`: measurement in the X-basis (a.k.a. Hadamard basis), equivalent to `measure(1,0,0)`,
- `measureY`: measurement in the Y-basis, equivalent to `measure(0,1,0)`,
- `measureZ`: measurement in the Z-basis (computational basis), equivalent to `measure(0,0,1)` and 'measure',

!!! note

    `measure(0,0,1)` is equal to the non-parameterized `measure` as $(0,0,1)$ defines the positive $z$-axis.

The general form of a **`measure`** instruction is as follows:

!!! info ""

    &emsp;_bit-argument_ **`=`** **`measure`** _qubit-argument_  
    &emsp;_bit-argument_ **`=`** **`measure(`**_parameter-list_**`)`** _qubit-argument_

??? info "Grammar for **`measure`** instruction"
    
    _measure-instruction_:  
    &emsp; _bit-argument_ __`=`__ __`measure`__ _qubit-argument_  
    &emsp; _bit-argument_ __`=`__ __`measure`__ _parameters_ _qubit-argument_

    _bit-argument_:  
    &emsp; _bit-variable_  
    &emsp; _bit-index_

    _bit-variable_:  
    &emsp; _identifier_

    _bit-index_:  
    &emsp; _index_  

    _parameters_:  
    &emsp; __`(`__ _parameter-list_ __`)`__

    _parameter-list_:  
    &emsp; _parameter_  
    &emsp; _parameter-list_ __`,`__ _parameter_

    _parameter_:  
    &emsp; _floating-literal_

    _qubit-argument_:  
    &emsp; _qubit-variable_  
    &emsp; _qubit-index_

    _qubit-variable_:  
    &emsp; _identifier_

    _qubit-index_:  
    &emsp; _index_

!!! example
    
    === "Measurement of a single qubit"
    
        ```linenums="1", hl_lines="3-5"
        qubit q
        bit b
        b = measure q
        b = measure(1,0,0) q
        b = measureY q
        ```
    
    === "Measurement of multiple qubits through their register index"
    
        ```linenums="1", hl_lines="3-5"
        qubit[5] q
        bit[2] b
        b[0, 1] = measure q[2, 3]
        b[1, 0] = measure(1,0,0) q[4, 3]
        b[0, 1] = measureY q[0, 1]
        ```

!!! note

    The **`measure`** instruction accepts
    [SGMQ notation](../single-gate-multiple-qubit-notation.md), similar to gates.

The following code snippet shows how the **`measure`** instruction might be used in context.

```linenums="1" hl_lines="9"
version 3.0

qubit[2] q
bit[2] b

H q[0]
CNOT q[0], q[1]

b = measure q  // Measurement in the standard basis.
```

On the last line of this simple cQASM program,
the respective states of both qubits in the qubit register are measured along the standard/computational basis.

To measure in the Hadamard basis (or X-basis) you can use the parameterized `measure` instruction to measure along the 
$x$-axis, defined by $(1,0,0)$.

```linenums="1" hl_lines="8"
version 3.0

qubit q
bit b

X q
H q
b = measure(1,0,0) q // Measurement in the Hadamard basis.
```

On the last line of the latter cQASM program the qubit is measured along the $x$-axis;
the measurement outcome will (always) be 1, due to measuring the $|1\rangle$ state in the X-basis.  
