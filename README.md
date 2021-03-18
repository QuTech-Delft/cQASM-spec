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

Almost everything in cQASM is parameterizable as well, both at compile-time via
so-called template parameters and at runtime via plain parameters. The former
is not dissimilar from specifying predefining preprocessor macros on a C++
compiler's command line, while the latter is not dissimilar from the `argv`
parameter passed to `main()` or (in Python) accessible via `sys.argv`, except
that type-safety is provided, and that the same syntax is used for both. The
parameters are passed to the toplevel cQASM file only, but this file may
propagate some or all of these parameters, even via expressions, to files that
it `include`s. All of this is intended to reduce the need to generate cQASM
code for complex algorithms; cQASM should be ergonomic enough to be
user-written, rather than only being an intermediate file format.

At runtime, the values for the plain parameters are expected to be passed to
the algorithm by the *host*; that is, the server that sends commands to the
firmware and reads back results. This is not a one-way street: cQASM 2.0 files
can also `return` data when they complete, and can communicate asynchronously
with the host in the interim via queues, using the `send` and `receive`
constructs. The language also provides `print` and `abort` statements that may
be used to emit debug messages or to indicate that a fatal error has occurred
respectively.

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

Normally, the primitives supported by some target are defined in either a
regular `include` file or in the prelude, the latter being a file that is
automatically included by libqasm before the first line of the toplevel cQASM
file is even read. The prelude and include path are configurable using
libqasm's API, allowing target-specific context to be provided similar to how
this was done in the 1.x API, except via more cQASM files rather than via API
calls.

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
*unit*. Things that are normally statements or definitions just return `null`
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
a braced block, or sequentially if used inside parentheses.

cQASM 2.0 leaves the exact definition of "sequential" and "parallel" to the
target. For instance, a compiler may not define any difference between them at
its input, because it will do the scheduling automatically, whereas a
timing-aware simulator might define parallel operations to start at the same
time and sequential operations to start in consecutive cycles, with a primitive
function that has a configurable duration, like 1.x's skip gate. The only
requirement is that the program behaves as if all units are evaluated
left-to-right, regardless of schedule.

# WIP from here on

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

 - *Primitive:* a construct that maps to a single, primitive hardware resource
   or instruction.

 - *Builtin:* a construct of which the semantics are language-defined.

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

Type system
-----------

cQASM uses a strong, static type system, in which the return value type of any
unit can be determined without context. This allows units that require input
values to be trivially overloaded based on the types presented to them, and
allows for type coercion rules (i.e. automatic typecasting, for example from an
`int` to a `real`, or a `real` to a `complex`) to be applied when there is no
direct match.

cQASM 2.0 extends on the 1.x type system with first-class compound/indexed
types rather than relying on special cases for matrices and (qu)bit registers,
and with user-definable enumerated and derived types. The former greatly extend
the expressive power of the language when writing complex algorithms, while the
latter is intended moreso to allow target-specific types (narrow integer
registers for example) to be specified from within the language, rather than
via the API or custom code added to libqasm.

Note that neither version of cQASM has first-class references or pointers.
Qubit references are the only exception: there is no such thing as the value of
a qubit in the classical sense, so they *must* be references. Everything else
is passed by value. Multiple things can be returned at once by simply returning
a pack of values.

The word "type" on its own is a bit ambiguous. We distinguish between "object
types" and "value types" here, by which we mean the type of storage used for an
object and the type of the values it can assume respectively.

### Object types

The following types of objects can be defined from within the language.

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

Plain file and function parameters are plain constant, and template file and
function parameters are static constant. This means that, unlike in C and
Python, they are not assignable inside the function body. When this is needed,
the user may copy the parameter into a variable.

While the constness of an object is reported through libqasm's API, it does not
have any semantical meaning associated with it after libqasm finishes
analyzing, as it only designates whether the object can be assigned from within
cQASM. This reduces the object types to only:

 - automatic objects, behaving as if they are allocated on the stack;
 - static objects, behaving as if they are allocated in global data memory
   during compilation; and
 - primitive objects, assumed to exist in the target in a predefined location,
   thus not allocated at all.

