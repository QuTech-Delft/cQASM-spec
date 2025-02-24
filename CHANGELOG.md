# Changelog

All notable changes to this project will be documented in this file.

### Types of changes:
* **Added** for new features.
* **Changed** for changes in existing functionality.
* **Fixed** for any bug fixes.
* **Removed** for now removed features.


## [<version>] - [ xxxx-yy-zz ]

### Added

- `Rn` single-qubit unitary instruction.

## [3.0-beta2] - [ 2025-02-18 ]

### Added

- `SWAP` two-qubit unitary instruction.
- `init` non-unitary instruction.
- `barrier` and `wait` control instructions.
- `inv`, `pow`, and `ctrl` gate modifiers.

## [3.0-beta1] - [ 2024-10-16 ]

The first (beta) release of the new cQASM language.

Main changes with respect to previous cQASM versions are:

- Case sensitive syntax.
- Decoupled qubit and bit registers.
- Qubit and bit register variable declarations.
- `q` and `b` are no longer reserved identifiers.
- Assignment of measurement outcomes to bit variables.
- Single-line comments through double-slash notation (`//`), instead of the hashtag notation (`#`).

> **Note**: this version of cQASM is not backwards compatible with previous versions of the language.