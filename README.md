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

cQASM 2.0 allows subprograms to be described using functions. Among many other
things, this conceptually replaces cQASM 1.x's kernels: any cQASM 1.x program
can be written as a sequence of cQASM 2.0 function calls, possibly in a
range-based foreach loop to mimic the repetition count, and convey exactly the
same information. cQASM 2.0's functions also replace cQASM 1.x's gates; a gate
is simply represented as a function call with at least one qubit reference as
an argument. Furthermore, functions are used internally for operators,
typecasts, and coercion rules as well. This, again, is intended to reduce code
duplication in libqasm and elsewhere, and to simplify the language
specification.

Like C++, cQASM 2.0 allows functions to be overloaded using the argument types.
For example, one might define `X(qref)` to do a 180-degree X rotation, but also
define `X(qref, real)` to define an arbitrary rotation. This is especially
important considering that functions are also used for operators; after all,
`1.2 + 3` means something different than `"hello" + " " + "world"`, but both
are implemented using `operator+`. However, to keep things simple, the language
is defined such that the return type of any unit can be determined before
knowing the context it is being used in. This means that distinguishing
overloads by return type only is not supported.

A notable difference between the type/value system of C++ and cQASM is that all
variables and constants must (appear to) have a well-defined value at all
times. In C++, all C-style (POD) types are uninitialized and contain garbage
until they are explicitly assigned; in cQASM 2.0, all variables are implicitly
initialized with a type-specified default value if no explicit initializer is
given. When cQASM 2.0 is used as a compiler IR, a pass that determines that no
default initialization is actually needed because the value is never used may
convey this information to the next pass by annotating the object.

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
   (anonymous) return value of a unit of some kind, possibly only evaluable at
   runtime.

 - *(Value) type:* the type of a value. Examples of types are `int`, `bool`,
   and `qref`, but also combined types such as `complex[2][2]` for a 2x2
   complex matrix, or `(int, string)` for a so-called pack consisting of an
   integer and a string.

 - *Runtime value:* a value that requires runtime processing to be evaluated.
   This processing incurs *side effects*. These side effects are eventually
   used to describe the entire algorithm, even if the actual value returned is
   void and not even used. For example, the block `{ x(q[0]); y(q[1]); }` is
   formally a runtime value with value type void, that results in an X gate on
   `q[0]` followed by a Y gate on `q[1]` when evaluated to null at runtime.

 - *Alias:* a name used to refer to an object, function, or some other named
   unit.

 - *Scope:* the context in/duration for which aliases exist. The global scope
   is the special scope that envelops all other scopes.

 - *Lifetime:* the context in/duration for which objects exist. The *static*
   lifetime is the special lifetime that envelops all other lifetimes,
   including compile-time. *Automatic* lifetimes are lifetimes determined by
   context, for example the lifetime of a local variable within a function.

 - *Frame:* the conceptual region in which objects with automatic lifetime
   are are allocated. All frames are scopes, but not all scopes are frames;
   scopes are also used to support the notion of private functions and objects.
   Objects with static lifetime are allocated in the special, toplevel static
   frame.

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

 - *Plain/automatic variables:* mutable objects with a lifetime set by the
   innermost frame in which they are defined. They are only visible and thus
   usable from the point at which they are declared and until the point where
   all aliases to them go out of scope, thus the actual lifetime of the
   object may be reduced further by the compiler when performing liveness
   analysis.

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

cQASM 2.0 completely decouples these mutability, lifetime, and implementation
style qualifiers from scoping qualifiers, other than that the lifetime of an
object must be at least as long as its scope. Refer to the section on scoping
for details.

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

Besides the above object types, an internal object type exists for function
template bindings. They may be used to specify the relation between tuple
sizes in the parameter pack and/or return pack of a function, without putting
constraints on their actual value. Their value type is always `int`.

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
 - `objname`: a reference to an object or an element thereof, for example the
   type of `q` when `q` was previously defined as a qubit reference.
 - `funcname`: a reference to the set of overloads for a particular function,
   for example the type of the identifier `cos` (cosine function) under typical
   circumstances.
 - `ident`: an unresolved identifier.
 - `error`: a special type that coerces to the default value of any other type,
   used for error recovery.

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

The following builtin functions exist for qubit references.

 - `[_builtin_]qref() -> (qref)` (default constructor): returns a reference to
   a qubit that is not currently referred to by any other `qref`, or aborts if
   no free qubits remain.
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
 - `operator==(qref, qref) -> (bool)` a.k.a. `[_builtin_]is_equal`: returns
   whether the two given `qref`s refer to the same qubit. If both `qref`s point
   to a statically-known default-constructed qubit or to a statically-known
   physical qubit, the operator is evaluated statically by libqasm, otherwise
   its evaluation will be postponed.
 - `operator!=(qref, qref) -> (bool)` a.k.a. `[_builtin_]is_not_equal`: returns
   the complement of the above.

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

 - `[_builtin_]bool() -> (bool)` (default constructor): returns false.
 - `[_builtin_]int(bool) -> (int)`: returns `0` for `false` and `1` for `true`.
 - `[_builtin_]bool(int) -> (bool)`: returns `false` for `0` and `true` for any
   other integer.
 - `[_builtin_]string(bool) -> (string)`: returns `"true"` for `true` and
   `"false"` for `false`.
 - `[_builtin_]bool(string) -> (bool)`: the inverse of the above. Aborts if the
   string does not exactly match `"true"` or `"false"`.
 - `operator==(bool, bool) -> (bool)` a.k.a. `[_builtin_]is_equal`: equality.
 - `operator!=(bool, bool) -> (bool)` a.k.a. `[_builtin_]is_not_equal`:
   inequality.
 - `operator>(bool, bool) -> (bool)` a.k.a. `[_builtin_]is_greater`: returns
   `true` if the LHS is `true` and the RHS is `false`, `false` otherwise.
 - `operator>=(bool, bool) -> (bool)` a.k.a. `[_builtin_]is_greater_equal`:
   returns `true` if the LHS is `true` or the RHS is `false`, `false`
   otherwise.
 - `operator<(bool, bool) -> (bool)` a.k.a. `[_builtin_]is_less`: returns
   `true` if the LHS is `false` and the RHS is `true`, `false` otherwise.
 - `operator<=(bool, bool) -> (bool)` a.k.a. `[_builtin_]is_less_equal`:
   returns `true` if the LHS is `false` or the RHS is `true`, `false`
   otherwise.
 - `operator++(bool) -> (bool)` a.k.a. `[_builtin_]increment`: returns `true`
   if the value was `false`, aborts otherwise.
 - `operator--(bool) -> (bool)` a.k.a. `[_builtin_]decrement`: returns `false`
   if the value was `true`, aborts otherwise.

