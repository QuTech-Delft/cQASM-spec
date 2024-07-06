The version statement is mandatory and indicates which version of the cQASM language the quantum program is written in.
Apart from comments, it must be the first statement of the program and occur only once.
It has the following general form:

`version M.m`

??? info "Grammar for version"

    _version_:</br>
    &nbsp;&nbsp;&nbsp;&nbsp;_major-version_ _minor-version-suffix<sub>opt<sub>_</br>
    _major-version_:</br>
    &nbsp;&nbsp;&nbsp;&nbsp;_digit-sequence_</br>
    _minor-version-suffix_:</br>
    &nbsp;&nbsp;&nbsp;&nbsp;<code>__.__</code> _minor-version_</br>
    _minor-version_:</br>
    &nbsp;&nbsp;&nbsp;&nbsp;_digit-sequence_

where the version number is to be given as two period separated integers, respectively indicating the major `M` and minor `m` version of the cQASM language.
It is permitted to only specify the major version number `M`, _i.e._, the specification of the minor version number `.m` is optional. In that case, `m` will be interpreted as `0`.

!!! example

    ```linenums="1"
    // Only comments may appear before the version statement.
    version 3.0
    ```
