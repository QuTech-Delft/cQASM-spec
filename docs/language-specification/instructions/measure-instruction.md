Currently, cQASM only supports the following measurement instruction at the end of the circuit.

`measure <qubit(-register)-name:ID>[<qubit-index:INT>]?`

```
// measure <qubit-name:ID>
qubit single_qubit
measure single_qubit

// measure <qubit-register-name:ID>
qubit[5] qubit_register
measure qubit_register

// measure <qubit-register-name:ID>[<qubit-index:INT>]
measure q[0]
```

!!! info
    
    Only a single measure instruction is supported for now, at the end of the cQASM program. Multiple qubits can be measured by passing the name of the qubit register as an argument or using SGMQ notation. 

The following code snippet shows how the measure instruction might be used

```linenums="1"
version 3.0

qubit[2] q

H q[0]
CNOT q[0], q[1]

measure q  // Measurement of the qubit states in the Z-basis.
```

In the last step of this simple program the respective states of both qubits are measured in the $Z$-basis, _i.e._, the computational basis.
Note that the measure instruction accepts [SGMQ-notation](gates.md#single-gate-multi-qubit-sgmq-notation), _e.g._ the following statement is semantically equivalent:

```linenums="8"
measure q[0, 1]  // Measurement of the state of the qubits at indices 0 an 1 in the Z-basis.
```

!!! info

    Midcircuit measurements are not supported at this stage.

