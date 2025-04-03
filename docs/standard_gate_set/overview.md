
| Name                             | Operator                                    | Description                                              | Example statement            |
|----------------------------------|---------------------------------------------|----------------------------------------------------------|------------------------------|
| [I](single_qubit/sq_I.md)        | $I$                                         | Identity gate                                            | **`I q[0]`**                 |
| [H](single_qubit/sq_H.md)        | $H$                                         | Hadamard gate                                            | **`H q[0]`**                 |
| [X](single_qubit/sq_X.md)        | $X$                                         | Pauli-X gate                                             | **`X q[0]`**                 |
| [X90](single_qubit/sq_X90.md)    | $X^{1/2}$                                   | Rotation around the _x_-axis of $\pi/2$                  | **`X90 q[0]`**               |
| [mX90](single_qubit/sq_mX90.md)  | $X^{-1/2}$                                  | Minus X90 gate: Rotation around the _x_-axis of $-\pi/2$ | **`mX90 q[0]`**              |
| [Y](single_qubit/sq_Y.md)        | $Y$                                         | Pauli-Y gate                                             | **`Y q[0]`**                 |
| [Y90](single_qubit/sq_X90.md)    | $Y^{1/2}$                                   | Rotation around the _y_-axis of $\pi/2$                  | **`Y90 q[0]`**               |
| [mY90](single_qubit/sq_mX90.md)  | $Y^{-1/2}$                                  | Minus Y90 gate: Rotation around the _y_-axis of $-\pi/2$ | **`mY90 q[0]`**              |
| [Z](single_qubit/sq_Z.md)        | $Z$                                         | Pauli-Z gate                                             | **`Z q[0]`**                 |
| [S](single_qubit/sq_S.md)        | $S$                                         | Phase gate                                               | **`S q[0]`**                 |
| [Sdag](single_qubit/sq_Sdag.md)  | $S^\dagger$                                 | S dagger gate                                            | **`Sdag q[0]`**              |
| [T](single_qubit/sq_T.md)        | $T$                                         | T gate                                                   | **`T q[0]`**                 |
| [Tdag](single_qubit/sq_Tdag.md)  | $T^\dagger$                                 | T dagger gate                                            | **`Tdag q[0]`**              |
| [Rx](single_qubit/sq_Rx.md)      | $R_x(\theta)$                               | Rotation around the _x_-axis of angle $\theta$           | **`Rx(pi) q[0]`**            |
| [Ry](single_qubit/sq_Ry.md)      | $R_y(\theta)$                               | Rotation around the _y_-axis of angle $\theta$           | **`Ry(pi) q[0]`**            |
| [Rz](single_qubit/sq_Rz.md)      | $R_z(\theta)$                               | Rotation around the _z_-axis of angle $\theta$           | **`Rz(pi) q[0]`**            |
| [Rn](single_qubit/sq_Rn.md)      | $R_\mathbf{n}(n_x, n_y, n_z, \theta, \phi)$ | Rotation around specified axis of angle $\theta$         | **`Rn(1,0,0,pi,pi/2) q[0]`** |
| [CNOT](multi_qubit/mq_CNOT.md)   | $CNOT$                                      | Controlled-NOT gate                                      | **`CNOT q[0], q[1]`**        |
| [CZ](multi_qubit/mq_CZ.md)       | $CZ$                                        | Controlled-Z, Controlled-Phase                           | **`CZ q[0], q[1]`**          |
| [CR](multi_qubit/mq_CR.md)       | $CR(\theta)$                                | Controlled phase shift (arbitrary angle)                 | **`CR(pi) q[0], q[1]`**      |
| [CRk](multi_qubit/mq_CRk.md)     | $CR_k(k)$                                   | Controlled phase shift ($\pi/2^{k-1}$)                   | **`CRk(2) q[0], q[1]`**      |
| [SWAP](multi_qubit/mq_SWAP.md)   | $SWAP$                                      | Swap gate                                                | **`SWAP q[0], q[1]`**        |