
| Name                                     | Identifier | Operator                                             | Example statement            |
|------------------------------------------|------------|------------------------------------------------------|------------------------------|
| [Identity](single_qubit/sq_I.md)         | I          | $I$                                                  | **`I q[0]`**                 |
| [Hadamard](single_qubit/sq_H.md)         | H          | $H$                                                  | **`H q[0]`**                 |
| [Pauli-X](single_qubit/sq_X.md)          | X          | $X$                                                  | **`X q[0]`**                 |
| [X90](single_qubit/sq_X90.md)            | X90        | $X^{1/2}$                                            | **`X90 q[0]`**               |
| [Minus X90](single_qubit/sq_mX90.md)     | mX90       | $X^{-1/2}$                                           | **`mX90 q[0]`**              |
| [Pauli-Y](single_qubit/sq_Y.md)          | Y          | $Y$                                                  | **`Y q[0]`**                 |
| [Y90](single_qubit/sq_X90.md)            | Y90        | $Y^{1/2}$                                            | **`Y90 q[0]`**               |
| [Minus Y90](single_qubit/sq_mX90.md)     | mY90       | $Y^{-1/2}$                                           | **`mY90 q[0]`**              |
| [Pauli-Z](single_qubit/sq_Z.md)          | Z          | $Z$                                                  | **`Z q[0]`**                 |
| [S](single_qubit/sq_S.md)                | S          | $S$                                                  | **`S q[0]`**                 |
| [S-dagger](single_qubit/sq_Sdag.md)      | Sdag       | $S^\dagger$                                          | **`Sdag q[0]`**              |
| [T](single_qubit/sq_T.md)                | T          | $T$                                                  | **`T q[0]`**                 |
| [T-dagger](single_qubit/sq_Tdag.md)      | Tdag       | $T^\dagger$                                          | **`Tdag q[0]`**              |
| [Rx](single_qubit/sq_Rx.md)              | Rx         | $R_x(\theta)$                                        | **`Rx(pi) q[0]`**            |
| [Ry](single_qubit/sq_Ry.md)              | Ry         | $R_y(\theta)$                                        | **`Ry(pi) q[0]`**            |
| [Rz](single_qubit/sq_Rz.md)              | Rz         | $R_z(\theta)$                                        | **`Rz(pi) q[0]`**            |
| [Rn](single_qubit/sq_Rn.md)              | Rn         | $R_\hat{\mathbf{n}}(\hat{\mathbf{n}}, \theta, \phi)$ | **`Rn(1,0,0,pi,pi/2) q[0]`** |
| [Controlled-NOT](multi_qubit/mq_CNOT.md) | CNOT       | $CNOT$                                               | **`CNOT q[0], q[1]`**        |
| [C-Phase](multi_qubit/mq_CZ.md)          | CZ         | $CZ$                                                 | **`CZ q[0], q[1]`**          |
| [CR](multi_qubit/mq_CR.md)               | CR         | $CR(\theta)$                                         | **`CR(pi) q[0], q[1]`**      |
| [CRk](multi_qubit/mq_CRk.md)             | CRk        | $CR_k(k)$                                            | **`CRk(2) q[0], q[1]`**      |
| [SWAP](multi_qubit/mq_SWAP.md)           | SWAP       | $SWAP$                                               | **`SWAP q[0], q[1]`**        |