The following functions are defined in addition.

 - `operator~(bool) -> (bool)` a.k.a. `[_builtin_]bit_complement`: returns
   `true` for `false` and `false` for `true`.
 - `operator&(bool, bool) -> (bool)` a.k.a. `[_builtin_]bit_and`: returns
   `true` if both values evaluate to `true`, `false` otherwise. Note that both
   operands are always evaluated.
 - `operator^(bool, bool) -> (bool)` a.k.a. `[_builtin_]bit_xor`: returns
   `true` if the values differ, `false` otherwise.
 - `operator|(bool, bool) -> (bool)` a.k.a. `[_builtin_]bit_or`: returns `true`
   if either value evaluates to `true`, `false` otherwise. Note that both
   operands are always evaluated.
 - `operator!(bool) -> (bool)` a.k.a. `[_builtin_]bool_not`: returns `true` for
   `false` and `false` for `true`.

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

 - `[_builtin_]int() -> (int)` (default constructor): returns 0.
 - `[_builtin_]bool(int) -> (bool)`: returns `false` for `0` and `true` for any
   other integer.
 - `[_builtin_]int(bool) -> (int)`: returns `0` for `false` and `1` for `true`.
 - `operator [_builtin_]real(int) -> (real)`: coerces an integer to its
   real-number representation.
 - `[_builtin_]int(real) -> (int)`: converts a real number to an integer by
   truncating to 0. Overflow behavior is undefined.
 - `operator [_builtin_]complex(int) -> (complex)`: coerces an integer to its
   complex-number representation (with no imaginary component).
 - `[_builtin_]int(complex) -> (int)`: converts a complex number to an integer
   by discarding the imaginary component and truncating to 0. Overflow behavior
   is undefined.
 - `[_builtin_]string(int) -> (string)`: returns the decimal string
   representation of the integer.
 - `[_builtin_]int(string) -> (int)`: parses the given string as a decimal
   integer, aborting if the conversion fails.
 - `operator==(int, int) -> (bool)` a.k.a. `[_builtin_]is_equal`: equality.
 - `operator!=(int, int) -> (bool)` a.k.a. `[_builtin_]is_not_equal`:
   inequality.
 - `operator>(int, int) -> (bool)` a.k.a. `[_builtin_]is_greater`: greater-than
   comparison.
 - `operator>=(int, int) -> (bool)` a.k.a. `[_builtin_]is_greater_equal`:
   greater-or-equal comparison.
 - `operator<(int, int) -> (bool)` a.k.a. `[_builtin_]is_less`: less-then
   comparison.
 - `operator<=(int, int) -> (bool)` a.k.a. `[_builtin_]is_less_equal`:
   less-or-equal comparison.
 - `operator++(int) -> (int)` a.k.a. `[_builtin_]increment`: returns the given
   integer plus one. Overflow behavior is undefined.
 - `operator--(int) -> (int)` a.k.a. `[_builtin_]decrement`: returns the given
   integer minus one. Overflow behavior is undefined.
 - `operator+(int) -> (int)` a.k.a. `[_builtin_]identity`: returns the integer
   without modification.
 - `operator-(int) -> (int)` a.k.a. `[_builtin_]negate`: returns the negated
   integer.
 - `operator+(int, int) -> (int)` a.k.a. `[_builtin_]add`: returns the sum of
   the given integers. Overflow behavior is undefined.
 - `operator-(int, int) -> (int)` a.k.a. `[_builtin_]subtract`: returns the
   difference of the given integers. Overflow behavior is undefined.
 - `operator*(int, int) -> (int)` a.k.a. `[_builtin_]multiply`: returns the
   product of the given integers. Overflow behavior is undefined.
 - `operator/(int, int) -> (real)` a.k.a. `[_builtin_]true_divide`: returns the
   "true" result obtained when dividing the two integers as a real number.
   Division by zero returns NaN.
 - `operator//(int, int) -> (int)` a.k.a. `[_builtin_]euclidian_divide`:
   returns the Euclidian division of the two given integers, i.e. the division
   value rounded to negative infinity. Division by zero yields zero.
 - `operator%(int, int) -> (int)` a.k.a. `[_builtin_]modulo`: returns the
   modulo of the two given integers, equivalent to the remainder of the
   Euclidian division operator. Division by zero yields the left-hand-side.
 - `operator**(int, int) -> (int)` a.k.a. `[_builtin_]exponentiate`: returns
   the LHS raised to the RHS's power. Overflow behavior is undefined.
 - `operator<<(int, int) -> (int)` a.k.a. `[_builtin_]left_shift`: returns
   the LHS shifted left by the number of bits indicated by the RHS. Zero is
   shifted in from the LSB. If the RHS is negative, arithmetic right-shift is
   used, i.e. the sign bit is shifted in from the MSB. The RHS shall be
   appropriately clamped to avoid overflow, such that numbers too large
   result in 0, and numbers too low result in the sign replicating across all
   bits.
 - `operator>>(int, int) -> (int)` a.k.a. `[_builtin_]arithmetic_right_shift`:
   returns the LHS arithmically shifted right by the number of bits indicated
   by the RHS. The sign bit is shifted in from the MSB. If the RHS is negative,
   left-shift is used, i.e. zero is shifted in from the LSB. The RHS shall be
   appropriately clamped to avoid overflow, such that numbers too large
   result in 0, and numbers too low result in the sign replicating across all
   bits.
 - `operator>>>(int, int) -> (int)` a.k.a. `[_builtin_]logical_right_shift`:
   returns the LHS logically shifted right by the number of bits indicated
   by the RHS. Zero is shifted in from the MSB regardless of the sign. If the
   RHS is negative, left-shift is used, i.e. zero is shifted in from the LSB.
   The RHS shall be appropriately clamped to avoid overflow, such that numbers
   too large result in 0, and numbers too low result in the sign replicating
   across all bits.
 - `operator~(int) -> (int)` a.k.a. `[_builtin_]bit_complement`: returns the
   bitwise complement of the given integer.
 - `operator&(int, int) -> (int)` a.k.a. `[_builtin_]bit_and`: returns the
   bitwise AND of all the bits.
 - `operator^(int, int) -> (int)` a.k.a. `[_builtin_]bit_xor`: returns the
   bitwise XOR of all the bits.
 - `operator|(int, int) -> (int)` a.k.a. `[_builtin_]bit_or`: returns the
   bitwise OR of all the bits.
 - `[_builtin_]abs(int) -> int`: returns the negation of the given integer if it
   is negative, and return the given integer without modification if it is
   positive or zero.
 - `[_builtin_]max(*int[]) -> int`: returns the integer that is closest to
   positive infinity.
 - `[_builtin_]min(*int[]) -> int`: returns the integer that is closest to
   negative infinity.

#### `real`

The `real` type is used for real numbers. They are represented as IEEE 754
doubles.

Positive real-number literals can be specified in the usual notation. Refer to
the real-number literal unit section for the exact syntax. In addition,
`[_builtin_]pi` is defined to the most accurate representation of *π* that is
representable, `[_builtin_]eu` is same thing for *e*, and `[_builtin_]infinity`
maps to positive infinity.

The following functions are defined on real numbers.

 - `[_builtin_]real() -> (real)` (default constructor): returns 0.0.
 - `[_builtin_]int(real) -> (int)`: converts a real number to an integer by
   truncating to 0. Overflow behavior is undefined.
 - `operator [_builtin_]real(int) -> (real)`: coerces an integer to its
   real-number representation.
 - `operator [_builtin_]complex(real) -> (complex)`: coerces a real number to
   its complex-number representation (with no imaginary component).
 - `[_builtin_]real(complex) -> (real)`: converts a complex number to a real
   number by discarding the imaginary component.
 - `[_builtin_]string(real) -> (string)`: returns a decimal string
   representation of the real number.
 - `[_builtin_]real(string) -> (real)`: parses the given string as a real
   number.
 - `operator==(real, real) -> (bool)` a.k.a. `[_builtin_]is_equal`: equality.
 - `operator==(real[N][M], real[N][M]) -> (bool)` a.k.a. `[_builtin_]is_equal`:
   equality.
 - `operator!=(real, real) -> (bool)` a.k.a. `[_builtin_]is_not_equal`:
   inequality.
 - `operator!=(real[N][M], real[N][M]) -> (bool)` a.k.a. `[_builtin_]is_not_equal`:
   inequality.
 - `operator>(real, real) -> (bool)` a.k.a. `[_builtin_]is_greater`:
   greater-than comparison.
 - `operator>=(real, real) -> (bool)` a.k.a. `[_builtin_]is_greater_equal`:
   greater-or-equal comparison.
 - `operator<(real, real) -> (bool)` a.k.a. `[_builtin_]is_less`: less-then
   comparison.
 - `operator<=(real, real) -> (bool)` a.k.a. `[_builtin_]is_less_equal`:
   less-or-equal comparison.
 - `operator+(real) -> (real)` a.k.a. `[_builtin_]identity`: returns the given
   number without modification.
 - `operator+(real[N][M]) -> (real[N][M])` a.k.a. `[_builtin_]identity`:
   returns the given matrix without modification.
 - `operator-(real) -> (real)` a.k.a. `[_builtin_]negate`: returns the negated
   real number.
 - `operator-(real[N][M]) -> (real[N][M])` a.k.a. `[_builtin_]negate`: returns
   the negated matrix.
 - `operator+(real, real) -> (real)` a.k.a. `[_builtin_]add`: returns the sum
   of the given real numbers.
 - `operator+(real[N][M], real[N][M]) -> (real[N][M])` a.k.a. `[_builtin_]add`:
   returns the sum of the given matrices.
 - `operator-(real, real) -> (real)` a.k.a. `[_builtin_]subtract`: returns the
   difference of the given real numbers.
 - `operator-(real[N][M], real[N][M]) -> (real[N][M])` a.k.a. `[_builtin_]subtract`:
   returns the difference of the given matrices.
 - `operator*(real, real) -> (real)` a.k.a. `[_builtin_]multiply`: returns the
   product of the given real numbers.
 - `operator*(real, real[N][M]) -> (real[N][M])` a.k.a. `[_builtin_]multiply`:
   scales the given matrix.
 - `operator*(real[N][M], real) -> (real[N][M])` a.k.a. `[_builtin_]multiply`:
   scales the given matrix.
 - `operator*(real[X][M], real[N][X]) -> (real[N][M])` a.k.a. `[_builtin_]multiply`:
   returns the outer product of the given matrices.
 - `operator/(real, real) -> (real)` a.k.a. `[_builtin_]true_divide`: returns
   the quotient of the given real numbers.
 - `operator/(real[N][M], real) -> (real[N][M])` a.k.a. `[_builtin_]true_divide`:
   scales the given matrix.
 - `operator**(real, real) -> (real)` a.k.a. `[_builtin_]exponentiate`: returns
   the LHS raised to the RHS's power.
 - `[_builtin_]abs(real) -> real`: returns the absolute value of the given real
   number.
 - `[_builtin_]max(*real[N]) -> real`: returns the real number that is closest
   to positive infinity.
 - `[_builtin_]min(*real[N]) -> real`: returns the real number that is closest
   to negative infinity.
 - `[_builtin_]is_inf(real) -> bool`: returns whether the given real number is
   positive or negative infinity.
 - `[_builtin_]is_nan(real) -> bool`: returns whether the given real number is
   NaN.
 - `[_builtin_]sqrt(real) -> real`: returns the square-root of the given real
   number. NaN is returned if the operand is negative.
 - `[_builtin_]exp(real) -> real`: returns the natural exponent of the given
   number.
 - `[_builtin_]log(real) -> real`: returns the natural logarithm of the given
   number.
 - `[_builtin_]log(real, real) -> real`: returns the logarithm of the given
   number with the given base.
 - `[_builtin_][a]sin[h](real) -> real`: returns the (inverse of the)
   (hyperbolic) sine of the given operand, using radians.
 - `[_builtin_][a]cos[h](real) -> real`: returns the (inverse of the)
   (hyperbolic) cosine of the given operand, using radians.
 - `[_builtin_][a]tan[h](real) -> real`: returns the (inverse of the)
   (hyperbolic) tangent of the given operand, using radians.
 - `[_builtin_]deg(real) -> real`: returns the given number times 180 divided
   by pi, converting radians to degrees.
 - `[_builtin_]rad(real) -> real`: returns the given number times pi divided by
   180, converting degrees to radians.

