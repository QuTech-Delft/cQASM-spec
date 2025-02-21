Assembly declarations can be used to add backend-specific (assembly) code to a cQASM circuit.
An assembly declaration is realized through an **`asm`** _declaration_ statement.
An **`asm`** declaration statement consists of the keyword **`asm`** with the identifier of the backend in parentheses,
followed by a code block containing the asembly code enclosed in curly brackets:

!!! info "" 
    
    &emsp;**`asm(`**_backend-identifier_**`) {`** _assembly-code_ **`}`**

??? info "Grammar for assembly declaration"
    
    _assembly-declaration_:  
    &emsp;**`asm(`**_backend-identifier_**`)`** **`{`** _backend-code_ **`}`**

    _backend-identifier_:  
    &emsp; _identifier_

    _backend-code_:  
    &emsp; _raw-text_

As part of a cQASM circuit, the contents of the backend code will be passed verbatim to the backend
and ignored by all other consumers of the circuit.

The location of the **`asm`** declaration in the cQASM circuit is preserved,
_i.e._ no cQASM statements can be moved across it by any subsequent processing of the cQASM circuit.
This allows for the ability to embed backend code into cQASM 
with the guarantee that the relative order between cQASM and backend code remains the same.

The following example shows how sections of code, specific to a fictional backend,
can be interlaced with cQASM statements:

```linenums="1", hl_lines="6 17"
version 3.0

qubit[4] q
bit[2]

asm(Backend) {
    POS(0, 0) q[0]
    POS(1, 0) q[1]
    POS(0, 1) q[2]
    POS(1, 1) q[3]
}

init q

X q[0]

asm(Backend) {
    PULSE(0.000467, -0.971166, 0.157596)
    PULSE(0.001868, -0.942333, 0.157596)
    PULSE(0.004196, -0.913500, 0.157596)
    PULSE(0.007442, -0.884666, 0.157596)
}

H q
CNOT q[0], q[1]

b = measure q[0, 1]

```
