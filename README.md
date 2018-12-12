## WORK IN PROGRESS; ANYTHING IS SUBJECT TO CHANGE UNTIL TONIGHT

cQASM 2.0 specification
=======================

This is intended to be a working document for the cQASM 2.0 specification. Feel free to add comments/notes using blockquotes (add your name to the top of it to keep things clear, though `git blame` can always be used in case of confusion). You should be able to use github's built-in editor to edit this file. You can also use the issue system to request and discuss changes.


Intended purpose of cQASM 2.0
-----------------------------

cQASM 2.0 (common quantum assembly) strives to be an implementation-agnostic assembly language for quantum accelerators. Because of this agnosticism, it supports many things that a realistic implementation might not, so its purpose is explicitly NOT to represent a minimum set of features needed to build a quantum accelerator. However, an implementation-specific subset of cQASM 2.0 should exactly describe all valid programs for that implementation. Less formally; if an implementation supports cQASM features A and B but not C, simply not using cQASM feature C should be enough to represent exactly the implementation.

cQASM 2.0 also strives to be usable as an intermediate representation for a quantum compiler at all levels. This requires that it can describe some higher-level constructs as well, to be reduced by later compilation steps. For instance, cQASM 2.0 supports the three-qubit Toffoli gate, which implementations most likely would not.

In addition to being a compiler intermediate representation (IR), it is expected that people will also be writing cQASM manually, for instance to use features that the compiler does not yet support. For this reason, unlike most IRs, cQASM should also be user-friendly, allowing some "syntactic sugar" here and there that a compiler would never generate. For instance, using a non-static range of qubits in a SIMD style (that is, defined by the contents of classical registers) would never be defined by a compiler, but might allow algorithms to be written more concisely when coded manually.

In terms of featureset, described very briefly: cQASM 1.0 allows only specification of pure quantum circuits, while 2.0 expands on this by adding classical instructions.

