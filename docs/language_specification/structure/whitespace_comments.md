cQASM is newline-sensitive, _i.e._ a newline terminates a statement.
A semicolon `;` may be used instead of a newline to separate statements, for instance when putting multiple statements on the same line.
Semicolons can also be put at the end of the line for clarity without changing the semantics of the program.

In general, cQASM is not whitespace-sensitive, apart from newlines. 
Spaces and tabs can be placed in between tokens.

Comments can be written as single-line comments or as multi-line comments within a comment block.
Only comments can appear before the [`version` statement](../statements/version_statement.md).
Whitespace before a single-line or multi-line comment is permitted.

## Single-line comment

A single-line comment is prefixed by two forward slashes `//` and finishes with the new line, equal to the syntax of C-like languages.

The general form of single-line comments is as follows

```
// <single-line-comment>
<statement>
<statement>  // <single-line-comment>
```

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

```
/* <multi-line
comment-block> */
<statement>  /* <multi-line
comment-block> */ <statement>
```

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
