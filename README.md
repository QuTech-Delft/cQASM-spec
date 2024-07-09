# cQASM language specification

This repository contains the specification documents of the cQASM quantum programming language. 


## Documentation

The cQASM language specification documentation is hosted through GitHub Pages [here](https://qutech-delft.github.io/cQASM-spec/).


## Deployment

### MkDocs

The cQASM language specification documentation is generated using [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/),
a documentation framework on top of [MkDocs](https://www.mkdocs.org).

    mkdocs.yml                   # The configuration file
    mkdocs-base.yml              # Base configuration file
    docs/
        javascripts/             # JS configuration files for extensions
        language-specification   # The cQASM language specification
        index.md                 # The documentation homepage

You can serve the documentation locally at <http://localhost:8000> by running:

```shell
mkdocs serve
```

The documentation is hosted through GitHub Pages. To deploy the docs run:

```shell
mkdocs gh-deploy
```

### Using the Docker Container

The documentation can also be viewed via the provisioned Docker container.
Run the docker container with the following command

```shell
docker compose up -d
```

The documentation can now be viewed at <http://localhost:8106>.


## Authors

Quantum Inspire: [support@quantum-inspire.com](mailto:"support@quantum-inspire.com")