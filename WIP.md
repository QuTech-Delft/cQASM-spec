cQASM 2.0 toplevel grammar
==========================

Syntax: `<version> <parameter*> <include*> <main>`, where:
 - `<version>` is a version directive;
 - `<generic*>` is a pack of zero or more generic directives;
 - `<include*>` is a pack of zero or more include directives;
 - `<parameter*>` is a pack of zero or more parameter directives;
 - `<main>` is any unit.

The execution model for a cQASM 2.0 file is as follows:
 - for each generic directive, define a constant in file scope with the name
   provided in the directive, set either to the default value provided in the
   directive, or to an externally provided value of the same name;
 - for each include directive, recursively load and evaluate the side effects
   of the cQASM file with the name provided in the directive according to the
   file search rules, with parameters set according to the argument pack in the
   directive, discarding its result;
 - for each parameter directive, define a variable in file scope with the name
   provided in the directive, initialized with externally-provided values at
   runtime;
 - execute the side effects of the main unit and return its result to the
   context that the cQASM 2.0 file is running in.

Version directive
=================

Syntax: `version <version-components>`, where:
 - `<version-components>` is a period-separated list of nonnegative integers.

The first version component for cQASM 2.0 files shall be `2`. Other versions
shall be rejected.

Subsequent version components are reserved for future expansion. They should
be omitted or set to zero for forward-compatibility.

The recommended version directive for cQASM 2.0 files is `version 2.0`.

Generic directive
=================

Syntax: `generic <name> [: <type>] [= <default>];`, where:
 - `<name>` is the identifier that will be added to file scope to refer
   to the generic;
 - `<type>` is a typename unit that optionally specifies the type of the
   generic, which must be a static type;
 - `<default>` is a statically instantiable unit that optionally specifies the
   default value for the generic.

Either `<type>` or `<default>` must be specified.

If both `<type>` and `<default>` are specified, `<default>` must return a type
that is equal to or can be promoted to `<type>`.

If `<type>` is specified but `<default>` is not, the default value for the
generic is implicitly the default value for the type.

If `<default>` is specified but `<type>` is not, the type of the generic will
be the type of value returned by `<default>`.

The generic directive defines a constant in file scope set to either:
 - a value for the generic externally specified at compile-time, associated
   using `<name>`; or
 - the default value, if no value is externally specified.

If a generic value is externally specified, a `generic` with matching name must
exist.

Include directive
=================

Syntax: `include <filename>[(<binding*>)]`, where:
 - `<filename>` is a static unit of type `string` identifying the file to
   include;
 - `<binding*>` is an optional, comma-separated list of zero or more bindings,
   each with syntax `<name> => <value>`, where:
    - `<name>` is an identifier mapping to a generic defined in the included
      file;
    - `<value>` is a static unit of a type that can be promoted to the type
      expected by the generic of the included file.

It is illegal to include a cQASM 2.0 file with one or more parameters.

The return value of an included cQASM 2.0 file is discarded.

Parameter directive
===================

Syntax: `parameter <name>: <type>;`, where:
 - `<name>` is the identifier that will be added to file scope to refer
   to the parameter;
 - `<type>` is a typename unit that specifies the type of the parameter, which
   must be a runtime type.

When a cQASM 2.0 file is run, an argument pack exactly matching the types of
the parameters must be available.

Units
=====

A *unit* is a grammatical construct that may have one or more of the following
effects on the program or its context:
 - it must *return* a value of some type, where the type shall be determinable
   at compile-time without context;
 - it may have *side effects*, with or without explicit schedule (i.e. it may
   affect the runtime state of the algorithm);
 - it may add variable, constant, alias, function, and/or operator
   *definitions* to the surrounding, parent, or global scope, where the
   type or signature shall be determinable at compile-time without context.

> Units always return a value for consistency. However, the type of that value
> can be a pack of zero subtypes, `()`, similar to `void` in C.

A *runtime instantiable* unit is a unit that returns a runtime type.

A *statically instantiable* unit is a unit that returns a static type.

A *static* unit is a statically instantiable unit with the following
constraints:
 - the return value is determinable during constant propagation;
 - the unit has no side effects;
 - the unit has no definitions.

A *typename* unit is a static unit that returns a value of type `typename`, or
(recursively) a `pack` of `typename`.

A *scalar* unit is a unit returning a type other than `csep` or `scsep`.

An *expression* unit is a scalar unit that does not define anything in the
surrounding or global scope (but may define things in subscopes).

Void unit
---------

Literal for the null value of type void.

Syntax: `()` or `{}`.

Return type: void (that is, a `pack` with zero elements).

Return value: null (that is, the sole placeholder value for the above).

Side effects: none.

Definitions: none.

Decimal integer literal unit
----------------------------

Allows integer literals to be specified in decimal format.

Syntax: matching regex `[0-9][0-9_]*`.

Return type: `int`.

Return value: an integer literal with the specified value.

Side effects: none.

Definitions: none.

Embedded underscores are ignored. They can be used to make long integers more
readable.

The integer must be between 0 and 2^63-1 inclusive.

> Negative integers are normally constructed via constant propagation through
> the unary minus operator. -2^63 is a bit more complicated; it can only be
> specified using hexadecimal notation or by means of more complex expressions.

Hexadecimal integer literal unit
--------------------------------

Allows integer literals to be specified in hexadecimal format.

Syntax: matching regex `0x[0-9a-fA-F_]+`.

Return type: `int`.

Return value: an integer literal with the specified value.

Side effects: none.

Definitions: none.

Embedded underscores are ignored. They can be used to make long integers more
readable.

The integer must be between 0 and `0xFFFF_FFFF_FFFF_FFFF` inclusive. The value
is interpreted as a 64-bit two's-complement integer.

Binary integer literal unit
---------------------------

Allows integer literals to be specified in binary format.

Syntax: matching regex `0b[01_]+`.

Return type: `int`.

Return value: an integer literal with the specified value.

Side effects: none.

Definitions: none.

Embedded underscores are ignored. They can be used to make long integers more
readable.

The integer must be between 0 and
`0b11111111_11111111_11111111_11111111_11111111_11111111_11111111_11111111`
inclusive. The value is interpreted as a 64-bit two's-complement integer.

Real number literal unit
------------------------

Allows real numbers to be specified.

Syntax: matching regex `([0-9][0-9_]*)?\.[0-9][0-9_]*([eE][-+]?[0-9]+)?`.

Return type: `real`.

Return value: a real-number literal with the specified value.

Side effects: none.

Definitions: none.

Embedded underscores are ignored. They can be used to make long numbers more
readable.

If the number is not representable in IEEE 754 binary64, it is silently rounded
to the nearest representable value.

> Negative reals are constructed via constant propagation through the unary
> minus operator. Complex numbers are constructed similarly using binary
> operators and the imaginary unit, predefined as `im`.

String literal unit
-------------------

Allows strings to be specified.

