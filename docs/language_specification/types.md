The table below lists the available types in a cQASM program.

| Type       | Keyword     | Form                                   | 
|:-----------|:------------|:---------------------------------------|
| Qubit      | **`qubit`** | **`qubit`** _identifier_               | 
| QubitArray | **`qubit`** | **`qubit[`**_size_**`] `**_identifier_ | 
| Bit        | **`bit`**   | **`bit`** _identifier_                 | 
| BitArray   | **`bit`**   | **`qubit[`**_size_**`] `**_identifier_ | 

!!! note

    Type keywords are [reserved](tokens/keywords.md) and, therefore,
    cannot be used as [identifiers](tokens/identifiers.md).
