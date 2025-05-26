This documentation describes the language specification of the cQASM quantum programming language, version 3.0.
cQASM stands for common Quantum ASseMbly language, and is pronounced _c-kazem_.

cQASM 3.0 supersedes the [cQASM 1.[012] languages](https://libqasm.readthedocs.io/en/latest/) and [cQASM 2.0 language specification](https://github.com/QuTech-Delft/cQASM-spec/tree/2.0-draft-2), the latter of which remains incomplete.

!!! note

    Even though cQASM 3.0 is conceptually similar to previous language specifications, it is not a straightforward extension thereof; the syntax and grammar of cQASM 3.0 differ fundamentally from its predecessors. These changes break backwards compatibility.

In the rest of the documentation we will drop the version label of language and simply refer to it as the cQASM language.

!!! warning

    The cQASM language is currently under active development. 
    cQASM 3.0 serves as a minimum viable product; to be used as a baseline version for the further development of, _e.g._, the [libQASM](https://github.com/QuTech-Delft/libqasm) language parser library, [OpenSquirrel](https://github.com/QuTech-Delft/OpenSquirrel) quantum algorithm compiler, and [QX simulator](https://github.com/QuTech-Delft/qx-simulator).
    The cQASM specification will be updated as new features are introduced to the language.
    Where applicable, these features are then also implemented in the aformentioned software components, in an iterative fashion.
    
