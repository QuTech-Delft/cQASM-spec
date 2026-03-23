Keywords constitute identifiers reserved by the language parser. 
As such, they have a specific predefined meaning and cannot be overwritten or used as a general identifier,
_e.g._, as the name of the (qu)bit register.

The table below lists the reserved keywords in cQASM:

| Keyword       | Use                         |
|:--------------|:----------------------------|
| __`asm`__     | Assembly declaration        |
| __`barrier`__ | Barrier control instruction |
| __`bit`__     | Bit type                    |
| __`ctrl`__    | Control gate modifier       |    
| __`init`__    | Init instruction            |
| __`inv`__     | Inverse gate modifier       |    
| __`measure`__ | Measure instruction         |
| __`pow`__     | Power gate modifier         |
| __`qubit`__   | Qubit type                  |
| __`reset`__   | Reset instruction           | 
| __`version`__ | Version statement           |
| __`wait`__    | Wait control instruction    |