#### `complex`

The `complex` type is used for complex numbers. They are represented as two
IEEE 754 doubles; one for the real part, and one for the imaginary part.

There is no literal syntax for complex numbers. Instead, they are constructed
via constant propagation of real numbers and `[_builtin_]im`, the imaginary
unit *i*.

The following functions are defined on complex numbers.

 - `[_builtin_]complex() -> (complex)` (default constructor): returns 0.0.
 - `[_builtin_]int(complex) -> (int)`: converts a complex number to an integer
   by discarding the imaginary component and truncating to 0. Overflow behavior
   is undefined.
 - `operator [_builtin_]complex(int) -> (complex)`: coerces an integer to its
   complex-number representation (with no imaginary component).
 - `[_builtin_]real(complex) -> (real)`: converts a complex number to a real
   number by discarding the imaginary component.
 - `operator [_builtin_]complex(real) -> (complex)`: coerces a real number to
   its complex-number representation (with no imaginary component).
 - `[_builtin_]string(complex) -> (string)`: returns a decimal string
   representation of the complex number.
 - `operator==(complex, complex) -> (bool)` a.k.a. `[_builtin_]is_equal`:
   equality.
 - `operator==(complex[N][M], complex[N][M]) -> (bool)` a.k.a. `[_builtin_]is_equal`:
   equality.
 - `operator!=(complex, complex) -> (bool)` a.k.a. `[_builtin_]is_not_equal`:
   inequality.
 - `operator!=(complex[N][M], complex[N][M]) -> (bool)` a.k.a. `[_builtin_]is_not_equal`:
   inequality.
 - `operator+(complex) -> (complex)` a.k.a. `[_builtin_]identity`: returns the
   given number without modification.
 - `operator+(complex[N][M]) -> (complex[N][M])` a.k.a. `[_builtin_]identity`:
   returns the given matrix without modification.
 - `operator-(complex) -> (complex)` a.k.a. `[_builtin_]negate`: returns the
   negated complex number.
 - `operator-(complex[N][M]) -> (complex[N][M])` a.k.a. `[_builtin_]negate`:
   returns the negated matrix.
 - `operator+(complex, complex) -> (complex)` a.k.a. `[_builtin_]add`: returns
   the sum of the given complex numbers.
 - `operator+(complex[N][M], complex[N][M]) -> (complex[N][M])` a.k.a. `[_builtin_]add`:
   returns the sum of the given matrices.
 - `operator-(complex, complex) -> (complex)` a.k.a. `[_builtin_]subtract`:
   returns the difference of the given complex numbers.
 - `operator-(complex[N][M], complex[N][M]) -> (complex[N][M])` a.k.a. `[_builtin_]subtract`:
   returns the difference of the given matrices.
 - `operator*(complex, complex) -> (complex)` a.k.a. `[_builtin_]multiply`:
   returns the product of the given complex numbers.
 - `operator*(complex, complex[N][M]) -> (complex[N][M])` a.k.a. `[_builtin_]multiply`:
   scales the given matrix.
 - `operator*(complex[N][M], complex) -> (complex[N][M])` a.k.a. `[_builtin_]multiply`:
   scales the given matrix.
 - `operator*(complex[N][M], complex[K][N]) -> (complex[K][M])` a.k.a. `[_builtin_]multiply`:
   returns the outer product of the given matrices.
 - `operator/(complex, complex) -> (complex)` a.k.a. `[_builtin_]true_divide`:
   returns the quotient of the given complex numbers.
 - `operator/(complex[N][M], complex) -> (complex[N][M])` a.k.a. `[_builtin_]true_divide`:
   scales the given matrix.
 - `operator**(complex, complex) -> (complex)` a.k.a. `[_builtin_]exponentiate`:
   returns the LHS raised to the RHS's power.
 - `[_builtin_]imag(complex) -> real`: returns the imaginary component of the
   given complex number.
 - `[_builtin_]abs(complex) -> real`: returns the magnitude of the given
   complex number.
 - `[_builtin_]arg(complex) -> real`: returns the angle of the complex number
   in radians between -pi (exclusive) and pi (inclusive). Zero is returned when
   the complex number is zero.
 - `[_builtin_]conj(complex) -> complex`: returns the complex conjugate of the
   given number.
 - `[_builtin_]norm(complex) -> complex`: normalize the given complex number to
   magnitude 1.
 - `[_builtin_]is_inf(complex) -> complex`: returns whether the given complex
   number is positive or negative infinity for either the real or imaginary
   component.
 - `[_builtin_]is_nan(complex) -> complex`: returns whether the given complex
   number is NaN for either the real or imaginary component.
 - `[_builtin_]sqrt(complex) -> complex`: returns the square-root of the given
   number. NaN is returned if the operand is negative.
 - `[_builtin_]exp(complex) -> complex`: returns the natural exponent of the
   given number.
 - `[_builtin_]log(complex) -> complex`: returns the natural logarithm of the
   given number.
 - `[_builtin_][a]sin[h](complex) -> complex`: returns the (inverse of the)
   (hyperbolic) sine of the given operand, using radians.
 - `[_builtin_][a]cos[h](complex) -> complex`: returns the (inverse of the)
   (hyperbolic) cosine of the given operand, using radians.
 - `[_builtin_][a]tan[h](complex) -> complex`: returns the (inverse of the)
   (hyperbolic) tangent of the given operand, using radians.
 - `[_builtin_]rx_unitary(real) -> (complex[2][2])`: constructs the unitary
   matrix for an arbitrary X rotation, specified using an angle in radians.
 - `[_builtin_]ry_unitary(real) -> (complex[2][2])`: constructs the unitary
   matrix for an arbitrary Y rotation, specified using an angle in radians.
 - `[_builtin_]rz_unitary(real) -> (complex[2][2])`: constructs the unitary
   matrix for an arbitrary Z rotation, specified using an angle in radians.
 - `[_builtin_]arb_unitary(real, real, real) -> (complex[2][2])`: constructs
   a unitary matrix using Qiskit's unitary notation in radians.
 - `[_builtin_]normalize_unitary(complex[N][N]) -> (complex[N][N])`:
   "normalizes" the given unitary gate matrix as follows:
    - orthogonalize the column vectors;
    - normalize the column vectors;
    - normalize global phase heuristically:
       - if index `[0,0]` is nonzero after rounding to 5 digits, apply global
         phase to make its phase 0;
       - otherwise, if index `[0,1]` is nonzero after rounding to 5 digits,
         apply global phase to make its phase *i* (this makes the standard Y
         matrix look right);
       - otherwise, for i in 2 <= i < N, if index `[0,i]` is nonzero after
         rounding to 5 digits, apply global phase to make its phase 0 (this
         should always succeed).
 - `[_builtin_]controlled_unitary(complex[N][N]) -> (complex[N*N][N*N])`: turns
   the given unitary gate matrix into its controlled variant.
 - `[_builtin_]controlled_unitary(complex[N][N], template count: int) -> (complex[N**(count+1)][N**(count+1)])`:
   turns the given unitary gate matrix into its controlled variant with the
   given number of control qubits.

#### `string`

The `string` type is used for strings of text or bytes. The type is only
intended for use in constant propagation, printing debug messages, and so on.

String literals use double-quote delimiters, for example `"hello"`. The most
common backslash-based escape sequences are supported as well. For the exact
syntax, refer to the string literal unit section.

