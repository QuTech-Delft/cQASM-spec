In general, cQASM is not whitespace-sensitive, apart from newlines.
Spaces and tabs can be placed in between tokens.

Comments can be written as single-line comments or as multi-line comments within a comment block.
Only comments can appear before the [version statement](../statements/version_statement.md).
Whitespace before a single-line or multi-line comment is permitted.

## Single-line comment

A single-line comment is prefixed by two forward slashes `//` and finishes with the new line, 
equal to the syntax of C-like languages.

The general form of single-line comments is as follows

!!! info ""

    &emsp;**`//`** _single-line-comment_  
    &emsp;_statement_  
    &emsp;_statement_  **`//`** _single-line-comment_


!!! example

    ```
    // This is a single-line comment, which ends on the new line.
    H q[0]
    CNOT q[0], q[1]  // A single-line comment can follow a statement.
    ```

## Multi-line comments

Multi-line comment blocks allow for writing comments that span multiple lines. 
A comment block starts with the combination of a forward slash and an asterisk `/*` and end with the combination of an asterisk and a forward slash `*/`.

The general structure of a multi-line comment is given by

!!! info ""

    &emsp;**`/*`** _multi-line_  
    &emsp;_comment-block_ **`*/`**  

    &emsp;_statement_  **`/*`** _multi-line_  
    &emsp;_comment-block_ **`*/`** _statement_


An example of multi-line commenting is given by the following:

!!! example

    ```
    /* This is a multi-
    line comment. */
    CNOT q[0], /* A comment block can
    be placed in between tokens. */ q[1]
    ```

A pair of forward slashes `//` may be part of a multi-line comment block.
In that case they are considered part of the comment and not the start of a single-line comment.
