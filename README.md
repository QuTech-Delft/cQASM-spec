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

cQASM 2.0 language design and processing pipeline
-------------------------------------------------

In order to meet the requirements and generally be a powerful language both at
runtime and compile-time, the complexity of the language has to be much greater
than that of cQASM 1.x. Describing this complexity entirely using LR(1) grammar
rules and an accompanying AST would be a significant effort, as would the
engineering effort to switch to a different parser. Instead, the grammar is
kept simple by taking a more functional approach in the design of the language:
there is no grammatical or (in many cases) even a semantic difference between
expressions, statements, declarations, and so on.

The amalgamation of expressions, statements, and definitions that cQASM uses
at the grammatical and AST level will be referred to as a *unit*. Here are some
potentially surprising examples:

 - `<unit> + <unit>` (addition), but also `<unit> ; <unit>` and `<unit> ,`;
 - `if (<unit>) <unit> else <unit>` and other such ;
 - `var <unit>`, `<unit> : <unit>`, and `<unit> [ ]`;
 - `(<unit>)` (as in, this is not just for overriding precedence, but has some
   semantic effects as well) and `<unit>(<unit>)`.

Without additional rules, a grammar like this accepts various nonsensical
programs, `var var var 1` to name a random one. "So isn't this just shifting
all the complexity to semantic analysis, instead?" one might ask. The short
answer is "yes," but a slightly longer one is "yes, but also no." Allow me to
digress a bit to show why the above is not necessarily a bad idea.

Consider the original grammar of cQASM 1.0, where gate names were keywords, and
the grammar rules dictated which argument packs were valid for a particular
gate. After all, much like the above, `X q[0], q[1], 3` is nonsense, but
`CRk q[0], q[1], 3` is valid, right? Furthermore, `CR q[0], q[1], 3` is also
valid, but here the `3` represents a real-valued angle rather than an integer.
This also means that `CR q[0], q[1], 3.3` is valid, but `CRk q[0], q[1], 3.3`
is not. The gate name does not in general identify a single set of arguments
considered valid either, however: `display` on its own is valid, but so is
`display b[0]`.

Disambiguating these valid programs and distinguishing them from the invalid
ones via grammar rules was arguably fine originally, but when the gateset had
to become runtime-configurable without breaking any backward compatibility, it
caused a bit of a problem. After all, someone might define a gateset where an
`X` takes two qubits and an integer, and `CR` and `CRk` don't even exist!

The first step in resolving this is to make all of the above grammatically
valid, as the grammar is "hardcoded" into libqasm via the Flex/Bison code
generator. Post-rewrite, a gate is grammatically simply an identifier followed
by a comma-separated list of expressions, and an expression can be of any type
(qubit reference, integer, float, and so on). This grammar accepts all of the
above, whether they make sense in context or not.

This is of course not nearly enough for backward compatibility: to be backward
compatible on the language level, it must reject invalid input, and to be
backward compatible on the API level, it must convert valid input back to the
original format, where the parameters were stored in hardcoded locations
depending on what the parameter signifies.

This was solved by introducing a type system. During 1.x semantic analysis, the
expression trees in the AST are converted to typed *values* via pre-order
depth-first tree traversal. Values differ from expressions in that they have a
type attached to them. For example, the `3` becomes an *integer* literal value,
`3.3` becomes a *real* (as in real number) literal value, `q` becomes a *qubit*
reference (which is a bit of a misnomer in cQASM 1.x because it refers to a
1-dimensional qubit register for reasons that are not important for this
discussion), and `<expr>[<expr>]` takes an indexable expression (`bit` or
`qubit` in cQASM 1.x) and an integer to return a modified `qubit` or `bit`
value, referring to a different set of qubits or bits. These types (as well as
the number of expressions, of course) can then be used to determine whether a
gate is valid or not.

To solve the `display` problem, gates can be *overloaded*; that is, a single
name for a gate can be used for multiple different (or not so different) gates,
distinguished by the the number and type of arguments it receives. In cQASM 1.0
this mechanism is quite simple: the overload resolver just iterates over all
available gates from the most-recently-defined gate to the least recent one,
and returns the first definition that matches. If no definition is found, the
gate is invalid and the program is rejected.

While the overload mechanism could be used to allow `CRk` to accept both an
integer and a float for its third argument, this becomes unwieldly fast: for
consistency, you would want every gate that accepts one or more real-valued
arguments to have overloads for every combination of integer and real
arguments. This is exponential in the number of real-valued arguments, of
course. Therefore, a so-called type promotion mechanism was introduced as
well. Whenever there is a mismatch between a given value and a (possible)
expected type, a function is called that checks whether the provided value can
be implicitly converted to the target type. A promotion rule exists for
converting integers to real numbers, so it is sufficient to only define the
gate for real-valued arguments. Again, cQASM's overload resolver is very
simplistic: a language like C++ will try to find the *best* overload for a
given parameter pack (with a long definition for which one is the best), while
cQASM just applies the first one it finds.

