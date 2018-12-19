cQASM 2.0 specification
=======================

This is intended to be a working document for the cQASM 2.0 specification. Feel free to add comments/notes using blockquotes (add your name to the top of it to keep things clear, though `git blame` can always be used in case of confusion). You should be able to use github's built-in editor to edit this file. You can also use the issue system to request and discuss changes.


Intended purpose of cQASM
-------------------------

cQASM (common quantum assembly) strives to be an implementation-agnostic assembly language for quantum accelerators. Because of this agnosticism, it supports many things that a realistic implementation might not, so its purpose is explicitly NOT to represent a minimum set of features needed to build a quantum accelerator. However, an implementation-specific subset of cQASM 2.0 should exactly describe all valid programs for that implementation. Less formally; if an implementation supports cQASM features A and B but not C, simply not using cQASM feature C should be enough to represent exactly the implementation.

cQASM also strives to be usable as an intermediate representation for a quantum compiler at all levels. This requires that it can describe some higher-level constructs as well, to be reduced by later compilation steps. For instance, cQASM supports the three-qubit Toffoli gate, which implementations most likely would not.

In addition to being a superset of the compiler intermediate representation, it is expected that people will also be writing cQASM manually, for instance to use features that the compiler does not yet support. For this reason, unlike most IRs, cQASM should also be user-friendly, allowing some "syntactic sugar" here and there that a compiler would never generate. For instance, using a non-static range of qubits in a SIMD style (that is, defined by the contents of classical registers) would never be defined by a compiler, but might allow algorithms to be written more concisely when coded manually.

The primary purpose of cQASM 2.0 is to extend 1.0 through the addition of classical arithmetic and flow control. In addition, 2.0 improves upon the grammar and adds many ways to write cQASM programs more concisely.

