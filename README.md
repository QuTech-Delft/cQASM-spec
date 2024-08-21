# cQASM language specification

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This repository contains the language specification of the cQASM quantum programming language
(*c*ommon *Q*uantum *AS*se*M*bly language).

The [cQASM language specification](https://qutech-delft.github.io/cQASM-spec/) is hosted through GitHub Pages.

## How to generate the cQASM language specification locally

Clone the repository to your local machine:

```shell
git clone https://github.com/QuTech-Delft/cQASM-spec.git
```

We recommend to create a virtual environment (_e.g._, [venv](https://docs.python.org/3/library/venv.html)),
run it, and install the requirements:

```shell
pip install -r requirements.txt
```

Once the required dependencies are installed,
the language specification can be served locally at <http://localhost:8000> by running:

```shell
mkdocs serve
```

The language specification can also be viewed via a provisioned Docker container.
No virtual environment is required in this case. Run the Docker container with the following command:

```shell
docker compose up -d
```

The language specification can now be viewed at <http://localhost:8106>.

## License

The cQASM language specification is licensed under the Apache License, Version 2.0.
See [LICENSE](https://github.com/QuTech-Delft/cQASM-spec/blob/master/LICENSE.md) for the full license text.

## Authors

Quantum Inspire: [support@quantum-inspire.com](mailto:"support@quantum-inspire.com")