The following functions are defined on strings.

 - `[_builtin_]string(bool) -> (string)`: returns `"true"` for `true` and
   `"false"` for `false`.
 - `[_builtin_]bool(string) -> (bool)`: the inverse of the above. Aborts if the
   string does not exactly match `"true"` or `"false"`.
 - `[_builtin_]string(int) -> (string)`: returns the decimal string
   representation of the integer.
 - `[_builtin_]int(string) -> (int)`: parses the given string as a decimal
   integer, aborting if the conversion fails.
 - `[_builtin_]string(real) -> (string)`: returns a decimal string
   representation of the real number.
 - `[_builtin_]real(string) -> (real)`: parses the given string as a real
   number.
 - `[_builtin_]string(complex) -> (string)`: returns a decimal string
   representation of the complex number.
 - `[_builtin_]string(json) -> (string)`: returns the given JSON as a string.

#### `json`

The `json` type can be used to insert arbitrary JSON data into cQASM. The type
is primarily intended for use in annotations and pragmas.

JSON literals use `{|`...`|}` delimiters for the outer object to disambiguate
between JSON and cQASM grammar. Inside these delimiters, the entire JSON syntax
may be used. Note that JSON does *not* define any syntax for comments, and as
such comments are not supported within these delimiters.

The following functions are defined on JSON objects.

 - `[_builtin_]string(json) -> (string)`: returns the given JSON as a string.
 - `[_builtin_]get(json, string) -> (json)`: indexes into a JSON object. Aborts
   if the JSON operand is not an object.
 - `[_builtin_]get(json, int) -> (json)`: indexes into a JSON array. Aborts if
   the JSON operand is not an array.
 - `[_builtin_]as_bool(json) -> (bool)`: converts the given JSON boolean to a
   cQASM boolean. Aborts if the JSON operand is not a boolean.
 - `[_builtin_]as_int(json) -> (int)`: converts the given JSON integer to a
   cQASM integer. Aborts if the JSON operand is not an integer.
 - `[_builtin_]as_real(json) -> (real)`: converts the given JSON float to a
   cQASM real. Aborts if the JSON operand is not a floating point number.
 - `[_builtin_]as_str(json) -> (string)`: converts the given JSON string to a
   cQASM string. Aborts if the JSON operand is not a string.

#### Packs

A pack is a type consisting of zero or more elements of potentially different
subtypes.

Pack literals are built using comma-separated lists of values surrounded by
parentheses, for example `(1, true, 3.14)`. A single-element pack can be made
using a trailing comman, for example `(1,)`. The same applies for identifying
pack types; these would be `(int, bool, real)` and `(int,)` for the previous
examples. `()` is special: it refers to both the zero-element pack type and its
sole value. In type context this is called *void*, and in value context this is
called *null*.

Semicolons may also be used within parentheses. These are a shorthand for a
second pack dimension. For example, `(1, 2; 3, 4)` is the same as
`((1, 2), (3, 4))`. This is intended to make writing matrices more ergonomic.

A `*` or `**` prefix may be used to convert a pack back to comma-separated or
comma/semicolon-separated context. For example, a function that takes two
arguments may be called with a pack via `some_fn(*pack)`. This is similar to
Python's starred expressions. Similarly, `**` is the inverse of the pack
literal with semicolons included.

Packs can be indexed using the `x[y]` index operator. Unless all elements have
exactly the same type (no coercion is done), the index must be static, in order
for the return type to be determinable during compile time. Out-of-range
accesses result in a call to abort, at compile-time if static or at runtime if
non-static.

#### Tuples

Tuples are a special case of packs where each element has the same type, and at
least one such element exists. Internally they are distinct types, but they
can be used interchangeably, because all tuples coerce to their respective
pack, and a pack coerces to a tuple with some element type if the pack has at
least one element and all pack elements coerce to said element type. For this
reason, no special syntax is needed for tuple literals; a pack literal can be
used instead.

Tuple types are represented as `T[N]`, where `T` is the elemental type, and `N`
is the size of the tuple. Note that `T[N][M]` represents a two-dimensional
tuple with *minor* dimension `N` and *major* dimension `M`, because it is a
tuple of size `M` with `T[N]` elements. This is backward from C, and also
backward from how you would index the tuple! To avoid confusion, the `T[M,N]`
syntax may be used instead: it is sugar for `T[N][M]` in type context, while
`val[i,j]` is sugar for `val[i][j]`.

The special case of `real[][]` and `complex[][]` is used for matrices; that is,
operators and functions are defined on them that implement basic matrix
algebra. There is nothing special about them otherwise. The tuples are
row-major, such that `(a; b)` results in a column vector, `(a, b;)` results in
a row vector, and `(a, b, c; d, e, f)` represents a two-by-three matrix of the
form

```
 _         _
|  a  b  c  |
|           |
|_ d  e  f _|
```

`T[M,N]` or `T[N][M]` represent an M-by-N matrix, and `val[i,j]` or `val[i][j]`
index into it. The indices are zero-based, so `0 ≤ i < M` and `0 ≤ j < N`.

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

#### Special functions

The following functions are defined programmatically from within C++ with
overloads that are not (easily) representable in cQASM 2.0 function definition
syntax.

 - `[_builtin_]len(T) -> (int)`: returns the length of a string, pack, or
   tuple.
 - `[_builtin_]shape(T) -> (int)`: returns the shape of a multidimensional
   pack or tuple.
 - `[_builtin_]type_of(T) -> (typename)`: returns the type of the given
   expression.
 - `[_builtin_]get_annotation(str, str, T) -> (S)`: fetches the payload of the
   first annotation with the given interface and operation identifier
   (represented as strings) found on the given object. The object may be
   anything with an alias:
    - for function aliases, this searches for annotations on the function
      definition;
    - for type aliases, this searches for annotations on the type definition;
    - for object aliases, this searches for annotations on the object
      definition (use `type_of()` to get annotations on its type instead);
    - for custom aliases, this searches for annotations on the aliased unit.
   If the annotation does not exist, `()` is returned.

Scopes and frames
-----------------

When you declare an object (variable or constant), two things happen.

 - First, the object is allocated somewhere. Where this is depends on whether
   you mark the object as `static`, `primitive`, or leave it unmarked
   (automatic): automatic objects will be allocated in the innermost frame,
   `static` objects will be allocated in static/global memory, and `primitive`
   objects are expected to not need allocation because they serve as a
   reference to some hardware construct. Objects in cQASM do not intrinsically
   have a name associated with them, so while the object *exists* at this
   point, it cannot be referred to yet.

 - Second, an *alias* to a reference to the otherwise anonymous object is made
   in some scope. Which scope this is depends on whether you mark the object
   declaration with `export`, `global`, or leave it unmarked (local): local
   objects will be aliased in the innermost scope, `export`ed objects will be
   aliased in the parent scope, and `global` objects will be allocated in
   global scope.

Function and type declarations and definitions follow the same pattern. The key
takeaway here is that lifetimes and aliases are two entirely distinct concepts
in cQASM.

Aliases are valid only from the point where they are declared onwards. For
function aliases, it is possible to declare the function before defining it
using the `future` keyword, to facilitate recursive programming patterns.

Objects can have multiple different aliases pointing to them, and these new
aliases can be exported to parent scope or made global. That means it is
possible to extend the scope of an object. However, it is illegal to extend
the scope of an automatic object beyond its frame. For example, a variable
declared inside an `if` statement cannot be exported out of that statement,
because if the branch is not taken it technically would not even exist.
Similarly, a local variable in a function cannot be exported out of the
function, because any number of instances of the variable might then exist at
a time (including zero).

cQASM 2.0 allows redefinition of aliases at any time. The latest definition
that is still in scope always takes precedence. For functions, the same
mechanism is used for overload resolution: the resolver will check whether
the latest function definition matches the provided argument pack, then check
the next if not, and so on, until all definitions are exhausted. Note that this
behavior differs from C++, where an overload defined in a subscope hides any
previously defined overloads.

The body of a function must only make use of objects defined in the static
frame, in the toplevel frame of the function itself, or control-flow subframes
thereof. That is, closures are not supported: when a function is defined within
a function, the inner function may not use local variables from the outer
function.

Units
-----

Besides the version statement, all syntax in cQASM 2.0 is defined recursively
using only units. The type system and constant propagation logic (collectively
referred to as "analysis" in this document) is subsequently used to assign
meaning to certain unit patterns, and to throw out patterns that do not make
sense.

During analysis, the unit tree is traversed pre-order depth-first (unless
otherwise noted), each unit or unit tree being converted to its return value.
This may be a "runtime value," in which case the value describes the steps that
need to be taken to evaluate the value at runtime, including any side effects,
or even frames (i.e. local objects) needed along the way. These steps usually
include the values returned by the subunits, which may again be runtime values,
thus recursively specifying runtime program behavior.