Note that a compiler may allocate objects differently if it can determine that
behavior is unaffected. For example, if function recursion is illegal or
unused, automatic variables may also be allocated in global data memory, and a
compiler may move objects to and from registers or alternative storage
locations at any time.

Simulators may treat primitive objects as static objects.

In case a target has multiple address spaces, annotations on the object
declaration, the value type of the object, or annotations on the value type
may for instance be used to designate the intended address space.

### Value types

The following builtin scalar types exist and can be used explicitly.

 - `qref`: a reference to a qubit.
 - `bool`: an enumerated type with the values `true` and `false`.
 - `int`: an integer between -2^63 and 2^63-1 inclusive.
 - `real`: a real number represented using IEEE 754 double precision.
 - `complex`: a complex number represented using two IEEE 754 double precision
   reals (real and imaginary value).
 - `string`: a variable-length string of characters.
 - `json`: a generalized JSON object.

Types can also be combined, using the following product types.

 - *Packs:* pack values consist of N >= 0 values of potentially different types.
   The syntax for a pack type is a comma-separated list of types within
   parentheses; for example `(int, bool)` for a pack consisting of an integer
   and a boolean. If only one type is used, a trailing comma must be used, for
   example `(int,)`. The same syntax is used for pack literals; for example,
   `(42, true)` or `(3,)`. `()` is special: it is known as "void" in type
   context and "null" in value context. It is a type with itself as the only
   value, used in contexts where no value logically exists, but one is
   grammatically required.

 - *Tuples:* tuples are a special case of packs, for which all elements have
   the same type, and at least one such element exists. The syntax for a tuple
   type is `<element-type>[N]`; for example `int[10]` is a tuple of 10
   integers. `<element-type>[]` is also allowed in the context of function
   parameters in order to generate a function for every tuple length the
   function is called with, but this is still decidedly *not* a variable-length
   tuple. There is no explicit notation for tuple literals, but packs and
   tuples coerce to one another as long as all elements coerce, so for instance
   `(1, 2, 3)` coerces to `int[3]` and can thus effectively be used as a
   literal for it.

In both cases, the `x[y]` unit is used to select individual elements of a tuple
or pack. In case of a pack, the index must be static, in order for the
resulting type to be known at compile-time.

Users can also define their own enumerated types and derived types. The primary
use case for this is to define the behavior of certain kinds of values that
actually exist in hardware, for example narrow integer registers or fixed-point
values.

Besides these types, libqasm internally uses a few additional types. These
behave as regular types for as far as the type system is concerned, but can
only exist statically. They are used to model context-sensitive constructs
(without making the actual type system context-sensitive), and for resolved
references (without making these instantiable as references/pointers from
within the language).

 - `csep`: the type for a context-sensitive comma-separated list of values,
   for example used to separate function arguments.
 - `scsep`: the type for a context-sensitive semicolon-separated list of
   values, for example used to sequentially execute statement-like units in a
   block.
 - `cnsep`: the type for a context-sensitive colon-separated two-tuple of
   values (used in object definitions), for example used to annotate the type
   of a new variable.
 - `eqsep`: the type for an context-sensitive equals-sign-separated two-tuple
   of values, for example used in the initial-value assignment of a new
   variable.
 - `ident`: the type for a context-sensitive/unresolved identifier, for example
   the type of the identifier unit used to name a new variable.
 - `starred`: the type for a context-sensitive starred unit, for example the
   type of the left-hand-side of `*q: qref[]` within the context of a function
   parameter.
 - `templ`: the type for a context-sensitive `template`-prefixed unit, for
   example the type of the left-hand-side of `template *q: qref[]`.
 - `typename`: a reference to a value type, for example the type of the
   identifier `int` under typical circumstances.
 - `reference`: a reference to an object or an element thereof, for example the
   type of `q` when `q` was previously defined as a qubit reference.
 - `function`: a reference to the set of overloads for a particular function,
   for example the type of the identifier `cos` (cosine function) under typical
   circumstances.

