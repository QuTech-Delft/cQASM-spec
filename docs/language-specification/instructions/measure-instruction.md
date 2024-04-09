Currently, cQASM only supports the following measurement instruction at the end of the circuit.

`measure <qubit(-register)-name:ID>[<qubit-index(-list): INT>]?`

The following code snippet shows how the measure instruction might be used

```
version 3.0

qubit[2] q

H q[0]
CNOT q[0], q[1]

measure q[0]  // Measurement of the state of the qubit at index 0 in the Z-basis.
measure q[1]  // Measurement of the state of the qubit at index 1 in the Z-basis.
```

In the last step of this simple program the respective states of both qubits are measured in the $Z$-basis, _i.e._, the computational basis.
Note that the measure instruction accepts SGMQ-notation, _e.g._ the two separate measurement instructions in the above code example can be written as

```
measure q[0, 1]  // Measurement of the state of the qubits at indices 0 an 1 in the Z-basis.
```

!!! info

    Midcircuit measurements are not supported at this stage.