To do so, the following context is needed.

 - The unit being analyzed.
 - Whether the unit is to be analyzed as a definition or not.
 - The state of the name resolver, in which new aliases may be defined.
 - A stack of frames that have not yet been absorbed into a unit, in which new
   objects may be allocated.
 - The nodes describing user-defined types and functions, to eventually be
   absorbed into the root node of the semantic tree, in which new types and
   functions may be defined.
 - A list of error messages, to which new messages may be added. If any of
   these exist when all units have been parsed, compilation fails. Analysis of
   a unit may also yield a non-recoverable error, in which case analysis stops
   immediately.

The following sections exhaustively list the available units.

### Literal units

The literal units allow data to be entered into the program as static values.

#### Decimal integer literal unit

The decimal integer literal unit consists of a single token that matches the
regular expression `[0-9][0-9_]*`; that is, any integer number, optionally
with some amount of leading zeros, containing or ending with an underscore.
Any embedded or trailing underscore is ignored when parsing the number; the
intention is that they may be used as for example a thousands separator in
long numbers.

The return value is a static `int` with the given positive value. Integers
too large to be represented by `int` are illegal.

Negative integers can be constructed using the negation operator unit. The
negative integer -9223372036854775808 (= -2**63) can *not* be represented this
way, because the positive part would be out of range; hexadecimal or binary
notation must be used instead.

#### Hexadecimal integer literal unit

The hexadecimal integer literal unit consists of a single token that matches
the regular expression `0x[0-9a-fA-F_]+`; that is, any case-insensitive
hexadecimal number with `0x` prefix, possibly containing underscores before,
after, or between the digits. Any embedded or trailing underscore is ignored
when parsing the number; the intention is that they may be used to group
the digits for easier readability. The `0x_` special case of the regular
expression is illegal.

The return value is a static `int` with the given value. Bit 63, if
specified, indicates the sign bit of the number in two's complement notation.
Integers too large to be represented by `int` are illegal.

#### Binary integer literal unit

The binary integer literal unit consists of a single token that matches the
regular expression `0b[01_]+`; that is, any binary number with `0b` prefix,
possibly containing underscores before, after, or between the digits. Any
embedded or trailing underscore is ignored when parsing the number; the
intention is that they may be used to group the digits for easier readability.
The `0b_` special case of the regular expression is illegal.

The return value is a static `int` with the given value. Bit 63, if
specified, indicates the sign bit of the number in two's complement notation.
Integers too large to be represented by `int` are illegal.

#### Real literal unit

The real-number literal unit consists of a single token that matches the
regular expression `([0-9][0-9_]*)?\.[0-9][0-9_]*([eE][-+]?[0-9]+)?`; that is,
an optional integer part, followed by the mandatory `.` decimal separator,
followed by at least one fractional digit, optionally followed by a power-of-10
exponent. The integer and fractional parts may include underscores, except at
the front; these underscores are ignored during parsing, and are intended to be
used for digit grouping to improve readability.

The return value is a static `real` with the closest representation of the
given value as per the IEEE 754 default rounding rules.

#### String literal unit