Syntax: `"<body>"`, where `<body>` is a sequence of:
 - any character other than `"` and `\`, interpreted literally;
 - `\\`, interpreted as a `\`;
 - `\t`, interpreted as a horizontal tab;
 - `\n`, interpreted as a line feed on Linux and Mac, and as a carriage return
   followed by a line feed on Windows;
 - `\'`, interpreted as `'`;
 - `\"`, interpreted as `"`;
 - a `\` followed by a line feed, carriage return, carriage-return line-feed
   sequence, tab, interpreted as an empty substring;
 - `\u` followed by four hexadecimal digits, interpreted as the corresponding
   UTF-8 code point.

Return type: `string`.

Return value: a string literal with the specified value.

Side effects: none.

Definitions: none.

JSON literal unit
-----------------

Allows JSON objects to be specified inline.

Syntax: `{|<json>|}`, where `<json>` follows the JSON specification, with
implicit `{` prefix and `}` suffix.

Return type: `json`.

Return value: a JSON object literal with the specified value.

Side effects: none.

Definitions: none.

Reference unit
--------------

Allows things existing in the current scope to be referenced.

Syntax: matching regex `[a-zA-Z_][a-zA-Z0-9_]*` (an identifier).

Return type: anything, depending on what the name resolves to.

Return value: anything, depending on what the name resolves to.

Side effects: anything, depending on what the name resolves to.

Definitions: none.

Names are resolved by searching for the latest case-sensitively matching alias
in the current scope or its ancestors. Any expression unit can be aliased,
therefore the return type, return value, and side effects are unknown until the
alias is resolved.

> Note: all definitions create aliases for themselves. That's just how name
> resolution is implemented. `alias` is just the most generic form that the
> user has direct access to. For example, a function definition creates (or
> adds to, in case of an overload) an alias referring to a "literal" `function`
> value, variable definitions create an alias referring to a "literal"
> `reference` value witout indexing, and so on.

> Note: `qref` and `reference` are two different things. You can have a
> reference to a `qubit`, or a reference to a `qref`. To be clear:
>
>  - a variable of type `qubit` represents an actual qubit, either already
>    physical, or a virtual qubit to be mapped to a physical qubit;
>  - a `reference` to a `qubit` variable represents a compile-time reference
>    to that variable, or an index thereof (note that the index might be
>    statically known, but might also be a dynamic expression of some kind);
>  - a variable/constant/parameter of type `qref` represents a link to a qubit
>    that can potentially be mutated at runtime via assignment statements (if
>    non-constant);
>  - a `reference` to a `qref` variable represents a compile-time reference to
>    the above.
>
> Note in particular that `reference` is an internal type of which the values
> are only used to communicate links to storage locations at compile-time,
> while a `qref` is something that exists at runtime.

Whenever a name does not resolve to anything currently in scope, an
`unresolved` for the name is returned instead.

Operator reference unit
-----------------------

Allows operator functions to be referenced.

Syntax: `operator <op>`, where `<op>` is one of the overloadable unary or
binary operator tokens: `~`, `!`, `*`, `**`, `/`, `//`, `%`, `+`, `-`, `<<`,
`>>`, `>>>`, `<`, `<=`, `>`, `>=`, `==`, `!=`, `&`, `^`, `^^`, or `|`.

> Note: assignments and the short-circuiting operators cannot be overloaded
> or referenced this way.

Return type: `function`.

Return value: a "literal" `function` value that refers to all available (i.e.
in-scope) overloads for the given operator.

Side effects: none.

Definitions: none.

Same behavior as a regular reference unit, except the function name searched
for is `operator<op>`.

One-dimensional packing unit
----------------------------

For constructing packed literals.

Syntax: `(<unit>)`, where `<unit>` is an expression unit returning `csep` of
scalars.

Return type: the `csep` type converted to a `pack`.

Return value: the `csep` value converted to a `pack`.

Side effects: the side effects of `<unit>`.

Definitions: none.

Two-dimensional packing unit
----------------------------

For constructing two-dimensional packed literals more elegantly than what is
possible with just the one-dimensional packing unit.

Syntax: `(<unit>)`, where `<unit>` is an expression unit returning `scsep` of
`csep` or scalars.

Return type: the `scsep` type converted to a `pack` of `pack`s.

Return value: the `scsep` value converted to a `pack` of `pack`s.

Side effects: the side effects of `<unit>`.

Definitions: none.

> I'm not sure how to formally define this one in prose, but the idea is that
> `(1; 2)` is equivalent to/shorthand for `((1,), (2,))`, i.e. a row vector.

One-dimensional unpacking unit
------------------------------

For allowing `pack`s and `tuple`s to be used in contexts where a
comma-separated construct (`csep`) is expected.

Syntax: `*<unit>`, where `<unit>` is an expression unit returning a `pack` or
`tuple`.

Return type: the elements of the `tuple`/`pack` as a `csep`.

Return value: the elements of the `tuple`/`pack` as a `csep`.

Side effects: the side effects of the `tuple`/`pack`.

Definitions: none.

> This is useful for (at least) two things.
>
>  - Functions evaluated piecewise return a tuple, where evaluation of each
>    tuple element results in the side effects of the function call. Normally,
>    this will result in sequential evaluation of the individial functions.
>    When such a piecewise function call is inside a block and `*` is prefixed,
>    however, the side effects of the functions will be executed in parallel,
>    just like any other comma-separated set of units in a block.
>  - A `pack` or `tuple` may be used to specify the argument pack of a function
>    directly. For example, `const a = (0, 3, 2); max(*a)` will look for the
>    function `max` with 3 integer arguments, rather than a single argument of
>    type `int[3]`.

Two-dimensional unpacking unit
------------------------------

> Note: this is sort of the logical amalgamation of the two-dimensional packing
> unit and the one-dimensional unpacking unit. But I'm not sure if the
> construct would be useful anywhere currently.

For allowing `pack`s and `tuple`s of `pack`s/`tuple`s to be used in contexts
where a semicolon- and comma-separated construct (`scsep` of `csep`) is
expected.

Syntax: `**<unit>`, where `<unit>` is an expression unit returning a `pack` or
`tuple`, each returning a `pack` or `tuple` of its own.

Return type: the elements of the two-dimensional `tuple`/`pack` as an `scsep`
of `csep`.

Return value: the elements of the two-dimensional `tuple`/`pack` as an `scsep`
of `csep`

Side effects: the side effects of the two-dimensional `tuple`/`pack`.

Definitions: none.

Range unit
----------

Allows numerical ranges to be specified intuitively.

Syntax: `<from> .. <to>`, where `<from>` and `<to>` are static units returning
the same, enumerable type.

Return type: a tuple of size |`<from>` - `<to>`| + 1 with element type
corresponding to `<from>`/`<to>`.

Return value: the values in the type of `<from>`/`<to>` from `<from>` to `<to>`
inclusive, with order depending whether `<from>` is less than or greater than
`<to>` (note that the order does not matter when `<from>` == `<to>`).

Side effects: none.

Definitions: none.

Block unit
----------

Allows explicit specification of sequential and parallel code, as well as
providing a scope for definitions.

Syntax: `{<unit>}`, where `<unit>` is a scalar unit, a unit returning `csep` of
scalars, or a unit returning `scsep` of `csep` or scalars.

Return type:
 - if `<unit>` is scalar, returns the type returned by `<unit>`;
 - if `<unit>` is non-scalar, returns the type returned by the final entry in
   the comma- and/or semicolon-separated list.

Return value:
 - if `<unit>` is scalar, returns the value returned by `<unit>`;
 - if `<unit>` is non-scalar, returns the value returned by the final entry in
   the comma- and/or semicolon-separated list.

Side effects: the side effects of subunits from left to right, sequentially for
semicolon-separated units, and (issued) in parallel for comma-separated units.

Definitions: the *exported* definitions of `<unit>` as regular (non-exported)
definitions, and global definitions of `<unit>` as global definitions.

> Note that the comma replaces the pipe for explicit parallelism. The pipe was
> always an issue grammatically for the precedence rules, because it's also
> used for the bitwise OR operator.

When two units affect the same variable or other state simultaneously, the
effect on that variable is *undefined*: it may result in a runtime- or
compile-time error, some combination of the results of the simultaneous state
updates, or *any* other value. However, the state of unaffected variables in
the same cycle/program shall remain unaffected, except when these variables
refer to hardware registers used for runtime exception handling.

Grouping parentheses unit
-------------------------

For overriding/bypassing operator precedence rules.

Syntax: `(<unit>)`, where `<unit>` is any scalar unit.

Return type: the return type of `<unit>`.

Return value: the return value of `<unit>`.

Side effects: the side effects of `<unit>`.

Definitions: the definitions of `<unit>`.

Constructor unit
----------------

Allows explicit construction of the default value of a type.

Syntax: `<type>()`, where `<type>` is a typename unit.

Return type: the type specified by `<type>`.

Return value: the default value for the type specified by `<type>`.

Side effects: the side effects of `<value>`.

Definitions: none.

If `<type>` refers to a scalar type, the function resolver will look for a
function or operator with a name identical to the name of `<type>`, with a
signature accepting zero arguments.

If `<type>` refers to a product type, the elements of the product type are
individually constructed as per the above rule.

Typecast unit
-------------

