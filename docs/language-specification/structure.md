# Structure

The general structure of a cQASM program is as follows:

- **Comment(s)** 
    - _optional_ 
    - _at any location in the program_
- **Version statement**
    - _mandatory_
    - _at the top, save for some potential comment(s)_
- **Qubit (register) declaration statement**
    - _optional_
- **Instruction(s)**
    - Gate(s)
        - _optional_ 
        - _requires a qubit (register) declaration_ 
    - Measure instruction
        - _optional_ 
        - _requires a qubit (register) declaration_ 
        - _at the end, save for some potential following comment(s)_

An example cQASM program may look accordingly:

```
// Example program according to the cQASM language specification

// Version statement
version 3.0

// Qubit register declaration statement
qubit[2] q;

// Instructions (Gates)
Rx(1.57) q[0];
H q[0]; H q[1];
CNOT q[0], q[1];

// Instructions (Measure instruction)
H q[0];
measure q[0];

```

Incidentally, the smallest valid cQASM program is given as follows:

```
version 3.0
```

## File extension

The file extension of a cQASM file is `*.cq`.

## Case-sensitivity

cQASM is now a case-sensitive language, in contrast to previous versions. 
The following lines of code need not be equivalent

```
h q[0];
H Q[0];
```

Note that gate names are case-sensitive.
Even though, it is common practice to write variable names or function identifiers in lowercase, we choose to define the gate names of the predefined standard gate set in PascalCase or UPPERCASE, as this is more in line with how these gates are represented in the field of quantum information processing (QIP).
A list of the predefined cQASM standard gate set can be found in section below.

## Whitespace & Comments

cQASM is newline-sensitive.
A semicolon `;` may be used, instead of a newline to separate statements, if the code is more readable when multiple statements occupy the same line.
In the code examples we add semicolons to signify the end of lines for clarity, but these can be omitted without changing the semantics of the programs.

 A backslash `\ ` may be used to escape newlines, such that larger statements can be written over multiple lines. 
 In general, cQASM is not whitespace-sensitive, apart from newlines. 
 Spaces and tabs can be placed in between tokens.

Comments can be written as single-line comments or as multi-line comments within a comment block.
Only comments can appear before the _version statement_ (see section _Version statement_ below). Whitespace before a single-line or multi-line comment is permitted.

### Single-line comment

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

### Multi-line comments

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

## Identifiers

The first character of an identifier may either be an upper or lowercase letter from the ISO basic Latin alphabet or an underscore, _i.e._, it cannot be a digit.
Any following character(s) follow the same rule as the first character, but now may also be a digit.
Identifiers cannot contain spaces.
Identifiers ID must follow the following regular expression pattern,

`[_a-zA-Z][a-zA-Z0-9_]*`

Examples are given below

```
q
_i
Id
b01
2k	// Invalid identifier: first character cannot be a digit!
```

Note that there exist certain predefined keywords that cannot be used as an identifier; a list of these keywords can be found under the section _Keywords_.

## Keywords

Keywords constitute identifiers reserved by the parser of the language. 
As such, they have a specific predefined meaning and cannot be overwritten or used as a general identifier, _e.g._, as the name of the qubit register.

`version`

`qubit`

`measure`

## Predefined constants

The following mathematical constants are recognized: `pi`, `tau`, and `eu`, where `tau` is `2 * pi` and `eu` represents Euler's constant.
They are of double precision and can be used in arithmetic expressions, _e.g._, `Rx(pi/2) q[0]`. 