The only two tools that are expected to support the full featureset of cQASM 2.0 are the parser and printer (libQASM) and the simulator (QX). Any compiler step, implementation, tool, etc. is allowed to reject any fraction of valid cQASM 2.0 input. However, it is not allowed to add language features not part of cQASM 2.0 (when it's using libQASM, this is not possible to begin with).


Syntax
------

Instructions are newline-separated. Breaking to the next line is permissible by "escaping" the newline with a backslash;

    hello \
    there # this is equal to "hello there"

This turns the newline into whitespace though, so

    hel\
    lo # becomes "hel lo", not "hello"

`\n` (Linux), `\r\n` (Windows), and `\r` (Mac) are all valid newlines.

> JvS: Same as 1.0, except for the addition of the \ syntax for breaking lines. So if lines DO become long, for instance with annotations, that syntax can be used.

A semicolon is functionaly equivalent to a newline, except that it cannot be used to break a comment. This implies that semicolons at the end of a line can optionally be used.

> JvS: this allows you to put more than one thing on a single line if this works out for readability.

Whitespace is legal between all tokens and is never interpreted.

> JvS: This contrasts with 1.0's lexer definition, which does not throw whitespace out. This only expands the set of valid cQASM programs, and simplifies the grammar significantly.

cQASM supports single-line comments using the # symbol.

> JvS: Same as 1.0.

Everything in cQASM is case-insensitive.

> JvS: Same as 1.0.

Identifiers follow the regex pattern `/[a-zA-Z_][a-zA-Z0-9_]*/`. That is, a combination of underscores, letters, and numbers, where the first character is not allowed to be a number. Identifier matching is case-insensitive.

> JvS: Same as 1.0.

Integer literals can be described using C-like decimal, hexadecimal, or binary notation. That is:

    decimal:     /-?[0-9]+/
    hexadecimal: /0[xX][0-9a-fA-F]+/
    binary:      /0[bB][01]+/

Note that unlike C numbers with zero-prefix are NOT interpreted as octal.

> JvS: Decimal notation is the same as 1.0, hexadecimal and binary are new. libQASM shall fully abstract this notation away from the API/AST layer.

Real numbers use the usual syntax:

    /-?[0-9]*\.[0-9]*([eE][-+]?[0-9]+)[fF]?/

where the "f" indicates single precision versus the default double precision. Exception: "." is not a legal floating point number, even though the regex above matches it.

You can also describe real numbers using hexadecimal or binary notation:

    hexadecimal: /0[xX][0-9a-fA-F]*\.[0-9a-fA-F]*/
    binary:      /0[bB][01]*\.[01]*/

This allows fixed-point numbers to be represented exactly, without roundoff error in the base 10 to 2 conversion.

Boolean literals use the keywords `true` and `false`. These are case-insensitive as usual.

String literals are used on occasion, although cQASM 2.0 does not support string types. Their syntax is `/"([^"]|\\["n])*"/`. That is, text surrounded by `"` symbols, with `\"` as escape sequence for including a `"` in the string and `\n` for including a newline. The newline should be converted to the newline specific to the host platform where applicable.

Finally, annotations (pragma-like information of which the function is to be defined by the target) carry JSON-like data. The toplevel must be an object (= a dict in Python lingo), the string format is limited to the description above, and `null` is not allowed; otherwise the JSON specification is followed. Newlines are allowed within JSON context.


Version header
--------------

cQASM files should start with a version identifier, which is (obviously) 2.0 for cQASM 2.0:

    version 2.0

> JvS: Same as 1.0 (aside from the version number).

Major versions greater than libQASM's version shall be discarded with an error message. If only the minor version is greater, a warning message will be generated instead.

> JvS: I don't think libQASM currently does anything with the version number, but this seems like a good idea.

Resource types
--------------

cQASM 2.0 recognizes the following data types:

 - `qubit` (or `qubits` for 1.0 compatibility): single qubit or multi-qubit register. A qubit comes with a dedicated measurement register for storing the result of a measure instruction.
 - `int<x>`/`uint<x>`: signed/unsigned integer scalars or arrays of bit-width x, where x is a positive integer literal less than or equal to 64.
 - `fixed<x,y>`/`ufixed<x,y>`: signed/unsigned fixed-point scalars or arrays of bit-width x+y, where x is the number of bits before the decimal point and y is the number of bits after. x and y may be negative or zero, as long as their sum is a positive integer less than or equal to 64; negative x implies that the range is less than 1, while negative y implies that the resolution is greater than 1. y=0 is synonymous with int/uint.
 - `float`, `double`: floating point scalars or arrays.
 - `boolean`: boolean register or array.
Note that strings do not exist.

> JvS: I'm allowing any size integer (<=64bit) to be defined to let people specify exactly what they need, and let implementation-specific subsets of cQASM define exactly what they have. The compiler/assembler can then figure out the best conversion between the two (or reject input they don't yet understand). Fixed-point types were added due to popular request, but I'd still like to add floats as well (even if real implementations are unlikely to support it), because they're so much easier to make an initial algorithm design with.

Any non-simulator implementation is allowed to internally represent integral types with greater range/resolution than required by the resource declaration. This means that arithmetic instructions operating on the representation may return a more accurate result than expected, and that overflow behavior cannot be relied upon.

> JvS: This allows compilation steps to round range/resolution up to the nearest thing supported by the target without violating constraints.

The simulator shall terminate with an error if any over- or underflow is detected at runtime, and shall correctly simulate arithmetic with the specified (i.e. worst-case) number representations.

> JvS: Useful when trying to determine what number representations are necessary for a particular algorithm.


Resource declarations
---------------------

Scalar values are defined as follows:

    int<32> scalar_value

And arrays are defined like this:

    int<8> memory[4096]
    qubit data[7]

> JvS: note that classical arrays basically represent memory. They can also be used to model register files of course, though an implementation is unlikely to support non-static indexation of registers (x[y] vs. x[0]).

Arrays always start at zero, and end at the specified length minus one. Simulators should exit with an error if an out-of-range access is performed, but behavior is left as undefined for real implementations.

> JvS: Easy to simulate, hard to do in hardware. Well not hard, but takes up logic and lowers frequency. Debugging should be done with a simulator.