In order to provide API-level compatibility, the rewrite of libqasm also
required constant propagation to be included. This is typically a compiler
task, which makes libqasm the wrong place for it in many ways. Nevertheless,
cQASM files need to be directly simulatable using QX without involvement of
a true compiler, and without constant propagation to some degree, a `3` cannot
be converted to a `3.0`; it would instead be some runtime function call that
converts an integer to a float until a compiler optimizes it out. Hence,
constant propagation was also a requirement.

Returning to the cQASM 2.0 problem at hand, we can now simply note that we
apply the same tricks again: generalize the grammar to accept more, and then
solve it in the type system, particularly because we already have a powerful
one in cQASM 1.x for different reasons.

Of course, the cQASM 1.x type system is not directly suitable for this amount
of additions. The relevant limitations are that the 1.x promotion logic and the
set of available types is hardcoded (while 2.0 will have custom types), and
that the 1.x type system treats one-dimensional qubit and bit registers and
real- and complex- matrices as special types rather than having generalized
sequence types. cQASM 2.0 will also require additional built-in types. But the
point is that it's very close to being suitable, so shifting complexity from
the grammar to this mostly preexisting system seems like an obvious choice.

Making it even more obvious is that, once everything is the equivalent of a
1.x expression, everything is also subject to constant propagation. Things like
function inlining and loop unrolling can then be massaged into this process as
well. For example, `inline foreach (i: 1..3) cnot(q[i], q[i+1])` is
constant-propagated to `cnot(q[1], q[2]); cnot(q[2], q[3]); cnot(q[3], q[4])`.
Essentially, you get generative constructs for free this way. Better yet, when
all 2.0-only constructs can be constant-propagated out of the code this way,
that 2.0 program can also be used by 1.x-only users of libqasm.

Note that libqasm's constant propagation system is not intended to be
exceptionally smart. For example, whenever a variable is involved anywhere,
constant propagation stops, so for `var a = 1; if (a > 1) ...` the `if` is
*not* removed. These more complex optimizations are left to a true compiler
framework or to the programmer to solve (for example, the latter may rewrite
the program to `const a = 1; if (a > 1) ...` to make things work, and may
explicitly mark the `const` as `inline`, which makes it an error if the
initialization of the `const` is not determinable at compile-time).

In order to extend the semantics of a cQASM 1.x expression to the semantics of
a 2.0 unit, units have to be able to yield more than just a value when they are
analyzed. Specifically, they yield:

 - the returned value (and its corresponding type);
 - side effects;
 - local, exported, and/or global alias definitions;
 - local variable and constant definitions;
 - global variable, constant, and function definitions.

Besides the return type, units may impose constraints on what their subtypes
can do. In particular, a *static unit* is a unit with no side effects and no
definitions. An example of a subunit that must be static is the parameter pack
in a function definition; specifically, this must return a value of type
`declaration` or `csep` (comma separated value) thereof.

Unfortunately, *some* context is required when evaluating units, namely whether
the unit is to be evaluated as regular code or as a variable, constant, alias,
or parameter definition pack. The difference is needed because the initializing
assignment unit conflicts with a regular assignment, and identifier tokens must
be interpreted as `unresolved` values rather than as `typename`, `reference`,
or `function` values. This boolean is, however, the only required context.

Let's look at the cQASM 2.0 types, since we've mentioned most of the internal
ones already. The full list is as follows.

 - `qubit`: used for variables that (bidirectionally) map one-to-one to
   physical qubits. That is, an in-scope `qubit` always refers to exactly one
   physical qubit, and every physical qubit refers to exactly zero or one
   variable of type `qubit`. Values of type `qubit` cannot be assigned or
   operated on directly, can only exist as primitive variables (making them
   the domain of platform specification header files), nor can they be used as
   function arguments, due to the no-cloning theorem, and the lack of
   ownership-passing semantics.
 - `qref`: a type used for referring to qubits. A `qref` acts as a copyable and
   assignable reference to a variable of type `qubit`. If a `qref` is not
   initialized by copying another `qref` or by a promotion from `qubit`, the
   constructor function for `qref` means "assign any qubit for which no
   references exist." In other words, `qref` represents a virtual qubit, to be
   mapped to a physical qubit by a compiler.
 - `bool`: a typical boolean, same as in 1.x.
 - `int`: a 64-bit signed integer, same as in 1.x.
 - `real`: a real number represented as a double, same as 1.x. Integers are
   automatically promoted to real numbers.
 - `complex`: a complex number represented as two doubles, same as 1.x.
   Integers and reals are automatically promoted to complex numbers.
 - `string`: a string, same as in 1.x.
 - `json`: a JSON object, same as in 1.x.
 - `pack`: an anonymous product type consisting of zero or more subtypes. These
   subtypes may or may not be different. The index operator is used to select
   components of the pack, but the index must be a static value, because
   otherwise the returned type would be undeterminable. A pack with zero
   subtypes is also called *void*, of which the only value is referred to as
   *null*.
 - `tuple`: an anonymous product type with one or more instances of the same
   type. The amount of instances is part of the type, so one cannot make a
   dynamically sized variable with these, but it *is* allowed to specify
   function parameters with dynamically-sized tuples for vararg-like constructs
   (they behave like templates in C++ rather than true variadic functions; that
   is, a supporting compiler would simply emit code for every tuple size it is
   called with). A pack promotes to a tuple of some type if it has at least one
   element and all its elements promote to the tuple type.
 - `user`: a user-defined type, derived from an existing type.
 - `enum`: a user-defined sum type (a.k.a. enumeration).
 - `csep`: an internal type representing a comma-separated list of units. It is
   not allowed to make variables or constants of this type (in fact the type
   does not even have a name usable within the language), it is only used
   internally.
 - `scsep`: same as `csep`, but for semicolon-separated lists.
 - `declaration`: an internal type for two colon-separated units, used within
   declarations to specify a name and an explicit type.
 - `unresolved`: an internal type for an unresolved identifier, again used
   within declarations.
 - `typename`: an internal type of which the *value* refers to another type.
   This is the result of for instance `int`; the resulting type is *not* an
   integer, but a `typename` where the value refers to the integer type.
 - `reference`: an internal type of which the value refers to a variable, or
   an N-dimensional index of a variable.
 - `function`: an internal type of which the value refers to a function name
   (before overload resolution).

