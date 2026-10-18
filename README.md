# Mano's Basic Computer — Verilog HDL

A modular Verilog implementation of Mano's Basic Computer, developed as part of a university Computer Architecture Laboratory group project.

## Overview

This project explores the design and RTL description of Mano's Basic Computer, based on Chapter 5 of *Computer System Architecture* by M. Morris Mano.

The implementation is organized into multiple Verilog source files, separating the datapath, control logic, registers, arithmetic and logic unit (ALU), shared bus, and main memory.

The project was developed as part of an academic assignment focusing on memory-reference and register-reference instructions.

## Project Information

- **Course:** Computer Architecture Laboratory
- **University:** Qom University of Technology
- **Academic Year:** 1404 SH (2025)
- **Hardware Description Language:** Verilog HDL
- **Simulation Tool:** ModelSim

## Architecture

The design is built around a top-level module that connects the datapath and the control unit.

### Main Components

| Module | Description |
|---|---|
| `TopModule` | Integrates the control unit and datapath |
| `DataPath` | Connects the processor registers, ALU, shared bus, and memory |
| `TimingControlUnit` | Generates control signals and sequences instruction execution using an FSM |
| `Register` | Implements configurable-width registers with load, clear, and increment controls |
| `ALU` | Performs arithmetic and logical operations |
| `Bus` | Routes data between datapath components |
| `Memory` | Implements main memory and initializes the program and test data |
| `TopModule_tb` | Provides the clock and reset and displays selected memory values |

### Datapath

The datapath uses 16-bit data paths and 12-bit address registers.

The implemented register components include:

- **AC:** Accumulator
- **DR:** Data Register
- **AR:** Address Register
- **IR:** Instruction Register
- **PC:** Program Counter
- **TR:** Temporary Register
- **E:** Carry / extension flag

The main memory is modeled as 4096 words, each 16 bits wide.

### Control Unit

The control unit uses a finite-state machine (FSM) with timing states to sequence instruction fetching, decoding, indirect addressing, and execution.

It generates control signals for register operations, ALU selection, bus selection, and memory access.

## Instruction Set

The source code includes implementations for the following memory-reference instructions:

- `AND`
- `ADD`
- `LDA`
- `STA`
- `BUN`
- `BSA`
- `ISZ`

The register-reference operations represented in the control logic include:

- `CLA` — Clear AC
- `CLE` — Clear E
- `CMA` — Complement AC
- `CME` — Complement E
- `CIR` — Circulate right
- `CIL` — Circulate left
- `INC` — Increment AC
- `SPA` — Skip if AC is positive
- `SNA` — Skip if AC is negative
- `SZA` — Skip if AC is zero
- `SZE` — Skip if E is zero
- `HLT` — Halt

The stated coursework scope excludes I/O instructions.

## Program and Memory Layout

The initialized memory contains a main program and arithmetic subroutines for addition, subtraction, and multiplication.

The designated memory locations are:

| Address | Description | Expected Value |
|---|---|---|
| `F00` | First operand | 16 (`0x0010`) |
| `F01` | Second operand | 5 (`0x0005`) |
| `F02` | Addition result | 21 (`0x0015`) |
| `F03` | Subtraction result | 11 (`0x000B`) |
| `F04` | Multiplication result | 80 (`0x0050`) |

The expected arithmetic results for the initialized operands are:

- Addition: 16 + 5 = 21
- Subtraction: 16 − 5 = 11
- Multiplication: 16 × 5 = 80

These are the intended results; they are not presented as independently verified test results in this repository.

## Repository Structure

```text
mano-computer-verilog/
├── README.md
├── .gitignore
├── rtl/
│   ├── ALU.v
│   ├── BUS.v
│   ├── Register.v
│   ├── Memory.v
│   ├── DataPath.v
│   ├── ControlUnit.v
│   └── TopModule.v
└── tb/
    └── TestBench.v
```

## Simulation

The project was simulated using ModelSim during the original coursework.

The testbench generates a clock with a 10 ns period, applies a reset sequence, and displays the contents of the designated memory locations before and after the execution interval.

Final-version waveform screenshots are not currently included in this repository.

### Running with ModelSim

From the repository root, compile the source files in ModelSim:

```tcl
vlib work
vlog rtl/Register.v rtl/ALU.v rtl/BUS.v rtl/Memory.v rtl/DataPath.v rtl/ControlUnit.v rtl/TopModule.v tb/TestBench.v
vsim -c work.TopModule_tb -do "run -all; quit -f"
```

These commands assume the repository follows the directory structure shown above. They should be checked against the local ModelSim environment before being treated as a verified reproduction procedure.

## Implementation Notes

This repository preserves my own implementation as developed during the coursework.

Some implementation details differ from the original assignment specification. The source files are presented as they were developed, without claiming complete compliance with every specification requirement or independent verification of every instruction.

## Author

**Zahra**

[GitHub Profile](https://github.com/zahra357)

## Team Collaboration

This project was developed as part of a university group assignment with [Fatemeh Schavoshi](https://github.com/fatemehschavoshi).

## Acknowledgments

Developed as part of the Computer Architecture Laboratory coursework at Qom University of Technology.