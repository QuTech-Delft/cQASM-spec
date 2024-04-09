The first character of an identifier may either be an upper or lowercase letter from the ISO basic Latin alphabet or an underscore, _i.e._, it cannot be a digit.
Any following character(s) follow the same rule as the first character, but now may also be a digit.
Identifiers cannot contain spaces.
Identifiers ID must follow the following regular expression pattern,

`[_a-zA-Z][a-zA-Z0-9_]*`

Examples are given below

```
q
_i
Id
b01
2k	// Invalid identifier: first character cannot be a digit!
```

Note that there exist certain predefined keywords that cannot be used as an identifier; a list of these keywords can be found under the section _Keywords_.
