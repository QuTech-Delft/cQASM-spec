The version statement is mandatory and indicates which version of the cQASM language the quantum program is written in.
Apart from comments, it must be the first statement of the program and occur only once.
It has the following form,

`version <M:INT>.<m:INT>`

where the version number is to be given as two period separated integers, respectively indicating the major `M` and minor `m` version of the cQASM language.
It is permitted to only specify the major version number `M`. In that case, `m` will be interpreted as `0`.

An example of the version statement for cQASM is given below,

```
// Only comments may appear before the version statement.
version 3.0
```