Unlike cQASM 1.0, the above notation for qubit registers does not permit a separate name for the qubit itself and its associated classical measurement bit. To disambiguate between the two when needed, use the suffix `.q` (qubit) or `.b` (binary/classical) in the reference. For instance, `cnot data.b[1], data[2]` specifies that the control for the CNOT gate uses the result of a previous measurement as control, instead of the qubit itself. The default for ambiguous situations is to use the qubit itself.

> JvS: This seems like the most intuitive implementation that is backward compatible with 1.0's notion of having a qubit represent both an actual qubit and a classical bit for its measurement.

The measurement register associated with a qubit has the same semantics as a boolean scalar, except that it can only be written by `measure`-like instructions, or toggled using the single-argument `not` instruction.

> JvS: The `not` exception can be modelled in hardware by having a second bit register in hardware for each qubit that is cleared when a measurement is queued and toggled when the `not` instruction is executed. When the measurement result is subsequently used, the exclusive-or of the two registers is returned. This allows the classical hardware to delay a stall waiting for the measurement to complete beyond the first `not` operation, and it prevents the need for the classical processor to physically be able to write to the measurement register (this is important), while maintaining cQASM 1.0 compatibility (which defined this nasty `not` operation in the first place).

For backward compatibility with 1.0, a qubit register of name "q" can also be defined as follows:

    qubits 15

In this case, "b" is used to refer to the associated measurement register, i.e. `b[1]` is the measurement register for `q[1]`. You can think of this as the suffix notation described before, but without a name or the dot.

> JvS: This is pretty much the ugliest backward compatibility hack in here...

Classical values can also be initialized. The syntax and semantics are borrowed from C, although the array length must always be defined between the square brackets (conversely, C allows the array length to be implicit in the initializer item count).

    int<64> r[16] = {3, 2, 1} # Initializes r to (3,2,1,0,0,0,...,0)
    boolean b = true
    int<32> x = 0
    int<32> y = 0
    int<32> z = 0

