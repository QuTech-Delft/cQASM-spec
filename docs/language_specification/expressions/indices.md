An index is a reference to one or more positions within a register. The first position of a register is 0.
Positions are expressed as a list of comma-separated entries. Each entry can be a single integer or a range.
A range is written as two integers separated by a colon, pointing to a first and to a last element within a register.
The last position is also part of the range, _i.e._, it does not point to the first element out of the range.

!!! info "Grammar for indices"

    _index_:  
    &emsp; _identifier_ __`[`__ _index-list_ __`]`__
    
    _index-list_:  
    &emsp; _index-entry_  
    &emsp; _index-list_ __`,`__ _index-entry_

    _index-entry_:  
    &emsp; _integer-literal_  
    &emsp; _index-range_

    _index-range_:  
    &emsp; _index-entry_ __`:`__ _index-entry_

!!! example "Indices, index entries, and index ranges"

    ```hl_lines="6"
    // Qubit register containing 7 qubits, numbered from 0 to 6
    qubit[7] q 
    
    // q[1, 3:5] is a qubit index with two entries: 
    // the first entry points to qubit 1 in q, and the second to qubits 3, 4, and 5
    H q[1, 3:5]
    ```
