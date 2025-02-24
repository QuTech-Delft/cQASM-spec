Raw text is used to write backend code in the raw text string of an
[assembly declaration](../statements/assembly_declaration.md).
Its syntax and semantics are wholly determined by the backend for which the raw text is written.

??? info "Grammar for raw text"

    _raw-text_:  
    &emsp; `(.)*?`

!!! warning

    Even though, any sequence of characters could be raw text,
    one should avoid using triple qoutes (**`'''`**) in raw text
    as they will be interpreted as the delimiters of a raw text string.
