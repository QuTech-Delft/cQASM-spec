Keywords constitute identifiers reserved by the language parser. 
As such, they have a specific predefined meaning and cannot be overwritten or used as a general identifier,
_e.g._, as the name of the (qu)bit register.

The table below lists the reserved keywords in cQASM:

| Keyword   | Use                         |
|:----------|:----------------------------|
| `asm`     | Assembly declaration        |
| `barrier` | Barrier control instruction |
| `bit`     | Bit type                    |
| `ctrl`    | Control gate modifier       |    
| `init`    | Init instruction            |
| `inv`     | Inverse gate modifier       |    
| `measure` | Measure instruction         |
| `pow`     | Power gate modifier         |
| `qubit`   | Qubit type                  |
| `reset`   | Reset instruction           | 
| `version` | Version statement           |
| `wait`    | Wait control instruction    |
