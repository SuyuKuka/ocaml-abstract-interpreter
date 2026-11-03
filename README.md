# OCaml Abstract Interpreter

## About

**OCaml Abstract Interpreter** is a third-year Bachelor's (L3) project at Université Paris Cité focused on the design and implementation of an abstract interpreter in **OCaml**. Built using modern functional programming principles and OCaml tooling (Dune, Opam), this project demonstrates a deep understanding of static analysis techniques, safety properties approximation, abstract domains, and geometric abstractions to analyze program behaviors.

The project features a modular architecture where separate components handle approximations, abstract state evaluation, execution traces, and geometric domain representations.

*Note: As this was an academic project, documentation and comments may contain some French.*

## Tech Stack

- **Language:** OCaml
- **Build System:** Dune
- **Package Manager:** Opam
- **Architecture:** Modular components for approximation, execution, interpretation, and geometry handling (`approx.ml`, `interp.ml`, `exec.ml`, `geo.ml`)

## Key Features

- **Abstract Interpretation Engine:** Core implementation of an interpreter capable of reasoning over abstract domains rather than concrete values.
- **Approximation & Domains:** Dedicated modules (`approx.ml`) handling state approximations and abstract transformations.
- **Geometric Abstractions:** Spatial and geometric representation modules (`geo.ml`) for analyzing numerical domains or shape properties.
- **Execution & Evaluation:** Structured execution engine (`exec.ml`, `interp.ml`) for processing instructions and tracking abstract states.
- **Testing & Validation:** Comprehensive test suites using Dune (`test/`) to validate base components and abstract interpretations.

## Project Structure

```text
📁 ocaml-abstract-interpreter/
│
├── 📁 src/                         # OCaml source files
│   ├── 📄 approx.ml / .mli         # Approximation logic & abstract domains
│   ├── 📄 display.ml / .mli        # Rendering and display utilities
│   ├── 📄 exec.ml / .mli           # Program execution engine
│   ├── 📄 geo.ml / .mli            # Geometric abstractions and domains
│   ├── 📄 interp.ml / .mli         # Core interpreter logic
│   ├── 📄 main.ml / .mli           # Entry point
│   ├── 📄 read.ml / .mli           # Parser / input reader
│   ├── 📄 utils.ml / .mli          # Utility functions
│   └── 📄 dune                     # Dune build configuration for source
│
├── 📁 test/                        # Test suite
│   ├── 📄 test.ml                  # Main test runner
│   ├── 📄 test_absint.ml / .mli    # Abstract interpreter tests
│   ├── 📄 test_base.ml / .mli      # Base component tests
│   └── 📄 dune                     # Dune build configuration for tests
│
├── 📄 dune-project                 # Dune project definition
├── 📄 Makefile                     # Build shortcuts
├── 📄 pf5.opam                     # Opam package definition
├── 📄 top.ml                       # Top-level integration file
└── 📄 README.md                    # Project documentation
```

## Getting Started

### Prerequisites

* OCaml (v4.14 or compatible)
* Dune build system
* [Opam package manager](https://opam.ocaml.org/) 

### Package Installation

1. **Clone the repository:**
```bash
git clone https://github.com/SuyuKuka/ocaml-abstract-interpreter.git
cd ocaml-abstract-interpreter
```

2. **Create a local opam switch and install dependencies:**

Place yourself inside the cloned directory, then run the following commands:
```bash
opam update
opam switch create . 4.14.1 -y --deps-only
```

### Compilation & Usage

1. **Compilation**  
To compile the project, run the following command
```bash
make
```

2. **Toplevel (utop)**  
To test and debug interactively, you can use the installed utop toplevel. To launch it, run:
```bash
make top
```

3. **Tests**  
* To run all available tests:
```bash
make test
```

* To test only the functions of exercise i:
```bash
make test-i
```

## Team

This project was developed collaboratively as a 2-person team:

- **CHEN Michel** - OCaml Development
  [![GitHub](https://img.shields.io/badge/GitHub-Profile-181717?logo=github)](https://github.com/SuyuKuka)
  [![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-0A66C2?logo=linkedin)](https://linkedin.com/in/chen-michel)

- **ROIG Lucas** - OCaml Development
  [![GitHub](https://img.shields.io/badge/GitHub-Profile-181717?logo=github)](https://github.com/ll-tykas)

## License

This repository contains academic coursework.
- The initial framework are the intellectual property of the teaching staff. They are included here strictly for context and evaluation purposes.
- The implementations, abstract domains, and logic are our team's work.

This project is shared for portfolio and reference purposes only.