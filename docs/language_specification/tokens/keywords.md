Keywords constitute identifiers reserved by the language parser. 
As such, they have a specific predefined meaning and cannot be overwritten or used as a general identifier,
_e.g._, as the name of the (qu)bit register.

The table below lists the reserved keywords in cQASM:

| Keyword       | Use                            |
|:--------------|:-------------------------------|
| __`version`__ | Version statement              |
| __`qubit`__   | Qubit type                     |
| __`bit`__     | Bit type                       |
| __`init`__    | Init instruction               |
| __`reset`__   | Reset instruction              | 
| __`measure`__ | Measure instruction            |
| __`wait`__    | Wait control instruction       |
| __`barrier`__ | Barrier control instruction    |
| __`ctrl`__    | Control gate modifier          |    
| __`inv`__     | Inverse gate modifier          |    
| __`pow`__     | Power gate modifier            |
| __`asm`__     | Language extension declaration |
