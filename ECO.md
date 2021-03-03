Custom types
------------

Remove the identity function. It was a kludge from the beginning and doesn't
have well-defined semantics.

Remove all the nonsense about the derived type behaving like the base type only
in some contexts. It should just never do that. A derived type is opaque until
the user defines otherwise; only a default constructor is generated, and within
the type definition scope builtin functions are implicitly defined to convert
back and forth between the base and derived type reinterpret_cast-style. See
examples.md.

Qubits
------

Remove `qubit` type, there is only `qref`. The semantics of `qref` are as
follows.

 - `qref` behaves as a reference to a qubit, such that it can be cloned. This
   is required for it to be pushable onto a stack, and thus for it to be usable
   as a function argument.

 - The default constructor for `qref` returns a reference to any physical
   qubit that does not currently have a `qref` pointing to it. This means that
   in the worst case (simulation) a reference counter should exist for each
   physical qubit (if the simulation supports dynamic qubit allocation, a qubit
   would be deallocated when the last reference to it goes out of scope, and
   the default constructor simply allocates a new qubit). Of course this can
   be restricted further. A compiler for any existing architecture would for
   instance have to do liveness analysis of the references at compile-time in
   order to determine which qubit should be selected, which means dynamic
   assignments of `qref`s would obviously not be supported.

 - There is an explicit conversion from `int` to `qref` that returns a
   reference to the given physical qubit, regardless of whether it is already
   live or not. This is used for the representation of a program after mapping;
   unless someone wants to add qubit index constraints to the mapper, the
   mapper should just throw an error when it sees this at its input.

`qubit` is instead made a keyword, used as a shorthand for creating `const`s of
type `qref` using the default constructor. `qref`s should normally be constant
because reassigning them (changing which qubit they point to) is difficult to
analyze, but the `const` keyword might be confusing to end users, hence the
special syntax.

```
qubit a, b, c;
# same as
# const a: qref, b: qref, c: qref;

qubit q[4];
# same as
# const q: qref[4];

qubit a = 3;
# defines a to be physical qubit 3, same as
# const q = qref(3);
```

Nevertheless, within simulation context there is no reason not to allow
variables of type `qref`, although there probably is little reason to use them
either.

Goto and labels
---------------

Allow the colon unit to be used within blocks to define labels, and allow
`goto` to be used to jump to labels. `goto` can ONLY jump to labels within the
exact same block; it can't jump out of the current block or into a child block.
Note that most control-flow statements implicitly open a block regardless of
whether the user uses the `{}` syntax. The only exceptions to this are
`primitive if` (= `cond`) and `primitive match`, which therefore allow
conditional jumps/branches to be described.

Prelude
-------

Specify some system to specify a set of default include files for a given
platform, in addition to a platform-based include path.

Generic function parameters?
----------------------------

Allow function parameters to be marked as `generic`, which essentially makes
them `static const` instead of just `const`, and requires different code to
be emitted for all function invocations with different values for the generics.
Essentially, generic function arguments function as C++ template parameters.

This is needed one way or another for allowing functions to be called with
qubit references for any current architecture, because the qubit references
affect mapping and scheduling and can only be specified as literals in the
final program. But it also allows (the tuple size of) the return type to be
specified based on parameters, as is implicitly done in
[Rabi.qasm](https://github.com/DiCarloLab-Delft/ElecPrj_QYASM/blob/dev-wouter/qasm/cal/Rabi.qasm).

