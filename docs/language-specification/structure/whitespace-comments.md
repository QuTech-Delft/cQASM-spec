cQASM is newline-sensitive.
A semicolon `;` may be used, instead of a newline to separate statements, if the code is more readable when multiple statements occupy the same line.
In the code examples we add semicolons to signify the end of lines for clarity, but these can be omitted without changing the semantics of the programs.

A backslash `\ ` may be used to escape newlines, such that larger statements can be written over multiple lines. 
In general, cQASM is not whitespace-sensitive, apart from newlines. 
Spaces and tabs can be placed in between tokens.

Comments can be written as single-line comments or as multi-line comments within a comment block.
Only comments can appear before the _version statement_ (see section _Version statement_ below). Whitespace before a single-line or multi-line comment is permitted.

## Single-line comment

A single-line comment is prefixed by two forward slashes `//` and finishes with the new line, equal to the syntax of C-like languages.

The general structure of a single-line comment is given by

```
// <single-line-comment>
<statement>
<statement>  // <single-line-comment>
```

An example of single-line commenting is show below:

```
// This is a single-line comment, which ends on the new line.
H q[0];
CNOT q[0], q[1];  // A single-line comment can follow an instruction or statement.
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

```
/* This is a multi-
line comment. */
CNOT q[0], /* A comment block can
be placed in between tokens. */ q[1];
```

A pair of forward slashes `//` may be part of a multi-line comment block.
In that case they are considered part of the comment and not the start of a single-line comment.
