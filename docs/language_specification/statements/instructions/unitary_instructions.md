Unitary instructions, commonly known as gates, define single-qubit or multi-qubit operations
that change the state of a qubit register in a reversible and deterministic fashion. They include:

- [named gates](unitary_instructions.md#named-gates), or
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

## Named gates

Named gates comprise particular unitary operations that have been given their own unique label,
_e.g._, the Hadamard gate **`H`** or the controlled-not gate **`CNOT`**.
In general, we simply refer to them as gates.
All recognized (named) gates are listed in the [standard gate set](unitary_instructions.md#standard-gate-set).
Moreover, we use the term _named gate_ to distinguish them from unitary operations consisting of
compositions of gate modifiers acting on a named gate, _i.e._, modified gates.
Named gates are, thus, unmodified gates and can simply be used on their own
or modified (multiple times) through gate modifiers. 

The general form of a named gate is given by the gate name
followed by the (comma-separated list of) qubit operand(s), _e.g._, **`X q[0]`**:

!!! info ""
    
    &emsp;_gate_ _qubit-arguments_

A named gate can be parameterized.
The general form of a parameterized gate is given by the gate name
followed by its (comma-separated list of) parameter(s) that is enclosed in parentheses,
which in turn is followed by the (comma-separated list of) qubit operand(s), _e.g._, **`CRk(2) q[0], q[1]`**:

!!! info ""
    
    &emsp;_gate_**`(`**_parameters_**`)`** _qubit-arguments_

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
| SWAP | Swap gate                                | **`SWAP q[0], q[1]`**   |

## Gate modifiers

A gate modifier is an operator _Q_ that takes a gate as input and returns a modified gate as output (_Q: gate → gate_),
_i.e._, it transforms an arbitrary unitary $U$ into $U'$, based on the particular modifier that is applied.
We consider the following gate modifiers:

- The _inverse_ modifier **`inv`**, which modifies the gate $U$ into $U^\dagger$, _e.g._, **`inv.X q[0]`**.
- The _power_ modifier **`pow`**, which raises the gate $U$ to the specified power $a$, _i.e._, $U^a$,
  where $a$ is a float, _e.g._, **`pow(pi/2).X q[0]`**.
- The _control_ modifier **`ctrl`**, which changes the gate $U$ into the controlled-$U$ gate, _e.g._,
  **`ctrl.X q[0], q[1]`**, where the control qubit is prepended to the list of qubit operands. 

Since gate modifiers return gates, they can be applied in a nested manner,
_e.g._, **`inv.pow(2).X`**, where a gate modifier **`inv`** is applied to the modified gate **`pow(2).X`**,
which in turn resulted from applying the gate modifier **`pow(2)`** on the (named) gate **`X`**.

The current version of the language only allows gate modifiers to act on single-qubit gates.

!!! info ""

    &emsp;**`inv.`**_gate_ _qubit-argument_  
    &emsp;**`pow(`**_exponent_**`).`**_gate_ _qubit-argument_  
    &emsp;**`ctrl.`**_gate_ _qubit-arguments_

A few examples of gates are shown below.

!!! example ""

    ```
    // Inverse of X
    inv.X q

    // S gate implemented as a power of T
    pow(2).T q

    // CZ implemented as a controlled-Z
    ctrl.Z q[0], q[1]

    // Composition of gate modifiers (modifiers are applied from right to left)
    ctrl.pow(1/2).inv.X q[0], q[1]
    ```

Notice that, **`inv`** and **`pow`** map an _n_-qubit gate to an _n_-qubit gate,
and **`ctrl`** maps an _n_-qubit gate to a (_n_+1)-qubit gate.

!!! warning

    The current version of the language does not support the use of gate modifiers on multi-qubit gates.
    For example, the following instructions are _not_ supported:

    - **`inv.CRk(2) q[0], q[1]`**, where the _inverse_ modifier is applied to a two-qubit named gate.
    - **`inv.ctrl.X q[0], q[1]`**, where the _inverse_ modifier is applied to a two-qubit modified gate.

    Considering the latter example, note that the following use of gate modifiers _is_ permitted:

    - **`ctrl.inv.X q[0], q[1]`**, since the _inverse_ modifier is first applied to the single-qubit named gate **`X`**,
    resulting in a single-qubit modified gate, which only then is modified through the _control_ modifier
    into a two-qubit modified gate.