The string literal unit consists of a leading and trailing `"` with text in
between. Any character, including a newline, can be used within the string and
will be copied as written unless otherwise specified via an escape sequence;
only a `"` can terminate the string. The following escape sequences are
available:

 - `\t` yields a tab character (ASCII 9);
 - `\n` yields a newline (ASCII 10);
 - `\'` yields `'`;
 - `\"` yields `"`;
 - `\\` yields a single `\`; and
 - a `\` followed by an actual newline is removed from the string.

The return value is a static `string` with contents as described above.

#### JSON literal unit

The JSON literal unit consists of an opening `{|` and a closing `|}` token,
with the contents of a JSON object (`{`..`}`) in the between, not including
the outer `{` and `}`. The special opening and closing tokens serve to
disambiguate cQASM grammar from JSON grammar. All JSON syntax within the
opening and closing tokens is allowed, including for example `|}` within a
JSON string, as long as the toplevel entity is an object.

The return value is a static `json` object.

### Identifier units

Identifiers represent references to previously declared things. All identifiers
are resolved via the alias system.

#### Regular identifier unit

A regular identifier unit consists of a single token matching the regular
expression `[a-zA-Z_][a-zA-Z0-9_]*`; that is, any word consisting of letters,
digits, and underscores, not starting with a digit.

Keywords take precedence over identifiers. Therefore, the following words
are not legal identifiers:

```
abort       alias       break       cond        const       continue
elif        else        export      for         foreach     function
future      global      goto        if          include     inline
match       operator    parameter   pragma      primitive   print
qubit       receive     repeat      return      runtime     send
static      template    transpose   type        until       var
when        while
```

The behavior of the regular identifier unit depends on context.

 - If the unit is parsed as part of a definition, a static `ident` value is
   returned, consisting of the specified identifier.

 - Otherwise, if the specified identifier matches a currently-visible alias,
   the aliased value is returned.

 - Otherwise, a suitable recoverable error message is appended to the list of
   errors, and `error` is returned.

#### Operator identifier unit

The operator identifier unit consists of the `operator` keyword followed by one
of the following operator tokens:

```
+   -   ~   !   **   *   /   //   %   <<   >>
>>>   <   <=   >   >=   ==   !=   &   ^   |
```

It behaves the same way as a regular identifier unit, but using the otherwise
impossible name `operator<tok>` for the identifier, where `<tok>` represents
the symbol-based token. Any spacing between `operator` and the subsequent token
is ignored; the resulting identifier never contains a space.

Identifiers of this form are used only for naming functions that serve as
custom operator overloads. These identifiers are illegal in any other context.
Refer to the function definition unit for more information.

#### Coercion identifier unit

The coercion identifier unit consists of the `operator` keyword followed by a
regular identifier token. It behaves the same way as a regular identifier unit,
but using the otherwise impossible name `(<identifier>)` for the identifier,
where `<identifier>` represents the contents of the regular identifier. For
example, `operator hello` would yield a static `ident` with value `(hello)`
when used in definition context.

Identifiers of this form are used only for naming functions that serve as
custom coercion rules (implicit typecasts). These identifiers are illegal in
any other context. Refer to the function definition unit for more information.

### Packing/grouping parentheses unit

The packing/grouping parentheses unit consists of a `(`, followed by an
optional subunit, followed by a `)`.

The behavior of the packing/grouping parentheses unit is as follows.

 - If no subunit is specified, an empty pack (a.k.a. null in value context
   or void in type context) is returned.

 - Otherwise, if the subunit returned a value of type `csep`, the `csep` is
   converted to a pack of the `csep` elements.

 - Otherwise, if the subunit returned a value of type `scsep`, the `scsep` is
   converted to a pack of the `scsep` elements, except if these elements are of
   type `csep`, in which case the elements are also converted to packs,
   resulting in a two-dimensional pack.

 - Otherwise, the value returned by the subunit is returned without
   modification. This is useful for overriding operator precedence.

### Unpacking units

The unpacking units allow packs (or tuples) to be unpacked back into the
internal `csep` or `scsep` types, to allow them to be used in contexts where
a comma/semicolon-separated list is expected otherwise, or for elegant
concatenation of packs. The notation is inspired by Python's starred notation,
and in many cases has similar semantics.

#### One-dimensional unpacking unit

The one-dimensional unpacking unit consists of a `*` token followed by a
subunit. The behavior is as follows.

 - If the unit is parsed as part of a definition, a value of type `starred` is
   returned, containing the value returned by the subunit.

 - Otherwise, if the subunit returned a value that is or coerces to a pack, the
   elements of the (outermost) pack are converted to a `csep`.

 - Otherwise, an appropriate error message is appended to the list of error
   messages, and the value returned by the subunit is returned without
   modification.

#### Two-dimensional unpacking unit

The two-dimensional unpacking unit consists of a `**` token followed by a
subunit. The behavior is as follows.

 - Otherwise, if the subunit returned a value that is or coerces to a pack, the
   elements of the (outermost) pack are converted to an `scsep`. If a resulting
   element is also or also coerces to a pack, the element is converted to a
   `csep`. Thus, at most two dimensions are converted to `scsep`/`csep`.

 - Otherwise, an appropriate error message is appended to the list of error
   messages, and the value returned by the subunit is returned without
   modification.

### Indexing units

The indexing units are used to index into packs and tuples. By indexing using
integer tuples, it is also possible to select multiple elements at the same
time, shift them around, and so on.

#### Regular indexing unit

The regular indexing unit has the syntax `x[y]`, where `x` is either a tuple, a
pack, an `objname`, or a `typename`, and `y` can be a number of things.

##### `x` = tuple

In the simplest case, `x` is a tuple and `y` is a unit that returns something
that coerces to `int`. In this case, the index operator has the usual
semantics; i.e., the outermost tuple/pack is indexed by `y`, using zero-based
indices. Out-of-range accesses result in a call to abort, either during
analysis if `y` is statically known, or at runtime if not.

It is also allowed to use a tuple/pack of any shape with only `int` elements
for `y`. In this case, the result of the index operation will have the same
shape, with the index operator applied piecewise.

Finally, `y` may be a comma-separated list of the above. In this case, multiple
dimensions of `x` are indexed at once: the first element of the comma-separated
indexes the outermost tuple, the next indexes the next, and so on. If `x` has
insufficient dimensions, abort is called during analysis.

The two notations can be combined. All comma-separated elements of `y` must
then have the same shape, or abort is called during analysis.

##### `x` = pack

If (one or more indexed dimensions of) `x` is a pack, all of the above still
applies, but (that comma-separated element of) `y` must be statically known.
This is needed to determine the resulting type.

##### `x` = `objname`

If `x` is an `objname`, the semantics are as described above, but the result
will be an appropriately modified `objname`. This means that the index operator
can be used on the left-hand side of an assignment unit.

##### `x` = `typename`

If `x` is a `typename`, the semantics are very different. In this case, `y`
must be something that coerces to either a static `int`, an `int` that only
depends on function template bindings, or a comma-separated list of any
combinationg thereof.

If `y` is a single `int`, it converts the type `x` to a tuple of that type with
length `y`. For example, `int[4]` refers to a tuple type consisting of four
integers.

If `y` is a comma-sepated list, this operation is applied recursively with the
elements of `y` in right-to-left order. For example, `complex[2,3]` represents
a two-by-three complex matrix.

Within function declaration/definition context, bindings may be used to
generically specify the relation between various tuple sizes used in the
parameter/return type packs.

#### Transposed indexing unit

The regular indexing unit has the syntax `x[transpose y]`, where `x` is either
a tuple, a pack, or an `objname`, and `y` can be a number of things.
Conceptually, it behaves the same as the regular index operator, but the
meaning of the comma-separated list and tuple/pack shape of its elements is
swapped.

##### `x` = tuple

In the simplest case, `x` is a tuple and `y` is a unit that returns something
that coerces to `int`. In this case, behavior is no different from the regular
index operator.

It is also allowed to use a one-dimensional tuple of `int` elements, with a
size no more than the dimensionality of `x` (abort is called during analysis
otherwise). The elements of this tuple correspond with the dimensions of `x`.
For example, `matrix[transpose (1, 2)]` selects matrix element `1,2`.

Finally, `y` may be a semicolon and/or comma-separated list of the above. In
this case, the result will be a one- or two-dimensional tuple/pack containing
the result of piecewise application of the above rule.

As an example, consider the following context.

```
const x = (11, 12, 13; 21, 22, 23);
const sel_11 = (0, 0);
const sel_12 = (0, 1);
const sel_13 = (0, 2);
const sel_21 = (1, 0);
const sel_22 = (1, 1);
const sel_23 = (1, 2);
```

In this context, `x[transpose sel_11, sel_23]` (a.k.a.
`x[transpose (0, 0), (1, 2)]`) would yield `(11, 23)`. You would not be able
to write this succinctly with only the regular index operator, because the
(expanded) equivalent for the same indices would be `x[(0, 1), (0, 2)]`.

#### Unbound size unit

The unbound size unit has the same syntax as the regular indexing unit, except
there is no `y` (that is, the syntax is `x[]`), and `x` must be a `typename`.
This may only be used in function declaration/definition context, and is sugar
for specifying a tuple type with no size constraints. For example,
`function x<N>(int[N])` and `function x(int[])` mean the same thing, i.e. a
function generically applicable to a tuple of any size.

### Range unit

The range unit provides a succint notation for tuples with incrementing or
decrementing indices of some type. The syntax is `x..y`, where `x` and `y` must
be static values with exactly the same type. This type may be any type for
which the following operators are defined:

 - `operator++(T) -> (T)`
 - `operator--(T) -> (T)`
 - `operator>(T) -> (T)`
 - `operator==(T) -> (T)`

This includes `int` and enumerated types.

The unit returns a static tuple of the same type as `x` and `y`, generated
using the following rules.

 - If `x == y`, return `(x,)`. For example, `1..1` yields `(1,)`.

 - Otherwise, if `x > y`, return the tuple whose elements are generated by
   iteratively calling `operator++()` on `x` until `x==y`, including `x` and
   `y`. For example, `1..3` yields `(1, 2, 3)`.

 - Otherwise, return the tuple whose elements are generated by
   iteratively calling `operator--()` on `x` until `x==y`, including `x` and
   `y`. For example, `3..1` yields `(3, 2, 1)`.

Note that it is possible to get infinite recursion during analysis when the
operators are defined incorrectly, or to get very large tuples by specifying
values that are very far apart. libqasm will emit a warning if it spends a
long time evaluating a particular range unit, but does not impose any
particular restriction.

### Overloadable operator units

Similar to C++, cQASM 2.0 supports operator overloading, and does so for almost
all common operators.

#### Identity unit

The identity unit has the syntax `+x`, where `x` is a unit returning any type
that can be coerced to a type for which `operator+(x)` is defined. The return
value and side effects are determined by the implementation of that function.
Normally it would yield `x` unchanged.

#### Negation unit

The identity unit has the syntax `-x`, where `x` is a unit returning any type
that can be coerced to a type for which `operator-(x)` is defined. The return
value and side effects are determined by the implementation of that function.
Normally it would yield the two's complement of `x`.

#### Bitwise complement unit

The identity unit has the syntax `~x`, where `x` is a unit returning any type
that can be coerced to a type for which `operator~(x)` is defined. The return
value and side effects are determined by the implementation of that function.
Normally it would yield the bitwise/one's complement of `x`.

#### Boolean complement unit

The identity unit has the syntax `!x`, where `x` is a unit returning any type
that can be coerced to a type for which `operator!(x)` is defined. The return
value and side effects are determined by the implementation of that function.
Normally it would yield the boolean complement of `x`.

#### Exponentiation unit

The exponentiation unit has the syntax `x ** y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator**(x, y)` is defined. The return value and side effects are determined
by the implementation of that function. Normally it would yield `x` raised to
the `y`th power.

#### Multiplication unit

The multiplication unit has the syntax `x * y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator*(x, y)` is defined. The return value and side effects are determined
by the implementation of that function. Normally it would yield the product
of `x` and `y`.

#### True division unit

The true division unit has the syntax `x / y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator/(x, y)` is defined. The return value and side effects are determined
by the implementation of that function. Normally it would yield the quotient
of `x` and `y` as a real number, without any rounding other than what may be
needed to represent the value using an IEEE 754 double. This mirrors Python's
implementation of the operator.

#### Euclidian division unit

The Euclidian division unit has the syntax `x // y`, where `x` and `y` are
units returning any pair of types that can be coerced to a pair of types for
which `operator//(x, y)` is defined. The return value and side effects are
determined by the implementation of that function. Normally it would yield the
Euclidian quotient of `x` and `y`, i.e. rounded toward negative infinity. This
mirrors Python's implementation of the operator.

#### Modulo unit

The modulo division unit has the syntax `x % y`, where `x` and `y` are
units returning any pair of types that can be coerced to a pair of types for
which `operator%(x, y)` is defined. The return value and side effects are
determined by the implementation of that function. Normally it would yield the
modulus of `x` and `y`, matching the remainder of the Euclidian division unit.
This mirrors Python's implementation of the operator.

#### Addition unit

The addition unit has the syntax `x + y`, where `x` and `y` are units returning
any pair of types that can be coerced to a pair of types for which
`operator+(x, y)` is defined. The return value and side effects are determined
by the implementation of that function. Normally it would yield the sum of `x`
and `y`.

#### Subtraction unit

The subtraction unit has the syntax `x - y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator-(x, y)` is defined. The return value and side effects are determined
by the implementation of that function. Normally it would yield the difference
of `x` and `y`.

#### Left-shift unit

The left-shift unit has the syntax `x << y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator<<(x, y)` is defined. The return value and side effects are determined
by the implementation of that function. Normally it would yield `x`
(arithmically) shifted left by `y` bits.

#### Arithmetic right-shift unit

The arithmetic right-shift unit has the syntax `x >> y`, where `x` and `y` are
units returning any pair of types that can be coerced to a pair of types for
which `operator>>(x, y)` is defined. The return value and side effects are
determined by the implementation of that function. Normally it would yield `x`
arithmically shifted right by `y` bits.

#### Logical right-shift unit

The logical right-shift unit has the syntax `x >> y`, where `x` and `y` are
units returning any pair of types that can be coerced to a pair of types for
which `operator>>>(x, y)` is defined. The return value and side effects are
determined by the implementation of that function. Normally it would yield `x`
logically shifted right by `y` bits.

#### Less-than unit