All types implicitly promote to void, effectively allowing values of all
currently existing types to be discarded.

Note that the `axis` type from cQASM 1.x is removed. Its enumeration constants
are way too short and conflict with gate names (in 1.x, gates were in a
different namespace; this is no longer the case in 2.0 due to units being
used), and if a platform really wants them, it can define its own axis type
using a sum/enum type definition.

The types from `csep` onwards are invisible at the language level; they are
merely artifacts of defining the language using units. That is, it is not
possible for instance to make a variable or constant of type `function`
(although it is possible to define an alias for one). The existence of both
tuples and packs is also largely an artifact (while packs are useful in their
own right, they are not an immediate requirement of cQASM 2.0); it is quite
difficult to find a common type that a number of types all promote to, so
it would be difficult to determine the type of for instance `(3, 3.1)` if
only tuples were to exist. You also see this in the syntax for the functional
variants of the `if` and `match` statements, as well as the `when`-`else`
ternary conditional operator (in cQASM 1.x and C this would be `?`-`:`, but
this caused grammatical conflicts), where `if` and `match` require you to
specify a return value, and `when`-`else` requires the types of both cases to
be identical.

Next, let's turn to values, i.e. the primary things that units yield when they
are analyzed. These are what the things that appear in the 2.0 semantic tree.

 - *Static* values: these contain a statically determined instance of their
   type, either directly specified using literal tokens or resulting from
   constant propagation during the analysis process. Static values exist for
   all types, regardless of whether a literal representation of them exists
   in the language. For example, a static value of type `reference` consists
   of a link to a variable definition node, even though no variables of type
   reference can be made (note that a `reference` to `qubit` variable differs
   from a `qref`).
 - *Function* values: these are used when a function is to be called at
   runtime. They consist of a pointer to a function definition node, and zero
   or more subvalues for its arguments. Function values are used for all
   operations, not just functions as they appear in the language; runtime
   typecasts, promotions, and operators are also represented this way.
 - *Statement* values: a group of value types used for the various
   control-flow constructs (for as far as they are not optimized out by the
   analyzer), assignment statements, and read-modify-write operators.
 - *Block* values: a special value corresponding to `{}`-enclosed blocks.
   Blocks consist of a 2-dimensional list of subvalues with side effects
   representing a schedule (the major dimension being temporal, the minor
   being spatial, a.k.a. bundle notation), as well as local variable, runtime
   constant, and alias definitions (the latter being functionally irrelevant
   after parsing, but useful for associating names with things when
   pretty-printing or outputting error messages).

The majority of a cQASM 2.0 file is described using a block value that
represents file scope, but some additional things are needed as well:

 - A list of callable function definitions or templates thereof, in case the
   compiler needs to expand them to work around the dynamic indexing problem
   or to prevent the need for variadic calling conventions.
 - A list of static variables, constants, and parameters. These differ from
   local variables in the toplevel block in that they exist before and after
   the algorithm as well. Static variables are subdivided into `inline` and
   `primitive` variables, the former being the equivalent of `.data` or `.bss`
   in the C world, and the latter being used to describe physical resources
   like physical qubits, registers, or data memory. Static constants are
   subdivided into `runtime` and `primitive`, where runtime constants would be
   placed in `.rodata`, and primitive constants map to read-only physical
   resources (note that they are not necessarily always the same value, i.e.,
   in C terminology, they are volatile constants; the value may change, the
   algorithm just cannot change it directly). `inline` variables and
   `runtime` constants include an initial value, while `primitive` variables
   and constants do not. Finally, parameters act as `runtime` constants at the
   language level, but their initial value is set to a special node that
   consists of an optional default value and a name. The idea is that, when the
   algorithm is run, the host can override these values to essentially pass
   arguments to the algorithm (a bit like `argv`/`argc`, but type-safe within
   cQASM).
 - A list of user-specified types. The node for an enumerated type consists of
   just a list of static value nodes for all its possible values, while the
   node for a derived type just has a link to the type it derives from.
   Everything else will already have been resolved.
 - A list of global alias definitions. Just like in block values, these do not
   have a semantic meaning, as aliases have already been inlined in the
   program, and names have already been resolved.
 - The cQASM file version.

