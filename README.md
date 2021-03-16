Introduction
============

cQASM (common quantum assembly) is a quantum programming language designed to
interface between and facilitate development of the various layers of a full
quantum computing stack, from theorist to instrument firmware. Rather than
supporting the gateset of any particular quantum computing technology, it
supports all the usual gates from theory, allowing a theorist to write
high-level programs without necessarily needing to understand the underlying
hardware, that can then be mapped to said hardware automatically, using
increasingly constrained and low-level cQASM representations of the same
algorithm as it traverses down the stack.

cQASM aims to have a well-defined, unambiguous execution model, such that
algorithms can be simulated or otherwise instrumented at every layer of the
stack, without needing a different tool or implementation for each layer.
This promotes code reuse, and hopefully makes the research process as
efficient as it can be.

To avoid needing to write a new parser for every tool that uses cQASM on its
interface, the language comes with a C++ library, called libqasm. The library
includes various services on top of the parser, such as error checking, and
reduction of the abstract syntax tree down to an easier-to-digest format in
which many user-friendliness features of the language are already reduced to
their most primitive form. Besides the C++ APIs, libqasm also includes a Python
wrapper.

The user-facing cQASM language and the program-facing libqasm API both come in
different versions. Roughly speaking, four versions of the cQASM language
exist, but unfortunately the version number was used more as a "hype" term than
as an actual version number, resulting in some confusion.

 - The initial 1.0 version, with the gateset hardcoded in the grammar. This
   version is deprecated in favor of the "updated 1.0".
 - The updated cQASM 1.0. At the language level not much changes, aside from
   the introduction of expressions with constant folding support, and the
   addition of annotations. Internally however, the gateset is no longer
   hardcoded, and can be modified programmatically prior to parsing.
 - cQASM 1.1. This backward-compatible version of the language adds support
   for variables and runtime-evaluated expressions.
 - cQASM 2.0. This is a complete redesign of the language that adds structured
   classical  flow control, both for code generation and for evaluation at
   runtime.

At the API level, the following versions exist.

 - The original API, natively handling the initial 1.0 version of the
   language. The updated cQASM 1.x syntax can also be read using this API
   version as long as none of the newly added features are used.
 - The 1.x API, natively handling both cQASM 1.0 and 1.1. The initial 1.0
   version is also supported, as the updated 1.0 is a superset of it.
 - The 2.x API, natively handling cQASM 2.0. Once done, it should also be
   possible to read 1.x files through this API via a conversion layer.

cQASM 1.x
=========