> JvS: Note with respect to the previous 2.0 draft: this resource specification is much more flexible than the previous draft, and is feature-wise a superset; the following declarations: `int<64> r[64]; int<64> mem[(some large number)]` define what was implicit in the previous draft. The approach suggested here instead leaves the mapping of arrays and scalars to registers and memory/memories to the compiler/assembler. This may seem harder on the compiler at first, but it actually prevents very annoying situations compared to when it would not perform this mapping. Consider for instance what it would need to do if it needs to split an instruction into multiple implementable instructions (similar to splitting a SWAP into three CNOTs) in a way that requires a temporary register. If the user already did register and memory allocation for the compiler, there is no good way of determining which (if any) register can be used for this. (if you're going to be doing liveness analysis to handle situations like these, you might as well just perform register allocation).

Simulators should keep track of uninitialized resources and throw an error if they are used. For real implementations, resources are allowed to be in any state before they are initialized.

The following statement marks two scalar resources as being mutually exclusive:

    exclusive scalar_value, x

In a simulator tracking uninitialized values, this declaration means that writing to scalar_value invalidates x and vice versa. This will basically never be useful for handwritten cQASM, but is very useful in the following cases:

 - Recording the results of liveness analysis amidst compilation steps.
 - Specifying that two values (usually of different types) occupy the same physical storage location in an implementation. For instance, a processor may have a 32x32bit register file that can also be viewed as a 16x64bit register file, as shown below. By having this specification, architectures with these characteristics can be accurately simulated before a microarchitecture-specific simulator is complete.

```
int<64> reg64[16]
int<32> reg32[32]
exclusive reg32[0] reg64[0]
exclusive reg32[1] reg64[0]
exclusive reg32[2] reg64[1]
exclusive reg32[3] reg64[1]
...
```

Resource mappings
-----------------

The map statement can be used to specify an alias for a resource:

    map q[0], data
    map q, qubit_reg

These mappings state that `data` and `qubit_reg[0]` can be used in place of `q[0]`. Mappings can be specified anywhere in the code, and go into effect from their declaration onwards. Mappings can also be overridden at any time. Note that while the examples are purely qubits, this works for quantum and classical resources alike.

> JvS: this is for compatibility with 1.0.

Mappings do not have any semantical meaning; use of a mapping and use of the actual resource it maps to is completely equivalent. The AST from libQASM abstracts mappings away, though the actual identifier that was used to specify a resource will be made available as a string should an implementation wish to use this metadata.


Subcircuits
-----------

Code can optionally be organized into subcircuits as in 1.0. They are defined like this:

    .subcircuit_one
        x q[0]

Subcircuits can be replicated a static number of times like this:

    .subcircuit_two(3)
        x q[1]

This will apply the X gate to q[1] three times.

The iteration count must be an positive integer literal; registers are not allowed. To get a dynamic iteration count, a loop must be described using classical instructions.

> JvS: This is to prevent cluttering up the subcircuit API. I'm basically assuming that you're either using subcircuits or classical flow control.

All code before the first subcircuit declaration is considered part of a subcircuit named "default".

> JvS: this is libQASM's current behavior.

If the default subcircuit does not contain code, it will not appear in the AST.

> JvS: This currently does NOT appear to be the case; you just end up with an empty subcircuit. Which seems unintuitive.


Qubit gates
-----------

The following single-qubit gates are defined:

    i       qubit                   # Identity
    h       qubit                   # Hadamard
    x       qubit                   # Pauli-X
    y       qubit                   # Pauli-Y
    z       qubit                   # Pauli-Z
    rx      qubit, angle            # Arbitrary X rotation (radians)
    ry      qubit, angle            # Arbitrary Y rotation (radians)
    rz      qubit, angle            # Arbitrary Z rotation (radians)
    x90     qubit                   # X90
    y90     qubit                   # Y90
    mx90    qubit                   # mX90
    my90    qubit                   # mY90
    s       qubit                   # Phase
    sdag    qubit                   # Phase dagger
    t       qubit                   # T
    tdag    qubit                   # T dagger
    u       qubit,[a,b,c,d,e,f,g,h] # Custom unitary gate

> JvS: the syntax for the custom unitary gate is taken from an undocument feature in 1.0's grammar. Actually, any single-qubit gate allows such a matrix to be specified... but since that doesn't to my knowledge make any sense I'm considering it a bug and won't enforce full backwards-compatibility for that.

The parameters for the unitary gate are:

    .--                --.
    | a + i·b    c + i·d |
    |                    |
    | e + i·f    g + i·h |
    '--                --'

Two following two-qubit gates are defined:

    swap    qubit, qubit            # Swaps two qubits
    cnot    ctrl, target            # CNOT
    cz      ctrl, target            # CPHASE
    cr      ctrl, target, angle     # Controlled phase shift (radians)
    crk     ctrl, target, k         # Controlled phase shift (pi/2^k)

The following three-qubit gates are defined:

    toffoli ctrl, ctrl, target      # Toffoli

All gates can optionally be controlled by prefixing `c-` to the gate name, and adding a boolean argument to the front of the argument list. When a qubit is used in the boolean argument, its measurement result is used instead (`qubit.b` may be used to make this explicit; refer to the definition of the qubit type for more information). Examples:

    c-x     bool, qubit             # Perform X gate if bool is true
    c-swap  bool, qubit, qubit      # Swap the two qubits if bool is true

> JvS: while not explicitly documented, the 1.0 grammar explicitly allows all gates to be controlled. So, for compatibility, I'm just adding it to the spec now.


Qubit measurement
-----------------

The following single-qubit measurement instructions are available:

    prep_x      qubit   # State preparation in X basis
    prep_y      qubit   # State preparation in Y basis
    prep_z      qubit   # State preparation in Z basis
    measure_x   qubit   # Measure qubit in X basis
    measure_y   qubit   # Measure qubit in Y basis
    measure_z   qubit   # Measure qubit in Z basis
    measure     qubit   # Measure qubit in Z basis (same as above)

The result of the measurements is stored in the classical bit register associated with the qubit.

There is also an operation to measure an entire qubit register in the Z-basis at once:

    measure_all qreg    # Measure all qubits in register qreg
    measure_all         # Measure all qubits in all registers

> JvS: the latter is for compatibility with 1.0.

It is also possible to measure parity of a number of qubits in specified bases:

    measure_parity  qubit_a, axis_a, qubit_b, axis_b, ...

The axes should be `x`, `y`, or `z`. Any number of qubits can be involved in the parity measurement. The result is stored in the measurement register of each involved qubit.


Parallelism and timing
----------------------

cQASM operates using an unconventional execution model timing-wise, modelling two flows of time within the same program flow.

The first is the flow of time of the controlling classical processor, in which arithmetic operations, flow control, etc. are evaluated. Within this flow, quantum operations are nothing more than queue operations.

The second is the passage of time within the context of the generated quantum circuit; here, all gates queued by the classical processor up to the next queued `wait` operation are started in parallel, after which the quantum computer will pause for the number of cycles specified by the `wait` before continuing to the next parallel issue of quantum gates.

This distinction is necessary because the classical processor may stall, for instance to wait for memory to be loaded into a register, while a quantum computer must be precisely timed to prevent decoherence. By conceptually separating these two flows of time, quantum computer stalls can be avoided, as long as the classical computer can keep up with it on average.

Unless otherwise specified, all instructions in cQASM take exactly one classical cycle to complete. However, instructions can be bundled together like in a VLIW; in this case they start simultaneously. There are two equivalent ways to bundle instructions together:

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

    { x q[1] | add i, 1 -> i }

> JvS: the latter is the 1.0 syntax.

The following restrictions and semantics apply to bundles:

 - It is illegal to write to the same classical value more than once within a bundle. The resultant will be undefined, and simulators may exit with an error for this.
 - At most one flow control operation (`jmp`-like, `call`, `ret`) may be performed within a bundle. Execution is undefined otherwise, and simulators may exit with an error for this.
 - At most one stack operation (`push`, `pop`, `call`, `ret`) may be performed within a bundle. Execution is undefined otherwise, and simulators may exit with an error for this.
 - At most one `wait` instruction may be performed within a bundle.
 - Any `wait` instruction shall be pushed into the quantum gate queue after any quantum gates specified in the same bundle.
 - When an operand is used as both a source and a destination within a bundle, the operations using it as a source will always see the previous value. Thus, `mov a -> b | mov b -> a` is a valid swap of scalars `a` and `b`.

As already hinted, flow of quantum time is controlled by the `wait` instruction, which has the following syntax:

    wait cycle_count

where `cycle_count` is an integer. A `wait 0` instruction has no effect. Behavior for a negative cycle count is undefined, and simulators may exit with an error for this.

Note that in the absence of `wait` operations, the classical and quantum flow of time is identical, as the quantum gate queue is always empty. That is, in the absence of stalls, all bundles take one cycle to complete. To prevent stalling quantum circuit execution, a `wait` statement of sufficient length must be placed in front of the classical program.

> JvS: also note that this model is coincidentally consistent with how 1.0 is specified in terms of simulation when no `wait` statements are specified!


SGMQ/SIMD parallelism and array indexation
------------------------------------------

In addition to the bundle notation described in the previous section, there is also a syntax to describe single-gate-multiple-qubit (SGMQ) and single-instruction-multiple-data (SIMD) operations. This works by allowing array indices to be sets and slices in addition to single indices using the following notation:

    x   q[0]                # Operate on qubit 0 only
    x   q[1:3]              # Operate on qubit 1, 2, and 3
    x   q[4,6,9]            # Operate on qubit 4, 6, and 9
    x   q[10:12,14,16:18]   # Operate on qubit 10, 11, 12, 14, 16, 17, and 18

> JvS: this is consistent with cQASM 1.0. I could not find the combination of ranges and set entries to be specified anywhere, but the grammar already allowed it.

Multi-qubit gates and multi-operand classical instructions can also make use of this indexation method. In this case, the number of selected elements must be the same for each operand, or (for source operands) only a single element must be selected. For instance:

    add x[0:7], 1 -> x[0:7] # Perform 8 increments in parallel
    mov x[0,1] -> x[1,0]    # A way to write down a classical swap operation
    cnot q[0], q[1:8]       # Apply CNOT to q[1] through q[8] using q[0] as control

cQASM 2.0 does not require indices, sets, or slices to be literals; they can take any scalar value. For instance,

    int<32> v
    int<32> a[10]
    ...
    x   q[v]                # Operate on the qubit indexed by v
    x   q[1:v]              # Operate on qubits ranging from 1 to v
    x   q[a[1],a[2]]        # Operate on qubits ranging from a[1] to a[2]
    # etc.

Note, however, that this construct is extremely difficult to support in hardware due to its flexibility and the amount of error conditions. Non-simulator targets are unlikely to support it.

The following semantics apply to SGMQ/SIMD indexation:

 - Descending ranges are null, i.e. include zero of the operands.
 - When an operand is specified multiple times, the operation is performed that many times. For target operands/qubits, this may lead to undefined/illegal behavior, as outlined in the instruction bundle semantics.
 - Out of range inclusions result in undefined behavior. Simulators may exit with a failure in this case.
 - Indexation nesting is allowed, but only the topmost level can specify more than one entry. That is, `x[y[0],y[1],y[2]]` is legal, but `x[y[0:2]]` is not.

> JvS: the latter prevents weird constructs like `x[y[0:2]:y[1,2]]` or whatever.


Classical flow control
----------------------

Structures such as conditional execution and loops are described using classical jump instructions and labels. Label syntax is borrowed from classical assembly languages:

    start:

Labels are scoped to the current subcircuit. In other words, it is impossible to jump from one subcircuit to another; they function like separate programs. Two different subcircuits can thus also reuse label names.

> JvS: This is to avoid semantic problems for subcircuits that have repitition specified. What would happen, for instance, if you jump out of a repeated subcircuit? The way I see it, you would normally use either 1.0's subcircuit repitition in a piece of code, OR use loops described classically in 2.0's way (since classical branching is functionally a superset of 1.0's functionality).

Labels can refer both backwards and forwards. There is no need to "forward-declare" a label.

The following branch instructions are defined. `x` and `y` can be any scalar numerical literal/resource. (note: this implies that comparing a whole array at once is illegal).

    jmp a_label        # Unconditional jump
    jez x, a_label     # Jump if x == 0 (eq. x == false)
    jnz x, a_label     # Jump if x != 0 (eq. x == true)
    jeq x, y, a_label  # Jump if x == y
    jne x, y, a_label  # Jump if x != y
    jgt x, y, a_label  # Jump if x > y
    jlt x, y, a_label  # Jump if x < y
    jge x, y, a_label  # Jump if x >= y
    jle x, y, a_label  # Jump if x <= y

> JvS: I added `jez`/`jnz` to be used in conjunction with booleans, to support architectures that can only branch based on a previously set boolean register.

Execution of a subcircuit starts at the first instruction. You can start elsewhere by simply using a `jmp` instruction. If an architecture implementation allows the start address to be different from the start of the program, its assembler can just interpret a `jmp` at the start of a subcircuit as the entry point declaration.


Subroutines
-----------

The following instructions support subroutines:

    increment_x:
        add x, 1 -> x
        ret                 # Return from procedure.

    a_label:
        call increment_x    # Jump to a_procedure and store the return address.
        call increment_x    # Same as above, but with a different return address.

Subroutines allow code to be reused. However, like "regular labels", you cannot use subroutines defined outside the current subcircuit.

> JvS: again, to avoid semantical issues.

Note that subroutines are no different from normal labels; they are just used differently. It is therefore legal to mix call/jmp instructions, "fall through" to a followup subroutine, etc. Also note that cQASM has no concept of local variables, parameters, or return values.

> JvS: cQASM is ultimately an assembly language, so much like if/then/else and for loop constructs these abstractions do not exist. Adding them would severily complicate the language.

You can make these manually, however, by declaring all the resources you need as globals. You might want to prefix subroutine-specific globals with the label of the subroutine to avoid confusion. This leaves one problem: recursion. Whenever you recursively call a subroutine, you must ensure that its locals and parameters are "backed up" before you assign new values to them for/in the recursive call. This can be done with the `push` and `pop` instructions:

    push x  # Pushes the value x on the stack.
    push y  # Pushes the value y on the stack.
    pop a   # Sets a to y, because that was the last value pushed.
    pop b   # Sets b to x, because that was the last value pushed that we haven't popped yet.

A `call` instruction contains an implicit `push` operation; it pushes the return address. `ret` contains an implitic `pop` operation to retrieve the return address and jump to it.

The following rules must be followed for `push` and `pop`:

 - When you push a certain data type, you must always pop the same data type. Not doing so leads to undefined behavior. A simulator should detect this and exit with an error.
 - Every `push` operation must have a respective `pop` operation. That is, when the program terminates, the number of calls to `push` must equal the number of calls to `pop`.
 - Popping when the stack is empty is illegal and leads to undefined behavior. A simulator should detect this and exit with an error.

Note that because `call` and `ret` share the same stack as `push` and `pop`, you must ensure that each subroutine has popped everything it has pushed before calling `ret`, otherwise the return address will not be at the top of the stack.

> JvS: they share the same stack in the execution model, because if a program works with a shared stack it also works with separate stacks. Thus, semantically sharing a stack supports more targets than having different stacks.

> JvS: during register allocation, the compiler may need the stack for spilling. This may conflict with the way push/pop operations are specified in the source. Therefore, push/pop operations may need to be reduced to a "user stack" separate from the call/spill stack before register allocation. I don't see a better way of doing this for a language that supports specifying recursion without a notion of local variables that still requires a register-allocation pass, but I'm open to suggestions.

There is an alternative syntax for `push` that makes the pushed data type explicit:

    push fixed<16,16>, 1.0

Without this notation, it would be impossible to push literals onto the stack, since the bit-width of a literal is undefined.


Classical arithmetic
--------------------

cQASM 2.0 defines the following arithmetic instructions. Keep in mind that, like everything else in this specification, targets are allowed to support only a subset and reject programs with instructions they do not support.

### Movement and type conversion

The `mov` instruction is used to move/copy classical data around. The format is as follows:

    mov     a -> b          # Sets b to a

For consistency with the quantum gates, source operands are specified first. To prevent confusion in that regard, a `->` arrow is used between the source and destination operands.

Because of the way cQASM typing works (this is elaborated upon in the next section), `mov` instructions can also be used for type conversion:

    int<32> i
    float f
    ...
    mov i -> f              # Convert integer to float

Furthermore, by way of allowing indexation for all operands, they can also model standalone memory operations:

    int<32> mem[4096]
    int<32> reg
    ...
    mov 42 -> mem[0]        # Store operation
    mov mem[0] -> reg       # Load operation

### Basic arithmetic

The following arithmetic instructions are defined.

    inc     a -> b          # Increment by 1
    dec     a -> b          # Decrement by 1
    neg     a -> b          # Negate/two's complement
    add     a, b -> c       # Add a to b, write to c
    sub     a, b -> c       # Subtract b from a, write to c
    addc    a, b -> c, d    # Add a to b, write result to c and carry to d
    subc    a, b -> c, d    # Subtract b from a, write result to c and carry to d
    mul     a, b -> c       # Multiply a with b, write to c
    div     a, b -> c       # Divide a by b, write to c
    sq      a -> b          # Square a, write to b
    sqrt    a -> b          # Square-root a, write to b
    mod     a, b -> c       # Write a mod b to c
    pow     a, b -> c       # Write a^b to c
    log     a, b -> c       # Write log_a(b) to c
    exp     a -> b          # Write e^a to b
    ln      a -> b          # Write ln(a) to b

The instructions operating on only a single value can also be written with a single operand, without the arrow, for in-place modification:

    inc     a               # Increment in place
    dec     a               # Decrement in place
    neg     a               # Negate/two's complement in place
    sq      a               # Square in place
    sqrt    a               # Square-root in place
    exp     a               # Natural exponentiation in place
    ln      a               # Natural logarithm in place

This is just a shorthand for the explicic destination.

> JvS: this is for consistency with the `not` operation defined in 1.0.

### Trigonometry

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

### Relational

The relational operators share their names with the jump instructions, except they are prefixed with `c` (compare) instead of `j` (jump).

    ceq     a, b -> c       # Write a == b to c
    cne     a, b -> c       # Write a != b to c
    cgt     a, b -> c       # Write a > b to c
    clt     a, b -> c       # Write a < b to c
    cge     a, b -> c       # Write a >= b to c
    cle     a, b -> c       # Write a <= b to c

### Selection

The following selection-based operators are available:

    slct    a, b, c -> d    # As in C: d = a ? b : c
    min     a, b -> c       # Write the minimum of a and b to c
    max     a, b -> c       # Write the maximum of a and b to c
    abs     a -> b          # Write the absolute value of a to b
    abs     a               # Absolute value in place

### Bitwise and logical

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

The ellipses in `error` and `print` can be any argument list, including string literals, and (for simulators) qubits. The contents will be printed to stdout separated by spaces (like Python's print statement).


Type promotion and conversion semantics
---------------------------------------

For the sake of flexibility in supporting any architecture, any classical instruction that operates on numerical values can take any combination of number representations as inputs and outputs. This requires setting some conversion rules. Note; as usual, real implementations are only expected to support a fraction of these things, but when they do support part of this they should adhere to this. For instance, an assembler for a particular implementation may reduce an int + float -> float addition to an int to float conversion and a floating point addition. If the implementation has no float support, the assembler should probably just reject the source, but it could of course try to emulate floats in software as well.

When two input arguments are mixed, the arguments are first converted per the following rules:

 - Combinations of int/uint/fix/ufix: the inputs are widened to a common integral format that can represent all numbers representable by any of the inputs. Formally:

```
fix<a,b>  + fix<c,d>  -> fix <max(a,c),  max(b,d)>
ufix<a,b> + ufix<c,d> -> ufix<max(a,c),  max(b,d)>
fix<a,b>  + ufix<c,d> -> fix <max(a,c+1),max(b,d)>
```

 - Booleans are treated as uint<1> values, where `true` equals 1 and `false` equals 0.
 - When an integral type is combined with a float/double, the integral type is converted to float/double. Rounding method for numbers that cannot be perfectly represented is undefined. Note that this is the only potentially lossy "promotion".

Arithmetic operations are performed at full precision. For example, the results of a multiplication of two `int<32>` values becomes an `int<64>` internally.

If the internal operation result is of a different type than the target scalar, it is converted as follows:

 - Anything to boolean: 0 -> `false`, nonzero -> `true`
 - Boolean to anything that can represent 1: `false` -> 0, `true` -> 1. If 1 cannot be represented, the implementation may choose any nonzero value or `true`.
 - Float/double to int/fix: round toward zero. Overflow behavior is undefined for real implementations, but simulators should detect this and raise an error.
 - Int/fix to float/double: use the exact representation if possible. Rounding is undefined otherwise, but should be no worse than rounding up or down (that is, there are two permitted values for the conversion if no exact representation exists).
 - Float to double: must be exact.
 - Double to float: use the exact representation if possible. Rounding is undefined otherwise, but should be no worse than rounding up or down (that is, there are two permitted values for the conversion if no exact representation exists). +inf/-inf are used in case of overflow.
 - Int/fix conversions: use the exact representation if possible. Round to the most negative representable value if no representation exists. Overflow behavior is undefined for real implementations, but simulators should detect this and raise an error.


Pragmas and annotations
-----------------------

TODO: annotations

The following instructions exist to have a 1.0-compatible interface for interacting with QX specifically:

    display                 # Dump the full quantum state to the console
    display_binary          # Dump the measurement register state to the console
    reset_averaging         # Reset measurement averaging
    error_model mdl, ...    # Set the error model

The ellipsis for the error model is a parameter list of integers and floats literals, while the `mdl` parameter can be any identifier. It is up to QX to check this.
