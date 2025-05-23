# Spin-2+

The Spin-2+ system developed by QuTech supports the following subset of the cQASM language:

* Multiple line comments in `/* … */` are supported.
* Single line comments in `// …`, `# …`, `/* …*/` are supported.
* A program must start with `version 3.0`.
* The version must be followed by a single declaration of the format `qubit[1-4] <varname>` or `qubit <varname>`, where
  the latter implies `qubit[1] <varname>`.
* The only accepted gates/operations are (case sensitive!): configurable (currently, `X90`, `mX90`, `Y90`, `mY90`, `Rz`,
  `CZ`)
* `<varname>` must be used to denote a qubit
* The single-gate-multiple-qubit (SGMQ) notation is fully supported for single qubit gates
* The SGMQ notation is not supported for two qubit gates.
* The SGMQ notation results in a bundle resulting in a sequential list of gate operations.
* All other libqasm 1.x language structures are not supported.
* No `prep_X` and `measure_X` instructions are allowed, the lls will init all supported qubits before circuit execution
  and measure all in the z-basis at the end of the circuit and only return the subset as defined in the qubit register.
* Bit register declaration statements, _e.g._,
`bit[<number-of-bits:INT>] <bit-register-name:ID>` or `bit <bit-name:ID>`, are accepted and subsequently ignored.
* Measure instruction statements assign outcomes to bit variables,
_e.g._ `<bit-name:BIT> = measure <qubit-argument:QUBIT>`. These statements are accepted and subsequently ignored.
* Assembly declaration statements, e.g., `asm(<backend-name>) ''' <backend-code> '''`,
are accepted and subsequently ignored.

