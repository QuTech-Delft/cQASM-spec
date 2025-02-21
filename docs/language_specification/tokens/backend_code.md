Backend code is any _raw text_ that appears in the body of an 
[assembly declaration](../statements/assembly_declaration.md).
Its syntax and semantics are wholly determined by the backend for which the text is written.
The only restriction on the backend code is described in the warning below and
stems from the syntax of the assembly declaration.

!!! warning "Curly brackets in backend code must match"

    Since backend code is written in the body of an 
    [assembly declaration](../statements/assembly_declaration.md),
    it is essential that any curly brackets, `{` or `}`, appearing in the backend code must match.
    That is, any opening curly bracket `{` must eventually be matched by a closing curly bracket `}`.
    The reason for this, is that the cQASM language parser will classify backend code as any raw text that is enclosed
    by the curly brackets of the assembly declaration.

    Note that a closing bracket `}` can, therefore, never occur before an opening curly bracket `{` in the backend code.
    
    