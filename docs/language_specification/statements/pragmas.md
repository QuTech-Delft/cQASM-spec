Pragmas can be used to add client-specific code to a cQASM circuit.
A pragma statement consists of a hash sign (**`#`**) with identifier of the client,
followed by a code block enclosed in curly brackets:

!!! info "" 
    
    &emsp;**`#`**_client_ **`{`** _client-code_ **`}`**

??? info "Grammar for pragmas"
    
    _pragma_:  
    &emsp;**`#`**_client_ _client-code-block_

    _client_:  
    &emsp; _identifier_

    _client-code-block_:  
    &emsp; **`{`** _client-code_ **`}`**

As part of a cQASM circuit, the content of the code block will be interpreted by the client
and ignored by all other consumers of the circuit.

The location of the pragma statement in the cQASM circuit is preserved,
_i.e._ no cQASM statements can be moved across a pragma statement.
This allows for the ability to embed client code into cQASM 
with the guarantee that the relative order between cQASM and client code remains the same.

The following example shows how sections of code, specific to a fictional client called 'backend',
can be interlaced with cQASM statements:

```linenums="1", hl_lines="6 17"
version 3.0

qubit[4] q
bit[2]

#backend {
    POS(0, 0) q[0]
    POS(1, 0) q[1]
    POS(0, 1) q[2]
    POS(1, 1) q[3]
}

init q

X q[0]

#backend {
    PULSE(0.000467, -0.971166, 0.157596)
    PULSE(0.001868, -0.942333, 0.157596)
    PULSE(0.004196, -0.913500, 0.157596)
    PULSE(0.007442, -0.884666, 0.157596)
}

H q
CNOT q[0], q[1]

b = measure q[0, 1]

```