Besides runtime parameters, cQSAM 2.0 files can also accept generic parameters.
These act like `static inline` constants, in that they are
constant-propagated/inlined by libqasm. They must thus also be passed to
libqasm. They allow the generative constructs to be controlled without having
to modify or regenerate the cQASM 2.0 file.

Finally, a cQASM 2.0 may include zero or more `include` directives. These serve
a similar purpose as `#include` does in C, although they are closer in function
to Python's `import` statement. When a cQASM 2.0 file includes another, the
global function, variable, constant, type, and alias definitions are copied
into the calling cQASM 2.0 file, and its main block is prepended to the main
block of the calling cQASM 2.0 (it may thus be used for platform-specific
initialization). The parameters and generics of the callee must be manually
associated in the include directive, or their defaults will be used, even if
the caller has parameters or generics of the same name.

New constructs required for classical flow
==========================================

In order to do classical computation, the following primitives need to
minimally be available on top of cQASM 1.1:

 - assignment statements;
 - a conditional construct; and
 - a looping construct.

Assignment statements
---------------------

Assignment statements allow variables to be assigned. The syntax is similar to
C:

 - `a = b` sets `a` to `b`, and returns `b` when used functionally;
 - `a += b` sets `a` to `a + b`, and returns `a + b` when used functionally;
 - likewise for `*=`, `**=`, `/=`, `//=`, `%=`, `-=`, `>>=`, `>>>=`, `<<=`,
   `&=`, `^=`, and `|=`, for the other relevant binary operators;
 - `a++` sets `a` to `a + 1` or increments an enum to the next value (with
   rollover), returning the *previous* value of `a` when used functionally;
 - `++a` is similar, but returns the *updated* value of `a`;
 - `a--` and `--a` are analogous, to the above, but decrement instead.

The left-hand side of a simple assignment (`=`) accepts the following
constructs:

 - references to variables;
 - index units operating on a supported construct; and
 - tuples/packs of supported constructs.

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

The following constructs are proposed.

 - `[inline|runtime|primitive] if [<annot>] (<condition>) [-> (<return>)] <if-true> [elif (<cond2>) <if-cond2>]* [else <if-false>]`:
   simple "if" statement. Yields void unless `<return>` is specified.

 - `cond [<annot>] (<cond>) <block>`: sugar for `inline if`, to follow cQASM
   1.x conventions. Yields void.

 - `[inline|runtime|primitive] match (<value>) [-> (<return>)] ( when <val1> -> <block1> [...] [else <block>] )`:
   Rust-style match statement. Like `switch`, but with the added requirement
   that at most one code block is executed. Yields void unless `<return>` is
   specified.

 - `[runtime|primitive] for [.<lbl>] [<annot>] (<init>; <cond>; <update>) <body>`:
   C-style for loop, with explicit startup block and increment block. `break`
   and `continue` can be used to respectively break out of the loop or
   immediately continue with the next iteration. They can also be used to
   immediately break out of another parent loop by specifying a matching label
   for both the target loop and the `break`/`continue`. Yields void.

 - `[runtime|primitive] while [.<lbl>] [<annot>] (<cond>) <body>`: C-style
   while loop. This is the same as the for loop above with null startup and
   increment, and can thus just be syntactic sugar for that. Yields void.
 
 - `[runtime|primitive] repeat [.<lbl>] [<annot>] <body> until (<cond>)`: like
   a for loop, but with the condition at the end. The block is always executed
   at least once, and will continue to be executed until the condition
   evaluates to true (note that this is the complement to C's do-while, without
   loss of generality), or as long as `continue` is called in the block.
   Yields void.

 - `[static] [inline|runtime|primitive] foreach [.<lbl>] [<annot>] (<tuple>) <body>`
   foreach loop. In conjunction with the `..` range operator, this also allows
   loops with fixed iteration counts to be written down easily. Especially in
   the absence of `break`/`continue` statements, such loops can easily be
   unrolled for when the target does not actually support runtime loops, or be
   converted to hardware loop logic for supporting microarchitectures. The
   optional `static` keyword asserts that no `break` or `continue` may affect
   this particular loop, meaning that the number of iterations is always
   exactly the number size of `<tuple>`; when this is specified, the loop
   yields a tuple of the elements returned by `<body>`, otherwise it yields
   void.