These types should never appear in libqasm's API, and are therefore not
documented in greater detail here.

The following subsections document the available types in detail.

#### `qref`

The `qref` type is used to refer to a single qubit.

`qref`s are usually declared using the `qubit` unit, which is just syntactic
sugar for defining plain constants of type `qref`. Note that this does not mean
that the qubit itself cannot be "mutated," it means it is illegal to use a
classical assignment statement to redirect the reference to a different qubit,
which is usually what you want. Nevertheless, cQASM does not impose any
requirements on how `qref`s are used at the language level: it is for example
legal for multiple `qref`s to refer to the same qubit, and it is legal to make
variable `qref`s. Targets need not necessarily support this, however; in more
cases than not they fundamentally cannot do this because qubits are scheduled
and mapped at compile-time, and in many other cases determining which `qref`
points to which qubit at a particular time in the schedule is intractable.
Ultimately, `qref`s are only defined this way because it allows the classical
type system to be leveraged for qubits as well.

The following builtin functions exist for qubits.

 - `qref() -> (qref)` (default constructor): returns a reference to a qubit
   that is not currently referred to by any other `qref`, or aborts if no
   free qubits remain.
 - `[_builtin_]physical_qubit(int) -> (qref)`: returns a `qref` for the given
   physical qubit, regardless of whether this qubit is in use. This is intended
   to be used only in post-mapping cQASM files.
 - `[_builtin_]qubit_index_of(qref) -> (int)`: returns the physical zero-based
   qubit index that the given `qref` refers to, or -1 if the `qref` is not
   mapped yet. This may be used to express different gate behavior depending
   on the physical qubits the gate is applied to.
 - `[_builtin_]apply_unitary(qref[], complex[][]) -> ()`: applies the given
   unitary matrix to the given set of qubits.
 - `[_builtin_]apply_density(qref[], real[][]) -> ()`: applies the given
   density operator to the given set of qubits.
 - `[_builtin_]prepare_z(qref[]) -> ()`: prepares the given qubits in
   the `|0>` state.
 - `[_builtin_]measure_z(q: qref[]) -> (bool[len(q)])`: measures the given
   qubits in the Z basis simultaneously, returning `true` upon collapse to
   `|1>` and `false` upon collapse to `|0>` for each qubit individually.
 - `operator==(qref, qref) -> (bool)`: returns whether the two given `qref`s
   refer to the same qubit. If both `qref`s point to a statically-known
   default-constructed qubit or to a statically-known physical qubit, the
   operator is evaluated statically by libqasm, otherwise its evaluation will
   be postponed.
 - `operator!=(qref, qref) -> (bool)`: returns the complement of the above.

The behavior of a program that uses both `qref`'s default constructor and
`physical_qubit()` is undefined. You should only use the former for programs
that are yet to be mapped, and only the latter for programs that have already
been mapped.

On the API layer, `qref` values are represented as signed integers. `qref()`
returns unique negative integers starting from -1 by means of a static counter,
to represent distinct unmapped qubits. Physical qubits are addressed using
nonnegative integers.

#### `bool`

The `bool` type is used for boolean values.

`bool`s behave exactly as a custom enumerated type declared as follows:

```
global type bool: (false, true)
```

That means that the following functions are defined by default (see also the
section on enumerated types).

 - `bool() -> (bool)` (default constructor): returns false.
 - `int(bool) -> (int)`: returns `0` for `false` and `1` for `true`.
 - `bool(int) -> (bool)`: returns `false` for `0` and `true` for any other
   integer.
 - `string(bool) -> (string)`: returns `"true"` for `true` and `"false"` for
   `false`.
 - `bool(string) -> (bool)`: the inverse of the above. Aborts if the string
   does not exactly match `"true"` or `"false"`.
 - `operator==(T, T) -> (bool)`: equality.
 - `operator!=(T, T) -> (bool)`: inequality.
 - `operator>(T, T) -> (bool)`: returns `true` if the LHS is `true` and the RHS
   is `false`, `false` otherwise.
 - `operator>=(T, T) -> (bool)`: returns `true` if the LHS is `true` or the RHS
   is `false`, `false` otherwise.
 - `operator<(T, T) -> (bool)`: returns `true` if the LHS is `false` and the
   RHS is `true`, `false` otherwise.
 - `operator<=(T, T) -> (bool)`: returns `true` if the LHS is `false` or the
   RHS is `true`, `false` otherwise.
 - `operator++(T) -> (T)`: returns `true` if the value was `false`, aborts
   otherwise.
 - `operator--(T) -> (T)`: returns `false` if the value was `true`, aborts
   otherwise.

