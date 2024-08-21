# cQASM language specification

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This repository contains the language specification of the cQASM quantum programming language.
cQASM stands for *c*ommon *Q*uantum *AS*se*M*bly language.

## Deployment

### MkDocs

The cQASM language specification documentation is generated using [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/),
a documentation framework on top of [MkDocs](https://www.mkdocs.org).

    mkdocs.yml                   # The configuration file
    mkdocs-base.yml              # Base configuration file
    docs/
        index.md                 # The documentation homepage
        introduction/            # History, context, acknowledgements
        language_specification/  # The cQASM language specification
        appendices/              # Spin-2
        javascripts/             # JS configuration files for extensions

You can serve the documentation locally at <http://localhost:8000> by running:

```shell
mkdocs serve
```

The documentation is hosted through GitHub Pages. To deploy the docs run:

```shell
mkdocs gh-deploy
```

### Using the Docker container

The documentation can also be viewed via the provisioned Docker container.
Run the docker container with the following command:

```shell
docker compose up -d
```

The documentation can now be viewed at <http://localhost:8106>.

## Documentation

The [cQASM language specification documentation](https://qutech-delft.github.io/cQASM-spec/) is hosted through GitHub Pages.

## License

The cQASM language specification is licensed under the Apache License, Version 2.0.
See [LICENSE](https://github.com/QuTech-Delft/cQASM-spec/blob/master/LICENSE.md) for the full license text.

## Authors

Quantum Inspire: [support@quantum-inspire.com](mailto:"support@quantum-inspire.com")
