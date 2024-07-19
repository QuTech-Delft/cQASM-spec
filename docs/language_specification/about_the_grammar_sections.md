In the syntax notation used in this language specification, syntactic categories are indicated by _italic_ type,
and literal words and characters in __`bold constant width`__ type.
Alternatives are listed on separate lines except in a few cases
where a long set of alternatives is presented on one line, with the quantifiers 'one of', 'through', or 'or'.
For example,

&emsp; one of __`a`__ through __`z`__ or __`A`__ through __`Z`__

indicates any lowercase or uppercase alphabetic character.

An optional terminal or non-terminal symbol is indicated by the subscript ~opt~, so

&emsp; __`{`__ _expression_~opt~__`}`__

indicates an optional expression enclosed in curly braces.

Names for syntactic categories have generally been chosen according to the following rules:

- _X-sequence_ is one or more _X_’s without intervening delimiters, _e.g._, _digit-sequence_ is a sequence of digits.
- _X-list_ is one or more _X_’s separated by intervening commas, _e.g._, _index-list_ is a sequence of 
indices separated by commas.