The less-than unit has the syntax `x < y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator<(x, y)` is defined. The return value and side effects are
determined by the implementation of that function. Normally it would yield a
boolean indicating whether `x` is less than `y`.

#### Less-than-or-equal unit

The less-than-or-equal unit has the syntax `x <= y`, where `x` and `y` are
units returning any pair of types that can be coerced to a pair of types for
which `operator<=(x, y)` is defined. The return value and side effects are
determined by the implementation of that function. Normally it would yield a
boolean indicating whether `x` is less than or equal to `y`.

#### Greater-than unit

The greater-than unit has the syntax `x > y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator>(x, y)` is defined. The return value and side effects are
determined by the implementation of that function. Normally it would yield a
boolean indicating whether `x` is greater than `y`.

#### Greater-than-or-equal unit

The greater-than-or-equal unit has the syntax `x >= y`, where `x` and `y` are
units returning any pair of types that can be coerced to a pair of types for
which `operator>=(x, y)` is defined. The return value and side effects are
determined by the implementation of that function. Normally it would yield a
boolean indicating whether `x` is greater than or equal to `y`.

#### Equality unit

The equality unit has the syntax `x == y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator==(x, y)` is defined. The return value and side effects are determined
by the implementation of that function. Normally it would yield a boolean
indicating whether `x` is equal to `y`.

#### Inequality unit

The inequality unit has the syntax `x == y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator!=(x, y)` is defined. The return value and side effects are determined
by the implementation of that function. Normally it would yield a boolean
indicating whether `x` is not equal to `y`.

#### Bitwise AND unit

The bitwise AND unit has the syntax `x & y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator&(x, y)` is defined. The return value and side effects are determined
by the implementation of that function. Normally it would yield the bitwise AND
of the two operands.

#### Bitwise XOR unit

The bitwise XOR unit has the syntax `x ^ y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator^(x, y)` is defined. The return value and side effects are determined
by the implementation of that function. Normally it would yield the bitwise XOR
of the two operands.

#### Bitwise OR unit

The bitwise OR unit has the syntax `x | y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator|(x, y)` is defined. The return value and side effects are determined
by the implementation of that function. Normally it would yield the bitwise OR
of the two operands.

### Short-circuiting operator units

Unlike cQASM 1.x, "expressions" may have side effects, because everything is a
unit. Therefore, the usual short-circuiting `&&` and `||` operators are now
sensible, as is the ternary conditional operator. The `^^` operator from cQASM
1.x is dropped, as it makes no sense in this context, and unlike C, cQASM 2.0
has no context in which it might find a use (for example, `&&` and `||` in C
also cast the operands to bool, whereas in cQASM 2.0 this must be done
explicitly anyway).

These units are not implemented via functions like regular operators, because
application of a function always triggers analysis and/or evaluation before
the function implementation is involved. Therefore, they cannot be overloaded.

#### Logical AND unit

The logical AND unit has the syntax `x && y`, where `x` and `y` are units
returning `bool`. The semantics are as follows.

 - If `x` is static `false`, `y` is not analyzed, and static `false` is
   returned.

 - Otherwise, if `y` is static `false`, the unit is equivalent to `{x; false}`.
   That is, any side effects of `x` are evaluated at runtime, its result is
   discarded, and `false` is returned instead.

 - Otherwise, if both `x` and `y` are static `true`, static `true` is returned.

 - Otherwise, the operation is evaluated at runtime. If `x` evaluates to
   `false`, `false` is returned and `y` is not evaluated. Otherwise, the result
   of evaluating `y` is returned.

#### Logical OR unit

The logical OR unit has the syntax `x || y`, where `x` and `y` are units
returning `bool`. The semantics are as follows.

 - If `x` is static `true`, `y` is not analyzed, and static `true` is returned.

 - Otherwise, if `y` is static `true`, the unit is equivalent to `{x; true}`.
   That is, any side effects of `x` are evaluated at runtime, its result is
   discarded, and `true` is returned instead.

 - Otherwise, if both `x` and `y` are static `true`, static `true` is returned.

 - Otherwise, the operation is evaluated at runtime. If `x` evaluates to
   `true`, `true` is returned and `y` is not evaluated. Otherwise, the result
   of evaluating `y` is returned.

#### Selection unit

The selection unit has the syntax `x when y else z`. `y` must be a unit
returning `bool`. The semantics are as follows.

 - If `y` is static `true`, `x` is returned, and `z` is not analyzed.

 - Otherwise, if `y` is static `false`, `z` is returned, and `x` is not
   analyzed.

 - Otherwise, `x` and `z` must return exactly the same type, and the
   selection is done at runtime. `y` and its side effects are evaluated first.
   If it yields `true`, `x` is evaluated, and its result is returned, without
   `z` ever being evaluated. Otherwise, `z` is evaluated, and its result is
   returned, without `x` ever being evaluated.

Note that `x` and `z` need not have the same type if the value of `y` is
static.

### Simple assignment unit

The simple assignment unit has the syntax `x = y`, and is used to assign the
value of `x`.

If the unit is evaluated in regular context, `x` must be a unit yielding a
`objname` to a variable object (i.e. not a constant), and `y` must return a
value that can be coerced to the value type of the reference. The semantics
are then that `x` is set to `y` as a "side effect," and the new value of `x` is
returned.

If the unit is evaluated in definition context, a context-sensitive `eqsep`
value is returned, containing the analyzed `x` and `y` units. The `y` unit is
always analyzed in regular context, despite the context that the assignment
unit is analyzed in.

### Increment & decrement units

The increment and decrement units are taken from C++. They are usually a
shorthand notation for adding or subtracting one, but are also defined for
enumerated types, where adding or subtracting an arbitrary amount is not
supported.

#### Post-increment unit

The post-increment unit has the syntax `x++`, where `x` must be an `objname`
referring to a variable (i.e. not a constant) with any value type that can be
coerced to a type for which `operator++(x) -> (x)` is defined. The semantics
are then as follows.

 - A copy is made of the current value in `x`.
 - `operator++(x)` and any of its side effects are evaluated, and `x` is
   assigned to its result as a further side effect.
 - The copy of the original value of `x` is returned.

#### Post-decrement unit

The post-decrement unit has the syntax `x--`, where `x` must be an `objname`
referring to a variable (i.e. not a constant) with any value type that can be
coerced to a type for which `operator--(x) -> (x)` is defined. The semantics
are then as follows.

 - A copy is made of the current value in `x`.
 - `operator--(x)` and any of its side effects are evaluated, and `x` is
   assigned to its result as a further side effect.
 - The copy of the original value of `x` is returned.

#### Pre-increment unit

The pre-increment unit has the syntax `++x`, where `x` must be an `objname`
referring to a variable (i.e. not a constant) with any value type that can be
coerced to a type for which `operator++(x) -> (x)` is defined. The semantics
are then as follows.

 - `operator++(x)` and any of its side effects are evaluated, and `x` is
   assigned to its result as a further side effect.
 - The new value of `x` is returned.

#### Pre-decrement unit

The pre-decrement unit has the syntax `--x`, where `x` must be an `objname`
referring to a variable (i.e. not a constant) with any value type that can be
coerced to a type for which `operator--(x) -> (x)` is defined. The semantics
are then as follows.

 - `operator--(x)` and any of its side effects are evaluated, and `x` is
   assigned to its result as a further side effect.
 - The new value of `x` is returned.

### Mutating assignment units

These units are syntactic sugar for expressions of the form `x = x <op> y` for
various operators.

#### Power-by unit

The power-by unit has the syntax `x **= y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator**(x, y) -> (x)` is defined, `x` being a `reference` to a variable
(not a constant). The semantics are then as follows.

 - `operator**(x, y)` and any of its side effects are evaluated, and `x` is
   assigned to its result as a further side effect.
 - The new value of `x` is returned.

#### Multiply-by unit

The multiply-by unit has the syntax `x *= y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator*(x, y) -> (x)` is defined, `x` being a `reference` to a variable
(not a constant). The semantics are then as follows.

 - `operator*(x, y)` and any of its side effects are evaluated, and `x` is
   assigned to its result as a further side effect.
 - The new value of `x` is returned.

#### True-divide-by unit

The true-divide-by unit has the syntax `x /= y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator/(x, y) -> (x)` is defined, `x` being a `reference` to a variable
(not a constant). The semantics are then as follows.

 - `operator/(x, y)` and any of its side effects are evaluated, and `x` is
   assigned to its result as a further side effect.
 - The new value of `x` is returned.

#### Euclidian-divide-by unit

The Euclidian-divide-by unit has the syntax `x //= y`, where `x` and `y` are
units returning any pair of types that can be coerced to a pair of types for
which `operator//(x, y) -> (x)` is defined, `x` being a `reference` to a
variable (not a constant). The semantics are then as follows.

 - `operator//(x, y)` and any of its side effects are evaluated, and `x` is
   assigned to its result as a further side effect.
 - The new value of `x` is returned.