The following functions are defined in addition.

 - `operator~(T) -> (T)`: returns `true` for `false` and `false` for `true`.
 - `operator&(T, T) -> (T)`: returns `true` if both values evaluate to `true`,
   `false` otherwise. Note that both operands are always evaluated.
 - `operator^(T, T) -> (T)`: returns `true` if the values differ, `false`
   otherwise.
 - `operator|(T, T) -> (T)`: returns `true` if either value evaluates to
   `true`, `false` otherwise. Note that both operands are always evaluated.
 - `operator!(T) -> (T)`: returns `true` for `false` and `false` for `true`.
 - `operator^^(T, T) -> (T)`: returns `true` if the values differ, `false`
   otherwise.

Furthermore, the short-circuiting `&&` and `||` operators are defined for
booleans. These are not represented as regular operator functions however,
because functions always evaluate all their arguments before the function
is evaluated.

#### `int`

The `int` type is used for integer values. In cQASM 2.0 it is represented as
a 64-bit signed integer, thus the range is from -2^63 to 2^63-1. However,
arbitrary-precision integers may be used in the future if a use case pops up
for this. These integers are primarily intended to be used for constant
propagation and code generation; targets should define derived primitive types
modelling correct overflow behavior for the integers actually supported by the
hardware (if any).

Positive integer literals can be specified in the usual decimal, hexadecimal,
and binary notation. Refer to the respective literal units for the exact
syntax.

The following functions are defined on integers.

**TODO:** long list. Integers coerce to `real` and `complex` and default to 0;
otherwise this is mostly just standard stuff.

#### `real`

The `real` type is used for real numbers. They are represented as IEEE 754
doubles.

Positive real-number literals can be specified in the usual notation. Refer to
the real-number literal unit section for the exact syntax. In addition,
`[_builtin_]pi` is defined to the most accurate representation of *π* that is
representable, `[_builtin_]eu` is same thing for *e*, and `[_builtin_]infinity`
maps to positive infinity.

The following functions are defined on real numbers.

**TODO:** long list. Reals coerce to `complex` and default to 0.0; otherwise
this is mostly just standard stuff.

#### `complex`

The `complex` type is used for complex numbers. They are represented as two
IEEE 754 doubles; one for the real part, and one for the imaginary part.

There is no literal syntax for complex numbers. Instead, they are constructed
via constant propagation of real numbers and `[_builtin_]im`, the imaginary
unit *i*.

The following functions are defined on complex numbers.

**TODO:** long list. Complex numbers default to 0.0; otherwise this is mostly
just standard stuff.

#### `string`

The `string` type is used for strings of text or bytes. The type is only
intended for use in constant propagation, printing debug messages, and so on.

String literals use double-quote delimiters, for example `"hello"`. The most
common backslash-based escape sequences are supported as well. For the exact
syntax, refer to the string literal unit section.

The following functions are defined on strings.

**TODO:** long list. Complex numbers default to 0.0; otherwise this is mostly
just standard stuff.

#### `json`

The `json` type can be used to insert arbitrary JSON data into cQASM. The type
is primarily intended for use in annotations and pragmas.

JSON literals use `{|`...`|}` delimiters for the outer object to disambiguate
between JSON and cQASM grammar. Inside these delimiters, the entire JSON syntax
may be used. Note that JSON does *not* define any syntax for comments, and as
such comments are not supported within these delimiters.

The following functions are defined on JSON objects.

**TODO** (not much here, though)

