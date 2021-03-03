cQASM 2.0 code examples
=======================

NOTE: these examples may or may not be syntactically correct, because they
haven't been tested yet, because there is no implementation yet.

NOTE: most examples rely on stuff being predefined, such as functions and
types. These must be defined in a platform header that is either included
explicitly or part of the prelude specified by the platform.

QEC.qasm
--------

[QYASM](https://github.com/DiCarloLab-Delft/ElecPrj_QYASM/blob/dev-wouter/qasm/QEC.qasm):

```
void QEC(qubit x, qubit xN, qubit xE, qubit xS, qubit xW, qubit z, qubit zN, qubit zE, qubit zS, qubit zW) {
    // X stabilizers
    { rym90 [x,xN,xE,xW,xS] };
    { cz x,xE | cz x,xN | cz x,xS | cz x,xW };
    { ry90 [x,xN,xE,xW,xS] };

    { measure x };

    // Z stabilizers
    { rym90 z };
    { cz z,zE | cz z,zS | cz z,zN | cz z,zW };
    { ry90 z };

    { measure z };
}
```

Literal cQASM 2.0 translation:

```
function QEC(qref x, qref xN, qref xE, qref xS, qref xW, qref z, qref zN, qref zE, qref zS, qref zW) {
    # X stabilizers
    rym90(x), rym90(xN), rym90(xE), rym90(xW), rym90(xS);
    cz(x, xE), cz(x, xN), cz(x,xS), cz(x, xW);
    ry90(x), ry90(xN), ry90(xE), ry90(xW), ry90(xS);

    measure(x);

    # Z stabilizers
    rym90(z);
    cz(z, zE), cz(z, zS), cz(z, zN), cz(z, zW);
    ry90(z);

    measure(z);
}
```

Note: single-gate-multiple-qubit notation is not yet defined, so the example is
shown without.

test1.qasm
----------

[QYASM](https://github.com/DiCarloLab-Delft/ElecPrj_QYASM/blob/dev-wouter/qasm/test1.qasm):

```
// for
for(ampl=0; ampl<100; ampl++) x q;
for(;;) x q[0];

// for with block
for(ampl=0; ampl<100; ampl++) {
    x q[0];
    x q[0];
    x q[1] | y q[2];
}

/*
for(ampl=0; ampl<100; ampl+=1) {
    x(ampl);
}
*/

// if ... else
if(a<b)
    y q[1];
else
    x q[2];

// if
if(a>b)
    y q[2];

// while
while(a>=b)
    spec q[12];

// do ... while
do
    x q[3];
while(a==b);
```

Literal cQASM 2.0 translation:

```
# for
for (ampl=0; ampl<100; ampl++) x(q);

# for (;;) is not supported. use while (true) instead.
while (true) x(q[0]);

# for with block
for(ampl=0; ampl<100; ampl++) {
    x(q[0]);
    x(q[0]);
    x(q[1]), y(q[2]);
};

# note that a trailing semicolon is needed when another instruction follows the
# block (because this is not actually a trailing semicolon, but just a
# semicolon separator between two instructions, the first of which happens to
# end in a block).

/*
for (ampl=0; ampl<100; ampl+=1) {
    x(ampl);
};
*/

# if ... else
# TODO: check if the trailing semicolon for y() actually works without blocks
# with the current precedence rules...
if (a<b)
    y(q[1]);
else
    x(q[2]);

# if
if (a>b)
    y(q[2]);

# while
while (a>=b)
    spec(q[12]);

# Instead of do..while, cQASM 2.0 has repeat..until (for grammar conflict
# reasons).
repeat
    x q[3];
until(a!=b);
```

AdaptiveParityMeasurement.qasm
------------------------------

[QYASM](https://github.com/DiCarloLab-Delft/ElecPrj_QYASM/blob/dev-wouter/qasm/cond/AdaptiveParityMeasurement.qasm):

```
QYASM 1.0;
qubit q;
boolean meas;
boolean sel;            // state variable

sel = 0;                // initial gate selector
//...
for(;;) {
    //...
    meas = measure q;

    sel = sel ^ meas;   // toggle selector if meas==1

    sel ? [a,b] q;      // perform gate 'a' or 'b', depending on 'sel'. FIXME: syntax
};
```

Literal cQASM 2.0 translation:

```
version 2.0
qubit q;
variable meas: bool;
variable sel: bool;     # state variable

sel = false;            # initial gate selector
#...
while (true) {
    #...
    meas = measure(q);

    sel = sel ^ meas;   # toggle selector if meas==1

    if (sel) a(q) else b(q);    # perform gate 'a' or 'b', depending on 'sel'.
};
```

Better translation:

```
version 2.0

qubit q;
variable sel = false;

#...

while (true) {
    #...

    # toggle selector if q is measured as 1
    sel ^= measure(q);

    # perform gate 'a' or 'b', depending on 'sel'.
    if (sel) a(q) else b(q);

};
```

RepeatUntilSuccess.qasm
-----------------------

[QYASM](https://github.com/DiCarloLab-Delft/ElecPrj_QYASM/blob/dev-wouter/qasm/cond/RepeatUntilSuccess.qasm):

```
QYASM 1.0;
qubit q;
bit meas;

do {
    // ...
    meas = measure q;
} while(meas==1);
```

Literal cQASM 2.0 translation:

```
version 2.0

qubit q;
variable meas: bool;

repeat {
    // ...
    meas = measure(q);
} until (meas!=true);
```

Better translation:

```
version 2.0

qubit q;

repeat {
    // ...
} until (!measure(q));
```

Chevron.qasm
------------

[QYASM](https://github.com/DiCarloLab-Delft/ElecPrj_QYASM/blob/dev-wouter/qasm/cal/Chevron.qasm):

```
QYASM 1.0;
qubit q;
bit meas[REP_CNT][AMPL_CNT][LEN_CNT];
int repetition;
frac amplitude;      // FIXME: define unit of amplitude, and range
int a;
frac len;
int l;

for(repetition=0; repetition<REP_CNT; repetition++) {
    for(amplitude=AMPL_MIN,a=0; a<AMPL_CNT; amplitude+=AMPL_STEP,a++) {
        for(len=0,l=0; l<LEN_CNT; len+=LEN_STEP,l++) {
            flux(amplitude,len) q,;     // FIXME: len as parameter to flux?
            meas[repetition][a][l] = measure q; // FIXME: INT_AVG?
        }
    }
}
```

Literal cQASM 2.0 translation:

```
version 2.0
qubit q;
variable meas: bool[REP_CNT][AMPL_CNT][LEN_CNT];

for(repetition=0; repetition<REP_CNT; repetition++) {
    for(amplitude=AMPL_MIN, a=0; a<AMPL_CNT; amplitude+=AMPL_STEP, a++) {
        for(len=frac(0),l=0; l<LEN_CNT; len+=LEN_STEP,l++) {
            flux(amplitude,len,q);     # FIXME: len as parameter to flux?
            meas[repetition][a][l] = measure(q); # FIXME: INT_AVG?
        };
    };
};
```

Better translation, allowing parameterization at compile-time and explicitly
returning the measured values:

```
version 2.0

generic REP_CNT: int;
generic AMPL_CNT: int, AMPL_MIN: frac, AMPL_STEP: frac;
generic LEN_CNT: int, LEN_STEP: frac;

qubit q;
variable meas: bool[REP_CNT][AMPL_CNT][LEN_CNT];

for(repetition=0; repetition<REP_CNT; repetition++) {
    for(amplitude=frac(AMPL_MIN), a=0; a<AMPL_CNT; amplitude+=AMPL_STEP, a++) {
        for(len=frac(0),l=0; l<LEN_CNT; len+=LEN_STEP,l++) {
            flux(amplitude,len,q);     # FIXME: len as parameter to flux?
            meas[repetition][a][l] = measure(q); # FIXME: INT_AVG?
        };
    };
};

return meas;
```

Or, using `send` for returning the values to avoid the 3-dimensional boolean
tuple:

```
version 2.0

generic REP_CNT: int;
generic AMPL_CNT: int, AMPL_MIN: frac, AMPL_STEP: frac;
generic LEN_CNT: int, LEN_STEP: frac;

qubit q;

for(repetition=0; repetition<REP_CNT; repetition++) {
    for(amplitude=frac(AMPL_MIN), a=0; a<AMPL_CNT; amplitude+=AMPL_STEP, a++) {
        for(len=frac(0),l=0; l<LEN_CNT; len+=LEN_STEP,l++) {
            flux(amplitude,len,q);     # FIXME: len as parameter to flux?
            send(measure(q));
        };
    };
};
```

I'm guessing that at least the internal loop should probably be inlined for
this to be fast enough, but a C-style `for` can't be inlined. Instead, this
would work:

```
version 2.0

generic REP_CNT: int;
generic AMPL_CNT: int, AMPL_MIN: frac, AMPL_STEP: frac;
generic LEN_CNT: int, LEN_STEP: frac;

qubit q;

for(repetition=0; repetition<REP_CNT; repetition++) {
    for(amplitude=frac(AMPL_MIN), a=0; a<AMPL_CNT; amplitude+=AMPL_STEP, a++) {
        variable len = frac(0);
        inline foreach(1..LEN_CNT) {
            flux(amplitude,len,q);     # FIXME: len as parameter to flux?
            send(measure(q));
            len += LEN_STEP;
        };
    };
};
```

libqasm doesn't constant-propagate variables, so there's no guarantee that the
`len` additions will be optimized out by a later compilation stage. However,
assuming that appropriate operators are defined on `frac`, you compute the
`len` value directly based the foreach loop variable (which is a misnomer,
because the loop "variable" is actually a constant that's redefined for each
loop iteration), in which case libqasm *will* constant-propagate it:

```
version 2.0

generic REP_CNT: int;
generic AMPL_CNT: int, AMPL_MIN: frac, AMPL_STEP: frac;
generic LEN_CNT: int, LEN_STEP: frac;

qubit q;

for(repetition=0; repetition<REP_CNT; repetition++) {
    for(amplitude=frac(AMPL_MIN), a=0; a<AMPL_CNT; amplitude+=AMPL_STEP, a++) {
        inline foreach(l: 0..LEN_CNT-1) {
            flux(amplitude, frac(l) * LEN_STEP, q);     # FIXME: len as parameter to flux?
            send(measure(q));
        };
    };
};
```

You could apply the same thing to the other loops, to make libqasm unroll
everything.

When using `send` in conjunction with runtime for loops, you can also use
`parameter` instead of `generic`, in which case the parameterization (for those
loops) is done at runtime instead of compile-time. You can't do this when you
want to return everything at once in an N-dimensional tuple however, because
the size of the tuple must be known at compile-time. Of course you could also
size the tuple based on some maximum value and just not use part of it based
on runtime paramaters.

Fixed-point type
----------------

```
# Example 16.16 signed fixed-point type with signed rollover behavior. The
# type is derived from the builtin integer type, meaning that internally, a
# value of type fixed16 is stored as an integer. Unless you state otherwise,
# however, none of int's functions and operators can be applied on the new
# type. You can kind of think of this as a grossly simplified version of
# C++'s private inheritance. The only publicly-scoped function defined
# implicitly is the default constructor, used to initialize variables of this
# type that don't have an explicit initializer. This default just initializes
# fixed16 with int's default constructor, which returns 0. Everything else
# needs to be defined inside the type definition scope, or afterwards, based on
# what's defined inside of it.
type fixed16 = int {

    # Two functions are implicitly defined in this scope:
    #  - as_derived(int) -> (fixed16): treats an int as a fixed16, *without*
    #    calling fixed16's constructor function;
    #  - as_base(fixed16) -> (int): treats a fixed16 as an int.
    # These functions serve as building block for the definition of the
    # operators and functions for fixed16.

    # Default value constructor. Used for initializing variables of type
    # fixed16 that have no explicit initialization value. This definition is
    # actually redundant, because the type definition implicitly defines this
    # based on the default value of int, which is also 0.
    export function fixed16() -> (fixed16) {
        return as_derived(0);
    };

    # Let's define some operators on fixed16 values. This list is not
    # exhaustive, of course. Here's the unary minus operator,
    export function operator-(x: fixed16) -> (fixed16) {
        return as_derived(-as_base(x) & 0xFFFFFFFF);
    };

    # the addition operator,
    export function operator+(x: fixed16, y: fixed16) -> (fixed16) {
        return as_derived((as_base(x) + as_base(y)) & 0xFFFFFFFF);
    };

    # the subtraction operator,
    export function operator-(x: fixed16, y: fixed16) -> (fixed16) {
        return as_derived((as_base(x) - as_base(y)) & 0xFFFFFFFF);
    };

    # and the multiplication operator.
    export function operator*(x: fixed16, y: fixed16) -> (fixed16) {
        return as_derived(((as_base(x) * as_base(y)) >> 16) & 0xFFFFFFFF);
    };

    # In order to use fixed16 without the as_base() and as_derived() functions,
    # we'll need to export some conversion and coercion rules as well. Here's
    # the coercion rule from integer to fixed16,
    export function operator fixed16(x: int) -> (fixed16) {
        return as_derived((x << 16) & 0xFFFFFFFF);
    };

    # and from float to fixed16. Note the "operator" in the name; this syntax
    # is used to indicate that they are implicit coercion rules rather than
    # explicit conversion rules. The conversions are implicit mostly because
    # there are no native literals for non-builtin types, so we'll want to
    # coerce integer and floating point literals to fixed16 when we see them.
    export function operator fixed16(x: float) -> (fixed16) {
        return as_derived(int(x * 65536.0) & 0xFFFFFFFF);
    };

    # We should probably also define the inverse. Converting from fixed16 to
    # int results in information loss, so this should be an explicit rule.
    export function int(x: fixed16) -> (int) {
        return as_base(x) >> 16;
    };

    # We don't lose anything when converting to a float, however, because
    # a double floating point mantissa is large enough to represent the full
    # range of fixed16 values exactly. So we'll make it implicit.
    export function operator float(x: fixed16) -> (float) {
        return float(as_base(x)) / 65536.0;
    };

};
```

Rabi.qasm
---------

[Rabi.qasm](https://github.com/DiCarloLab-Delft/ElecPrj_QYASM/blob/dev-wouter/qasm/cal/Rabi.qasm):

```
QYASM 1.0;

int[][] Rabi(qubit q, int REP_CNT, int AMPL_CNT, ufixed<1,31> AMPL_STEP)
{
    int meas[REP_CNT][AMPL_CNT];
    int repetition;
    ufixed<1,31> amplitude;      // FIXME: define unit of amplitude, and range
    int a;

    for(repetition=0; repetition<REP_CNT; repetition++) {
        for(amplitude=AMPL_MIN,a=0; a<AMPL_CNT; amplitude+=AMPL_STEP,a++) {
            prepz q;
            rx q,amplitude;
            meas[repetition][a] = measure q,INT_AVG;
        }
    }
    return meas;
}
```

and [Rabi-17.qasm](https://github.com/DiCarloLab-Delft/ElecPrj_QYASM/blob/dev-wouter/qasm/cal/Rabi-17.qasm):

```
QYASM 1.0;

include "Rabi.qasm"

// int[][][] Rabi-17(int REP_CNT, int AMPL_CNT, ufixed<1,31> AMPL_STEP)

qubit q[17];
int meas[17][REP_CNT][AMPL_CNT];
int i;

for(i=0; i<17; i++) {
    // int[][] Rabi(qubit q, int REP_CNT, int AMPL_CNT, ufixed<1,31> AMPL_STEP)
    meas[i] = Rabi(q[i], REP_CNT, AMPL_CNT, AMPL_STEP);
}
```

This cannot be directly represented in cQASM 2.0 right now, because the return
type of any function must be statically known, and the size of a tuple is part
of this type.

One way to do it already would be to make `REP_CNT` and `AMPL_CNT` generics
of the include file:

```
version 2.0

generic REP_CNT: int, AMPL_CNT: int;

export function Rabi(q: qref, AMPL_MIN: ufixed_1_31, AMPL_STEP: ufixed_1_31, INT_AVG: int) -> (int[REP_CNT][AMPL_CNT]) {
    variable meas: int[REP_CNT][AMPL_CNT];

    for(repetition=0; repetition<REP_CNT; repetition++) {
        for(amplitude=AMPL_MIN,a=0; a<AMPL_CNT; amplitude+=AMPL_STEP,a++) {
            prepz(q);   
            rx(q,amplitude);
            meas[repetition][a] = measure(q,INT_AVG);
        }
    }
    return meas;
}
```

and

```
version 2.0

generic REP_CNT: int;
generic AMPL_CNT: int, AMPL_MIN: ufixed_1_31, AMPL_STEP: ufixed_1_31;
generic INT_AVG: int;

include "Rabi.qasm" REP_CNT=REP_CNT, AMPL_CNT=AMPL_CNT;

qubit q[17];
int meas[17][REP_CNT][AMPL_CNT];

foreach(i: 0..16) {
    meas[i] = Rabi(q[i], AMPL_MIN, AMPL_STEP, INT_AVG);
};

return meas;
```

However, it might also be worthwhile to allow parameters to be specified as a
sort of generic, for example like this:

```
export function Rabi(
    generic q: qref,
    generic REP_CNT: int,
    generic AMPL_CNT: int,
    AMPL_MIN: ufixed_1_31,
    AMPL_STEP: ufixed_1_31,
    INT_AVG: int
) -> (
    int[REP_CNT][AMPL_CNT]
) {
    ...
}
```

The semantics here would be that the function would be replicated for every
combination of generic values used within the program, similar to how templates
work in C++. This is needed to some degree anyway in order to support qubit
arguments for architectures that do not support dynamic indexing/runtime
mapping (so, essentially, all architectures for the forseeable future), but
without this special syntax that could just be special-cased for `qref`s.