#### Modulo-by unit

The modulo-by unit has the syntax `x %= y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator%(x, y) -> (x)` is defined, `x` being a `reference` to a variable (not
a constant). The semantics are then as follows.

 - `operator%(x, y)` and any of its side effects are evaluated, and `x` is
   assigned to its result as a further side effect.
 - The new value of `x` is returned.

#### Increment-by unit

The increment-by unit has the syntax `x += y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator+(x, y) -> (x)` is defined, `x` being a `reference` to a
variable (not a constant). The semantics are then as follows.

 - `operator+(x, y)` and any of its side effects are evaluated, and `x` is
   assigned to its result as a further side effect.
 - The new value of `x` is returned.

#### Decrement-by unit

The decrement-by unit has the syntax `x -= y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator-(x, y) -> (x)` is defined, `x` being a `reference` to a
variable (not a constant). The semantics are then as follows.

 - `operator-(x, y)` and any of its side effects are evaluated, and `x` is
   assigned to its result as a further side effect.
 - The new value of `x` is returned.

#### Shift-left-by unit

The shift-left-by unit has the syntax `x <<= y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator<<(x, y) -> (x)` is defined, `x` being a `reference` to a variable
(not a constant). The semantics are then as follows.

 - `operator<<(x, y)` and any of its side effects are evaluated, and `x` is
   assigned to its result as a further side effect.
 - The new value of `x` is returned.

#### Arithmically-shift-right-by unit

The arithmically-shift-right-by unit has the syntax `x >>= y`, where `x` and
`y` are units returning any pair of types that can be coerced to a pair of
types for which `operator>>(x, y) -> (x)` is defined, `x` being a `reference`
to a variable (not a constant). The semantics are then as follows.

 - `operator>>(x, y)` and any of its side effects are evaluated, and `x` is
   assigned to its result as a further side effect.
 - The new value of `x` is returned.

#### Logically-shift-right-by unit

The logically-shift-right-by unit has the syntax `x >>>= y`, where `x` and `y`
are units returning any pair of types that can be coerced to a pair of types
for which `operator>>>(x, y) -> (x)` is defined, `x` being a `reference` to a
variable (not a constant). The semantics are then as follows.

 - `operator>>>(x, y)` and any of its side effects are evaluated, and `x` is
   assigned to its result as a further side effect.
 - The new value of `x` is returned.

#### Bitwise-AND-by unit

The bitwise-AND-by unit has the syntax `x &= y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator&(x, y) -> (x)` is defined, `x` being a `reference` to a variable (not
a constant). The semantics are then as follows.

 - `operator&(x, y)` and any of its side effects are evaluated, and `x` is
   assigned to its result as a further side effect.
 - The new value of `x` is returned.

#### Bitwise-XOR-by unit

The bitwise-XOR-by unit has the syntax `x ^= y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator^(x, y) -> (x)` is defined, `x` being a `reference` to a variable (not
a constant). The semantics are then as follows.

 - `operator^(x, y)` and any of its side effects are evaluated, and `x` is
   assigned to its result as a further side effect.
 - The new value of `x` is returned.

#### Bitwise-OR-by unit

The bitwise-OR-by unit has the syntax `x |= y`, where `x` and `y` are units
returning any pair of types that can be coerced to a pair of types for which
`operator|(x, y) -> (x)` is defined, `x` being a `reference` to a variable (not
a constant). The semantics are then as follows.

 - `operator|(x, y)` and any of its side effects are evaluated, and `x` is
   assigned to its result as a further side effect.
 - The new value of `x` is returned.

### Function call unit

The function call unit has the syntax `x(y)`, where `x` is a unit of type
`funcname`, and `y` is a potentially comma-separated list of units, the return
values of which the function is to be called with.

The semantics depend on the function.

**TODO**

### Block unit

The block unit has the syntax `{x}`, where `x` may one of the following things.

 - Nothing, i.e. `{}`. This is equivalent to `()`.
 - A single unit. This is equivalent to that unit on its own.
 - A semicolon- and/or comma-separated list of units, with semantics described
   below.

Within a block, a semicolon acts as the sequentialization operator, either as
`x; y` or `x;`. In the former case, the side effects of `x` are evaluated,
sequentially followed by the side effects of `y`, and the value returned by `y`
is returned. In the latter case, the side effects of `x` are evaluated, and
null is returned.

Furthermore, a comma acts as the parallelization operator, either as `x, y` or
`x,`. In the former case, the side effects of `x` are evaluated in parallel to
the side effects of `y`, and the value returned by `y` is returned. In the
latter case, the side effects of `x` are evaluated, and null is returned.

Two interpretations are available for the exact definitions of "sequential" and
"parallel".

 - *Unscheduled.* This is the flavor that the average user is expected to
   write as the input to the compiler. In this flavor, there is no defined
   difference between the `;` and `,` separators. That is, the contents of a
   block are always evaluated left-to-right. Thus, something like
   `{X(q[0]), X(q[0])}` is perfectly permissible, even though it is logically
   impossible to perform a gate on the same qubit at the same time. It implies
   that the X gates are simply executed sequentially. A compiler may use the
   difference between `;` and `,` as scheduling hints, but ultimately, the
   schedule is undefined.

 - *Scheduled.* in this flavor:
    - a semicolon separator issues the first primitive of the second unit one
      cycle after the last primitive of the first unit was issued;
    - a comma separator issues the last primitive of the second unit in the
      same cycle the last primitive of the first unit was issued;
    - dependencies of the last primitive of either are always issued in their
      own, private cycle; and
    - evaluation order of the unscheduled interpretation is maintained, except
      for the last primitive of comma-separated units.

   Here, "primitive" means any of the following, including assignment of its
   return value to a variable (if any):
    - a call to a function marked primitive, either explicitly or implicitly
      via operator usage or a coercion;
    - an `if`, `match`, or `foreach` marked primitive;
    - evaluation of a short-circuiting unit;
    - a `goto`, `return`, `break`, `continue`, `send`, `receive`, `print`,
      `abort`, or `pragma` unit;
    - evaluation of `{}` or `()` (no-operation).

   The body of a primitive construct is treated as a behavioral description of
   a single, atomic instruction, and is thus treated as a single node in the
   schedule.

   The construct `runtime foreach (1..N) {}` may be used to skip `N` cycles,
   similar to the `skip` instruction in the default gateset of cQASM 1.x.

Note that the functional behavior of either interpretation is almost identical;
the only difference is that side effects of the last primitives of
comma-separated units in a block are evaluated in a different order compared to
their dependencies; it is up to implementations that convert from one
representation to another to ensure that this does not lead to behavioral
differences, which they would normally ensure anyway, by explicitly scheduling
the unit trees via intermediate value assignments. Ultimately, the main
difference is only that the latter has a defined schedule and the former does
not.

Note also that the rules need to be this complicated to support the full cQASM
2.0 syntax: for example `{x(), {y(); z()}}` (assuming all are marked
`primitive`) reduces to `{y(); x(), z()}` by the above rules, while a simpler
ruleset would fall apart due to the `;` embedded in the `,`. If this seems
contrived, note that this sort of thing is likely to happen for any inlined
function call.

### Conditional units

#### If-elif-else unit

TODO

#### Conditional execution unit

TODO

#### Match unit

TODO

### Looping units

#### For loop unit

TODO

#### Foreach loop unit

TODO

#### While loop unit

TODO

#### Repeat-until loop unit

TODO

### Special statement-like units

#### Goto unit

TODO

#### Return unit

TODO

#### Break unit

TODO

#### Continue unit

TODO

#### Send unit

TODO

#### Receive unit

TODO

#### Print unit

TODO

#### Abort unit

TODO

### Annotation units

#### Annotation operator unit

TODO

#### Pragma unit

TODO

### Object definition units

#### Qubit definition unit

TODO

#### Variable definition unit

TODO

#### Constant definition unit

TODO

### Alias definition unit

TODO

### Function definition units

#### Function declaration unit

TODO

#### Function definition unit

TODO

### Type definition units

#### Sum type definition unit

TODO

#### Derived type definition unit

TODO

### File parameter unit

TODO

### File inclusion unit

TODO

### Context-sensitive grammatical units

#### Template marker unit

TODO

#### Colon-separated unit

TODO

#### Comma-separated unit

TODO

#### Comma suffix unit

TODO

#### Semicolon-separated unit

TODO

#### Semicolon suffix unit

TODO



# TODO


Map<Str, List<Tup<HierarchyLevel scope, HierarchyLevel frame, Value>>> aliases
Stack<HierarchyLevel> frames
Stack<HierarchyLevel> function_frames

frame level 0 (static) is always accessible. frame levels above zero are only
accessible from the current function frame and upwards.



when an alias is made, its frame level is set to the hierarchy level of the
innermost frame

