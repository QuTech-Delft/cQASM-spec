The following mathematical constants are recognized:
**`pi`**, **`tau`**, and **`eu`**, where **`tau`** is $2\pi$ and **`eu`** represents Euler's constant $e$.
They are stored as floating-point [number literals](../tokens/literals.md)
and can be used in arithmetic expressions with [operators](../tokens/operators_and_punctuators.md),
_e.g._, **`pi/2`** equals $\tfrac{\pi}{2}$. 

The latter can be used, for example, as an argument for a
[parameterized named gate](../statements/instructions/unitary_instructions.md#named-gates),
_i.e._, &emsp;**`Rx(pi/2) q[0]`**.
