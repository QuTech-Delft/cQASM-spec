A raw text string is a sequence of zero or more characters delimited by triple quotes.
Any character, including whitespaces, comments, and newlines, can be part of a raw text string.

??? info "Grammar for raw text string"

    _raw-text-string_:  
    &emsp; **`'''`** raw-text~opt~ **`'''`**

    _raw-text_:  
    &emsp; raw-char  
    &emsp; raw-text raw-char

    _raw-char_:  
    &emsp; any character

!!! warning

    Even though any sequence of characters could be raw text,
    one should avoid using triple qoutes (**`'''`**)
    as they will be interpreted as the delimiters of the raw text string.

A raw text string is used in an [assembly declaration](../statements/assembly_declaration.md) to describe backend code.