The only two tools that are expected to support the full featureset of cQASM are the parser and printer (libcqasm2) and the simulator (QX). Any compiler step, implementation, tool, etc. is allowed to reject any fraction of valid cQASM 2.0 input. However, it is not allowed to add language features not part of cQASM 2.0 (when it's using libcqasm2, this is not possible to begin with).


Planning
--------

This table should be removed eventually, but for now I feel like keeping everything in one place is a good idea:

| OK | Feature                             | Dependencies                        | Priority | Responsible | Deadline    |
|----|-------------------------------------|-------------------------------------|----------|-------------|-------------|
|    | **cQASM**                           |                                     |          | Jeroen      |             |
| ✓  | cQASM 2.0 draft                     | -                                   | High     | Jeroen      | 2018-12-12  |
|    | cQASM 2.0 draft review              | cQASM 2.0 draft                     | High     | Everyone    | 2018-12-21  |
|    | Frozen cQASM 2.0 specification      | cQASM 2.0 draft review              | High     | Jeroen      | 2018-12-21  |
|    | **libcqasm2**                       |                                     |          | Jeroen      |             |
|    | libcqasm2 lexer                     | Frozen cQASM2.0 specification       | High     | Jeroen      | 2018-12-23  |
|    | libcqasm2 parser + AST              | libcqasm2 lexer                     | High     | Jeroen      | 2018-12-23  |
|    | libcqasm2 semantical + IR           | libcqasm2 parser + AST              | High     | Jeroen      | 2018-12-23  |
|    | libcqasm2 unit tests                | libcqasm2 semantical + IR           | Medium   | Jeroen      | 2019-12-31  |
|    | libcqasm2 API specification         | Frozen cQASM 2.0 specification      | High     | Jeroen      | 2019-12-23  |
|    | libcqasm2 API                       | libcqasm2 semantical + IR           | High     | Jeroen      | 2019-12-31  |
|    | libcqasm2 pretty-printer            | libcqasm2 semantical + IR           | Low      | Jeroen      | ?           |
|    | **QX**                              |                                     |          | ?           |             |
|    | QX/libcqasm2 API update             | libcqasm2 API                       | High     | ?           | ?           |
|    | QX multi-qreg support               | QX/libcqasm2 API update             | ?        | ?           | ?           |
|    | QX custom gate support              | QX/libcqasm2 API update             | ?        | ?           | ?           |
|    | QX classical flow control           | QX/libcqasm2 API update             | ?        | ?           | ?           |
|    | QX classical resource system        | QX/libcqasm2 API update             | ?        | ?           | ?           |
|    | QX dynamic indexation               | QX classical resource system        | ?        | ?           | ?           |
|    | QX integer operation support        | QX classical resource system        | ?        | ?           | ?           |
|    | QX floating point operation support | QX classical resource system        | ?        | ?           | ?           |
|    | QX fixed point operation support    | QX classical resource system        | ?        | ?           | ?           |
|    | QX boolean operation support        | QX classical resource system        | ?        | ?           | ?           |
|    | QX classical type conversions       | Support for types to convert        | ?        | ?           | ?           |
|    | **OpenQL**                          |                                     |          | Imran?      |             |
|    | OpenQL ???                          | libcqasm2 API specification?        | ?        | ?           | ?           |


Overview of changes from 1.0 to 2.0
-----------------------------------

 - Improved handling of whitespace, newlines, and comments.
 - Gates, axes, `q`, and `b` are no longer reserved words.
 - Overhauled resource declarations, including classical resources of types `int`, `uint`, `fixed`, `ufixed`, `float`, `double`, and `boolean`, as well as 1-dimensional arrays thereof.
 - Added `fredkin` and `sqswap` gates, as well as some aliases for existing gates.
 - Added a way to specify custom n-qubit gates.
 - Added a powerful macro expansion system to reduce the amount of typing when writing cQASM manually.
 - Added classical flow control and arithmetic.
 - Added expression syntax for macros and to be used as a higher level of abstraction for describing classical arithmetic.
 - Added `stop`, `error` and `print` instructions to ease debugging.
 - Added `pragma` statements and annotations to easily create your own language extensions, without needing to change the cQASM specification and all associated tools.

### Deprecated cQASM 1.0 features

The following language features should no longer be used because they have been superseded, but are still included in 2.0 for backward-compatibility.

#### Qubit register declaration

In cQASM 1.0, the qubit register was implicitly named `q` (for the qubits) and `b` (for the measurements), and was defined as follows:

    qubits 15

Instead of this, use:

    qubit q[15]

and refer to the measurement registers (where ambiguous) using `q.b` instead of `b`.

#### QX-specific instructions

cQASM 1.0 defined the following QX-specific instructions:

    display                     # Dump the full quantum state to the console
    display_binary              # Dump the measurement register state to the console
    reset_averaging             # Reset measurement averaging
    error_model mdl, ...        # Set the error model

The ellipsis for the error model is a parameter list of integers and floats literals, while the `mdl` parameter can be any identifier. It is up to QX to check this.

Instead of these instructions, use their `pragma` equivalent.

#### Matrix specification for the U instruction

cQASM 1.0 allows custom unitary matrices to be specified using `[a,b,c,d,e,f,g,h]`, where each letter is a real number. This format is now deprecated in favor of the following equivalant:

    [| a + im*b, c + im*d
       e + im*f, g + im*h |]

There are more newline options than shown here. Refer to the matrix subsection in the data type section for more info.

### Unsupported cQASM 1.0 features

In practice, cQASM 2.0 is expected to be fully backward compatible with 1.0. However, because new keywords were added, the following identifiers (which may have been used for `map` statements) are no longer legal:

    boolean    complex    const      def        double     else       eu         extern
    false      fixed      float      for        gate       goto       if         im
    include    int        let        matrix     pi         pragma     qubit      set
    string     struct     true       type       ufixed     uint       vector     volatile
    weak

They will cause parse errors.


cQASM file structure
--------------------

cQASM files are case-insensitive text files consisting of a version header and a number of statements. The version header looks like this:

    version 2.0

> JvS: Same as 1.0 (aside from the version number). Lexically though, the entire version string will be represented as a single token, compared to making `version` a keyword and using (yuck) the floating point token for the version number.

When cQASM code is parsed, a major version number greater than what is supported by the parser must be rejected with an error message. For minor versions a warning should suffice.

> JvS: I don't think libcqasm2 currently does anything with the version number, but this seems like a good idea.

*Statements* can be any of the following things:

 - resource declarations, mappings, and assignments;
 - macros;
 - subcircuit headers and labels;
 - bundles;
 - or pragmas.

The *bundle* is the most common type of statement. They consist of one or more *gates* that may be executed in parallel, where a gate is defined to be any quantum gate or classical instruction. All statements and gates can be annotated with arbitrary data for extensibility. These features are explained in more detail in later sections of this document.

### Whitespace and newlines

Instructions are separated by newlines or (less typically) semicolons, similar to Python. Examples:

    statement 1              # Canonical syntax
    statement 2;             # Since a newline = a semicolon, they are optional
    statement 3; statement 4

Like Python, when a statement is longer than you'd like, you can break to the next line by "escaping" the newline with a backslash;

    statement \
    5;

Beware that escaping a newline still breaks the current token, so

    state\
    ment 6 # equivalent to "state ment 6", not "statement 6"

cQASM supports all of the following newlines: `\n` (Linux), `\r\n` (Windows), and `\r` (Mac).

Whitespace in cQASM consists of any combination of consecutive spaces and tabs. Unlike Python, it has no grammatical significance: it is legal between all tokens, and mandatory only when there would otherwise be no non-alphanumeric, non-underscore character between two tokens. For instance, aside from the last line, these are equivalent:

    x90 q[0]        # Legal
      x90 q [ 0 ]   # Exactly the same as above
    x90q[0]         # Not the same as above; there must be a space between two identifiers

> JvS: This contrasts with 1.0's lexer definition, which does not throw whitespace out. This only expands the set of valid cQASM programs, and simplifies the grammar significantly.

### Comments

cQASM supports single-line comments using the `#` symbol, as already shown in many of the examples above. In addition, cQASM 2.0 adds C-like `/* ... */` multiline comments. Like C, they do not nest, so:

    statement 1 # This is a single-line comment.
    statement /* Multi-line comments can go anywhere, */ 2
    statement /* and can even break statements
    to the next line. */ 3
    /* Comment precedence is whatever comes first. So # */
    statement 4
    /* broke the previous comment. */
    # Similarly: /*
    statement 5
    /* Multi-line comments cannot be nested. So: /* */
    statement 6

> JvS: Same as 1.0 with the addition of comment blocks. Comments are no longer parsed in 2.0, and thus behave as optional whitespace.

### Identifiers

Identifiers are combinations of letters, numbers, and underscores, used to refer to all kinds of language constructs, such as the names of gates, axes, resources, and so on. They must not start with a number (so their regex is `/[a-zA-Z_][a-zA-Z0-9_]*/`), and cannot be one of the following reserved words:

    boolean    complex    const      def        double     else       eu         extern
    false      fixed      float      for        gate       goto       if         im
    include    int        let        map        matrix     pi         pragma     qubit
    qubits     set        string     struct     true       type       ufixed     uint
    vector     volatile   weak

Some of these reserved words are already in use as keywords, while others are reserved for future use.

> JvS: The introduction of new keywords is the only thing that isn't lexically compatible to 1.0. At the same time though, 2.0 greatly reduces the number of keywords, as instructions are now represented as identifiers instead of keywords. All remaining single-letter keywords were also removed to prevent confusion (`q`, `b`, `x`, `y`, and `z`).


Data types
----------

cQASM 2.0 extends 1.0's data type support from just qubits and their associated measurement bits with a number of classical data types. The full list of fully supported types is:

 - qubits (with associated measurement register),
 - fully parameterizable fixed-points (up to 64 bits wide, also used to represent integers and booleans),
 - single- and double-precision floating point numbers,
 - and fixed-length, 1-dimensional arrays of the above.

In addition, there is (very) limited support for:

 - complex matrices,
 - and strings.

### Qubits

The type name for a qubit is (equivalently) `qubit` or `qubits`. The `qubits` name is deprecated, and exists only for backward compatibility.

Qubits work the same way in cQASM 2.0 as they did in 1.0. That is, each qubit consists of the actual qubit and an associated boolean measurement register. As far as the language is concerned, all qubits can interact and entangle with each other, regardless of which resource they are part of.

There is no literal notation for qubits. The only way to interact with them is through application of quantum gates.

In most contexts where qubits can be specified, it is clear from context whether the qubit itself or its measurement register is used, but for some gates (in particular when using a qubit register for conditional execution) this is not clear. In this case subscript notation should be used. If the `.q` subscript suffix is applied to the qubit, the actual qubit is selected, whereas `.b` explicitly selects the measurement register. When the qubit is part of an array, the suffix comes after the indexation, for instance `q[0].b`. You are free to use this notation anywhere.

There is an exception to the above for compatibility with 1.0, where qubits were implicitly named `q` and their measurement registers were implicitly named `b`. This notation is deprecated, and only used in conjunction with the equally deprecated nameless qubit register declaration.

Qubit measurement registers are only writable by measurement instructions and the `not` instruction. The latter is only for 1.0 compatibility. This has to do with the way these registers are likely to be implemented in a real quantum computer. They require synchronization between the quantum domain and the classical domain, which run asynchronously otherwise, so making them write-only for one side and read-only for the other simplifies the implementation considerably. The `not` gate exception could be implemented without writing to the actual register by recording whether an even or odd number of `not` instructions has been applied since the latest measurement, and inverting the value read from the measurement register when the number was odd.

### Numeric types

cQASM 2.0 supports fixed-point numbers of up to 64-bits in width, IEEE-754 single and double precision floats, and has limited support for complex numbers (represented as two doubles). Strict typing is employed: all literals, resources, and expressions have a well-defined type.

#### Fixed-point numbers

cQASM supports both unsigned and signed (two's complement) fixed-point numbers. Their types are specified as follows:

    fixed<i,f>      # Signed fixed point, i+f bits, LSB is worth 1/2**f
    ufixed<i,f>     # Unsigned fixed point, i+f bits, LSB is worth 1/2**f
    int<i>          # Synonym for fixed<i,0>
    uint<i>         # Synonym for ufixed<i,0>
    boolean         # Synonym for ufixed<1,0>

Some notes:

 - Intuitively, `i` represents the number of bits before the decimal, and `f` represents the number of bits after the decimal. However, both `f` and `i` can be negative. A negative `i` implies that the range is less than one, while a negative `f` implies that the LSB is greater than 1.
 - `i` and `f` can be written as a static expression.
 - Implementations need only support values of `i` + `f` of up to 64 bits.
 - `i` + `f` < 1 is illegal.

And some examples:

    fixed<8,8>      # -128..127.99609375, LSB=0.00390625
    fixed<0,8>      # -0.5..0.49609375, LSB=0.00390625
    ufixed<0,8>     # 0..0.99609375, LSB=0.00390625
    ufixed<-4,12>   # 0..0.06227106227106227, LSB=0.0002442002442002442
    ufixed<12,-4>   # 0..4080, LSB=16
    int<8>          # -128..127, LSB=1
    int<5>          # -16..15, LSB=1
    uint<32>        # 0..4294967295, LSB=1
    uint<2>         # 0..3, LSB=1
    uint<64>        # 0..18446744073709551615, LSB=1
    boolean         # 0..1, LSB=1

Fixed-point numbers can be represented as literals matching the following patterns:

    /[0-9]+[uU]?/                           -> (u)int<64> = (u)fixed<64,0>
    /0[xX][0-9a-fA-F]+[uU]?/                -> (u)int<4*i> = (u)fixed<4*i,0>
    /0[xX][0-9a-fA-F]*_*\.[uU]?/            -> (u)fixed<4*(u+i),-4*u>
    /0[xX][0-9a-fA-F]*\.[0-9a-fA-F]*[uU]?/  -> (u)fixed<i,f>
    /0[xX]\._*[0-9a-fA-F]*[uU]?/            -> (u)fixed<-4*u,4*(u+f)>
    /0[bB][01]+[uU]?/                       -> (u)int<i> = (u)fixed<i,0>
    /0[bB][01]*_*\.[uU]?/                   -> (u)fixed<u+i,-u>
    /0[bB][01]*\.[01]*[uU]?/                -> (u)fixed<i,f>
    /0[bB]\._*[01]*[uU]?/                   -> (u)fixed<-u,u+f>
    true (case-insensitive)                 -> boolean = ufixed<1,0> (value 1)
    false (case-insensitive)                -> boolean = ufixed<1,0> (value 0)

where `i` is the number of digits before the decimal separator (if any), `f` is the number of fractional digits, and `u` is the number of underscores.

Some notes:

 - There is no direct decimal notation for negative numbers. To get a negative number, use the unary minus operator (possible to get all numbers except `-2**63`) or hexadecimal/binary notation.
 - Literal overflows result in error messages.
 - libcqasm2's AST does not distinguish between different literal representations for the same number/type pair.

And some examples:

    10              # int<64>: 10
    10u             # uint<64>: 10
    0x0A            # int<8>: 10
    010             # int<64>: 10 (note, NOT octal)
    0b1010          # int<4>: 10
    0x12.34         # fixed<8,8>: 18.203125
    0x.F3u          # ufixed<0,8>: 0.94921875
    0b.1111001100u  # ufixed<0,10>: 0.94921875
    0b0.11110011    # fixed<1,8>: 0.94921875
    0b.11110011     # fixed<0,8>: -0.05078125   (note the sign!)
    0x.__1          # fixed<-8,12>: 0.000244140625
    0x10_.          # fixed<12,-4>: 256
    true            # ufixed<1,0>: 1

You can also specify the type you want explicitly using a typecast. Overflow is still an error on this case. Examples:

    (uint<3>)4      # uint<3>: 4
    (uint<3>)80     # ERROR: overflow

Semantically, the bitcount parameters specify only a minimum width: an implementation is free to represent a `uint<5>` as an `uint<8>` or even an `int<64>`. Therefore, operators like `+`, `-`, and `*` may set these past-MSB bits during overflow:

    0x10u * 0x10u   # May be 0 as expected (due to overflow), but may
                    #   also be the unrepresentable number 0x100!

However, for typecasts, implementations are required to force the number representation to be representable in that notation using the following rules:

 - Unrepresentable bits are set to zero.
 - For signed fixed-point numbers, the sign is copied to the MSB of the destination type, so sign is always maintained.

Thus, if a cast is applied after a `+`, `-`, or `*` operator, the result is defined again:

    (uint<8>)(0x10u * 0x10u) -> 0

It is recommended for simulators to track whether overflow has occurred for a number, so they can exit with an error if the number is used before an appropriate typecast is applied.

#### Floating-point numbers

cQASM supports single- and double-precision IEEE-754 floating-point numbers. Their types are specified as follows:

    float           # Single-precision
    double          # Double-precision

A small subset of the language also supports complex numbers, represented using two doubles. The keyword `complex` is reserved for the type, but complex resources are currently not part of the language, so this keyword is unused; `complex` numbers can only be used to statically express the matrix elements of custom gates, and only `+`, `-`, `*`, and `exp()` are defined over complex inputs.

Floating-point numbers can be represented as literals matching the following patterns:

    /[0-9]*\.[0-9]+([eE][-+]?[0-9]+)?/      -> float
    /[0-9]*\.[0-9]+([eE][-+]?[0-9]+)?[fF]/  -> double
    pi (case-insensitive)                   -> double (3.141592653589793)
    eu (case-insensitive)                   -> double (2.718281828459045)
    im (case-insensitive)                   -> complex (i)

Single-precision versions of `pi` and `eu` are achieved by means of `(float)pi` and `(float)eu`. Some examples:

    0.0             # double: 0
    .0              # double: 0
    0.              # Syntax error; the regex requires a number after
                    #   the decimal
    1.9             # double: 1.89999999999999991118...
    1.9f            # float: 1.89999997615814208984375
    1.5e3           # double: 1500
    1.5e+3          # double: 1500
    1.5e-3          # double: approx. 0.0015
    (float)pi       # double: 3.1415927410125732421875

#### Automatic type promotions

Operators are defined only for certain combinations of source and destination types. You can find these combinations in the operator table. When operands must be of the same type, they are promoted to a common format that can represent all of the inputs. When this cannot be done without loss of range or accuracy, an error is reported, which the user must then fix using explicit typecasts.

The following promotions are legal:

| Promotion                         | Condition                             |
|-----------------------------------|---------------------------------------|
| `qubit` -> `ufixed<1,0>`          | always allowed (measurement register) |
| `ufixed<x,y>` -> `ufixed<x+n,y>`  | x+y+n <= 63                           |
| `ufixed<x,y>` -> `ufixed<x,y+n>`  | x+y+n <= 63                           |
| `ufixed<x,y>` -> `fixed<x+1,y>`   | x+y <= 63                             |
| `fixed<x,y>` -> `fixed<x+n,y>`    | x+y+n <= 64                           |
| `fixed<x,y>` -> `fixed<x,y+n>`    | x+y+n <= 64                           |
| `ufixed<x,y>` -> `float`          | x+y <= 24                             |
| `fixed<x,y>` -> `float`           | x+y <= 25                             |
| `ufixed<x,y>` -> `double`         | x+y <= 53                             |
| `fixed<x,y>` -> `double`          | x+y <= 54                             |
| `float` -> `double`               | always                                |
| `double` -> `complex`             | always                                |

#### Lossy typecasts

Typecasts to a lesser datatype round as follows:

 - `double` to `float`: up to the implementation.
 - anything to incompatible `ufixed`: unrepresentable bits are discarded.
 - anything to incompatible `fixed`: sign is copied from source, unrepresentable bits are discarded.

Note that discarding unrepresentable bits results in rounding toward negative infinity because of the way two's complement works.

### Arrays

cQASM 2.0 supports one-dimensional arrays over the above datatypes. The size of an array must be specified statically in the resource declaration, and cannot change at runtime. Arrays must have at least one entry. An array of size 1 is semantically equivalent to a scalar (in fact, all internal values are arrays) due to the way SIMD/SGMQ works.

Array literals are specified using comma-separated entries and curly brackets. For example:

    {1, 2, 3}   # int<64>[3]

### Complex matrices

cQASM 2.0 allows complex matrices to be specified. The keyword `matrix` is reserved for this type, but matrix resources are not supported, and they cannot be operated on using expressions. Matrices can be specified in two ways:

    [|0, -im; im, 0|]  # Pauli-Y using 2.0 syntax
    [0,0,0,-1,0,1,0,0] # Pauli-Y using 1.0 syntax

There are several differences between the two:

 - The 2.0 syntax uses `[|...|]` to enclose the matrix, versus `[...]`. This disambiguates between the two notations.
 - The 2.0 syntax uses a single complex number for each matrix entry, while the 1.0 syntax uses two real numbers to specify the real component and imaginary component.
 - The 2.0 syntax uses `;` or a newline to go to the next line in the matrix, whereas 1.0 does not make that distinction.
 - The 2.0 syntax makes the aspect ratio of the matrix explicit. 1.0 matrices can only be square.
 - A newline is optional after `[|` and before `|]`.

The 1.0 syntax is deprecated and may be removed in later versions. Some equivalent ways to describe Pauli-Y in 2.0:

    [|
        0, -im
        im, 0
    |]

    [| 0, -im
       im, 0 |]

The comma-separated lists, in turn separated by newlines/semicolons, represent the rows of the matrix. Each must have the same length.

### Strings

String literals are used in cQASM 2.0 on occasion. The keyword `string` is reserved for this type, but string resources are not supported, and they cannot be operated on using expressions. Their literals use the usual string syntax, using `"` as delimiters. `\t` (tab), `\n` (OS-dependent newline), `\"` (`"`) and `\\` (`\`) can be used as escape sequences within the string. Actual newlines within strings are allowed; they're equivalent to `\n`. If you want to break up a long string without inserting a newline, use the escaped newline syntax. Some examples:

    "Hello, World!"     # -> Hello, world!
    "This is \
    a long string"      # -> This is a long string
    "This contains
    a newline"          # -> This contains<NEWLINE>a newline
    "More\nnewlines"    # -> More<NEWLINE>newlines
    "\"Huh?\" he said." # -> "Huh?" he said.

### JSON strings

Similar to strings, JSON data is used on occasion. JSON data must be enclosed by `{|` and `|}` symbols, which behave like the outer `{` and `}` of a JSON object. The contents are parsed by [this library](https://github.com/nlohmann/json).


Expressions
-----------

Expressions allow (classical) arithmetic to be specified almost anywhere in a cQASM 2.0 program.

The primary purpose of expressions is to increase the power of macro expansions (described later) and provide a more intuitive way to write down sequences of classical arithmetic gates. They are also used to represent the complex numbers for the description of custom gates. Ultimately, the output of libcqasm2 does *not* include any expressions: it is up to libcqasm2 to reduce them.

An important distinction is made between *static* and *dynamic* expressions: static expressions are fully evaluable at parse-time because they only depend on constants after macro expansion, whereas dynamic expressions depend on resources or use the `rand`/`randf` functions. This distinction is important because some constructs require values to be known at parse-time, such as the number of elements in an array resource, a custom gate definition, or the index of a qubit array.

The operators are defined similar to C, with some minor additions:

 - as in Python 3, `//` is integer division, and `**` is exponentiation;
 - `^^` is added for logical exclusive or;
 - `(>>a)b` and `(<<a)b` shift the interpreted position of the decimal point of a fixed-point number without affecting its contents. Conversely, the regular shift operations cause bits to be thrown away, like integer shifts.

The following table lists the available operators, their precedence, the equivalent classical gates, and the types they operate on. This last column should be interpreted as follows:

 - `s` included: can operate on `float`.
 - `d` included: can operate on `double`.
 - `u` included: can operate on `ufixed`.
 - `f` included: can operate on `fixed`.
 - `c` included: can operate on `complex`.
 - * included: more information in the sections below the table.

All operations are defined over arrays of supported types as well, by means of SIMD/SGMQ rules. They execute piecewise. All non-scalar values must have the same array length for this to make sense; scalar values are applied to each array entry. For instance:

    int<32> a[10]
    set a = a + 1

adds 1 (a scalar) to all entries of a (an array). Refer to the SIMD/SGMQ section for more information.

Unless otherwise specified, all operands must share the same type. Type promotion is automatically applied to the source operands before applying the operation; if this is not possible, an error is generated. The result of the expression has the same type as the operands.

| Operator    | Description                     | Equivalent gate | Precedence        | Types   |
|-------------|---------------------------------|-----------------|-------------------|---------|
| `sqrt(x)`   | Square-root                     | `sqrt`          | 1, left-to-right  | `sd`    |
| `pow(x, y)` | Exponentiation with base `x`    | `pow`           | 1, left-to-right  | `sd`    |
| `log(x, y)` | Logarithm with base `x`         | `log`           | 1, left-to-right  | `sd`    |
| `exp(x)`    | Natural exponentiation          | `exp`           | 1, left-to-right  | `sd`    |
| `ln(x)`     | Natural logarithm               | `ln`            | 1, left-to-right  | `sd`    |
| `floor(x)`  | Round down to nearest int       | `floor`         | 1, left-to-right  | `sduf`  |
| `ceil(x)`   | Round up to nearest int         | `ceil`          | 1, left-to-right  | `sduf`  |
| `round(x)`  | Round to nearest even           | `round`         | 1, left-to-right  | `sduf`  |
| `sin(x)`    | Sine (radians)                  | `sin`           | 1, left-to-right  | `sd`    |
| `cos(x)`    | Cosine (radians)                | `cos`           | 1, left-to-right  | `sd`    |
| `tan(x)`    | Tangent (radians)               | `tan`           | 1, left-to-right  | `sd`    |
| `asin(x)`   | Inverse sine (radians)          | `asin`          | 1, left-to-right  | `sd`    |
| `acos(x)`   | Inverse cosine (radians)        | `acos`          | 1, left-to-right  | `sd`    |
| `atan(x)`   | Inverse tangent (radians)       | `atan`          | 1, left-to-right  | `sd`    |
| `min(x, y)` | Minimum                         | `min`           | 1, left-to-right  | `sduf`  |
| `max(x, y)` | Maximum                         | `max`           | 1, left-to-right  | `sduf`  |
| `abs(x)`    | Absolute value                  | `abs`           | 1, left-to-right  | `sduf`  |
| `rand()`    | Uniform random double in [0,1)  | `rand`          | 1, left-to-right  | *       |
| `randf()`   | Uniform random float in [0,1)   | `randf`         | 1, left-to-right  | *       |
| `x[...]`    | Array indexation                | `ld` and `st`   | 1, left-to-right  | *       |
|             |                                 |                 |                   |         |
| `(type)x`   | Typecast                        | `mov`           | 2, right-to-left  | n/a     |
| `(>>y)x`    | Shift decimal left by `y` bits  | -               | 2, right-to-left  | `uf`    |
| `(<<y)x`    | Shift decimal right by `y` bits | -               | 2, right-to-left  | `uf`    |
| `+x`        | Unary plus (no-op)              | -               | 2, right-to-left  | `sdufc` |
| `-x`        | Negation                        | `neg`           | 2, right-to-left  | `sdufc` |
| `!x`        | Boolean inversion               | `not`           | 2, right-to-left  | `uf`    |
| `~x`        | Bitwise inversion               | `inv`           | 2, right-to-left  | `uf`    |
|             |                                 |                 |                   |         |
| `x ** y`    | Exponentiation with base `x`    | `pow`           | 3, right-to-left  | `sd`    |
|             |                                 |                 |                   |         |
| `x * y`     | Multiplication                  | `mul`           | 4, left-to-right  | `sdufc`*|
| `x / y`     | True division                   | `div`           | 4, left-to-right  | `sduf`  |
| `x // y`    | Floored division                | `idiv`          | 4, left-to-right  | `sduf`  |
| `x % y`     | Remainder for floored division  | `mod`           | 4, left-to-right  | `sduf`  |
|             |                                 |                 |                   |         |
| `x + y`     | Addition                        | `add`           | 5, left-to-right  | `sdufc`*|
| `x - y`     | Subtraction                     | `sub`           | 5, left-to-right  | `sdufc`*|
|             |                                 |                 |                   |         |
| `x << y`    | Shift left                      | `shl`           | 6, left-to-right  | `uf`*   |
| `x >> y`    | Shift right                     | `shr`           | 6, left-to-right  | `uf`*   |
|             |                                 |                 |                   |         |
| `x > y`     | Greater than                    | `cgt`           | 7, left-to-right  | `sduf`  |
| `x < y`     | Less than                       | `clt`           | 7, left-to-right  | `sduf`  |
| `x >= y`    | Greater/equal                   | `cge`           | 7, left-to-right  | `sduf`  |
| `x <= y`    | Less/equal                      | `cle`           | 7, left-to-right  | `sduf`  |
|             |                                 |                 |                   |         |
| `x == y`    | Equality                        | `ceq`           | 8, left-to-right  | `sduf`  |
| `x != y`    | Inequality                      | `cne`           | 8, left-to-right  | `sduf`  |
|             |                                 |                 |                   |         |
| `x & y`     | Bitwise and                     | `and`           | 9, left-to-right  | `uf`    |
| `x ^ y`     | Bitwise exclusive or            | `xor`           | 10, left-to-right | `uf`    |
| `x \| y`    | Bitwise or                      | `or`            | 11, left-to-right | `uf`    |
|             |                                 |                 |                   |         |
| `x && y`    | Boolean and                     | `land`          | 12, left-to-right | `uf`    |
| `x ^^ y`    | Boolean exclusive or            | `lxor`          | 13, left-to-right | `uf`    |
| `x \|\| y`  | Boolean or                      | `lor`           | 14, left-to-right | `uf`    |
|             |                                 |                 |                   |         |
| `x ? y : z` | Selection                       | `slct`          | 15, right-to-left | `sduf`* |

### rand()/randf() semantics

Unlike all other operations, the `rand` and `randf` instructions have no source operands. Therefore, the resultant type is made explicit through the name of the function/gate. Also unlike all other operations, `rand` and `randf` are never constant-folded.

### Indexation semantics

The indexation operator selects one or more comma-separed elements or element ranges from an array. When more than one element is selected, the result of the operation becomes an array containing the selected elements in the order in which they are specified. This is useful for the SIMD/SGMQ notation.

The syntax for a range is `a:b`, which selects `a` up to and including `b`. `a` and `b` must be static expressions at all times, because the width of the SIMD/SGMQ operation and the size of the resultant array type must be known at parse-time. Reverse ranges result in no elements being selected. Not selecting any elements in the whole indexation nullifies the SIMD/SGMQ operations.

In addition, all indices of qubit arrays must be static. The reason for the latter is that mapping, routing, and scheduling of qubits depends on their index due to interaction constraints. These transformations are currently performed during compilation. Issue #3 has more information on this subject.

All indices must be integral; that is, the number of fractional bits in the `(u)fixed` must be 0 (integer) or negative. Out-of-range indexation behavior is an error when the index is static. It is undefined at runtime, though it is recommended that simulators exit with a failure condition when this happens.

If an index is itself a matrix, its elements are interpreted as if they were comma-separated indices.

Note that all array indices start at 0.

Some examples:

    qubit q[5]
    float f[5]
    uint<32> u[5]
    int<32> i
    ...
    f[3]                # float: f3
    f[4,2]              # float[2]: [f4, f2]
    f[1,1,3,3]          # float[4]: [f1, f1, f3, f3]
    f[1,1:3,3]          # float[5]: [f1, f1, f2, f3, f3]
    f[i]                # selects the float indexed by i
    f[i,i+1,i+2,i+3]    # float[4]; note that i must be 0 or 1 here
    f[0:i]              # illegal
    f[i:i+2]            # while technically correct, this is currently illegal
    q[0]                # qubit: q0
    q[0:3]              # qubit[4]: {q0, q1, q2, q3}
    q[5]                # undefined behavior, out of range
    q[i]                # illegal, cannot dynamically index a qubit array
    f[1,u[0:2],3]       # float[5]: [f1, fu0, fu1, fu2, f3]
    u[u]                # swizzle u using itself. legal (as long as all entries of u
                        #    are in 0:4), but hurts my brain.

### Addition, subtraction, and multiplication semantics

The type returned by addition, subtraction, and multiplication operations is the same as the source operands. Therefore, overflow is possible; the semantics for this are described in the data type section of this document.

The semantics for fixed-point multiplication follow naturally from what has been described thus far, but some examples are in order for building intuition:

    0x01 * 0x100  -> 0x100
    0x10 * 0x100  -> undefined, overflow
    (uint<12> 0x10
    0x.01 * 0x100 -> 0x001.00

### Shift and rotate semantics

The shift operations take their signedness from their operands: if either is signed, the shifts are signed.

Unsigned shifts are trivial. They shift in zeros and throw away the bits that were shifted out. For example:

    uint<4> val = 0b1001u
    print val >> 2 # 2 = 0b0010 (01 was lost at the LSB side)
    print val << 2 # 4 = 0b0100 (10 was lost at the MSB side)

Signed shifts are implemented differently. Right-shifts shift in sign bits instead of zeros to maintain the sign. Left-shifts leave the sign alone and only operate on the remainder of the bits. For example:

    int<4> val = 0b1001
    print val >> 2 # -2 = 0b1110 (sign-extended, 01 was lost at the LSB side)
    print val << 2 # -4 = 0b1100 (sign replicated, 100 was lost at the MSB side)

In both cases, a left-shift by one bit multiplies by 2, while a right-shift is equivalent to a flooring division by 2. For left-shifts, the sign is maintained even during overflow. Note that "overflow" for shifts is not considered an error, unlike multiplicative overflow.

The type of the shift amount must be a nonnegative integer. The runtime result of a negative shift amount is undefined, and simulators may exit with an error for this.

To understand the "shift decimal point" operators (`(>>a)b` and `(<<a)b`), consider the following situation:

    fixed<1,63> num = (fixed<1,63>)(sqrt(0.5))
    fixed<11,53> num_times_1024
    # Set num_times_1024 to 1024*num: how?
    print num_times_1024

If we would not be limited by the 64-bits-maximum rule, we could first extend the number by 10 bits, then perform a shift, and then perform a typecast:

    fixed<11,63> temp = num # Note: illegal
    set temp = temp << 10
    set num_times_1024 = (fixed<11,53>)temp

However, note that `num` and `num_times_1024` should contain the same bits of data after the operation, the decimal point is just interpreted to be in a different place. So even if we would be able to temporarily extend to 74 bits, it would be a bit silly, because a real implementation would then need to do a 74-bit shift-left, followed by a 74-bit shift-right (during the typecast, which moves the interpreted position of the decimal point along with a shift in the opposite direction).

Instead, we can use the shift decimal point operator:

    set num_times_1024 = (<<10)num

Like a typecast, it changes the type (in this case from `fixed<1,63>` to `fixed<11,53>`), but it does not change the data contained within the value. To illustrate (with spaces added in the numbers to align them up):

    num               =           0b0.1011010100 00010011110011[...]
    num<<10           =                      0b0.00010011110011[...]
    (fixed<11,53>)num = 0b00000000000.1011010100 00010011110011[...]
    (<<10)num         =           0b0 1011010100.00010011110011[...]

The left-shift throws away MSB-data (overflow) and the typecast throws away LSB-data (loss of precision), but the shift decimal point operator keeps all bits intact. Note that the decimal point is shifted in the opposite direction as the arrows in the cast, so the numerical result is consistent with what you would expect from a shift in the same direction.

The type of the shift amount for the cast must be a static nonnegative integer.

### Selection semantics

The selection operator, `x ? y : z`, differs from the other operators in that it requires that `x` is a `boolean` (equivalently, a `uint<1>` or a `ufixed<1,0>`), while it requires that `y`, `z`, and the result are of the same type.

### Parentheses

Parentheses can be used for disambiguation and to select a different order of operations. For instance:

    3 + 4 * 5       # int<64>: 23
    (3 + 4) * 5     # int<64>: 35
    3 + (4 * 5)     # int<64>: 23


Resources
---------

Like 1.0, cQASM 2.0 does not define any computational resources implicitly. Therefore, any useful cQASM program should declare one or more resources for it to operate on.

### Declarations

Resources can be declared as follows:

    int<32> scalar
    int<8> memory[4096]
    qubit data[7]

Semantically, scalars and arrays of size 1 are equivalent.

> JvS: note that classical arrays basically represent memory. They can also be used to model register files of course, though an implementation is unlikely to support non-static indexation of registers (`x[y]` vs. `x[0]`).

Classical values can be initialized with an expression, evaluated whenever the declaration is logically processed in the program. The resulting type of the expression must be either exactly the specified type, or it must be promotable. For array initialization, it is also allows to specify a scalar of an appropriate type, which will then be used to initialize all entries.

    int<64> r[3] = {3, 2, 1}    # Declares and sets r to (3,2,1)
    int<64> s[3] = 3            # Declares and sets r to (3,3,3)
    boolean b = true            # Declares and sets b to true
    int<32> x = (int<32>)0      # Declares and sets x to 0, not the required typecast
    int<64> x = 0xFF            # Declares and sets x to 255 (promoted from uint<8>)

You can also use the following alternate syntax in conjunction with an initialization expression:

    let x = <expr>

Here, the type of `x` is implicitly set to the resulting type of the expression.

### Scoping and mappings

Resources can be used from their declaration onwards. That is, you cannot refer to a resource that you have not declared yet.

The map statement can be used to specify an alias for an expression or resource. You can write them like this:

    map data -> q[0]
    map qubit_reg -> q

or, for backward compatibility with 1.0:

    map q[0], data
    map q, qubit_reg

These mappings state that `data` and `qubit_reg[0]` can be used in place of `q[0]`, kind of like pointers. Note that while the examples are purely qubits, this works for any expression; the expression is inserted into the code that uses the mapping, but using the references that were in scope when the mapping was defined. However, when the expression does more than simple indexation (an *lvalue*), you can no longer assign new values to it.

One use case for allowing expressions to be mapped are constants that do not cost any physical resource and are static/can be constant-folded. For instance,

    map sqrthalf -> sqrt(0.5)
    double x = sqrthalf * 2.0

expands to

    double x
    mov 1.4142135623730951 -> x

Compare to using `let` instead of map:

    let sqrthalf -> sqrt(0.5)
    double x = sqrthalf * 2.0

which expands to

    double sqrthalf
    double x
    sqrthalf -> 0.7071067811865476
    mul sqrthalf, 2.0 -> x

because resources are dynamic expressions. Likewise,

    map index -> 2
    x qubit[index]

is legal because index is static, but

    let index = 2
    x qubit[index]  # Error: cannot index qubit arrays dynamically

is not.

It is allowed to reuse resource names and mappings. Declaring a resource with the same name as an existing resource produces a new logical resource, simply hiding the old one.

Example of all of the above:

    let a = 1       # Declares int<64> a with initial value 1
    map b -> a      # Maps b to a
    let a = 1       # Declares int<64> a with initial value 1, hiding the previous a
    set b = 2       # b still refers to the previous a, so
    print a, b      # this prints "1 2"
    let c -> b + 1  # Maps c to b + 1
    # set c = 2     # Illegal, b + 1 is not an lvalue
    print c         # Prints "3", because b (the first a declaration) was set to 2
    set b = 3       # Sets the first declaration of a to 3
    print c         # Prints "4", because b is now 3.

Note that this rather high-level program is abstracted to the following equivalent by libcqasm2:

    int<64> a
    int<64> a_1
    int<64> temp_1
    int<64> temp_2
    mov 1 -> a
    mov 1 -> a_1
    mov 2 -> a
    print a_1, a        # "1 2"
    add a, 2 -> temp_1
    print temp_1
    mov 3 -> a
    add a, 2 -> temp_2
    print temp_2

which is harder to read for a human, but easier for a computer, because:

 - all resources have unique names and can thus be declared at the start of the program,
 - and all expressions have been turned into single-operation instructions.

Of course, the original example isn't that easy to read either; it is intentionally convoluted to show all the features in a concise program.

### Assignments

Once a resource has been declared (through `let` or through a typed declaration), you can write data to it. The easiest way to do this is through an assignment statement:

    set a = expr

where `a` is a (possibly indexed) named resource or a mapping to one, and `expr` is an expression. If the expression can be evaluated statically and does not require casting, libcqasm2 turns this statement into a `mov` (for scalars) or a `st` (for arrays). For example,

    int<64> x
    int<64> y[10]
    set x = 1 + 2
    set y[3 + 4] = (int<64>)sqrt(9.0)

expands to

    int<64> x
    int<64> y[10]
    mov 3 -> x
    st 3 -> y[7]

If the expression or (for indexed assignments) index cannot be statically evaluated, they are synthesized into instructions. For example,

    int<64> x
    int<64> y[10]
    set x = x + 1
    set y[x // 2] = 10

expands to

    int<64> x
    int<64> y[10]
    int<64> temp
    add x, 1 -> x
    idiv x, 2 -> temp
    st 10 -> y[temp]


Flow control and code organization
----------------------------------

Without flow control operations, a program is just a list of instructions, executed sequentially. In cQASM 1.0, the only nonlinear flow control possible was subcircuit repetition and (depending on your definition of flow control) conditional execution using the `c-` gate prefix. cQASM 2.0 extends these two methods with macro expansion and classical flow control. Each of these methods have their own strengths and weaknesses:

 - Subcircuit repetition is the most concise way to specify that a piece of a program needs to execute many times in succession. However, only a single loop level is supported, and the iteration count is static.
 - Macros are a much more powerful way to specify static flow control than subcircuits. Macros include inlined subroutines, for loops, and if/else blocks, each fully supporting recursion. However, they are fully unrolled and inlined by libcqasm2 before they are passed to a program operating on the cQASM code. This can lead to excessive load and compile times when the loops become large.
 - Classical flow control is the most expressive method to describe nonlinear program flow. It is represented using branch statements, labels, and a call stack, just like a classical assembly language. However, classical flow control is hard to read, and code constructs that must be statically evaluated (such as qubit indices) can not be manipulated this way. Code described using classical flow control is also the hardest to parallelize by a scheduler.
 - Conditional execution is not really nonlinear flow control, depending on your definition. It allows you to specify a boolean condition for executing a gate; if the condition is not, the gate is no-op. Conditional execution is very easy to parallelize compared to the other methods.

### Subcircuits

Code can optionally be organized into subcircuits as in 1.0. They are defined like this:

    .subcircuit_one
        x q[0]

Subcircuits can be replicated a static number of times like this:

    .subcircuit_two(3)
        x q[1]

This will apply the X gate to `q[1]` three times. To get a dynamic iteration count, a loop must be described using classical instructions.

Note that it is impossible to recurse subcircuits, because you can only end a subcircuit by specifying a new one. The subcircuit name has no functional significance to the code, but is made available in the AST.

All code before the first subcircuit declaration is considered part of a subcircuit named "default". If the default subcircuit does not contain code, it will not appear in the AST.

### Macro expansion

Macros are a powerful way to write long pieces of repetitive code concisely. They also allow you to organize a cQASM program into multiple files using the `include` statement. There are four types of macro statements, explained below.

#### Macro subroutines

Macro subroutines allow you to define statically parameterizable pieces of code that you can then insert anywhere in your code as if they were a gate. Their syntax is as follows:

    def name(params) {
        ...
    }

where `name` is any identifier used to refer to the macro, `params` is a list of zero or more identifiers that may be used as parameters within the macro, and `...` is a block of statements. The parameter list consists of one or two comma-separated lists of identifiers, in turn separated by `->`. The `->` has no functional significance aside from specifying how the operand list of the gate it defines should look like. For instance:

    def hypot(a, b -> c) {
        map ad -> (double)a
        map bd -> (double)b
        set c = sqrt((ad * ad) + (bd * bd))
    }

    let x = 3
    let y = 4
    double dist
    hypot x, y -> dist  # Call the hypot macro
    print dist          # Prints "5.0"

This code reduces to the following:

    int<64> x
    int<64> y
    double dist
    double temp_1
    double temp_2
    double temp_3
    double temp_4
    double temp_5
    mov 3 -> x
    mov 4 -> y
    conv double, x -> temp_1
    mul temp_1, temp_1 -> temp_2
    conv double, x -> temp_3
    mul temp_3, temp_3 -> temp_4
    add temp_2, temp_4 -> temp_5
    sqrt temp_5 -> dist
    print dist

Parameters work like mappings; they behave as if `map param -> arg` is placed at the start of the block, where `arg` is whatever is placed in the argument list of the call and `param` is the name of the parameter within the subroutine.

#### For loops

For loops allow specification of repetition, similar to subcircuits. However, they can be specified anywhere, and they're expanded before they're passed to the compiler (for better or for worse). The syntax is as follows:

    for x = [indices] {
        ...
    }

`x` is any identifier that will represent the current loop iteration within the block. `indices` works the same as the contents of the indexation operator. For example:

    for x = [1,3,2:5] {
        print x
    }

is expanded to

    print 1
    print 3
    print 2
    print 3
    print 4
    print 5

Note that the loop iteration is considered to be static. It can therefore be used to index qubits as well. For instance,

    qubit q[4]
    for x = [0:2] {
        cnot q[x], q[x+1]
        cnot q[x+1], q[x]
        cnot q[x], q[x+1]
    }

is expanded to

    cnot q[0], q[1]
    cnot q[1], q[0]
    cnot q[0], q[1]
    cnot q[1], q[2]
    cnot q[2], q[1]
    cnot q[1], q[2]
    cnot q[2], q[3]
    cnot q[3], q[2]
    cnot q[2], q[3]

#### If/else

If/else blocks are useful only in combination with subroutines and/or loops. The syntax is:

    if (expr) {
        ...
    }

or

    if (expr) {
        ...
    } else {
        ...
    }

where `expr` is a static boolean expression (usually an inequality). If the expression statically evaluates to true, the first block is inserted; otherwise the second block (if specified) is inserted. For example, the following code computes the n'th Fibonnaci number:

    def fib_rec(a, f, tmp, n) {
        add a, f -> tmp
        mov f -> a
        mov tmp -> f
        if (n > 1) {
            fib_rec(a, f, tmp, n - 1)
        }
    }

    def fib(n -> f) {
        if (n <= 2) {
            sub n, 1 -> f
        } else {
            int<64> a
            int<64> tmp
            mov 0 -> a
            mov 1 -> f
            if (n > 2) {
                fib_rec(a, f, tmp, n + 2)
            }
        }
    }

    int<64> f
    fib 6 -> f
    print f

which expands to:

    int<64> f
    int<64> temp_fib_a_1
    int<64> temp_fib_tmp_1
    mov 0 -> temp_fib_a_1
    mov 1 -> f
    add temp_fib_a_1, f -> temp_fib_tmp_1   # 1
    mov f -> temp_fib_a_1                   # 1
    mov temp_fib_tmp_1 -> f                 # 1
    add temp_fib_a_1, f -> temp_fib_tmp_1   # 2
    mov f -> temp_fib_a_1                   # 1
    mov temp_fib_tmp_1 -> f                 # 2
    add temp_fib_a_1, f -> temp_fib_tmp_1   # 3
    mov f -> temp_fib_a_1                   # 2
    mov temp_fib_tmp_1 -> f                 # 3
    add temp_fib_a_1, f -> temp_fib_tmp_1   # 5
    mov f -> temp_fib_a_1                   # 3
    mov temp_fib_tmp_1 -> f                 # 5
    print f                                 # 5

In a loop it'd be

    int<64> f
    for n = [1:8] {
        fib n -> f
        print f
    }

which should print 0, 1, 1, 2, 3, 5, 8, and 13 in succession. But of course, this results in a lot of code, so you really only want to use macros when you have to.

#### File inclusion

The final macro is similar to `#include` in C:

    include "other-file.cq"

While parsing, the `include` statement AST node is replaced with the AST of `other-file.cq`. Including files in a loop is illegal and returns a parse error.

#### Rules for blocks and included files

The following rules apply for the `{...}` blocks used in macros (not to be confused with bundles) and included files.

 - Code within the block/file can refer to resources and mappings outside of the block, as long as they are not hidden (by parameters or otherwise).
 - For macro subroutines, reference resolution of resources and mappings occurs during the definition, not during its usage (just like mappings).
 - Anything declared within a block goes out of scope at the end of the block. This does not apply to included files.
 - No block or included file can use subcircuit headers. They make no logical sense, because subcircuits can only be terminated by opening another subcircuit.
 - `def` statements cannot nest into blocks.

### Classical flow control

Subcircuit repetition and macros allow only static flow control. That is, the program is *actually* still executed linearly; it just allows you to write it down more concisely. Classical flow control, in contrast, is evaluated at runtime by the classical processor.

#### Conditionals and loops

Structures such as conditional execution and loops are described using classical jump gates and labels. Label syntax is borrowed from classical assembly languages:

    start:

Labels are scoped to the current subcircuit. In other words, it is impossible to jump from one subcircuit to another; they function like separate programs. Two different subcircuits can thus also reuse label names.

> JvS: This is to avoid semantic problems for subcircuits that have repetition specified. What would happen, for instance, if you jump out of a repeated subcircuit? The way I see it, you would normally use either 1.0's subcircuit repetition in a piece of code, OR use loops described classically in 2.0's way (since classical branching is functionally a superset of 1.0's functionality).

Labels can refer both backwards and forwards. There is no need to "forward-declare" a label.

The following branch gates are defined. `x` and `y` can be any scalar numerical literal/resource. (note: this implies that comparing a whole array at once is illegal).

    jmp label        # Unconditional jump to "label"
    jez x, label     # Jump to "label" if x == 0 (eq. x == false)
    jnz x, label     # Jump to "label" if x != 0 (eq. x == true)
    jeq x, y, label  # Jump to "label" if x == y
    jne x, y, label  # Jump to "label" if x != y
    jgt x, y, label  # Jump to "label" if x > y
    jlt x, y, label  # Jump to "label" if x < y
    jge x, y, label  # Jump to "label" if x >= y
    jle x, y, label  # Jump to "label" if x <= y

> JvS: I added `jez`/`jnz` to be used in conjunction with booleans, to support architectures that can only branch based on a previously set boolean register.

The following alternative syntax may also be used to make classical flow easier to comprehend:

    if expr goto label  # Equivalent to "jnz expr, label"

If the topmost expression can is one of those supported directly by one of the jump gates, that gate is used instead of `jnz`. The expression is automatically expanded to additional artithmetic gates and temporary resources when necessary during expression synthesis.

Note that cQASM 2.0 does not support arbitraty expressions here; only expressions that can be statically reduced to one of the above are legal.

Execution of a subcircuit starts at the first gate. You can start elsewhere by simply using a `jmp` gate. If an architecture implementation allows the start address to be different from the start of the program, its assembler can just interpret a `jmp` at the start of a subcircuit as the entry point declaration.

#### Classical subroutines

The `call` and `ret` gates allow you to use subroutines:

    increment_x:
        add x, 1 -> x
        ret                 # Return from procedure.

    a_label:
        call increment_x    # Jump to a_procedure and store the return address.
        call increment_x    # Same as above, but with a different return address.

Subroutines allow code to be reused, not just in the cQASM file, but also in the program memory of the quantum computer.

Note that subroutines are no different from normal labels; they are just used differently. It is therefore legal to mix call/jmp gates, "fall through" to a followup subroutine, etc. Because classical subroutines have no well-defined endpoint (and because dynamic resource allocation would be required) cQASM has no concept of local variables/resource for classical subroutines. They only exist for macros.

> JvS: cQASM is ultimately an assembly language, so much like if/then/else and for loop constructs these abstractions do not exist. Adding them would severily complicate the language.

You can make these manually, however, by declaring all the resources you need as globals. You might want to prefix subroutine-specific globals with the label of the subroutine to avoid confusion. This leaves one problem: recursion. Whenever you recursively call a subroutine, you must ensure that its locals and parameters are "backed up" before you assign new values to them for/in the recursive call. This can be done with the `push` and `pop` gates:

    push x  # Pushes the value x on the stack.
    push y  # Pushes the value y on the stack.
    pop a   # Sets a to y, because that was the last value pushed.
    pop b   # Sets b to x, because that was the last value pushed that we haven't popped yet.

A `call` gate contains an implicit `push` operation; it pushes the return address. `ret` contains an implicit `pop` operation to retrieve the return address and jump to it.

The following rules must be followed for `push` and `pop`:

 - When you push a certain data type, you must always pop the same data type. Not doing so leads to undefined behavior. A simulator should detect this and exit with an error.
 - Every `push` operation must have a respective `pop` operation. That is, when the program terminates, the number of calls to `push` must equal the number of calls to `pop`.
 - Popping when the stack is empty is illegal and leads to undefined behavior. A simulator should detect this and exit with an error.
 - Only classical values can be pushed.

Note that because `call` and `ret` share the same stack as `push` and `pop`, you must ensure that each subroutine has popped everything it has pushed before calling `ret`, otherwise the return address will not be at the top of the stack.

> JvS: they share the same stack in the execution model, because if a program works with a shared stack it also works with separate stacks. Thus, semantically sharing a stack supports more targets than having different stacks.

> JvS: during register allocation, the compiler may need the stack for spilling. This may conflict with the way push/pop operations are specified in the source. Therefore, push/pop operations may need to be reduced to a "user stack" separate from the call/spill stack before register allocation. I don't see a better way of doing this for a language that supports specifying recursion without a notion of local variables that still requires a register-allocation pass, but I'm open to suggestions.

There is an alternative syntax for `push` that makes the pushed data type explicit:

    push fixed<16,16>, 1.0

Without this notation, it would be impossible to push literals onto the stack, since the bit-width of a literal is undefined.

### Conditional execution and controlled gates

The final method for working with program flow is conditional execution, i.e., only executing a gate when a certain condition applies. Conditional execution can be specified for all gates by prefixing `c-` to the gate name, and prefixing the operand list with a boolean expression serving as the condition. Examples:

    c-x     bool, qubit         # Perform X gate if bool is true
    c-swap  bool, qubit, qubit  # Swap the two qubits if bool is true
    c-mov   bool, a -> b        # Move a to b only when bool is true
    c-jmp   bool, label         # Functionally synonymous to jnz

This notation not only allows for a more concise notation than the equivalent using jumps and labels, but it may also execute more efficiently in some cases, especially in the context of a VLIW architecture.

For quantum gates, the condition can also be another qubit. This turns the gate into a controlled gate. However, since a qubit can also be used as a boolean representing its latest measurement, this requires disambiguation using the subscript notation:

    c-z     ctrl_qubit, qubit   # Conditionally-executed Z based on
                                #   ctrl_qubit's latest measurement
    c-z     ctrl_qubit.b, qubit # Same as above, but more explicit
    c-z     ctrl_qubit.q, qubit # Controlled phase

Nesting `c-` is allowed, for instance:

    c-c-x   a, b, qubit         # Perform X gate if a and b are true

You can of course also do

    c-x a && b, qubit

but this expands to

    boolean temp
    land a, b -> temp
    c-x temp

during expression synthesis. You can also mix qubit control and boolean conditions.

Note: on rare occasions, code like `c-a` may appear in an expression, when you're trying to subtract `a` (or any other named value) from `c`. This will lead to an "unexpected CDASH" error from the parser, because `c-<identifier>` is a keyword. To avoid this error, place a space before and/or after the operator. The `c-` syntax is defined such for compatibility with 1.0.


Timing
------

Timing is very important for quantum computers due to decoherence. Therefore, cQASM aims to specify fully deterministic timing for quantum gates. However, at the same time, classical processors are prone to stalling, for instance due to cache misses. The way in which these two properties are dealt with is described in this section.

### Execution model

A cQASM program models the execution of two processors running asynchronous to each other: the classical processor and the quantum processor. They interact with each other through queues.

The classical processor is the one that truly runs the cQASM program. Essentially, it uses classical instructions and flow control to generate a quantum circuit, which it then feeds to the quantum computer in real time through a queue. Thus, to the classical processor, a gate operating on qubits is nothing more than a queue operation.

The quantum processor takes the gates that the classical processor pushed into the queue and issues them in parallel until the queue runs dry or it encounters the special `qwait n` gate, where `n` is a positive integer: `qwait 1` instructs the quantum computer to continue executing gates in the next cycle, `qwait 2` waits an additional cycle, and so on.

The classical processor has an equivalent wait instruction, `wait n`. This gate is equivalent to `n` "nop" instructions.

The distinction between classical and quantum flow is necessary because the classical processor may stall, for instance to wait for memory to be loaded into a register. A quantum computer, in turn, should never stall while a circuit is being executed, to prevent unexpected decoherence. By conceptually separating these two flows of time, quantum computer stalls can be avoided, as long as the classical computer "buffers" enough quantum gates before starting the quantum computer, and can keep up with it on average.

While the quantum processor is implicitly parallel (waiting for `qwait` instructions to stop issuing more gates and go to the next cycle), the classical processor behaves sequentially unless otherwise specified using bundles or SIMD/SGMQ notation (explained in the following sections).

The only communication from the quantum processor back to the classical processor is done through the measurement registers associated with the qubits. These are write-only for the quantum processor, and read-only for the classical processor. Since the classical processor normally runs ahead of the quantum processor, race conditions could potentially occur in the following code:

    qwait 10    # Stop the quantum processor for 10 cycles
    x q         # Flip q
    qwait 1     # Delay 1 quantum cycle, otherwise x and measure
                #   are attempted in the same cycle
    measure q   # Measure q
    qwait 1     # Some more gates, not depending on
    x q2        #   the measurement
    print q.b   # Print the measured value

Without any kind of synchronization, the `print` gate could run as soon as cycle 4, while the `measure` gate would run in cycle 12. But the classical processor may stall, for instance to resolve an instruction cache miss, so the `print` gate could also run in cycle 500. The way in which this race condition is resolved is up the implementation, but the `print` gate *must* be executed after the measurement.

One way an implementation might resolve this is to make the `measure` gate stall the classical processor until it is completed by the quantum processor. But this prevents the classical processor from queueing up `x q2` until the measurement completes. A better way is to stall only when the measurement register is actually read; in this case, `measure` would take only one classical cycle, and the `print` gate would stall instead. Further extensions involve allowing the quantum processor to resolve conditional execution of quantum gates, and recording the number of classical `not` gates applied to the measurement result to apply them as an exclusive-or to the measurement only when it becomes available.

### Bundles

There are two equivalent ways to bundle instructions together, i.e. to mark them for parallel execution:

    x q[1] | add i, 1 -> i

and

    {
        x q[1]
        add i, 1 -> i
    }

The only difference is that the first is single-line, while the second is multiline. The two methods can also be combined, for instance,

    {
        x q[1] | z q[2]
        add i, 1 -> i
    }

or

    { x q[1] | z q[2] | add i, 1 -> i }

> JvS: the latter is the 1.0 syntax; 1.0 did not allow line breaks even within curly brackets.

### SIMD/SGMQ

In addition to the bundle notation described above, there is also a syntax to describe single-gate-multiple-qubit (SGMQ) and single-instruction-multiple-data (SIMD) operations. This works by allowing applying gates to arrays:

    x   q[0]                # Operate on qubit 0 only
    x   q[1:3]              # Operate on qubit 1, 2, and 3
    x   q[4,6,9]            # Operate on qubit 4, 6, and 9
    x   q[10:12,14,16:18]   # Operate on qubit 10, 11, 12, 14, 16, 17, and 18
    x   q                   # Operate on all qubits in q

> JvS: aside from the last line (which was not a thing) this is consistent with cQASM 1.0. I could not find the combination of ranges and set entries to be specified anywhere, but the grammar already allowed it.

Multi-operand gates and expressions can also make use of this indexation method. When multiple operands are involved, each operand resolving to an array must have the same number of elements. Scalars are automatically up-scaled to an array of the right size. For instance,

    add x[0:7], 1 -> x[0:7] # Perform 8 increments in parallel
    mov x[0,1] -> x[1,0]    # Semantically this is a classical swap
    cnot q[0], q[1:8]       # Apply CNOT to q[1] through q[8] using q[0] as control

SIMD/SGMQ notation is essentially a macro for a number of similar scalar operations inside a bundle. For instance, the last line in the previous example is equivalent to

    {
        cnot q[0], q[1]
        cnot q[0], q[2]
        cnot q[0], q[3]
        cnot q[0], q[4]
        cnot q[0], q[5]
        cnot q[0], q[6]
        cnot q[0], q[7]
        cnot q[0], q[8]
    }

libcqasm2 abstracts SIMD/SQMG syntax away during the macro expansion process.

### Bundle restrictions

The following restrictions and semantics apply to bundles:

 - Barring undefined behavior in the cases described below, implementations may not depend on the order in which parallel gates are specified.
 - Implementations can choose to execute bundles completely or partially sequentially, if they do not support enough parallelism to do everything at once. This shall not affect the semantics of the bundle; only its timing is affected.
 - It is illegal to write to the same classical value more than once within a bundle. The resultant will be undefined, and simulators may exit with an error for this.
 - Using a qubit more than once within a bundle is undefined behavior, and simulators may exit with an error for this. The same thing applies to the quantum processor of course; when `qwait`s are used, it is possible to queue up multiple gates for parallel execution on the quantum computer without them seeming parallel in the cQASM code. This does not make it any more legal (or physically possible).
 - At most one flow control operation (`jmp`-like, `call`, `ret`) may be performed within a bundle, because they are essentially writes to the program counter. Execution is undefined otherwise, and simulators may exit with an error for this.
 - Flow control gates appear to be executed after all other gates complete.
 - At most one stack operation (`push`, `pop`, `call`, `ret`) may be performed within a bundle, because they are essentially writes to the stack pointer. Execution is undefined otherwise, and simulators may exit with an error for this.
 - `wait` gates cannot be combined in a bundle with any other gate.
 - At most one `qwait` gate may be performed within a bundle.
 - Any `qwait` gate shall be passed to the the quantum processor after all other gates in the bundle.
 - When an operand is used as both a source and a destination within a bundle, the operations using it as a source will always see the previous value. Thus, `mov a -> b | mov b -> a` is a valid swap of scalars `a` and `b`. However, unless you are writing cQASM with a specific quantum computer implementation in mind, it is best to avoid such constructs, because they can not be easily serialized.


Gates
-----

As described earlier, the term *gate* is used for any quantum or classical operation. This section describes the available gates.

### Single-qubit gates

This section lists the single-qubit gates.

#### X-rotations

The following gate describes an arbitrary rotation around the X-axis of the Bloch sphere:

    rx      qubit, theta

where `qubit` is any qubit resource, and `theta` expects a `double` expression (can be dynamic) representing the angle in radians. This operation is represented by the following matrix:

![matrix](https://github.com/QE-Lab/cQASM-spec/blob/master/gates/rx.png)

Some special cases of this gate have synonyms:

    mx90    qubit       # theta = -1/2 pi
    i       qubit       # theta = 0 pi
    x90     qubit       # theta = 1/2 pi
    x       qubit       # theta = pi

#### Y-rotations

The following gate describes an arbitrary rotation around the Y-axis of the Bloch sphere:

    ry      qubit, theta

where `qubit` is any qubit resource, and `theta` expects a `double` expression (can be dynamic) representing the angle in radians. This operation is represented by the following matrix:

![matrix](https://github.com/QE-Lab/cQASM-spec/blob/master/gates/ry.png)

Some special cases of this gate have synonyms:

    my90    qubit       # theta = -1/2 pi
    i       qubit       # theta = 0 pi
    y90     qubit       # theta = 1/2 pi
    y       qubit       # theta = pi

#### Z-rotations

The following gate describes an arbitrary rotation around the Z-axis of the Bloch sphere:

    rz      qubit, theta

where `qubit` is any qubit resource, and `theta` expects a `double` expression (can be dynamic) representing the angle in radians. This operation is represented by the following matrix:

![matrix](https://github.com/QE-Lab/cQASM-spec/blob/master/gates/ry.png)

Some special cases of this gate have synonyms:

    sdag    qubit       # theta = -1/2 pi
    tdag    qubit       # theta = -1/4 pi
    i       qubit       # theta = 0 pi
    t       qubit       # theta = 1/4 pi
    s       qubit       # theta = 1/2 pi
    z       qubit       # theta = pi
    rzk     qubit, k    # theta = pi / 2^k

#### Multiple rotations

It is also possible to perform multiple rotations at once, thereby describing any single-qubit gate, with the following syntax:

    r       qubit, theta, phi, lambda

where `qubit` is any qubit resource, and `theta`, `phi`, and `lambda` expect `double` expressions (can be dynamic) representing the angles in radians. This operation is represented by the following matrix:

![matrix](https://github.com/QE-Lab/cQASM-spec/blob/master/gates/r.png)

The Hadamard gate is a special case of this:

    h       qubit   # theta = 1/2 pi, phy = 0, lambda = pi

Which reduces to:

![matrix](https://github.com/QE-Lab/cQASM-spec/blob/master/gates/h.png)

### Multi-qubit gates

This section lists the multi-qubit gates.

#### Swap gates

The following gate can be used to swap two qubits:

    swap    qa, qb

where `qa` and `qb` are two different qubits. This is represented by the following matrix:

![matrix](https://github.com/QE-Lab/cQASM-spec/blob/master/gates/swap.png)

cQASM 2.0 further introduces the sqswap gate:

    sqswap  qa, qb

which is represented by the following matrix:

![matrix](https://github.com/QE-Lab/cQASM-spec/blob/master/gates/sqswap.png)

#### Custom unitary gates

In addition to the gates specified above, it is also possible to specify a custom gate:

    u q1, q2, ..., qn, matrix

The matrix literal is used in this syntax to specify a complex `2**n` by `2**n` matrix.

The matrix entries must be static expressions; that is, they must be reducible to a constant number before the code is executed.

The Gram–Schmidt procedure is performed during semantic analysis to ensure that the specified matrix is unitary to within the accuracy of double floating-point arithmetic. If the matrix was not initially found to be unitary, the semantic analyzer has the following behavior:

 - division by zero during normalization results in a parse error;
 - normalization is otherwise performed silently (so you explicitly do NOT need to scale the matrix yourself);
 - and orthogonalization affecting the matrix significantly results in a warning message including the evaluated unitary matrix.

Note that macro subroutines can be used to define reusable custom gates. For instance, to implement the Ising gate:

    def xx(qa, qb, phi) {
        u qa, qb, [|
                    1,          0,         0,  -im*exp(im*phi)

                    0,          1,        -im,        0

                    0,         -im,        1,         0

            -im*exp(-im*phi),   0,         0,         1
        |]
    }

    xx qa, qb, phi

Note that this matrix is implicitly normalized through scaling by `1 / sqrt(2)`.

#### Controlled gates

As stated in the section about conditional execution, all qubit gates can be controlled by using the `c-` notation. Some examples:

    c-x     qc,  qt         # Controlled-X a.k.a. CNOT
    c-c-x   qc1, qc2, qt    # Toffoli gate
    c-rzk   qc,  qt,  k     # Controlled phase as used in QFT

For compatibility with cQASM 1.0 and to improve readability of some commonly used controlled gates, the following synonyms are defined:

    cnot    qc,  qt         # = c-x     qc,  qt
    ccnot   qc1, qc2, qt    # = c-c-x   qc1, qc2, qt
    toffoli qc1, qc2, qt    # = c-c-x   qc1, qc2, qt
    cz      qc,  qt         # = c-z     qc,  qt
    cr      qc,  qt,  theta # = c-rz    qc,  qt,  theta
    crk     qc,  qt,  k     # = c-rzk   qc,  qt,  k

### Measurement

The following single-qubit measurement instructions are available:

    prep_x      qubit   # State preparation in X basis
    prep_y      qubit   # State preparation in Y basis
    prep_z      qubit   # State preparation in Z basis
    prep        qubit   # NEW IN 2.0: state preparation in Z basis (same as above)
    measure_x   qubit   # Measure qubit in X basis
    measure_y   qubit   # Measure qubit in Y basis
    measure_z   qubit   # Measure qubit in Z basis
    measure     qubit   # Measure qubit in Z basis (same as above)

> JvS/AS: added `prep` (new in 2.0) for symmetry with `measure`.

The result of the measurements is stored in the classical bit register associated with the qubit.

SIMD/SGMQ syntax can be used to easily measure multiple or all qubits in a qubit array at once:

    measure     q[0:3]  # Measure the first four qubits
    measure     q       # Measure all qubits in q

There is also an operation to measure all qubit resources in the Z-basis at once:

    measure_all         # Measure all qubits in all registers

This instruction includes measurement of any qubit resources that may have been hidden.

> JvS: measure_all is there for compatibility with 1.0.

> JvS: does it make sense to add `prep_all` equivalents for the `measure_all` instructions? I'm not sure what state preparation means exactly.

It is also possible to measure parity of a number of qubits in specified bases:

    measure_parity  qubit_a, axis_a, qubit_b, axis_b, ...

The axes should be `x`, `y`, or `z`. Any number of qubits can be involved in the parity measurement. The result is stored in the measurement register of each involved qubit.

### Classical gates

The following classical gates are defined. They behave the same way as their expression operator counterparts. Note that dynamic expressions may be used in these, just like the assignment notation; they will then be similarly expanded during expression synthesis. The purpose of having these gates is to allow you (or a compiler) to schedule them in parallel and/or be more efficient in terms of temporary resource usage.

The only expression operators that are NOT expanded and may be used in any of these are the `(<<x)y` and `(>>x)y` casts, which serve only as reinterpretation of a fixed-point number.

#### Basic arithmetic

The following arithmetic instructions are defined.

    mov     a -> b          # Set b to a, possibly with a typecast
    ld      a[i] -> b       # Set b to a[i]
    st      a -> b[i]       # Set b[i] to a
    inc     a -> b          # Increment by 1
    dec     a -> b          # Decrement by 1
    neg     a -> b          # Negate/two's complement
    add     a, b -> c       # Add a to b, write to c
    sub     a, b -> c       # Subtract b from a, write to c
    mul     a, b -> c       # Multiply a with b, write to c
    rcp     a -> b          # Real number division of 1 by a, write to b
    div     a, b -> c       # Real number division of a by b, write to c
    idiv    a, b -> c       # Floored division of a by b, write to c
    mod     a, b -> c       # Integer remainder of a "tdiv" b, write to c
    sq      a -> b          # Square a, write to b
    sqrt    a -> b          # Square-root a, write to b
    pow     a, b -> c       # Write a^b to c
    log     a, b -> c       # Write log_a(b) to c
    exp     a -> b          # Write e^a to b
    ln      a -> b          # Write ln(a) to b
    floor   a -> b          # Round a down to nearest integer, write to b
    ceil    a -> b          # Round a up to nearest integer, write to b
    round   a -> b          # Round a to nearest integer (tie to even), write to b
    rand    a               # Set a to a uniformly distributed number in [0, 1)

The instructions operating on only a single value can also be written with a single operand, without the arrow, for in-place modification:

    inc     a               # Increment in place
    dec     a               # Decrement in place
    neg     a               # Negate/two's complement in place
    rcp     a               # Reciprocal in place
    sq      a               # Square in place
    sqrt    a               # Square-root in place
    exp     a               # Natural exponentiation in place
    ln      a               # Natural logarithm in place
    floor   a               # Round down to nearest integer in place
    ceil    a               # Round up to nearest integer in place
    round   a               # Round to nearest integer (tie to even) in place

This is just a shorthand for the explicic destination.

> JvS: this is for consistency with the `not` operation defined in 1.0.

#### Trigonometry

The following trigonometric functions are defined. Radians are used as angular unit.

    sin     a -> b          # Write sin(a) to b
    cos     a -> b          # Write cos(a) to b
    tan     a -> b          # Write tan(a) to b
    asin    a -> b          # Write arcsin(a) to b
    acos    a -> b          # Write arccos(a) to b
    atan    a -> b          # Write arctan(a) to b

Their shorthand in-place notations (without the arrows) are of course also legal.

    sin     a               # sin(a) in place
    cos     a               # cos(a) in place
    tan     a               # tan(a) in place
    asin    a               # arcsin(a) in place
    acos    a               # arccos(a) in place
    atan    a               # arctan(a) in place

#### Relational

The relational operators share their names with the jump instructions, except they are prefixed with `c` (compare) instead of `j` (jump).

    ceq     a, b -> c       # Write a == b to c
    cne     a, b -> c       # Write a != b to c
    cgt     a, b -> c       # Write a > b to c
    clt     a, b -> c       # Write a < b to c
    cge     a, b -> c       # Write a >= b to c
    cle     a, b -> c       # Write a <= b to c

#### Selection

The following selection-based operators are available:

    slct    a, b, c -> d    # As in C: d = a ? b : c
    min     a, b -> c       # Write the minimum of a and b to c
    max     a, b -> c       # Write the maximum of a and b to c
    abs     a -> b          # Write the absolute value of a to b
    abs     a               # Absolute value in place

#### Bitwise and logical

The following bitwise instructions are available. They cannot be applied to floats; this will raise an error. Negative shift amounts are undefined behavior.

    shl     a, b -> c       # Shift a left by b bits, write to c
    shr     a, b -> c       # Shift a right by b bits logically, write to c
    ashr    a, b -> c       # Shift a right by b bits arithmetically, write to c
    rol     a, b -> c       # Rotate a left by b bits, write to c
    ror     a, b -> c       # Rotate a right by b bits, write to c
    sbit    a, b -> c       # Set bit, as in C: c = a | (1 << b)
    cbit    a, b -> c       # Clear bit, as in C: c = a & ~(1 << b)
    tbit    a, b -> c       # Toggle bit, as in C: c = a ^ (1 << b)
    inv     a -> b          # Write one's complement of a to b
    inv     a               # One's complement in place
    and     a, b -> c       # Bitwise and as in C: c = a & b
    or      a, b -> c       # Bitwise or as in C: c = a | b
    xor     a, b -> c       # Bitwise xor as in C: c = a ^ b
    not     a -> b          # Logical inversion as in C: b = !a
    not     a               # Logical inversion in place as in C: a = !a (as in 1.0!)
    land    a, b -> c       # C-like: c = a && b
    lor     a, b -> c       # C-like: c = a || b
    lxor    a, b -> c       # C-like: c = !!(a ^ b)

### Debugging

The following statements are useful for debugging:

    stop                    # Terminates the program successfully
    error ...               # Terminates the program unsuccessfully
    print ...               # Write information to the debug console

The ellipses in `error` and `print` can be any argument list, including arrays, string literals, and (for simulators) qubits. The contents will be printed to `stdout` separated by spaces, followed by a newline. That is, they work like Python 2's print statement.


Extensibility
-------------

### Pragmas and annotations

Pragmas and annotations are a way to specify things that have no business being in a common language specification, metadata such as line number information, or things that were not accounted for during creation of this specification (pending their addition to a later version of the spec).

Pragmas behave like statements. They are specified as follows:

    pragma target name {|...|}

where `target` and `name` are identifiers used to specify what the pragma is all about, and `{|...|}` is an optional JSON literal. The `target` identifier is used by targets to detect whether the annotation is meant for them; they can silently ignore any pragmas intended for different targets this way. Conversely, a target is allowed to throw an error if a pragma meant for it has an invalid name or is used incorrectly. If there is no specific target, `com` (abbreviation for common) may be used.

Annotations instead add arbitrary data to existing constructs. Their syntax is as follows:

    ... @target name {...}

They can be applied to any cQASM statement (including pragmas and bundles) and to individual gates. When there is ambiguity between gate and bundle annotations, the gates are preferred. For example:

    x q1 @example annotates_x_gate
    { x q1 } @example annotates_bundle
    x q1 @example annotates_x_gate | y q1 @example annotates_y_gate
    {
        x q1 @example annotates_x_gate
        y q1 @example annotates_y_gate
    } @example annotates_bundle

The remainder of this section lists some pragma/annotation ideas.

#### QX directives

The following pragmas replace what was dedicated syntax in 1.0:

    pragma qx display
    pragma qx display_binary
    pragma qx reset_averaging
    pragma qx error_model {"name": "depolarizing_channel", args: [...]}

#### Tracing line numbers

The following annotation specifies information about the original source of a statement across compilation steps:

    @com src {"line_nr": int, "file": "filename", ...}

Compilation steps may include additional information to the JSON object if they want.

#### Mutually exclusive resources

The following pragma marks two scalar resources as being mutually exclusive:

    pragma com exclusive {"a": "scalar_x", "b": "scalar_y"}

For a simulator tracking uninitialized values, this pragma means that writing to `scalar_x` should invalidate `scalar_y` and vice versa. This will basically never be useful for handwritten cQASM, but is very useful in the following cases:

 - Recording the results of liveness analysis amidst compilation steps.
 - Specifying that two values (usually of different types) occupy the same physical storage location in an implementation. For instance, a processor may have a 32x32bit register file that can also be viewed as a 16x64bit register file, as shown below. By having this specification, architectures with these characteristics can be accurately simulated before a microarchitecture-specific simulator is complete.

```
int<64> reg64[16]
int<32> reg32[32]
pragma com exclusive {"a": "reg32[0]", "b": "reg64[0]"}
pragma com exclusive {"a": "reg32[1]", "b": "reg64[0]"}
pragma com exclusive {"a": "reg32[2]", "b": "reg64[1]"}
pragma com exclusive {"a": "reg32[3]", "b": "reg64[1]"}
...
```

### Gate definition file

The list of available quantum gates and the list of classical gates may be extended through a JSON file. The format is to be determined. It will be similar to the JSON file currently used to configure OpenQL, but some changes may be required due to all the new features in 2.0.


Operating on cQASM code
-----------------------

TODO: this section will contain info about libcqasm2's API. This is still very much a work in progress. I'm trying to figure it out as much as possible while defining the spec though, to avoid finding out that something is (virtually) impossible after freezing the spec.

libcqasm will need the following passes:

 - Lexing (flex).
 - Parsing (yacc).
 - Name resolution: resolve and uniquify labels and resources, resolve mappings by replacing references to a mapping with the mapped expression, and remove `map` statements from the AST. Subroutine macro parameters and macro for loop index variables are also replaced with appropriate nodes, to be replaced further by macro expansion.
 - Replacement of `include` statements with the AST of the included file. This includes all steps up to and including this step for the included files, and also includes checking that the included file does not contain subcircuit statements.
 - `def` statement gathering (macros can refer backward to allow them to call each other recursively) and removal of them from the AST.
 - Optional: macro expansion.
 - Optional: expression synthesis.

Macro expansion substeps:

 - Replace `let` calls with appropriately typed resources.
 - Expand SIMD/SGMQ gates to bundles of scalar gates.
 - When encountering an expression, constant-fold it as far as possible.
 - When encountering a macro subroutine call: 1) make a copy of the AST representing the contents of the macro; 2) replace the (thus far unresolved) parameter references with copies of the expression AST nodes from the call; 3) recursively apply macro expansion to the new AST; 4) replace the macro subroutine call with the generated AST.
 - When encountering a macro if/else: 1) statically evaluate the condition; 2) reduce to either the if or else block; 3) recursively apply macro expansion to the selected block; 4) replace the macro with the new block.
 - When encountering a macro for: 1) statically evaluate the loop index list; 2) make a copy of the loop body for each iteration; 3) replace the (thus far unresolved) loop index reference with the expression indicating the current index; 4) apply macro expansion to each of the new ASTs; 5) replace the `for` statement with the list of generated ASTs.

Expression synthesis substeps:

 - Reduce assignment statements to the equivalent list of classical gates and (uniquified) temporary resources.
 - Reduce `if x goto y` gates to the equivalent list of classical gates and (uniquified) temporary resources.
 - Reduce all nontrivial expressions used in gates to the equivalent list of classical gates and (uniquified) temporary resources.
 - The expression reductions above implicitly type-check the expressions as part of the reduction. Whenever promotion is required, a `mov` is synthesized for the type conversion.
