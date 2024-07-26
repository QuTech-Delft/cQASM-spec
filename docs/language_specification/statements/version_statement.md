The version statement is mandatory and indicates which version of the cQASM language the program is written in.
Apart from comments, it must be the first statement of the program and occur only once.
It has the following general form:

!!! info "" 
    
    &emsp;**`version`** _major-version_**`.`**_minor-version_

??? info "Grammar for version statement"

    _version_:  
    &emsp; _major-version_ _minor-version-suffix_~opt~

    _major-version_:  
    &emsp; _digit-sequence_

    _minor-version-suffix_:  
    &emsp; __`.`__ _minor-version_

    _minor-version_:  
    &emsp; _digit-sequence_

where the version number is to be given as two period separated integers,
respectively indicating the major and minor version of the cQASM language.
It is permitted to only specify the major version number, _i.e._,
the specification of the minor version number is optional.
In that case, the _minor-version_ will be interpreted as **`0`**.

!!! example

    ```linenums="1"
    // Only comments may appear before the version statement.
    version 3.0
    ```