The cQASM 1.x language is extensively documented
[here](https://libqasm.readthedocs.io/en/latest/cq1-structure.html). The 1.x
API is documented [here](https://libqasm.readthedocs.io/en/latest/doxy/index.html).

cQASM 2.0
=========

As stated in the introduction, cQASM 2.0's primary goal is to extend upon 1.x
by adding support for control-flow. However, unlike all the previous versions,
it is no longer backward-compatible.

cQASM 2.0 is designed as an imperative, structured programming language, with
a small amount of functional syntax peppered in. This means that the language
uses structures like `if`/`else` or `for` for control-flow, rather than
explicit goto and branch instructions. Furthermore, rather than using
assembly-level instructions like `add(rd, rs)`, expressions such as
`rd = rd + rs` are used.

The language has first-class support for generative code; that is, code that
is run *before* compilation by the parser library (libqasm) rather than during
compilation or at runtime. In some sense it is therefore similar to the C
preprocessor, but more powerful, type-safe, and using the same syntax as
regular control-flow constructs. This allows the algorithm programmer to write
repetitive stuff succinctly, similar to using Python loops and if/else
statements while generating kernels with the OpenQL API. Because they're built
into the parser, the complexity of this is hidden from the various pieces of
software that use libqasm, making them available regardless of how much of the
language they support.

On the opposite end of the spectrum, there is also first-class support for
defining and directly using "primitives." These are intended to map one-to-one
to something that the software reading the cQASM file must understand and
translate using logic defined outside of the cQASM world. However, they are
still written in a way that their function is immediately clear to someone
reading the program, and such that they can be interpreted by a simulator. For
example, the primitive function definition for an MX90 gate may use a
generalized RX function to perform a -90 degree rotation, and the RX function
would in turn use the builtin unitary gate function to process the gate. This
contrasts with the cQASM 1.x approach, where the gateset is built into the
parser or (in later API versions) is configurable via API calls: context beyond
the cQASM language specification was needed to parse or interpret a file, the
effect of which being that every implementation using cQASM was essentially
using its own dialect of cQASM.

Like cQASM 1.x, the language is statically typed, with quite a strict system
that supports only basic type coercion. Also like cQASM 1.x, 2.0 provides a
number of built-in types, namely `qref`, `bool`, `int`, `real`, `complex`,
`string`, and `json`. However, it expands upon these by supporting product
types similar to Python's tuples, and by letting users define their own
sum types (enumerations) and types derived from other types. This is primarily
intended for describing types of classical registers that a platform might
have; for example, if a platform has 16-bit registers, an integer-derived type
may be defined on this for which only operators supported by the hardware are
defined, with the same overflow behavior that the hardware uses. This, again,
prevents the need for a simulator to have hardcoded support for different
platforms.

Unlike most languages, cQASM 2.0 makes no grammatical distinction between
statements, expressions, or definitions. The mix of these is referred to as a
"unit." Things that are normally statements or definitions just return `null`
(equivalent to `None` in Python, or `void` in C++), and can otherwise be used
in most contexts, as long as the context supports side effects or definitions.
However, some of the statement-like constructs do or can return something more
useful. For example, a `foreach` loop returns a tuple of whatever its body
returns (if anything), making a `foreach` loop usable as a poor-man's map
function. Note however that cQASM 2.0 does not support function pointers or
closures, so the use of this is limited. The primary reason for this design
choice is that generalizing constructs as much as possible increases the
expressive power of the language with minimal additional effort.

cQASM 2.0 allows subprograms to be described using functions. This conceptually
replaces the named kernel concept from cQASM 1.x; one can now simply write the
program as a list of function calls if they want. cQASM 2.0's functions also
replace cQASM 1.x's gates; a gate is simply represented as a function call with
at least one qubit reference as an argument. Furthermore, functions are used
internally for operators, typecasts, and coercion rules as well. This, again,
is intended to reduce code duplication in libqasm and elsewhere, and to
simplify the language specification.

Like C++, cQASM 2.0 allows functions to be overloaded using the argument types.
For example, one might define `X(qref)` to do a 180-degree X rotation, but also
define `X(qref, real)` to define an arbitrary rotation. This is especially
important considering that functions are also used for operators; after all,
`1.2 + 3` means something different than `"hello" + " " + "world"`, but both
are implemented using `operator+`. However, to keep things simple, the language
is defined such that the return type of any unit can be determined before
knowing the context it is being used in. This means that distinguishing
overloads by return type only is not supported.

To facilitate expression of circuits with explicit parallelism and timing,
cQASM 2.0's braced block unit allows semicolons to be used to separate
instructions temporaly, and commas to separate them spatially. The comma thus
replaces the `|` of cQASM 1.x's single-line bundle notation. Furthermore, to
simplify expressing lots of parallel gates of the same type, functions that
expect scalar qubit references as arguments may be called with tuples of qubits
instead: this is implicitly expanded to a "comma-separated list" of
piecewise-applied functions, which will be executed in parallel if used inside
a braced block, or sequentially if used inside parentheses. Long idle times can
be specified using a builtin "skip" function, similar to 1.x's `skip` gate.
1.x's `wait` gate (essentially a barrier) is not defined as part of the
language, and should instead be written as a primitive function. This is
because cQASM 2.0 has no notion of gate or instruction duration, making a
`wait` builtin no different from any other function. Also, while quantum
hardware always has some kind of delay instruction, a barrier like 1.x's `wait`
is purely a scheduler directive.

Terminology
-----------

Because cQASM 2.0 is not an entirely conventional language, some of the usual
terminology (statement, expression, etc) does not apply. To avoid ambiguity, we
define the following terms.

 - *Unit:* the collective term for all of cQASM's individual language
   constructs. Units represent the expressions, statements, and declarations of
   more conventionally-implemented languages.

 - *Function:* the collective term for any named subprogram. This includes
   quantum gates: cQASM 2.0 makes no distinction between classical and quantum
   subprograms.

 - *Object:* the collective term for variables and constants, i.e. things that
   live in classical data memory or appear to do so. Qubits are not objects,
   nor anything else for that matter: cQASM 2.0 only knows of classical
   *references* to qubits, known as `qref`.

 - *(Object) type:* the type of an object, i.e. variable, constant, or a
   variation thereof. Not to be confused with the type of the values that the
   object can assume.

 - *Value:* the value associated with an object at some instant, or the
   (anonymous) return value of a unit of some kind.

 - *(Value) type:* the type of a value. Examples of types are `int`, `bool`,
   and `qref`, but also combined types such as `complex[2][2]` for a 2x2
   complex matrix, or `(int, string)` for a so-called pack consisting of an
   integer and a string.

 - *Alias:* a name used to refer to an object, function, or some other named
   unit.

 - *Scope:* the context in/duration for which aliases exist. The global scope
   is the special scope that envelops all other scopes.

 - *Lifetime:* the context in/duration for which objects exist. The static
   lifetime is the special lifetime that envelops all other lifetimes,
   including compile-time.

Structure
---------

cQASM 2.0 files consist of a version statement followed by a unit. The version
statement has the following syntax.

```
cQASM 2.0
```

The line may optionally be terminated with a semicolon.

### File extension

The file extension for cQASM files is `.cq`.

### Whitespace and comments

Unlike its predecessor, cQASM 2.0 is entirely insensitive to whitespace. That
is, newlines, whitespace, and block comments can be inserted between any two
tokens without affecting the functionality of the program.

Single-line comments use the hash (`#`) prefix as in Python and most other
scripting languages. Block comments use `/* */` as in C and various C-like
languages. Like spaces and tabs, block comments can go between any two tokens.

```
statement 1 # I'm a comment
statement /* I'm a much
longer comment */ 2
```

Unlike its predecessor, cQASM 2.0 files are case sensitive.

```
H(q[1])
h(Q[1]) # this means something else!
```

### Keywords

cQASM 2.0 recognizes the following keywords. These words cannot be used as a
name for gates, functions, mappings, or objects.

```
abort       alias       break       cond        const       continue
elif        else        export      for         foreach     function
future      global      goto        if          include     inline
match       operator    parameter   pragma      primitive   print
qubit       receive     repeat      return      runtime     send
static      template    transpose   type        until       var
when        while
```

Object types
------------

 - *Plain/automatic variables:* mutable objects with a lifetime from the point
   where they are declared to the end of the current scope. They are usually
   allocated within the current stack frame.
 - *Plain/automatic constants:* exactly as above, but immutable.
 - *Static variables:* mutable objects with static lifetime. They are usually
   allocated within global data memory. Their initial value must also be
   static, i.e. be evaluable at compile-time.
 - *Static (inline) constants:* immutable objects with static lifetime and
   value. libqasm will replace references to such constants with the assigned
   value, so the constants do not exist anymore on the API.
 - *Static runtime constants:* as above, but libqasm will not inline them,
   making them behave as immutable static variables.
 - *Primitive variables:* mutable objects with static lifetime that represent
   physical registers with read/write access.
 - *Primitive constants:* immutable objects with static lifetime that represent
   physical registers with read-only access. Note that the value of a primitive
   constant may still be modified externally; they should be treated like the
   `const volatile` construct from C.

While the constness of an object is reported through the API, it does not have
a semantical meaning associated with it after libqasm finishes analyzing, as it
only designates whether the object can be assigned from within cQASM. This
reduces the object types to only:

 - automatic objects, allocated on the stack;
 - static objects, allocated in global data memory; and
 - primitive objects, assumed to exist in the target in a predefined location,
   thus not allocated at all.


# WIP
