# Beware anyone who stumbles into this by chance

This is very much a work in progress, and currently is more of an example
than an actual specification! The real docs for cQASM are
[here](https://libqasm.readthedocs.io/en/latest/).

cQASM 2.0 goals
===============

 - Add the usual classical constructs (if-else, loops, etc.) in both runtime
   and generative forms, to make programming in cQASM more ergonomic (and, in
   time, hopefully allow the OpenQL Python API for constructing kernels to be
   deprecated), and to support runtime classical constructs in Quantum
   Inspire.

 - Return to the state where a (set of) cQASM files can be simulated without
   context, without losing generality. Essentially, allow gate/instruction
   sets to be defined from within cQASM (include) files by leveraging the new
   classical constructs. Then actually update the frontend of QX (and DQCsim)
   accordingly.

 - The newly added constructs should be as general as can reasonably be
   implemented *IN LIBQASM*. It is absolutely a non-goal to immediately
   implement all the new language constructs anywhere other than libqasm and
   maybe a simulator. Keep in mind that a programming language is an interface
   between components, and changing interfaces should be avoided as much as
   possible. Therefore, when you have to change it, change as much as possible.

 - Nevertheless, the new features are to be chosen such that they do not
   fundamentally emburden other parts of the toolchain, notably compilation.

 - Take the chance to re-engineer the syntax of the language to get rid of
   strange and annoying exceptions in the grammar and lexical rules, at the
   cost of having to rewrite the language documentation and some of the
   frontend components of Quantum Inspire (notably the syntax highlighting
   rules and the circuit visualization, though the latter wouldn't work in
   the presence of classical flow anyway). Some examples of this are:
    - `reset-averaging` being a valid identifier, while all other identifiers
      can only contain letters, digits, and underscores;
    - all the weirdness surrounding disambiguation of `|` used as bundle
      separator versus used as bitwise OR operator;
    - the weird `c-` token;
    - ambiguity of `a [x]` at the start of a line as gate `a` being invoked
      with matrix `[x]` and variable `a` being indexed with `x`;
    - get rid of whitespace-sensitivity (well, only newlines at this point)
      and case-insensitivity;
    - and so on.
   This should make actually implementing the cQASM 2.0 parser a lot easier.
   However, it shouldn't come at a significant expense in the readability
   department.

 - Backward-compatibility, in the sense that the cQASM-2.0-capable version of
   libqasm should continue to read cQASM 1.1 and earlier files correctly. This
   can easily be based on the version statement.

 - Add a (pretty-)printer to go back from libqasm's internal representation to
   a corresponding cQASM file. In conjunction with the above, it should be
   possible to read a cQASM 1.0 or 1.1 file and convert it to an equivalent
   cQASM 2.0 file.

 - Finally make a Python interface for libqasm again.

Revised structure of libqasm
============================

The data flow for libqasm shall be engineered as follows. The blocks that are
annotated with a check mark already exist, other solidly-bordered blocks are
mandatory for 2.0 support, and dashed blocks are nice to have.

```
                          cQASM file                                cQASM user
========================)------------(=========================================
                               |                                       libqasm
                               v
                       .--------------.
                       | File version |
                 .-----|  detection   |------.
                 |     '--------------'      |
                 v                           v
          .-------------.             .-------------.
          |  1.x lexer  |             |  2.x lexer  |
          |-------------|             |-------------|
          | 1.x parser  |             | 2.x parser  |
          '------------[✓]            '-------------'
                 |                           |
              1.0 AST                     2.0 AST
                 |                           |
                 |`..........                |`.
                .^.          '.              |  `.
        .------'   `------.   :              |   :
        |                 |   :              |   :
        v                 v   '              v   '         .
.--------------.   .--------------.   .--------------.     | recursive
| 1.0 semantic |   | 1.1 semantic |   | 2.0 semantic |<----| invocation
|   analyzer   |   |   analyzer   |   |   analyzer   |---->| for include
'-------------[✓]  '-------------[✓]  '--------------'     | statements
        |                 |   .              |   .         '
        '------.   ,------'   :              |   :
                `.'           :              |   :
                 |            :              |
           1.0 semantic       :        2.0 semantic
                 |            '              |
                 |      .------------.       |   :
                 |`.    |   convert  |       |   :
                 |  `-->| 1.x to 2.x |----.  |   :
                 |      '------------'     `.|   :
                 |                           |   :
                 |       - - - - - - .       |   :
                 |      '  backport  .     .'|   :
                 |  ,---' 2.x to 1.x .<---'  |   :
                 |,'    ' - - - - - -        |   :
                 |            .              |`. '   - - - - - - - - .
                .^.           :              |  `-->' Pretty-printer .
        .------'   `------.   :              |   .  ' - - - - - - - -
        |                 |   :              |   :          :
        v                 |   :              |   :          :
 .-------------.          |   :              |   :    cQASM 2.0 file
 | Backport to |          |   :              |   :          :
 |   old API   |          |   :              |   :          :
 '------------[✓]         |   :              |   :    ,.....'
        |                 |   :              |   :   :
        v                 v   v              v   v   v                 libqasm
===)---------(=========)---------(=========)-----------(=======================
     Old API             1.0 API              2.0 API             libqasm user
   (Py and C++)         (C++ only)     (Should be Py and C++)
```

Existing APIs will remain intact. The API version that libqasm is called with
determines which features are supported. Cosmetic features added in newer
cQASM language versions may be seamlessly backported to the internal
representations of the older APIs, but newly added semantic features will raise
an error during the backport process. When the 2.0 API is used on a 1.x file,
the 1.x analysis pipeline will be called, after which the resulting semantic
tree will be seamlessly converted to the 2.0 internal representation. The APIs
can also query the abstract syntax tree, but conversion from 1.1 to 2.0 will
not be supported at this level.

A lot of the code and infrastructure from 1.x should be reusable for 2.x,
despite the duplication of the pipeline. However, duplicating it allows the
parser and internal representation to be updated for the 2.0 constructs
properly, without needing to resort to hacks to keep the IR and antiquated
grammatical constructs backward compatible.

New constructs required for classical flow
==========================================

In order to do classical computation, the following primitives need to
minimally be available on top of cQASM 1.1:

 - assignment statements;
 - a conditional construct; and
 - a looping construct.

Assignment statements
---------------------

The assignment statement, while a relatively simple addition, is problematic
in the current grammar. Specifically, the left-hand side of an indexed
assignment statement (for example, `b[0] = ...`) cannot be distinguished from
a gate with a matrix literal (for example, `U [1, 0, 0, 0, 0, 0, 1, 0]`)
sufficiently quickly for an LR(1) parser such as Bison. Either a keyword is
needed in front of the assignment, or different syntax is needed for array
literals. The resolution for this is TBD.

Control-flow statements
-----------------------

In terms of control flow, two options are available: either support high-level
constructs such as loops, or support low-level labels and branch statements.
The latter certainly seems simpler to implement in libqasm, but it has many
downsides:

 - Due to its generality, it is relatively difficult to optimize. Say for
   instance that some microarchitecture has hardware loop support for loops
   with a fixed iteration count; it would be very difficult to reliably
   reliably detect such a pattern to make use of this construct. Loop
   unrolling requires similar detection.

 - Branch statements are inherently runtime structures, and thus cannot be
   used for procedural code generation.

 - It's unintuitive to write. We haven't been manually programming assembly
   for decades for good reason.

 - It's even more unituitive to read as a human.

The alternative also has downsides, primarily that the lack of explicit branch
instructions makes it more difficult or impossible to write the output of a
*classical* compiler for a branch-based architecture in cQASM format. However,
even with explicit branches, designing for this makes writing a generic
simulator for cQASM files virtually impossible, as it would have to support all
classical constructs of all microarchitectures that are within scope, and the
whole idea behind a "common" QASM is that this scope is large. Therefore, we
will assume that cQASM is only used as the input and output of a quantum
compiler, before any lowering to classical assembly occurs. Thus, we need
high-level constructs.

The following constructs are proposed. Exact syntax is TBD.

 - `if (<cond>) <block>`: simple "if" statement. The block is executed only
   when the condition evaluates to true.

 - `if (<cond>) <block> else <block>`: as aforementioned, but also has a block
   for when the condition is false. The `else` block can be another "if"
   statement, to allow an if-else tree to be constructed without the need for
   a special "elsif" construct. It may also be possible to use this construct
   in a functional context, by replacing the blocks with expressions.

 - `match (<value>) ( case <val1>: <block1> [...] [else: <block>] )`:
   Rust-style match stastement. Like `switch`, but with the added requirement
   that at most one code block is executed. It may also be possible to use this
   construct in a functional context by replacing the blocks with expressions,
   or for generating conditional gates with multiple possibilities in a single
   cycle (if supported by hardware).

 - `for (<block>, <cond>, <block>) <block>`: C-style for loop, with explicit
   startup block and increment block. `break` and `continue` can be used to
   respectively break out of the loop or immediately continue with the next
   iteration.

 - `while (<cond>) <block>`: C-style while loop. This is the same as the for
   loop above with empty startup and increment blocks, and can thus just be
   syntactic sugar for that.
 
 - `repeat <block> until (<cond>)`: like a for loop, but with the condition
   at the end. The block is always executed once, and will continue to be
   executed until the condition evaluates to true (note that this is the
   complement to C's do-while, without loss of generality), or as long as
   `continue` is called in the block.

 - `foreach ([<name> :] <tuple>) <block>` foreach loop. With the addition of a
   range operator (likely this will be `..`, for example `2..5` resulting in
   an integer tuple containing 2, 3, 4, and 5) this also allows loops with
   fixed iteration counts to be written down easily. Especially in the absence
   of `break`/`continue` statements, such loops can easily be unrolled for when
   the target does not actually support runtime loops, or be converted to
   hardware loop logic for supporting microarchitectures.

It is furthermore proposed to allow the user to prefix the keyword `inline`,
`runtime`, or `primitive` in front of (much of) these constructs to enforce a
certain implementation style:

 - `inline` requires the block to be optimized out during constant propagation.
   That is, for conditional statements the condition must be constant, allowing
   the statement to be replaced with the appropriate conditional block, and for
   looping statements, the loop shall be completely unrolled. An error will be
   thrown if any branch condition found during constant propagation is not
   actually constant. This can be used to construct algorithms generatively,
   similar to how this is currently done in OpenQL's Python API, even when the
   target does not support any flow control constructs. Inline constructs will
   be completely expanded by libqasm and will not appear in the semantic tree.

 - `runtime` explicitly disables the constant propagation logic that would be
   enforced by `inline` (it is its opposite) and requires the construct to be
   handled using classical flow instructions in the hardware. This could be
   useful primarily for debugging, or when it is somehow necessary to disable
   optimizations.

 - `primitive` is a bit of a mix between inline and runtime. libqasm will leave
   the construct alone, passing it directly to the platform to deal with.
   However, `primitive` constructs must ultimately be handled *without*
   classical control-flow instructions. It is up to the platform to figure out
   how, or to throw an error if this is impossible. For example, a primitive
   match statement may be compiled to conditionally-executed gates using CC's
   sequencer, while a runtime match statement would be handled using ALU
   instructions. Likewise, a primitive for loop might be compiled into a
   hardware looping construct.

Note that simulators can just ignore the `runtime` and `primitive` keywords.
These keywords only affect the implementation style in actual hardware, not
the semantics of the flow control construct.

The conditional gate construct from cQASM 1.x (`cond (<condition>) <gate>`)
might be the same as `primitive if (<condition>) <gate>` for this reason. Since
this construct is relatively common, it is proposed to keep this syntax, but
simply make it syntactic sugar for `primitive if`.

For the `break` and `continue` statements, it may be useful, particularly for
compiler output, to allow the usage of labels to identify exactly which
construct is broken out of or continued. The proposed syntax for this is a
`#` followed by some label directly following the identifying keyword that
starts the affected construct, and a `#` followed by the same label
immediately following the `break` or `continue` keyword. `break` and `continue`
can furthermore be extended semantically for the less-obvious keywords; for
example, breaking out of an `if` might be the same as jumping immediately past
it, or continuing an `if` might be the same as jumping back to the condition
check. TBD.

Functions and procedures
------------------------

To truly support control-flow as it is used in self-respecting classical
processors, some form of function/procedure system should also be supported.
For the avoidance of doubt; the word "function" will be used to refer to a
callable piece of code that returns a value, while "procedure" is used to
refer to a callable piece of code that does *not* return a value.

While it is highly unlikely that this will be implemented as actual classical
control-flow constructs in hardware anytime soon (as it requires a call stack),
much less in OpenQL, supporting these constructs at the language level greatly
increases the expressiveness of the language. This is especially useful for
procedural generation of an algorithm; in such a case, procedures could simply
be inlined by libqasm, so no code has to be written to handle them outside of
it. It would also allow the primitive gate/instruction set for a particular
platform to be described in cQASM itself using only primitive expressions,
built-in N-qubit unitary, measurement, and prep gates, and annotations/pragmas.
This eliminates current complication that a cQASM 1.1 simulator cannot possibly
simulate the output of OpenQL in general, since OpenQL outputs custom gates
defined in a JSON file, which does not even define what these custom gates
actually do. Things like gate decompositions can be naturally written this way
as well.

Note that all this is not as hard to implement in libqasm as it may seem. In
fact, custom functions are already a thing; the cQASM 1.1 `map` statement
internally effectively defines a function without arguments that is always
inlined. Inlining procedures similarly is just a glorified replace operation.
Return statements in functions are relatively annoying, however; it is proposed
to keep functions purely functional (i.e., their body is a single expression,
not a block of code that eventually returns something). This limits execution
of gates to procedures. To allow procedures to also "return" information, it
shall be possible to pass arguments by value or by reference; the latter is
needed for qubits anyway.

In terms of syntax, the following is proposed, but the exact syntax is TBD.

 - `[inline|runtime|primitive] function <name> ( [<name> : <typename> [, ...] ] ) <expr>`:
   defines a function. `inline` functions must be completely reduced during
   constant propagation, or an error will be thrown. `runtime` and `primitive`
   functions, on the other hand, result in a function reference in the semantic
   tree, even if the function could otherwise be constant-propagated. The
   former must be implemented using a `call` instruction when mapped to
   hardware, while the latter must map to exactly one instruction in hardware.
   The body of `primitive` functions is only used by simulators, to allow them
   to emulate the behavior of the hardware. Functions not marked either way
   will be constant-propagated if possible, and left to the compiler to handle
   using default behavior otherwise.

 - `[inline|runtime|primitive] operator <symbol> ( <name> : <typename> [, ...] ) <expr>`:
   defines an operator overload. Otherwise, this is the same as above.

 - `implicit [inline|runtime|primitive] function <name> ( <name> : <typename> ) <expr>`:
   same as normal functions, but may also be used by libqasm's overload
   resolver as promotion rule or as check/narrowing rule. In either case, the
   name of the function must match an exisiting custom type (see next section).
   When the argument is of a different type, the function acts as a promotion
   rule: it will be implicitly applied when a value of the argument type is
   used in a context where the target type is expected. This is necessary, for
   instance, when a target defines a custom integer type for registers; integer
   literals will be of the internal `int` type, but the user will obviously
   assume that they can assign an integer literal to a variable of the custom
   type. When the target and argument type are the same, the function acts as
   a constructor: it will be called any time a value of that type is created.
   This can be used to handle overflow behavior in narrow integer types, for
   instance. Functions of that type should probably always be `inline`, though
   I see no reason to limit libqasm to that.

 - `alias <name> = <expr>`: shorthand for a function without arguments, to
   replace the `map` syntax in cQASM 1.x. Useful for instance when you have
   a qubit register of n qubits named `q`, and you want to use more
   imaginitive names for the qubits in your algorithm. While `alias` would
   just syntactic sugar for `func` in 2.0, later minor versions may make
   them distinct, should the semantics of functions be changed to not always
   be inlined, and thus pass their result by value (which would otherwise
   break said use case).

 - `[inline|runtime|primitive] procedure <name> ( [<name> : [&] <typename> [, ...] ] ) <block>`:
   defines a procedure. The optional `&` indicates that a parameter is passed
   by reference rather than by value. `inline` procedures are always inlined
   by libqasm, and thus does not appear in the resulting AST. Conversely,
   `runtime` procedures must always result in a classical `call` instruction
   when compiled to hardware. `primitive` procedures must map to exactly one
   instruction in hardware; their body is only used to define the functionality
   of the instruction for simulators.

cQASM 1.x already supports function overloading based on the argument types.
This may need to be extended slightly to first try all possible overloads
*without* promotion, before allowing arguments to be implicitly promoted.
Otherwise, infinite recursion may be unavoidable when definining operators
on new types. The type promotion logic also needs to be updated to find any
path from one type to another, rather than only direct paths, to prevent
unnecessary code duplication.

Primitive types
---------------

The primitive types supported in cQASM 2.0 will be at least the following:

 - `qubit`: represents a single qubit.
 - `bool`: represents a single bit/boolean.
 - `axis`: represents an axis (X, Y, or Z).
 - `int`: represents a 64-bit signed integer.
 - `real`: represents a real number (IEEE double).
 - `complex`: represents a complex number (2x IEEE double, cartesian).
 - `string`: represents a string (primarily intended for annotations).
 - `json`: represents a JSON object (primarily intended for annotations).

These types all exist in cQASM 1.x as well.

cQASM 1.x has special cases for real and complex matrix types, and bit/qubit
variables and references are sort of in a superposition between being vectors
or scalars. This was in part due to a desire to keep things simple and in part
for backward compatibility for single-gate-multiple-qubit notation (in which a
single qubit index is sort of semantically the same as multiple for as far as
type checking is concerned). In short, it is ugly.

Therefore, for 2.0, the idea is to make generalized tuple types. Tuple types
are restricted to a single element type and a statically defined length to
keep things simple. A matrix can be described as a tuple of tuples; because
the length is part of the type instead of the value, it is impossible to get
"jagged" matrices this way. For the purpose of function overloading, functions
can either require a particular tuple size, or only require a particular tuple
recursion depth (i.e. dimensionality). A type is turned into a tuple by adding
`[<n>]` to the end of the type name, where `<n>` is the number of elements.
`<n>` may be omitted for function argument types.

Tuple types can be indexed using the `[]` operator. When the index is a simple
integer, the resulting type is the elemental type of the indexed tuple.
However, the index may also be an N-dimensional tuple of integers. In this
case, the result is a tuple of the same shape as the index, selecting from the
input tuple piecewise.

Multidimensional tuples may be indexed at once by comma-separating multiple
indices, e.g. `x[1, 2]` selects the element at the second row and third column
of matrix x (note that indices start at zero), while x[{0, 1}, {1, 2}] makes a
tuple with matrix index `0, 1` at position 0 and matrix index `1, 2` at
position 1, and so on.

The range operator (`..`) may be used to quickly select a number of elements.
For example, `q[1..3]` selects indices 1, 2, and 3. This is similar to the
`:` symbol in index lists in cQASM 1.x. Tuples with the same element type can
be concatenated using the `+` operator. Thus, `q[(1..3) + {5}]` is the 2.0
equivalent of `q[1:3,5]` in 1.x. However, SGMQ notation is not recommended in
2.x (TBD whether it will be supported at all, it's hard to generalize its
behavior in a consistent and satisfying way).

Custom types
------------

To completely allow the instruction set of a platform to be described from
within cQASM itself, it must also be possible to define custom types in cQASM
itself. For example, not every microarchitecture supports 64-bit signed
integers, and certainly that would not be the only integral type supported.
Thus, the need arises for custom types.

To not overcomplicate things, it is proposed to just allow aliases to be
created for existing primitive types at this time, treated as distinct by the
type checker and overload resolution. When the need arises, compound types
(i.e. records/structs) or custom enumerations may be added as well, but not
within 2.0.

The syntax for defining a type might simply be the following:

`primitive type <name> : <internal-type>`

An implicit literal promotion rule is automatically created to convert from the
new type to the internal type and vice versa.

`primitive` is prefixed to allow truly user-defined types to be added later as
well. Currently, custom types are only intended to be used to describe the
types of physical resources.

To allow newly defined type to actually be used by the user, implicit
conversion rules, functions, and operator overloads should probably be defined
after the type is itself defined. Here's a guiding use case for what should be
possible.

```
// Define type for 8-bit register.
primitive type reg8 : int;

// Ensure that the register type can only ever contain 0..255, with unsigned
// rollover for overflow.
implicit inline function reg8(x: reg8) x & 0xFF;

// Allow 8-bit registers to be added and subtracted at runtime.
primitive operator+(x: reg8, y: reg8) reg8(x + y);
primitive operatori(x: reg8, y: reg8) reg8(x - y);
// ... and so on for other supported ALU ops.
```

TODO: not sure if all of this is 100% sound yet.

Variables and constants
-----------------------

Variables are already supported in cQASM 1.1, but not very extensively.

The following variable definition syntax is proposed.

```
[primitive] var <name> [: <type>] [= <expr>] [, ...]
```

The primitive keyword is used to mark that a variable represents a physical
register. Non-primitive variables, instead, are to be mapped to primitive types
by a compiler. Mixing usage of primitive and non-primitive variables probably
will not be supported by OpenQL anytime soon (it complicates the mapping
process), but this way the language is ready for it.

Note that virtual and physical qubits are simply regular and primitive
variables of type `qubit` (or a tuple thereof) by this definition. No special
casing is needed otherwise.

Scoping rules for definitions
-----------------------------

Definitions (variables, functions, procedures, etc) can be placed anywhere, and
are scoped to the innermost control-flow statement (if any) from that moment
onward. It is permissible to redefine existing things; the new definition will
then override or shadow the existing one.

Include syntax
--------------

To make proper use of the instruction/gateset definition system, "header files"
become a thing. Therefore, it should be possible to include secondary cQASM
files. The proposed semantics are as follows:

 - `include <filename-string>` statements must be placed before the first line
   of code.

 - Relative filenames are resolved first as relative to the directory that the
   calling cQASM file resides in, and secondarily as paths predefined by the
   platform. The current working directory is ignored, as working directory
   dependence only causes confusion.

 - Included cQASM files are fully parsed and analyzed out of context. That is,
   filed included before some header do not affect that header (unlike C).
   Include loops would therefore cause infinite recursion and is illegal. When
   the included file has been completely analyzed, the resulting scope is added
   to the scope of the parent cQASM file. Any instructions are appended as
   analyzed, and thus function as initialization code.

Builtin gates, procedures, functions, etc.
------------------------------------------

The default gates from cQASM 1.x are replaced with only the following builtin
procedures:

 - `_builtin_unitary(qs: &qubit[], matrix: complex[][])`: applies an n-qubit
   unitary gate to the given qubits;

 - `_builtin_measure(qs: &qubit[], bs: &bool[])`: measures the given qubits
   on the Z axis and returns the results in the given boolean variables;

 - `_builtin_prep(qs: &qubit[])`: prepares the given qubits in the Z basis.

Any other primitive gate can be constructed from this using primitive
procedures definitions in platform header files.

Directives such as reset-averaging shall be removed in 2.x. Pragmas can be used
for this purpose, without poluting the set of builtin gates. However, some form
of generic formatted print statement/procedure should be added for debugging
purposes; TBD. There should also be an `error` procedure, which throws an error
when evaluated during constant propagation.

Predefined functions and operators shall be mostly the same as in 1.x, with
some additions here and there as appropriate:

 - matrix algebra should be added for tuple types, especially now that gates
   are expected to be defined from within cQASM itself;
 - it would be nice if there would be some primitive to fetch annotation data
   from things, for instance to query physical qubit index, in order to allow
   the gate matrix to be modified appropriately for the simulation model;
 - the new tuple type needs some new functions and operators, like `len()`,
   indexation, concatenation, etc.

The predefined constants will be:

 - `_builtin_true` and `true`: boolean true.
 - `_builtin_false` and `false`: boolean false.
 - `_builtin_x` and `x`: the X axis.
 - `_builtin_y` and `y`: the Y axis.
 - `_builtin_z` and `z`: the Z axis.
 - `_builtin_im` and `im`: the imaginary unit.
 - `_builtin_pi` and `pi`: shorthand for 3.14159...
 - `_builtin_eu` and `eu`: shorthand for 2.71828...

The short versions are the same as they were in 1.x, the long versions are
added in case platforms want to use the default names for something else (like
gate names) and thus need to define different short versions.