Allows explicit typecasting (as opposed to implicit promotions).

Syntax: `<type>(<value>)`, where:
 - `<type>` is a typename unit;
 - `<value>` is the expression unit to be typecast.

Return type: the type specified by `<type>`.

Return value: the return value of `<value>` cast to `<type>`.

Side effects: the side effects of `<value>`.

Definitions: none.

If `<type>` refers to a scalar type, the function resolver will look for a
function or operator with a name identical to the name of `<type>`, with a
signature that accepts `<value>` as argument.

If `<type>` refers to a product type, `<value>` must have the same
dimensionality as the `<type>`. The scalars that `<value>` is comprised of are
then cast individually as per the above rule.

Function call unit
------------------

Allows function overloads to be resolved and called.

Syntax: `<function>([<args>])`, where:
 - `<function>` is a static unit of type `function`;
 - `<args>` is an optional expression unit that returns either a scalar or
   `csep` of scalars, representing the arguments of the function.

Return type: determined by the return type of the resolved function.

Return value: determined by the resolved function.

Side effects: the side effects of `<args>` from left to right, followed by the
side effects of the resolved function.

Definitions: none.

The `function` type refers to a number of identically-named functions that
accept different argument packs (i.e., function overloads). The function used
for evaluation shall be the most recently defined overload for which all
`<args>` promote to the types expected by the overload. If no such overload
exists, and all comma-separated elements of `<args>` are either a `tuple` or
a `pack` of size N, overload resolution is retried piecewise. This is done
recursively until an overload is found or one or more of the `<args>` have
no remaining dimensions. If any of the piecewise-evaluated `<args>` is a
`pack`, the result for that dimension will be a `pack`; otherwise it will be a
`tuple`. If all the resolved functions are `primitive`, they are to be executed
in parallel, as if they were individual comma-separated function calls in a
block.

Indexing unit
-------------

Allows `pack`s and `tuple`s to be indexed, sliced, and swizzled.

Syntax: `<value>[<index>]`, where:
 - `<value>` is the to-be-indexed expression unit, which must be of type `pack`
   or `tuple`, or a `reference` thereof;
 - `<index>` is the index, which must be either:
    - an expression unit returning a type that promotes to `int` or an
      N-dimensional tuple thereof;
    - a `csep` of the above, of at most the number of elements as `<value>` has
      dimensions.

> Note the ambiguity in the syntax notation here... the `[]` are explicit in
> the syntax rather than denoting that `<index>` is optional (it is mandatory).

Return type:
 - if (the comma-separated subunits in) `<index>` promote(s) to a single
   integer, the type of `<value>`, with outer dimensions stripped as per
   the number of comma-separated subunits;
 - if (the comma-separated subunits in) `<index>` promote(s) to a tuple of
   integers, a tuple with the same shape as the `<index>` subunits of the
   type of `<value>`, with outer dimensions stripped as per the number of
   comma-separated subunits.

Return value: same logic as above. Each comma-separated element of `<index>`
indexes or slices a dimension of `<value>`, starting with the outermost
dimension, using zero-based indices.

Side effects: the side effects of `<value>`, followed by the side effects of
`<index>`.

Definitions: none.

The shapes of the comma-separated index tuples must be identical.

If `<value>` is a `pack` (or a `tuple` of `pack`s for the affected dimensions),
`<index>` must be a static unit, of which the elements may not be tuples.

All indices must be between 0 and the size of the associated dimension of
`<value>` (exclusive). When the index is static, this is checked at
compile-time. When the index is non-static, behavior for out-of-range indices
is undefined.

