Unitary instructions include:

- named [gates](unitary_instructions.md#gates), and
- compositions of [gate modifiers](unitary_instructions.md#gate-modifiers) acting on a named gate.

Note that a composition of gate modifiers acting on a named gate is itself a gate. 

??? info "Grammar for unitary instructions"
    
    _unitary-instruction_:  
    &emsp; _gate_ _qubit-arguments_  

    _gate_:  
    &emsp; _inv-gate_  
    &emsp; _pow-gate_  
    &emsp; _ctrl-gate_  
    &emsp; _named-gate_  

    _inv-gate_:  
    &emsp; `inv.`gate
    
    _pow-gate_:  
    &emsp; `pow(`_parameter_`).`_gate_
    
    _ctrl-gate_:  
    &emsp; `ctrl.`_gate_

    _named-gate_:  
    &emsp; _identifier_ _parameters_~opt~  

    _parameters_:  
    &emsp; __`(`__ _parameter-list_ __`)`__

    _parameter-list_:  
    &emsp; _parameter_  
    &emsp; _parameter-list_ __`,`__ _parameter_

    _parameter_:  
    &emsp; _integer-literal_  
    &emsp; _floating-literal_

    _qubit-arguments_:  
    &emsp; _qubit-argument-list_

    _qubit-argument-list_:  
    &emsp; _qubit-argument_  
    &emsp; _qubit-argument-list_ __`,`__ _qubit-argument_

    _qubit-argument_:  
    &emsp; _qubit-variable_  
    &emsp; _qubit-index_

    _qubit-variable_:  
    &emsp; _identifier_

    _qubit-index_:  
    &emsp; _index_

## Gates

Gates define single-qubit or multi-qubit unitary operations
that change the state of a qubit register in a deterministic fashion.
The general form of a gate is given by the gate name
followed by the (comma-separated list of) qubit operand(s), _e.g._, **`X q[0]`**:

!!! info ""
    
    &emsp;_gate qubit-arguments_

Parameterized unitary operations are represented by parameterized gates.
The general form of a parameterized gate is given by the gate name
followed by its (comma-separated list of) parameter(s) that is enclosed in parentheses,
which in turn is followed by the (comma-separated list of) qubit operand(s), _e.g._, **`CRk(2) q[0], q[1]`**:

!!! info ""
    
    &emsp;_gate_**`(`**_parameters_**`)`**_ qubit-arguments_

Note that the parameters, either single or a list of multiple parameters,
appear within parentheses directly following the gate name.
We distinguish between the _parameters_ of a parameterized gate,
in terms of number [literals](../../tokens/literals.md),
and the _qubit arguments_ that a (parameterized) gate acts on.

A few examples of gates are shown below.

!!! example ""

    ```
    // A single-qubit Hadamard gate
    H q[0]
    
    // A two-qubit controlled-Z gate (control: q[0], target: q[1])
    CZ q[0], q[1]
    
    // A parameterized single-qubit Rx gate (with π/2 rotation around the x-axis)
    Rx(pi/2) q[0]
    
    // A parametrized two-qubit controlled phase-shift gate (control: q[1], target: q[0])
    CRk(2) q[1], q[0]
    ```

The gates that are supported by the cQASM language
are listed in the [standard gate set](unitary_instructions.md#standard-gate-set).

### Standard gate set

| Name | Description                              | Example statement       |
|------|------------------------------------------|-------------------------|
| I    | Identity gate                            | **`I q[0]`**            |
| H    | Hadamard gate                            | **`H q[0]`**            |
| X    | Pauli-X                                  | **`X q[0]`**            |
| X90  | Rotation around the _x_-axis of $\pi/2$  | **`X90 q[0]`**          |
| mX90 | Rotation around the _x_-axis of $-\pi/2$ | **`mX90 q[0]`**         |
| Y    | Pauli-Y                                  | **`Y q[0]`**            |
| Y90  | Rotation around the _y_-axis of $\pi/2$  | **`Y90 q[0]`**          |
| mY90 | Rotation around the _y_-axis of $-\pi/2$ | **`mY90 q[0]`**         |
| Z    | Pauli-Z                                  | **`Z q[0]`**            |
| S    | Phase gate                               | **`S q[0]`**            |
| Sdag | S dagger gate                            | **`Sdag q[0]`**         |
| T    | T                                        | **`T q[0]`**            |
| Tdag | T dagger gate                            | **`Tdag q[0]`**         |
| Rx   | Arbitrary rotation around _x_-axis       | **`Rx(pi) q[0]`**       |
| Ry   | Arbitrary rotation around _y_-axis       | **`Ry(pi) q[0]`**       |
| Rz   | Arbitrary rotation around _z_-axis       | **`Rz(pi) q[0]`**       |
| CNOT | Controlled-NOT gate                      | **`CNOT q[0], q[1]`**   |
| CZ   | Controlled-Z, Controlled-Phase           | **`CZ q[0], q[1]`**     |
| CR   | Controlled phase shift (arbitrary angle) | **`CR(pi) q[0], q[1]`** |
| CRk  | Controlled phase shift ($\pi/2^k$)       | **`CRk(2) q[0], q[1]`** |

## Gate modifiers

Gate modifiers are operators _Q_ that modify a gate (or unitary operator _A_)
into another (modified) gate (or unitary operator _A'_), _Q: gate → gate_, (or _Q: U → U'_).

We consider the following gate modifiers:

- **inverse**: which modifies the gate _U_ into _U<sup>†<sup>_, e.g., `inv.X q[0]`.
- **power**: raises the gate _U_ to the specified power _a_, i.e., _U<sup>a<sup>_,
  where _a_ is a float, e.g., `pow(pi/2).X q[0]`.
- **control**: changes _U_ gate for controlled-U gate, e.g., `ctrl.X q[0], q[1]`, 
  where the control qubit is prepended to the list of qubit operands. 

Notice that, `inv` and `pow` map an _n_-qubit gate to an _n_-qubit gate,
and `ctrl` maps an _n_-qubit gate to a (_n_+1)-qubit gate.

Since gate modifiers return gates, they can be applied in a nested manner,
e.g., `inv.pow(2).X`, where a gate modifier `inv` is applied to the modified gate `pow(2).X`,
which in turn resulted from applying the gate modifier `pow(2)` on the (named) gate `X`.

The current version of the language only allows gate modifiers to act on single-qubit gates.

!!! info ""

    &emsp;**`inv.`**_gate qubit-argument_  
    &emsp;**`pow(`**_exponent_**`).`**_gate qubit-argument_  
    &emsp;**`ctrl.`**_gate qubit-arguments_

A few examples of gates are shown below.

!!! example ""

    ```
    // Inverse of X
    inv.X q

    // S gate implemented as a power of T
    pow(2).T q

    // CZ imlemented as a controlled-Z
    ctrl.Z q[0], q[1]

    // Composition of gate modifiers (modifiers are applied from right to left)
    ctrl.pow(1/2).inv.X q[0], q[1]
    ```