#### Packs

A pack is a type consisting of zero or more elements of potentially different
subtypes.

**TODO**

#### Tuples

**TODO**

#### Enumerated types

Enumerated types may be defined using the following syntax.

```
[export|global] [primitive] type <type-name>: (<comma-separated-value-names>)
```

This defines a type that can assume one of the one or more given values, and
defines the following aliases in local (no specifier), parent (`export`
specifier), or global (`global` specifier) scope:

 - `<type-name>` aliases the newly defined type;
 - `<value-name>` aliases a static constant containing one of the possible
   values for the newly defined type.

In addition, the following functions are defined automatically in the same
scope, `T` being the new type.

 - `T() -> (T)` (default constructor): returns the first value in the
   comma-separated list of possible values.
 - `int(T) -> (int)`: casts `T` to an integer, returning the zero-based index
   of the value within the list of possible values.
 - `T(int) -> (T)`: the inverse of the above. Returns the last value in the
   comma-separated list of possible values if the integer is out of range.
 - `string(T) -> (string)`: returns a textual representation of T.
 - `T(string) -> (T)`: the inverse of the above. Aborts if the string does not
   exactly match one of the possible values.
 - `operator==(T, T) -> (bool)`: equality.
 - `operator!=(T, T) -> (bool)`: inequality.
 - `operator>(T, T) -> (bool)`: greater-than using the defined ordering.
 - `operator>=(T, T) -> (bool)`: greater-than-or-equal using the defined
   ordering.
 - `operator<(T, T) -> (bool)`: less-than using the defined ordering.
 - `operator<=(T, T) -> (bool)`: less-than-or-equal using the defined ordering.
 - `operator++(T) -> (T)`: returns the next possible value. Aborts if out of
   range.
 - `operator--(T) -> (T)`: returns the previous possible value. Aborts if out
   of range.

Note that `bool` is just a predefined enumerated type. Therefore, all the above
functions are defined for `bool` as well. The value order of `bool` is
`(false, true)`.

The `primitive` specifier specifies to the target that the user expects the
type to map to a particular type that physically exists in hardware. How this
mapping is accomplished is target-specific (it may be via name lookup, via
annotations on the type, or by some other means). If this is not the case, the
target must emit a compile error, rather than emulating the type with a
sufficiently-sized integral type.

#### Derived types

Derived types may be defined using the following syntax.

```
[export|global] [primitive] type <type-name> = <base-type-name> { <defs> }
```

This defines a type that can assume the exact same types as the given base
type internally, but behaves like a distinct type. Its semantics thus somewhat
resemble private inheritance in C++.

The only alias implicitly defined in local (no specifier), parent (`export`
specifier), or global (`global` specifier) scope is `<type-name>`, which
aliases the newly defined type, and the only function implicitly defined in
this scope is `T() -> (T)` (the default constructor), which returns the
default value for the base type. However, the following functions are defined
in addition within the `<defs>` scope:

 - `unpack(T) -> (Base)`: converts the derived type into the base type;
 - `pack(Base) -> (T)`: converts the base type into the derived type.

These may then be used to define the functions and operators for the newly
defined type. These functions must be either marked `export` or not
marked with a scope specifier (`global` is not legal); in the former case,
their scope will automatically be promoted to the scope that `<type-name>`
is defined in, and in the latter case, they will remain private to the
`<defs>` scope.

`<defs>` must be a semicolon-separated list of only function declaration and
function definition units. Any other unit is illegal.

The `primitive` specifier specifies to the target that the user expects the
type to map to a particular type that physically exists in hardware. How this
mapping is accomplished is target-specific (it may be via name lookup, via
annotations on the type, or by some other means). If this is not the case, the
target must emit a compile error, rather than emulating the type using its
base type.

Units
-----

Besides the version statement, all syntax in cQASM 2.0 is defined recursively
using only units. The type system and constant propagation logic (collectively
referred to as "analysis" in this document) is subsequently used to assign
meaning to certain unit patterns, and to throw out patterns that do not make
sense.

# TODO
