1. In the syntax notation used in this documentation, syntactic categories are indicated by _italic_ type,
and literal words and characters in <code>__boldface constant width__</code> type.  
Alternatives are listed on separate lines except in a few cases
where a long set of alternatives is presented on one line, with the help of "one of", "through" and "or".
For example:  
&nbsp;&nbsp;&nbsp;&nbsp;one of <code>__a__</code> through <code>__z__</code> or <code>__A__</code> through <code>__Z__</code>  
indicates any lowercase or uppercase alphabetic character.  
An optional terminal or non-terminal symbol is indicated by the subscript "<sub>opt</sub>", so  
&nbsp;&nbsp;&nbsp;&nbsp;<code>__{__</code> _expression<sub>opt</sub>_ <code>__}__</code>  
indicates an optional expression enclosed in braces.

2. Names for syntactic categories have generally been chosen according to the following rules:
     - _X-sequence_ is one or more _X_’s without intervening delimiters (e.g. _digit-sequence_ is a sequence of digits).
     - _X-list_ is one or more _X_’s separated by intervening commas (e.g. _index-list_ is a sequence of
indices separated by commas).