Where:

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

 - `<return>` and `static` are used to specify that a construct is intended to
   be used in a functional sense, enforcing additional constraints at analysis
   time to allow the a non-void return type to be determinable.

 - `<annot>` is an optional list of zero or more annotations, applied to the
   flow-control construct. Regular annotations placed at the end of the line
   would otherwise be applied to the body rather than the flow-control
   construct due to operator precedence rules.

 - `.<lbl>` allows loop labels to be specified, which may be referred to by
   `break` and `continue` statements inside (nested) loops.

Note that simulators can just ignore the `runtime` and `primitive` keywords.
These keywords only affect the implementation style in actual hardware, not
the semantics of the flow control construct.

The syntax for `break` and `continue` is simply the keyword followed by an
optional loop identifier. If the loop identifier is not specified, the
innermost loop is implied. Note that, unlike in C, `break` has no effect on
`match` (or what would be `switch` in C, anyway).

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

In terms of syntax, the following is proposed.

 - `[export|global] [inline|runtime|primitive] function <name> [<annot>] ([<types>]) [-> (<return>)] <body>`:
   defines a function. `<name>` is the name, which can be an identifier for
   a normal function, `operator <symbol>` to define an operator overload, a
   name referring to a type for constructor and conversion functions, or
   `operator <type>` for implicit conversion functions/custom promotion
   rules for custom types. `export` and `global` affect the scope in which the
   alias for the function is defined: `export` defines it in the parent scope,
   `global` defines it in the global scope, and plain defines it in the current
   scope. Note that `alias` may be used to extend the visibility of functions.
   Note also that functions are static regardless of where they are defined;
   only the visibility of the name is affected by this. `inline`
   functions must be completely reduced during constant propagation, or an
   error will be thrown. `runtime` and `primitive` functions, on the other
   hand, result in a function reference in the semantic tree, even if the
   function could otherwise be constant-propagated. The former must be
   implemented using a `call` instruction when mapped to hardware, while the
   latter must map to exactly one instruction in hardware. The body of
   `primitive` functions is only used by simulators, to allow them to emulate
   the behavior of the hardware. Functions not marked either way will be
   constant-propagated if possible, and left to the compiler to handle using
   default behavior otherwise. The syntax for `<types>` is a comma-separated
   list of `<name> : <type> [= <default>]` pairs/triplets. The types here can
   be undefined-length or (at most one) vararg tuple, specified as `<eltype>[]`
   and `<eltype>[*]` respectively; in the former case, the function accepts a
   tuple of any length for that parameter index, and in the latter case, the
   function accepts zero or more arguments of that type and passes them to the
   body as a tuple. The default may be used to make parameters from a certain
   point onward optional, similar to C++ and Python. (note: I haven't thought
   much about how annoying it will be to implement the vararg and optional
   arguments, but assuming they are "expanded" just like variadic templates
   and functions with default arguments in C, i.e. just by replication, I
   don't imagine it would be too difficult.) Finally, `<return>` specifies the
   return type; without this, the function defaults to returning void.

 - `future function <name> ([<types>]) [-> (<return>)]`: a forward declaration
   for a function, allowing multi-function recursion to be specified for
   supporting targets and inlining.

Functions return the result of their body, or the value passed to `return` if
`return` is called prior to the end of the body.

cQASM 1.x already supports function overloading based on the argument types.
This may need to be extended slightly to first try all possible overloads
*without* promotion, before allowing arguments to be implicitly promoted.
Otherwise, infinite recursion may be unavoidable when definining operators
on new types. The type promotion logic also needs to be updated to find any
path from one type to another, rather than only direct paths, to prevent
unnecessary code duplication.

Primitive types
---------------

The primitive types supported in cQASM 2.0 will be:

 - `qubit`: represents a physical qubit.
 - `qref`: represents a virtual qubit or a runtime reference to a qubit
   (when supported).
 - `bool`: represents a single bit/boolean.
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

Therefore, 2.0 will have tuple and pack types. Tuples are indexable sequences
of one or more values with static length (part of the type, not part of the
value) and a common type; packs are statically-indexable sequences of zero or
more values with mixed types. Note that a matrix can be described as a tuple of
tuples; because the length is part of the type instead of the value, it is
impossible to get "jagged" matrices this way. For the purpose of function
overloading, functions can either require a particular tuple size, or only
require a particular tuple recursion depth (i.e. dimensionality). A type is
turned into a tuple by adding `[<n>]` to the end of the type name, where `<n>`
is the number of elements. `<n>` may be omitted for function argument types.
Pack types are constructed using a comma-separated list of the subtypes inside
`()`. Tuple and pack values are constructed similarly (the notation returns
a pack, but packs with values that all promote to a single value promote to
tuples of that value by induction). 2-dimensional packs and tuples can be
specified at once using semicolons; for example, `(1, 2; 3, 4)` is sugar for
`((1, 2), (3, 4))`. A tuple with a single element is disambiguated from
grouping parentheses by appending a comma, just like Python: `(1,)` is an
example. Column vectors can be specified as well by omitting the commas;
`(1; 2)` is sugar for `((1,), (2,))`, and `(1;)` is sugar for `((1,),)`.
Note that `()` refers to both the type of an empty tuple and its value: this is
sound because in both cases only the null value exists. `{}` is a synonym for
`()` to allow users to specify what resembles an empty block as well, but
`{...}` with contents means something different than `(...)` (here, the
semicolons and commas are used to specify schedules).

The range operator (`..`) may also be used to construct tuples of sequential
types (integers and enumerations). The range is inclusive on both ends, and
may be ascending or descending, as derived from which index is higher. For
example, `1..3` is equivalent to `(1, 2, 3)`, and `3..1` is equivalent to
`(3, 2, 1)`.

Tuples and packs may be concatenated using the `+` operator, so
`(1..2) + (5..6)` is short for `(1, 2, 5, 6)`.

Tuple and pack types can be indexed using the `[]` operator. In case of a pack,
the index must be static; otherwise, the return type cannot be determined. When
the index is a single integer, the resulting type is the elemental type of the
indexed tuple or the selected element type of the pack. However, the index may
also be an N-dimensional tuple of integers. In this case, the result is a tuple
of the same shape as the index, selecting from the input tuple piecewise. In
conjunction with the range operator, slices can be efficiently specified:
`x[5..9]` is equivalent to `(x[5], x[6], x[7], x[8], x[9])`.

Multidimensional tuples may be indexed at once by comma-separating multiple
indices, e.g. `x[1, 2]` selects the element at the second row and third column
of matrix x (note that indices start at zero), while `x[(0, 1), (2, 3)]` makes
a tuple with matrix index `0, 2` at position 0 and matrix index `1, 3` at
position 1, and so on. The indices can also be be specified in opposite
dimensional order using the `transpose` keyword: `x[transpose (0, 1), (2, 3)]`
makes a tuple with matrix index `0, 1` at position 0 and matrix index `1, 2` at
position 1, and so on. Semicolons may in this case be used for a second
dimension in the output, but more than that cannot be specified.

Tuples can be "unpacked" to comma-separated lists using the `*` unary operator.
That is, `*(1, 2, 3)` is equivalent to `1, 2, 3`. This is useful when using the
index operator or when calling functions. For example, `max(*x)` returns the
highest value in the `x` tuple, and `x[*y]` (also `x[transpose y]`) indexes the
dimensions of `x` using the tuple entries of `y`.

Tuples of references can appear at the left-hand side of assignment statements,
allowing functions that return multiple values to be easily unpacked. This is
especially true when the result is used as an initializing expression for a
constant or variable, where the type may be omitted (similar to `auto` in
C++11).

Custom types
------------

To completely allow the instruction set of a platform to be described from
within cQASM itself, it must also be possible to define custom types in cQASM
itself. For example, not every microarchitecture supports 64-bit signed
integers, and certainly that would not be the only integral type supported.
Thus, the need arises for custom types.

The syntax for defining a type based on an existing type is:

`[export|global] [primitive] type <name> = <existing-type> { <functions> }`

`primitive` indicates that the type should map to a hardware construct. The
compiler or target should know about this. Simulators can ignore it, however.
`export` and `global` select the visibility of `<name>`: `export` defines it
in the parent scope, `global` defines it in the global scope, and plain defines
it in the current scope. Note that `alias` may be used to extend the visibility
of types.

Within the `<functions>` block, the new type functionally behaves as the
existing type. This allows typecasts, promotions, etc. to be specified. Outside
the block, the functions and operators operating only on `<existing-type>` are
no longer visible; for example, if the existing type is a pack, the index
operator will cease to work, unless it is defined manually within the block.

Two special functions known as the constructor and identity functions may also
be defined here. Both are named the same as the type. The constructor function
takes no arguments, and will be called whenever a variable is constructed and
no default value is explicitly specified. The identity function takes a single
argument of the newly defined type, and, if specified, is called whenever a
value of this type is constructed. It may be used for instance to model
overflow behavior of narrow integer types.

Besides derived types, users can also define custom sum types a.k.a.
enumerations. The syntax for this is:

`[export|global] [primitive] type <name> : (<values>)`

This defines a completely new type, which accepts only the values listed in the
comma-separated `<values>` block. The values must be identifiers, which will be
defined as aliases to the otherwise anonymous literals for the type, in the
same scope as the typename.

Enumerated types are iterable, which means that `++`, `--`, `..`, and the
(in)equality operators are predefined for them.

Variables and constants
-----------------------

Variables are already supported in cQASM 1.1, but not very extensively.

The following variable/constant definition syntax is proposed.

```
[export|global] [static] [inline|runtime|primitive] <var|const> <name> [: <type>] [= <init>] [, ...]
```

`export` and `global` indicate the scope in which the variable or constant
will be visible; `export` defines the name in the parent scope, `global`
defines the name in the global scope, and plain defines it in the current
scope. `static` indicates that the lifetime of the variable or constant should
be the entire duration of the program and that there must always be a single
instance, regardless of its scope, and regardless of whether the variable is
defined within a function or flow control block. Conversely, non-`static`
(a.k.a. automatic) means that the variable/constant only needs to exist when
it is visible, and may thus also be initialized at runtime. `inline` enforces
that the `<init>` expression be statically evaluable (i.e. a literal or
something constant-propagated). `runtime` instead enforces that even if it is
statically evaluable, the initialization *must* be done when the
variable/constant is defined via a load instruction of some kind, rather than
via initial values loaded into memory when the program is uploaded, and in
case of a constant, that the value must be stored in memory somewhere.
`primitive` indicates that the variable should not be allocated as usual, but
instead refers to a hardware resource, like a register; the platform/compiler
must be aware of which resource is referred to by name or by means of
annotations, or it must throw an error. When neither `inline`, `runtime`, or
`primitive` are (implicitly) specified, the behavior is like `inline`, but the
initial value need not be static. Finally, the primary difference between `var`
and `const` is that `var`s can be assigned, while `const`s cannot be. Also,
`static`/`inline` constants may be removed (i.e. inlined) by libqasm during
constant propagation, in which case they will not appear in memory at all.

Not all combinations of modifier keywords are accepted. The following rules
apply:

 - `global`, `export`, and `primitive` imply `static` (that is, `static` may
   be omitted in these cases; they are always static);
 - for variables, `static` implies `inline` if `primitive` is not already
   specified;
 - for constants, `inline` implies `static`;
 - any conflicts arising from the above rules cause the program to be rejected;
 - if neither `inline`, `runtime`, or `primitive` is specified by the above,
   `inline` is added when the initial value (the explicit initial value or
   its constructor function if none is specified) is static, and `runtime` is
   used otherwise.

This restricts the available variable and constant types to the following:

 - `inline var`: a local variable for which the initializing assignment is
   static, i.e. it always initializes to the same value;
 - `runtime var`: a local variable for which the initializing assignment
   may not or can not be optimized away by constant propagation because it
   depends on context or has side effects;
 - `runtime const`: like runtime var, but may not be assigned to after its
   initializing assignment;
 - `[export|global] static inline var`: a variable with static lifetime,
   aliased in either the current, parent, or global scope;
 - `[export|global] static inline const`: a constant which is replaced during
   constant propagation, aliased in either the current, parent, or global
   scope (essentially, a static value is aliased, rather than a reference to
   the `const`);
 - `[export|global] static runtime const`: a constant for which the value can
   be determined during constant propagation, but that nevertheless is
   allocated in memory as a read-only variable;
 - `[export|global] static primitive var`: a hardware resource that must
   be recognized by the target, accessible as a read/write variable,
   aliased in either the current, parent, or global scope.
 - `[export|global] static primitive const`: as above, but the resource can
   only be read.

Note that the physical qubit register may be defined cQASM 1.0-style using
`primitive var q: qubit[<size>]; primitive var b: bool[<size>]`. Virtual qubits
should use the `qref` type instead.

Aliases
-------

Aliases are an internal construct in libqasm that map variables, constants,
functions, types, or essentially any other otherwise anonymous unit to a scoped
name. That is, something like a variable has no intrinsic name associated with
it; instead, it just *exists* somewhere in the semantic tree, and aliases are
needed to allow them to be referred to from within the language.

The `alias` syntax can be used to explicitly define new aliases as follows:

```
[export|global] alias <name> [: <type>] = <value> [, ...]
```

`export` and `global` select the scope that the alias is defined in, `<name>`
is the name of the alias, `<value>` is the aliased unit, and `<type>`
optionally specifies the type (a promotion rule may be applied to `<value>` to
accomplish the constraint). In order to use aliases, it is important to
understand that they alias an *entire unit*, rather than its return value. That
is, any side effects of `<value>` are evaluated for every instance where the
alias is used. It thus behaves more like an inlined function without arguments
than a constant. However, `<value>` *is* analyzed when it is defined. That
means that any names it refers to are resolved where the alias is defined,
rather than where it is used.

The above, among other things, allows the visibility of things to be extended.
For example, a type defined locally may be exported with a different name, or
exported beyond a single scope by adding `export alias x = x` at the end of
each scope for which it must be extended. However, it is illegal to refer to
local variables and constants within an `export` or `global` alias, as this at
best might allow variables to be used before they are initialized or after they
are destroyed, or at worst is utter nonsense.

Parameterization and host interaction
-------------------------------------

cQASM 2.0 files can be parameterized at both runtime by the host and at
compile-time through libqasm's inlining and constant propagation, can
return values to the host at runtime, and can communicate with the host
asynchronously. The following syntax is used.

 - `parameter <name> [: <type>] [= <value>]` declares a runtime parameter.
   `<name>` is aliased in file scope to a reference that behaves like a
   `static runtime const`. Either `<type>` or `<value>` must be specified; if
   only `<type>` is specified, the parameter is mandatory; if only `<value>` is
   specified, the value signifies the default value for the parameter (allowing
   it to be omitted), and the `<type>` is implicitly copied from the type
   returned by it; and if both are specified, `<value>` is promoted to `<type>`
   and `<type>` is thus used for the parameter type.

 - `generic <name> [: <type>] [= <value>]` as above, but declares a
   compile-time parameter. The `<name>` alias behaves like a
   `static inline const` or, equivalently, a static value.

 - A `return` statement outside of a function gracefully stops execution of the
   algorithm and returns the optional value specified after `return` to the
   host. Alternatively, if the outer block terminates without calling `return`,
   the result of the block is returned to the host.

 - The `send(<payload>)` function asynchronously sends data to the host.

 - The `receive(<type>)` function waits for the host to send a message
   (unless a message is already in the receive queue), interprets it as
   `<type>`, and returns it. If the host is simultaneously waiting for the
   algorithm to send something or to complete, either host, algorithm, or
   both should fail with a deadlock error.

Note that the communication model exactly matches the model DQCsim uses for
host and frontend interaction.

The type conversion process or serialization of internal cQASM types is
unspecified; the platform can implement whatever subset it wants, however it
wants.

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

 - `_builtin_unitary(qs: qref[], matrix: complex[][])`: applies an n-qubit
   unitary gate to the given qubits;

 - `_builtin_measure(qs: qref[]) -> (bool[])`: measures the given qubits
   on the Z axis and returns the results as booleans (true for `|1>`, false for
   `|0>`);

 - `_builtin_prep(qs: qref[])`: prepares the given qubits in the Z basis.

Any other primitive gate can be constructed from this using primitive
function definitions in platform header files.

Simulator control directives such as reset-averaging shall be removed in 2.x.
Pragmas can be used for this purpose, without polluting the set of builtin
functions. However, the following builtins are available for debugging:

 - `[inline|runtime] print(<format>, ...)`: prints a message. A plain print
   statement is expected to be handled by simulation only. A `runtime` print
   statement must be executed in hardware as well; if the target cannot do
   this, an error must be thrown at compile-time. An `inline` print statement
   is executed when the unit is analyzed into a value, and may thus be used
   to debug libqasm itself. `<format>` must be
   [a format string](https://github.com/fmtlib/fmt), and `...` is zero or more
   arguments (obviously the `,` is omitted when there are zero). `inline`
   print statements with non-static arguments (aside from the format string)
   are legal: libqasm should just pretty-print or provide a debug dump of the
   provided values.

 - `[inline|runtime] abort([<format>, ...])`: aborts execution or compilation
   with an error. A plain abort is expected to be handled by simulation only.
   A `runtime` abort statement must be executed in hardware as well; if the
   target cannot do this, an error must be thrown at compile-time. An `inline`
   abort statement is executed when the unit is analyzed into a value, and may
   thus be used to terminate compilation; branches of `if` and `match`
   blocks that are optimized away by constant propagation due to static
   conditions are not analyzed, or at least will not trigger an abort if they
   are. Similarly, aliases values and inlined functions will only trigger
   `inline` aborts when they are used.

`print` and `abort` are keywords, as variadic functions with variadic argument
types are not supported as functions at this time, and to allow `inline` and
`runtime` to be prefixed for the call.

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
 - `_builtin_im` and `im`: the imaginary unit.
 - `_builtin_pi` and `pi`: shorthand for 3.14159...
 - `_builtin_eu` and `eu`: shorthand for 2.71828...

The short versions are the same as they were in 1.x, the long versions are
added in case platforms want to use the default names for something else (like
gate names) and thus need to define different short versions. It is illegal to
make aliases (implicitly or explicitly) that start with `_builtin_` from within
cQASM.

Pragmas and annotations
-----------------------

All units can be *annotated* using the following syntax:

```
<target> @ <iface>.<oper>([<payload>])
```

Here, `<target>` is any unit, `<iface>` and `<oper>` are identifiers, and
`<payload>` is a comma-separated list of zero or more arguments. Annotation
arguments are analyzed by libqasm just like any function argument, allowing
things like variable references to be ergonomically specified; however, it
is up to the target to decide whether the side effects of the arguments are
evaluated or not (typically, they won't be).

In general, it should be possible for a target to ignore annotations that
it does not know about, without this significantly affecting the functional
behavior of the algorithm. However, the user should also be made reasonably
aware if a target does not support a particular annotation. Therefore, the
following semantics are mandated: if `<iface>` is `_` or identifies an
interface understood by the target, the target must throw an error if it does
not know what `<oper>` means, but otherwise, it should ignore the annotation
(although it may display a warning, if deemed necessary). These semantics
mirror those used in cQASM 1.x and DQCsim.

In addition to annotating existing units, a pragma statement also exists:

```
pragma <iface>.<oper>([<payload>])
```

The semantics are the same, except `pragma`s are intended to be used when
some kind of runtime side effect is implied (for example printing some
debugging information), while annotations are intended to be used for
attaching static information to constructs, for example to specify
compile-time attributes, without any side effect at runtime.

Compilers should strive to keep `pragma` statements and annotations that
they do not recognize intact where applicable, if they output to a format
that also supports them.