> Some examples:
>
>  - `(1, 2, 3, 4, 5)[3]` returns `4`.
>  - `(1, 2, 3, 4, 5)[(3,)]` returns `(4,)`.
>  - `(1, 2, 3, 4, 5)[(3, 2)]` returns `(4, 3)`.
>  - `(1, 2, 3, 4, 5)[(3; 2)]` returns `(4; 3)` (aka `((4,), (3,))).
>  - `(1, 2; 3, 4)[0]` returns `(1, 2)`.
>  - `(1, 2; 3, 4)[0, 1]` returns `2`.
>  - `(1, 2; 3, 4)[(1, 0), (0, 1)]` returns `(3, 2)`.
>
> Note also that `x[a, b, ...]` behaves identically to `x[a][b]...`.

Transposed indexing unit
------------------------

Allows `pack`s and `tuple`s to be indexed, sliced, and swizzled.

Syntax: `<value>[transpose <index>]`, where:
 - `<value>` is the to-be-indexed expression unit, which must be of type `pack`
   or `tuple`, or a `reference` thereof;
 - `<index>` is the index, which must be either:
    - an expression unit returning a type that promotes to `int` or a
      1-dimensional tuple thereof, with a size of at most the dimensionality of
      `<value>` (a single `int` is treated as a one-tuple of type `int`);
    - a `csep` of the above;
    - an `scsep` of the above.

> Note the ambiguity in the syntax notation here... the `[]` are explicit in
> the syntax rather than denoting that `transpose <index>` is optional (it is
> mandatory).

Return type: a tuple of the shape defined by the shape of the
semicolons/commas as it would be in the tuple unit, with the element type
of `<value>`, with outer dimensions stripped as per the tuple size of
the elements of `<index>`.

Return value: same logic as above. Every N-tuple in `<index>` represents an
N-dimensional index into `<value>`. If there are multiple of these index
tuples, they are composed into a one- or two-dimensional tuple of the shape
of `<index>`.

> Note that `x[*a, b; c, d]` is ultimately just sugar for
> `(x[a], x[b]; x[c], x[d])`, but with the side effects of `x` only evaluated
> once.

Side effects: the side effects of `<value>`, followed by the side effects of
`<index>`.

Definitions: none.

If one of the index elements is an N-`tuple`, all of them must be an N-`tuple`.

If `<value>` is a `pack` (or a `tuple` of `pack`s for the affected dimensions),
`<index>` must be a static unit, and `<index>` must be scalar (no comma- or
semicolon-separated elements).

Tuple type unit
---------------

Allows tuple *types* to be constructed.

Syntax: `<type>[[<size>|*]]`, where:
 - `<type>` is typename unit;
 - `<size>` is an optional static unit that promotes to `int` or a `csep`
   thereof.

> Note the ambiguity in the syntax notation here... the outer `[]` are explicit
> in the syntax, the inner `[]` imply that `<size>` or `*` are optional.

Return type: `typename`.

Return value: depends on `<size>`/`*`:
 - if not specified (i.e. `<type>[]`), a `tuple` type with unbound size is
   returned;
 - if an asterisk is specified (i.e. `<type>[*]`), a `tuple` type with unbound
   size is returned, marked as being a vararg tuple (this is only to be used in
   function prototype specifications);
 - if a single `int` (e.g. `<type>[3]`), a `tuple` type consisting of `<size>`
   elements of type `<type>` is returned;
 - if multiple comma-separated `int`s (e.g. `<type>[3, 4]`), the effect is the
   same as recursive application of the tuple type unit with the integers from
   left to right. That is, the above example is identical to `<type>[3][4]`.

Side effects: none.

Definitions: none.

Unary expression unit
---------------------

Allows unary expressions to be applied to expressions.

Syntax: `<unop> <unit>`, where:
 - `<unop>` is one of `-`, `+`, `!`, or `~`;
 - `<unit>` is any scalar expression unit.

Return type: determined by the return type of the resolved operator.

Return value: determined by the resolved operator.

Side effects: the side effects of `<unit>`, followed by the side effects of the
resolved operator.

Definitions: none.

Operators are resolved via function overload resolution. The resolver looks for
a function with a signature matching `operator<unop>(<unit>)` and applies it as
if it were a normal function call.

Regular binary expression unit
------------------------------

Allows binary expressions to be applied to expressions.

Syntax: `<lhs> <binop> <rhs>`, where:
 - `<lhs>` and `<rhs>` are any scalar expression unit;
 - `<binop>` is one of `*`, `**`, `/`, `//`, `%`, `+`, `-`, `<<`, `>>`, `>>>`,
   `<`, `<=`, `>`, `>=`, `==`, `!=`, `&`, `^`, `^^`, `|`.

Return type: determined by the return type of the resolved operator.

Return value: determined by the resolved operator.

Side effects: the side effects of `<lhs>`, followed by the side effects of
`<rhs>`, followed by the side effects of the resolved operator.

Definitions: none.

Operators are resolved via function overload resolution. The resolver looks for
a function with a signature matching `operator<binop>(<lhs>, <rhs>)` and
applies it as if it were a normal function call.

Short-circuiting AND unit
-------------------------

Special cased binary AND operator with short-circuiting behavior.

Syntax: `<lhs> && <rhs>`, where `<lhs>` and `<rhs>` are scalar expression units
returning a value of type `bool`.

Return type: `bool`.

Return value: the logical AND of the values returned by `<lhs>` and `<rhs>`.

Side effects: the side effects of `<lhs>`, only followed by the side effects of
`<rhs>` if `<lhs>` evaluated to true.

Definitions: none.

Short-circuiting OR unit
------------------------

Special cased binary OR operator with short-circuiting behavior.

Syntax: `<lhs> || <rhs>`, where `<lhs>` and `<rhs>` are scalar expression units
returning a value of type `bool`.

Return type: `bool`.

Return value: the logical OR of the values returned by `<lhs>` and `<rhs>`.

Side effects: the side effects of `<lhs>`, only followed by the side effects of
`<rhs>` if `<lhs>` evaluated to false.

Definitions: none.

Ternary conditional unit
------------------------

Ternary conditional operator with short-circuiting behavior. Essentially this
is shorthand for if-else.

Syntax: `<cond> ? <a> : <b>`, where:
 - `<cond>` is a scalar expression unit returning a value of type `bool`;
 - `<a>` and `<b>` are scalar expression units with no definitions.

Return type: the type returned by `<a>` if `<cond>` evaluates to true, or the
type returned by `<b>` if `<cond>` evaluates to false.

Return value: the value returned by `<a>` if `<cond>` evaluates to true, or the
value returned by `<b>` if `<cond>` evaluates to false.

Side effects: the side effects of `<cond>`, followed by the side effects of
*either* `<a>` or `<b>`, depending on `<cond>`.

Definitions: none.

If `<cond>` is not static, `<a>` and `<b>` must be of the exact same type;
there is no logic to determine a type that all subtypes can promote to.

Assignment unit
---------------

Allows variables to be assigned or modified.

Syntax: `<lhs> <assignop> <rhs>`, where:
 - `<lhs>` is a static unit of type `reference` (note that static reference
   values may include non-static indices), referring to a variable with a
   non-quantum type, or a `pack`, or `tuple` thereof;
 - `<assignop>` is one of `=`, `*=`, `**=`, `/=`, `//=`, `%=`, `+=`, `-=`,
   `<<=`, `>>=`, `>>>=`, `&=`, `^=`, or `|=`;
 - `<rhs>` is an expression unit.

Return type: `reference`.

Return value: `<lhs>` (logically referring to the values *after* the assignment
took place).

Side effects: the side effects of `<rhs>`, followed by a side effect depending
on `<assignop>`:
 - if `=`, the variable or variables referenced by `<lhs>` is/are set to the
   scalar or appropriately sized `pack`/`tuple` value returned by `<rhs>`;
 - if `<binop>=`, the variable or variables referenced by `<lhs>` is/are
   updated using the scalar or appropriately sized `pack`/`tuple` value
   returned by `<rhs>`, by application of `operator<binop>` with appropriate
   LHS and RHS.

Definitions: none.

A modifying assignment is only legal when the resolved operator overload
returns a value of the same type as its left-hand side.

Declaration unit
----------------

Used in variable, constant, alias, and function parameter specifications to
combine a name and a type.

Syntax: `<name>: <type>`, where:
 - `<name>` is a static unit that promotes to `unresolved`;
 - `<type>` is a typename unit.

Return type: `declaration`.

Return value: a declaration with the given name and type.

Side effects: none.

Definitions: none.

Initialization/default unit
---------------------------

Allows declarations to be given an initial or default value.

Syntax: `<decl> = <init>`, where:
 - `<decl>` is a static unit of type `declaration` with no previously bound
   default value;
 - `<init>` is an expression unit.

Return type: `declaration`.

Return value: the original declaration with initial value attached.

Side effects: the side effects of `<init>`.

Definitions: none.

> Note that in the grammar this is the same rule as an assignment statement.
> They are disambiguated based on the type of the left-hand side.

Variable definition unit
------------------------

Allows variables to be defined.

Syntax: `[export|global] [static] [primitive] var <decl>`, where:
 - the `export` keyword indicates that the variable should be declared in the
   parent scope rather than the current scope;
 - the `global` keyword indicates that the variable should be declared in the
   global scope rather than the current scope;
 - the `static` keyword indicates that the variable should be bound to
   statically allocated program memory rather than the current stack frame;
 - the `primitive` keyword indicates that the variable refers to a physical
   resource on the target, that the compiler should recognize by name or by
   means of annotations;
 - `<decl>` is a unit of type `declaration` or `csep` thereof.

Return type: void.

Return value: null.

Side effects: the side effects of `<decl>`.

Definitions:
 - (a) variable(s) of the type(s) specified in `<decl>` are allocated in the
   current stack frame (if any, and `static` is not specified) or globally;
 - the name of `<decl>` is defined as an alias for the reference to the
   constructed variable in either the current, parent, or global scope.

`export` is illegal in the outermost scope of a function body.

`global` implies `static` (that is, `static` may be omitted for `global`
variables).

`primitive` implies `static` (that is, `static` may be omitted for `primitive`
variables).

The `static` keyword is no-op when the variable definition is not inside a
function body.

> Note that `global`/`export` and `static` control different things: the former
> controls the *visibility* of the variable, while `static` controls whether it
> is allocated globally or on the stack frame of the current function. It is
> always no-op for targets that don't support stack frames or function
> recursion, as in this case everything can be allocated globally.

Either `<type>` or `<init>` must be specified.

If both `<type>` and `<init>` are specified, `<init>` must return a type
that is equal to or can be promoted to `<type>`.

If `<type>` is specified but `<init>` is not, the initial value for the
variable is implicitly the default value for the type.

> If a compiler determines that a variable needs no initialization because it
> is never used before it is assigned, and wants to indicate this in an export
> of its IR back to cQASM 2.0, it must use an annotation to do so.

If `<init>` is specified but `<type>` is not, the type of the variable will
be the type of value returned by `<init>`.

Constant definition unit
------------------------

Allows constants to be defined.

Syntax: `[export|global] const <name> [: <type>] = <value>`, where:
 - the `export` keyword indicates that the constant should be declared in the
   parent scope rather than the current scope;
 - the `global` keyword indicates that the constant should be declared in the
   global scope rather than the current scope;
 - `<name>` is the identifier that will be added to the target scope to refer
   to the constant;
 - `<type>` is a typename unit that optionally specifies the type of the
   constant, which must be a static type;
 - `<value>` is a static unit that specifies the value of the constant.

Return type: void.

Return value: null.

Side effects: none.

Definitions: `<name>` is defined as an alias to a literal node representing the
value returned by `<value>` in either the current, parent, or global scope.

`export` is illegal in the outermost scope of a function body.

If `<type>` is specified, `<value>` must return a type that is equal to or can
be promoted to `<type>`. Otherwise, the constant assumes the type returned by
`<value>`.

Alias unit
----------

Allows aliases to be defined.

Syntax: `[export|global] alias <name> [: <type>] = <value>`, where:
 - the `export` keyword indicates that the alias should be declared in the
   parent scope rather than the current scope;
 - the `global` keyword indicates that the alias should be declared in the
   global scope rather than the current scope;
 - `<name>` is the identifier that will be added to the target scope to refer
   to the value;
 - `<type>` is a typename unit that optionally specifies the type of the
   aliased expression unit;
 - `<value>` is the aliased expression unit.

Return type: void.

Return value: null.

Side effects: none.

Definitions: `<name>` is defined as an alias for `<value>` in either the
current, parent, or global scope.

`export` is illegal in the outermost scope of a function body.

`global` is illegal in any scope residing inside a function body.

`<value>` is analyzed during evaluation of the alias unit. That is, constant
propagation and name resolution is performed immediately. However, the
resulting expression, along with its side effects, are evaluated every time
the alias is referenced.

Function declaration unit
-------------------------

Allows functions to be declared before they are defined.

Syntax: `future function <name> ([<types>]) [-> (<return>)]`, where:
 - `<name>` is either an identifier, the `operator` keyword followed by
   an overloadable operator token (operator overload), or the `operator`
   keyword followed by an identifier (custom promotion rule);
 - `<types>` is an optional static typename unit, declaration unit, or a `csep`
   thereof, representing the function paramater pack for overload resolution,
   where each type must be static or runtime, and must not be quantum;
 - `<return>` is an optional static typename unit representing the return
   type for the function.

Return type: void.

Return value: null.

Side effects: none.

Definitions: one of the following:
 - if `<name>` exists in the current scope and is a `typename` alias to a
   user-defined type, the function must take either no argument (default
   constructor) or one argument (identity, promotion, or typecast function),
   and adds or replaces the default constructor/identity/promotion/typecast
   function for that type;
 - if `<name>` exists in a parent scope and is a `typename` alias, an error
   is thrown by the parser;
 - if `<name>` exists in the current scope and is a `function` alias, a
   reference to the declared function overload is added to it;
 - if `<name>` exists in a parent scope and is a `function` alias, a new
   alias is added in the current scope with the overloads inherited from the
   parent scope and this overload added to it;
 - if `<name>` exists in the current or a parent scope but is not a `function`
   alias, or `<name>` does not exist in any visible scope, a new alias is added
   in the current scope that refers to the declared overload.

In the above, `<name>` is `operator<op>` for operator overloads, or the name of
the resulting type for promotion rules.

If `<return>` is not specified:
 - for normal functions, void is implied (i.e. `-> ()`);
 - for operators, the type of the first argument is implied;
 - for constructors, promotion rules, and typecasts, the name of the function
   is also the name of the implied return type.

The return type for constructors, promotion rules, and typecasts must match the
name of the function.

Function definition unit
------------------------

Allows functions to be defined.

Syntax: `[export|global] [inline|runtime|primitive] function <name> [<annot>] ([<types>]) [-> (<return>)] <body>`,
where:
 - the `export` keyword indicates that the function should be declared in the
   parent scope rather than the current scope;
 - the `global` keyword indicates that the function should be declared in the
   global scope rather than the current scope;
 - the `inline` keyword indicates that the function *must* be inlined during
   constant propagation (i.e., the function call will be replaced with the
   function body, with parameters replaced with arguments where appropriate;
   it thus behaves a bit like a type-safe C macro);
 - the `runtime` keyword indicates that the function *must* be evaluated at
   runtime via a classical call instruction (i.e., a compiler must generate
   an error if this is impossible, and it should never inline the function
   call);
 - the `primitive` keyword indicates that the function *must* map to a single,
   atomic, potentially parallelizable instruction in hardware (i.e., a
   compiler must generate an error if no instructions implementing the body
   exists, and aside from this pattern matching, the statement should only
   ever be interpreted by simulators);
 - `<name>` is an identifier;
 - `<annot>` consists of zero or more annotation objects of the form
   `@<iface>.<oper>([<expr>])` (this is syntactic sugar for applying the
   annotation unit to the function definition for each annotation);
 - `*`: if specified, at least one parameter must be specified, and the last
   parameter must be of a `tuple` type with undefined size, representing a
   variable number of arguments;
 - `<types>` is an optional static typename unit or a `csep` thereof,
   representing the function paramater pack for overload resolution, where each
   type must be static or runtime, and must not be quantum;
 - `<return>` is an optional static typename unit representing the return
   type for the function;
 - `<body>` is any unit (usually a block) returning a value of a type that can
   be promoted to the function return type.

Return type: void.

Return value: null.

Side effects: none.

Definitions:
 - If this particular overload was previously declared using a function
   declaration unit, the alias is left as-is, but the body and
   `inline`/`runtime`/`primitive` attribute is attached accordingly. A mismatch
   in return type results in an error.
 - Furthermore, one of the following:
    - If non-`export`, non-`global`, and the function has not been declared
      yet, the same rules as defined for function declarations are applied, but
      the function is also immediately defined;
    - If `export`, the same rules as defined for function declarations are
      applied, but using the parent scope rather than the current one, and the
      function is also immediately defined.
    - If `global`, the same rules as defined for function declarations are
      applied, but using the global scope rather than the current one, and the
      function is also immediately defined.

If `<return>` is not specified, the same defaults are applied as defined for
function declarations.

The return type for constructors, promotion rules, and typecasts must match the
name of the function.

If `<body>` contains `return` units, the returned value must be promotable to
the return type of the function.

> Notes on the different kinds of functions...
>
>  - `function bla()` is a normal function. It can only be called explicitly.
>  - `function bla*(x: int[])` is a normal function that takes a
>    one-dimensional tuple with any number of integer arguments. For example,
>    the signature of the builtin `max` function is
>    `inline function max*(a: int, b: int[])`, allowing the maximum of 1, 2, 3,
>    etc. integers to be determined with one function definition.
>  - `function <type>()` is the default constructor function for user-defined
>    type `<type>`. It is called whenever a default value is needed for the
>    type.
>  - `function <type>(<type>)` is the identity function for user-defined
>    type `<type>`. It is only called by simulators and during constant
>    propagation whenever a value of that type is created or mutated, except
>    when this is done inside the body of this function. It can be used for
>    range-checking or handling overflow.
>  - `function <dest>(<src>)` is a typecast function from type `<src>` to type
>    `<dest>`. It is used by typecast units.
>  - `function operator <dest>(<src>)` works the same as above, but also
>    defines an *implicit* promotion rule, allowing `<src>` to be used in any
>    context where `<dest>` is needed by implicit application of this function.
>  - `function operator<unop>(<expr>)` defines a unary operator overload.
>  - `function operator<binop>(<lhs>, <rhs>)` defines a binary operator
>    overload.

Type definition unit
--------------------

Allows types to be defined.

Syntax: `[export|global] [primitive] type <name> = <parent>` or `... type <name>: (<values>)`,
where:
 - the `export` keyword indicates that the type should be declared in the
   parent scope rather than the current scope;
 - the `global` keyword indicates that the type should be declared in the
   global scope rather than the current scope;
 - the `primitive` keyword indicates that the type maps to a physical resource
   available on the target, that the compiler should recognize by name or by
   means of annotations, allowing the type to be used at runtime;
 - `<name>` is the name of the user-defined type;
 - `<parent>` is a typename unit for the type that the user-defined type is
   based on;
 - `<values>` is a comma-separated list of names indicating the values that
   this enumerated (sum) type can accept.

Return type: void.

Return value: null.

Side effects: none.

Definitions:
 - an alias from `<name>` to a `typename` for the newly defined type in the
   designated scope;
 - if the type has a parent:
    - a predefined default constructor returning the default value for the
      parent type;
    - a predefined identity function that does not modify the value;
    - predefined typecasts from the parent type to the user-defined type and
      back;
    - a predefined typecast from the user-defined type to `string`;
 - if the type is enumerated:
    - a predefined default constructor returning the first value in `<values>`;
    - a predefined identity function that does not modify the value;
    - predefined relational operators (`==`, `!=`, `<=`, `<`, `>=`, and `>`);
    - a predefined typecast from the user-defined type to `int` and back,
      referencing the enumerated values by zero-based index;
    - a predefined typecast from the user-defined type to `string`;
    - an alias for each element of `<values>` to a literal node for each of the
      enum values in the designated scope.

Constructor, identity, typecast, and promotion rules may only be defined in the
same inner scope that the type is defined in, regardless of whether `export` or
`global` is specified.

If `<parent>` is a `tuple` or `pack`, the tuple/pack may only be indexed in the
inner scope that the type is defined in, regardless of whether `export` or
`global` is specified. All user-defined types behave as scalars outside of this
scope.

The identity function of a type is called whenever a value of that type is
constructed. This may be used to limit the set of values actually supported by
a type based upon a parent type. The body of the identity function is evaluated
with the default identity function in effect, in order to avoid recursion.

Types not marked `primitive` are only available during constant propagation.

If/else statement unit
----------------------

Allows blocks to be executed conditionally using ALU branches or conditional
execution.

Syntax: `[inline|runtime|primitive] if [<annot>] (<condition>) [-> <return>] <if-true> [elif (<cond2>) <if-cond2>]* [else <if-false>]`,
where:
 - the `inline` keyword indicates that the statement statement *must* be
   inlined during constant propagation, implying that `<condition>` must be a
   static unit;
 - the `runtime` keyword indicates that the statement *must* be implemented
   using classical branch statements (i.e., a compiler must generate an error
   if this is impossible, and even if `<condition>` is static, the statement is
   not reduced during constant propagation);
 - the `primitive` keyword indicates that the statement *must* map to a single,
   atomic, potentially parallelizable instruction in hardware (i.e., a
   compiler must generate an error if no instructions implementing the body
   exists, and aside from this pattern matching, the statement should only
   ever be interpreted by simulators, and even if `<condition>` is static, the
   statement is not reduced during constant propagation);
 - `<annot>` consists of zero or more annotation objects of the form
   `@<iface>.<oper>([<expr>])` (this is syntactic sugar for applying the
   annotation unit to the complete statement for each annotation);
 - `<condition>` and `<cond2>` are expression units returning something that
   promotes to `bool`;
 - `<return>` is a typename unit representing the optional return type for the
   if-else statement;
 - `<if-true>`, `<if-cond2>`, and `<if-false>` are any scalar unit.

Return type: void if `<return>` is not specified, otherwise the type specified
by `<return>`.

Return value: null if `<return>` is not specified, otherwise the value returned
by the selected block as promoted to `<return>`, or the default value for the
`<return>` type if no block was selected.

Side effects: the side effects of `<condition>`, followed by the side effects
of the selected block (if any).

Definitions: the definitions of `<if-true>`, followed by the definitions of
`<if-cond[i]>` from left to right (if specified), followed by the definitions
of `<if-false>`.

The return value of the selected block is discarded if `<return>` is not
specified.

> Note that `else if` works just as well as `elif`, but would require you to
> repeat the return type if return types are used.

Conditional execution unit
--------------------------

Provides a shorthand notation for `primitive if` with no `elif` or `else`.

Syntax: `cond [<annot>] (<condition>) <unit>`, where:
 - `<annot>` consists of zero or more annotation objects of the form
   `@<iface>.<oper>([<expr>])`. This is syntactic sugar for applying the
   annotation unit to the conditional statement for each annotation.
 - `<condition>` is an expression unit that returns `bool`;
 - `<unit>` is any scalar unit.

Return type: void.

Return value: null.

Side effects: the side effects of `<condition>`, only followed by the side
effects of `<unit>` if `<condition>` evaluated to true.

Definitions: the definitions of `<unit>`.

The return value of `<unit>` is discarded.

Compilers must implement this unit using conditional execution, or throw an
error if not supported.

Match unit
----------

Provides a shorthand notation for an if-elif-else statement where each
condition is a simple equality check between a single unknown value and a
literal, without re-evaluating the unknown value for every match arm.

Syntax: `[inline|runtime|primitive] match [<annot>] (<unknown>) [-> <return>] { when <val1>: <unit1> [...] [else <otherwise>] }`,
where:
 - the `inline` keyword indicates that the statement statement *must* be
   inlined during constant propagation, implying that `<unknown>` must be a
   static unit;
 - the `runtime` keyword indicates that the statement *must* be implemented
   using classical branch statements (i.e., a compiler must generate an error
   if this is impossible, and even if `<unknown>` is static, the statement is
   not reduced during constant propagation);
 - the `primitive` keyword indicates that the statement *must* map to a single,
   atomic, potentially parallelizable instruction in hardware (i.e., a
   compiler must generate an error if no instructions implementing the body
   exists, and aside from this pattern matching, the statement should only
   ever be interpreted by simulators, and even if `<unknown>` is static, the
   statement is not reduced during constant propagation);
 - `<annot>` consists of zero or more annotation objects of the form
   `@<iface>.<oper>([<expr>])` (this is syntactic sugar for applying the
   annotation unit to the complete statement for each annotation);
 - `<unknown>` is the expression unit of which the returned value is to be
   matched;
 - `<val[i]>` are static units returning something promotable to the type of
   `<unknown>`, representing the values to be matched;
 - `<return>` is a typename unit representing the optional return type for the
   statement;
 - `<unit[i]>` is the scalar unit of which the side effects are to be
   evaluated an possibly the return value is to be returned when `<value>` is
   found to be equal to `<val[i]>`;
 - `<otherwise>` is the scalar unit of which the side effects are to be
   evaluated an possibly the return value is to be returned when `<value>` is
   not found to be equal to any `<val[i]>`.

Return type: void if `<return>` is not specified, otherwise the type specified
by `<return>`.

Return value: null if `<return>` is not specified, otherwise the value returned
by the selected block as promoted to `<return>`, or the default value for the
`<return>` type if no block was selected.

Side effects: the side effects of `<condition>`, followed by the side effects
of the selected block (if any).

Definitions: the definitions of `<unit[i]>` from left to right, followed by the
definitions of `<otherwise>` (if specified).

The return value of the selected block is discarded if `<return>` is not
specified.

For loop unit
-------------

Allows dynamic loops to be specified.

Syntax: `[runtime|primitive] for [.<lbl>] [<annot>] (<control>) <body>`, where:
 - the `runtime` keyword indicates that the statement *must* be implemented
   using classical branch statements (i.e., a compiler must generate an error
   if this is impossible);
 - the `primitive` keyword indicates that the statement *must* map to a single,
   atomic, potentially parallelizable instruction in hardware (i.e., a
   compiler must generate an error if no instructions implementing the body
   exists, and aside from this pattern matching, the statement should only
   ever be interpreted by simulators);
 - `<lbl>` is an optional identifier that may be referred to by `break` and
   `continue`;
 - `<annot>` consists of zero or more annotation objects of the form
   `@<iface>.<oper>([<expr>])` (this is syntactic sugar for applying the
   annotation unit to the complete statement for each annotation);
 - `<control>` must be a unit returning `scsep` with three elements, where:
    - the first element (init) must be a `csep` or scalar unit, evaluated
      sequentially when the loop is initialized;
    - the second element (cond) must be an expression unit returning `bool`,
      evaluated before each loop iteration, determining whether the loop is
      complete or a new iteration is required;
    - the third element (update) must be an expression unit or a `csep` thereof,
      evaluated sequentially after the loop body terminates or calls `continue`,
      before the second element is re-evaluated;
 - `<body>` is the scalar unit of which the side effects are evaluated for each
   loop iteration.

Return type: void.

Return value: null.

Side effects:
 - the side effects of the init part of `<control>`, sequentially for each
   comma-separated unit (if non-scalar);
 - the side effects of the cond part of `<control>`;
 - if the above evaluates to true:
    - the side effects of `<body>`, until it completes or calls `break` or
      `continue` for this loop (if break is called, the loop terminates, so no
      more side effects are evaluated);
    - the side effects of the update part of `<control>, sequentially for each
      comma-separated unit (if non-scalar);
    - the side effects of the cond part of `<control>` are re-evaluated, and
      so on.

Definitions: the definitions in the init part of `<control>`, followed by the
definitions of `<body>`.

Any value returned by the init and update parts of `<control>` is discarded.

Any value returned by `<body>` is discarded.

> Note that unlike in C, variables defined in the init part are still available
> after the loop. Note also that void is returned and `inline` is not
> available, because even determining whether the loop even terminates requires
> solving the halting problem (not to mention determining how many iterations
> it goes through before terminating). `primitive` is available because why
> not, but will probably never be supported for any reasonable compiler and
> architecture.

While loop unit
---------------

Syntactic sugar for a for loop unit with null init and update.

Syntax: `[runtime|primitive] while [.<lbl>] [<annot>] (<cond>) <body>`, where:
 - the `runtime` keyword indicates that the statement *must* be implemented
   using classical branch statements (i.e., a compiler must generate an error
   if this is impossible);
 - the `primitive` keyword indicates that the statement *must* map to a single,
   atomic, potentially parallelizable instruction in hardware (i.e., a
   compiler must generate an error if no instructions implementing the body
   exists, and aside from this pattern matching, the statement should only
   ever be interpreted by simulators);
 - `<lbl>` is an optional identifier that may be referred to by `break` and
   `continue`;
 - `<annot>` consists of zero or more annotation objects of the form
   `@<iface>.<oper>([<expr>])` (this is syntactic sugar for applying the
   annotation unit to the complete statement for each annotation);
 - `<cond>` must be an expression unit returning `bool`, evaluated before
   each loop iteration, determining whether the loop is complete or a new
   iteration is required;
 - `<body>` is the scalar unit of which the side effects are evaluated for each
   loop iteration.

Return type: void.

Return value: null.

Side effects:
 - the side effects of `<cond>`;
 - if the above evaluates to true:
    - the side effects of `<body>`, until it completes or calls `break` or
      `continue` for this loop (if break is called, the loop terminates, so no
      more side effects are evaluated);
    - the side effects of `<cond>` are re-evaluated, and so on.

Definitions: the definitions of `<body>`.

Any value returned by `<body>` is discarded.

> Same notes about `inline` and `primitive` apply as for the for loop unit.

Repeat until unit
-----------------

Like a while loop, but with the condition at the end and the body evaluated at
least once.

Syntax: `[runtime|primitive] repeat [.<lbl>] [<annot>] <body> until (<cond>)`, where:
 - the `runtime` keyword indicates that the statement *must* be implemented
   using classical branch statements (i.e., a compiler must generate an error
   if this is impossible);
 - the `primitive` keyword indicates that the statement *must* map to a single,
   atomic, potentially parallelizable instruction in hardware (i.e., a
   compiler must generate an error if no instructions implementing the body
   exists, and aside from this pattern matching, the statement should only
   ever be interpreted by simulators);
 - `<lbl>` is an optional identifier that may be referred to by `break` and
   `continue`;
 - `<annot>` consists of zero or more annotation objects of the form
   `@<iface>.<oper>([<expr>])` (this is syntactic sugar for applying the
   annotation unit to the complete statement for each annotation);
 - `<body>` is the scalar unit of which the side effects are evaluated for each
   loop iteration;
 - `<cond>` must be an expression unit returning `bool`, evaluated after each
   loop iteration, determining whether the loop is complete or a new iteration
   is required.

Return type: void.

Return value: null.

Side effects:
 - the side effects of `<body>`, until it completes or calls `break` or
   `continue` for this loop (if break is called, the loop terminates, so no
   more side effects are evaluated);
 - the side effects of `<cond>` are (re-)evaluated;
 - if the `<cond>` evaluated to false, re-evaluate `<body>`, and so on.

Definitions: the definitions of `<body>`.

Any value returned by `<body>` is discarded.

> Same notes about `inline` and `primitive` apply as for the for loop unit.

Foreach loop unit
-----------------

A loop for which the (maximum) iteration count is known at compile-time,
iterating over the elements of a `tuple`.

Syntax: `[static] [inline|runtime|primitive] foreach [.<lbl>] [<annot>] ([<name> :] <tuple>) <body>`,
where:
 - the `static` keyword asserts that, when the loop returns, the number of
   iterations must be exactly the number of elements in `<tuple>`, and `<body>`
   was executed in full for all iterations;
 - the `inline` keyword indicates that the statement statement *must* be
   inlined during constant propagation;
 - the `runtime` keyword indicates that the statement *must* be implemented
   using classical branch statements (i.e., a compiler must generate an error
   if this is impossible, and the compiler must not inline the loop);
 - the `primitive` keyword indicates that the statement *must* map to a single,
   atomic, potentially parallelizable instruction in hardware (i.e., a
   compiler must generate an error if no instructions implementing the body
   exists, or the separate instances of `<body>` cannot be parallelized);
 - `<lbl>` is an optional identifier that may be referred to by `break` and
   `continue`;
 - `<annot>` consists of zero or more annotation objects of the form
   `@<iface>.<oper>([<expr>])` (this is syntactic sugar for applying the
   annotation unit to the complete statement for each annotation);
 - `<name>` is an optional name for a special constant defined only within
   `<body>` that takes the value of the tuple element for the current
   iteration;
 - `<body>` is the scalar unit of which the side effects are evaluated for each
   loop iteration.

Return type: if `static` is specified, a tuple of the same size as `<tuple>` is
returned, with the element type returned by `<body>`; otherwise, the return type
is void.

Return value: as above; each element taking the value returned by the
corresponding evaluation of `<body>` if `static`, or null if non-`static`.

Side effects: the side effects of `<tuple>`, followed by the side effects of
`<body>` for each element in `<tuple>`, or until `break` is called from
`<body>`.

Definitions: the definitions of `<body>`.

The `inline` marker implies `static`.

It is illegal to call `break` or `continue` for a `static` (or `inline`)
foreach loop.

The `static` and `inline` markers are mutually exclusive with `<lbl>`.

Return unit
-----------

The return unit allows returning from a function or stopping algorithm
execution before the end is reached.

Syntax: `return [<value>]`, where `<value>` is an optional expression unit
that will be returned by the surrounding function or by the algorithm.

Return type: not applicable.

Return value: not applicable.

Side effects: the side effects of `<value>`, and execution of the current
function or algorithm is stopped.

Definitions: none.

If `return` is used within a function body, the function will return what is
returned by `<value>`, or null if no value is specified, promoted to the
function return type.

If `return` is not used within a function body, the algoritm is stopped, and
either `<value>` or null is returned to the host.

Break unit
----------

The break unit allows exiting from loops prematurely.

Syntax: `break [<lbl>]`, where `<lbl>` is an identifier mapping to the label of
one of the surrounding loops.

Return type: not applicable.

Return value: not applicable.

Side effects: none.

Definitions: none.

If `<lbl>` is not specified, the innermost loop is exited.

It is illegal to use `break` when there is no surrounding loop.

It is illegal to break out of a function body by referring to a loop external
to the surrounding function body.

Continue unit
-------------

The continue unit allows moving on to the next iteration of a loop prematurely.

Syntax: `continue [<lbl>]`, where `<lbl>` is an identifier mapping to the label
of one of the surrounding loops.

Return type: not applicable.

Return value: not applicable.

Side effects: none.

Definitions: none.

If `<lbl>` is not specified, the innermost loop is continued.

It is illegal to use `continue` when there is no surrounding loop.

It is illegal to break out of a function body by referring to a loop external
to the surrounding function body.

Send unit
---------

The send unit models information transfer from the classical processor to the
host.

Syntax: `send([<args>])`, where `<args>` is an optional expression unit or
`csep` thereof.

Return type: void.

Return value: null.

Side effects: the side effects of `<args>` from left to right (if any),
followed by a data transfer from classical processor to host with the specified
payload.

Definitions: none.

Receive unit
------------

The receive unit models information transfer from the host to the classical
processor.

Syntax: `receive([<types>])`, where `<types>` is an optional typename unit or
`csep` thereof.

Return type: a pack of the given `<types>`, or void if `<types>` is not
specified.

Return value: the received data, expressed using the types specified above.

Side effects:
 - the algorithm pauses until a message is received from the host;
 - if no message is in the receive queue and the host is simultaneously waiting
   for algorithm completion or a message from the classical processor, a
   deadlock exception is thrown and the algorithm is stopped;
 - the message payload is converted to the given cQASM type and returned, or if
   the payload has an incorrect type, an exception is thrown and the algorithm
   is stopped.

Definitions: none.

Print unit
----------

Allows information to be printed for debugging during compilation, simulation,
or, if supported, a hardware run.

Syntax: `[inline|runtime] print(<args>)`, where:
 - `inline` indicates that the print statement should be executed during
   constant propagation;
 - `runtime` indicates that the print statement must be compiled to hardware
   instructions;
 - `<args>` is a static unit returning `string`, or a `csep` of static units,
   the first of which returns `string`.

Return type: void.

Return value: null.

Side effects:
 - `print`: during simulation, a message is printed to `stdout` as formatted
   using [the format string](https://github.com/fmtlib/fmt) passed as the first
   argument, and variadic argument pack passed as the remainder of the
   arguments. A `qubit` reference should print the current probabilities of
   that qubit being `<0|` or `<1|`; tuples of qubit references should print the
   current propabilities for the entire given register.
 - `inline print`: during constant propagation, the constant propagation result
   of all arguments is pretty-printed as per the format string. `inline print`s
   do not do anything when they are not analyzed, for instance in an if-true
   block of an if-statement that is statically optimized away because the
   condition is statically false. This is primarily useful for debugging
   constant propagation and generative constructs.
 - `runtime print`: like a normal print, but must be compiled to hardware
   instructions. If this is impossible, the compiler must throw an error.

Definitions: none.

Abort unit
----------

Throws an exception that stops compilation or the algorithm with an error.

Syntax: `[inline|runtime] abort(<args>)`, where:
 - `inline` indicates that the abort statement should be executed during
   constant propagation;
 - `runtime` indicates that the abort statement must be compiled to hardware
   instructions;
 - `<args>` is a static unit returning `string`, or a `csep` of static units,
   the first of which returns `string`.

Return type: void.

Return value: null.

Side effects: the same semantics as `print`, but (compilation of) the algorithm
is aborted.

Definitions: none.

Annotation unit
---------------

The annotation unit allows any other unit to be annotated with custom,
target-specific information.

Syntax: `<unit> @<iface>.<oper>([<expr>])`, where:
 - `<unit>` is the unit to be annotated; any unit will do;
 - `<iface>` and `<oper>` are identifiers indentifying the annotation;
 - `<expr>` is an optional expression unit or `csep` thereof.

Return type: the return type of `<unit>`.

Return value: the value returned by `<unit>` by default, but targets may
override this based on the annotation.

Side effects: the side effects of `<unit>` by default, but targets may
override this based on the annotation.

Definitions: the definitions of `<unit>`, with this annotation attached to
them.

Units and definitions may have any number of annotations attached to them,
including the same type of annotation multiple times. The order in which the
annotations are added shall be preserved.

Targets that do not support any annotations with interface `<iface>` may safely
ignore the annotation, unless `<iface>` equals `required`.

Targets that do support any annotation with interface `<iface>` must throw an
exception if they do not also support `<oper>`.

> For example, the QX simulator might support the `qx` interface. If it then
> receives `qx.super_experimental_error_model`, but doesn't know what that
> operation means, it must throw an error to make the user aware of it. But a
> compiler would not implement `qx` annotations, and would just ignore it;
> after all, it might not care about error models.

`<expr>` is analyzed (names are resolved and constant propagation is
performed) regardless of whether the annotation is supported, but it is up to
the target if, when, or how it is evaluated.

If an annotation is not supported, the side effects of `<expr>` must not be
evaluated.

Pragma unit
-----------

The pragma unit allows operations to be defined that cannot be defined inside
cQASM 2.0 normally.

Syntax: `pragma <iface>.<oper>([<expr>])`, where the syntax and semantics after
`pragma` match those of an annotation unit.

Return type: none.

Return value: none.

Side effects: undefined.

Definitions: none.

Comma unit
----------

The comma unit is mostly a grammatical construct, used for all comma-separated
lists of units.

Syntax: `<lhs>, [<rhs>]`, where `<lhs>` and `<rhs>` are any unit (the latter
being optional).

Return type: `csep`, (flattened) concatenation of `<lhs>` and `<rhs>`.

Return value: as above. The `csep` value is comma-terminated if and only if
`<rhs>` is comma-terminated or is omitted.

Side effects: side effects are forwarded for `csep` elements independently.
How exactly the side effects are evaluated depends on context.

Definitions: the definitions of `<lhs>` followed by the definitions of `<rhs>`.

If `<lhs>` and/or `<rhs>` returns a value of type `csep`, the comma-separated
list is flattened.

Semicolon unit
--------------

The semicolon unit is mostly a grammatical construct, used for all
semicolon-separated lists of units.

Syntax: `<lhs>; [<rhs>]`, where `<lhs>` and `<rhs>` are any unit (the latter
being optional).

Return type: `scsep`, (flattened) concatenation of `<lhs>` and `<rhs>`.

Return value: as above. The `scsep` value is semicolon-terminated if and only
if `<rhs>` is semicolon-terminated or is omitted.

Side effects: side effects are forwarded for `scsep` elements independently.
How exactly the side effects are evaluated depends on context.

Definitions: the definitions of `<lhs>` followed by the definitions of `<rhs>`.

If `<lhs>` and/or `<rhs>` returns a value of type `scsep`, the
semicolon-separated list is flattened.

Types
=====

A *type* identifies the type of some value.

A *builtin* type is a primitive type provided by the language.

An *internal* type is a builtin type that cannot be explicitly referred to
inside cQASM 2.0 (there is no defined name for it), but does exist in the
internal representation.

A *runtime* type is a type that can be instantiated at runtime (i.e. one that
can exist as the result of a runtime expression or be stored in a variable).

A *static* type is a type that can be instantiated at compile-time (i.e. one
that can exist as the result of a constant-propagated expression, in some
cases a literal, or can be bound to a constant).

A *quantum* type is a type representing quantum information. Quantum
information cannot be copied, and thus cannot be used in many contexts; it
is typically only used in variable declarations to declare resource usage.

A *user* type is a runtime type defined using the `type` construct.

A *product* type is a type defined as the product of other types.

A *scalar* type is a non-product type.

An *enumerable* type is a type that has a limited number of values that can be
logically enumerated. That is, types derived from `bool`, `int`, or custom
enumerations.

The following builtin types exist:
 - `qubit`: a runtime, quantum type for non-static type for qubits.
 - `qref`: a runtime, static type for referring to qubits.
 - `bool`: a runtime, static type for boolean values (either true or false)
 - `int`: a static, non-runtime type identifying for integers between -2^63 and
   2^63-1 inclusive;
 - `real`: a static, non-runtime type for real numbers representable using
   IEEE 754 binary64;
 - `complex`: a static, non-runtime type for complex numbers representable
   using a pair of IEEE 754 binary64s for the real and imaginary parts;
 - `string`: a static, non-runtime type for a string of bytes (typically, but
   not necessarily, encoded as UTF-8);
 - `json`: a static, non-runtime type for a JSON object;
 - `pack`: a product type consisting of zero or more other subtypes;
 - `tuple`: a product type for one or more instances of a single subtype.
 - `csep`: an internal product type consisting of zero or more other subtypes,
   not yet combined into a pack;
 - `scsep`: an internal product type consisting of zero or more other subtypes,
   not yet combined into a pack;
 - `typename`: an internal, static, non-runtime type for identifying other
   types;
 - `reference`: an internal, static, non-runtime type for referring to one or
   more variables or indices thereof;
 - `function`: an internal, static, non-runtime type for referring to all
   overloads of some named function or operator in a particular scope;
 - `unresolved`: an internal, static, non-runtime type for unresolved
   identifiers;
 - `declaration`: an internal, static, non-runtime type for declarations
   (variables, constants, aliases, or function parameters).

*void* is used as a synonym for a pack with zero subtypes. Its sole value is
referred to as *null*.

> Note that all builtin types except `qubit` and `bool` are non-runtime. That
> means that they will only ever exist as static values. For example, it's
> *NOT* possible to make a variable of type `function` (i.e. a function
> pointer), `reference` (i.e. pointers/references), or `typename` (i.e. dynamic
> types). It also means that any classical types that the target architecture
> can deal with at runtime (besides `bool`) must be user-defined.




TODO: definitions cannot start with `_builtin_` (reserved prefix)
