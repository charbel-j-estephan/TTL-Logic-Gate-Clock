# Clock Using Logic Gates

This project shows two ways to build a digital clock. The first uses discrete logic gates. The second implements the same design in Verilog. Both versions track seconds, minutes, and hours without a microcontroller or software running on a CPU.

## Table of Contents

* [Overview](#overview)
* [Features](#features)
* [Repository Structure](#repository-structure)
* [Logic Gate Implementation](#logic-gate-implementation)
* [Verilog Implementation](#verilog-implementation)
* [Getting Started](#getting-started)
* [Contributing](#contributing)
* [License](#license)

## Overview

The "Clock Using Logic Gates" project demonstrates timekeeping built entirely from digital logic. You get two implementations of the same idea.

The first version uses discrete gates and flip flops on a breadboard or in a schematic. The second version describes the same counting and display logic in Verilog, so you can simulate it or synthesize it onto an FPGA.

Both versions teach the same core concept. A clock is just a set of counters that reset at the right values and drive a display.

## Features

* Fully functional clock with seconds, minutes, and hours.
* One version built from discrete logic gates, no microcontroller involved.
* One version written in Verilog for simulation or FPGA synthesis.
* Modular design in both versions, so you can study each counting stage on its own.
* Educational and beginner friendly.

## Repository Structure

```
Clock-Using-Logic-Gates-/
├── logic-gates/
│   └── (schematics, simulation files, breadboard notes)
├── verilog/
│   └── (Verilog source files, testbenches)
└── README.md
```

Adjust the folder names above to match what you actually name them when you push the Verilog files.

## Logic Gate Implementation

### Required Components

* Basic logic gates (AND, OR, NOT, NAND, NOR, XOR).
* Flip flops (T, D, or JK).
* A clock signal generator.
* 7 segment displays or LEDs for time display.
* Resistors and capacitors for debouncing or smoothing signals, if needed.
* A power supply.

### How It Works

1. Clock pulse generation. A stable pulse generator provides the base timing signal.
2. Counting logic. Sequential counters track the number of pulses to calculate seconds, minutes, and hours.
3. Reset logic. The circuit resets properly when seconds reach 60 or hours reach 24 or 12, depending on configuration.
4. Display logic. Binary counters convert into decimal values for 7 segment displays or other output devices.

## Verilog Implementation

The Verilog version mirrors the logic gate design. It replaces physical gates and flip flops with synthesizable RTL, so you can simulate the whole clock before touching hardware, or synthesize it directly onto an FPGA.

### Required Tools

* A Verilog simulator, such as Icarus Verilog, ModelSim, or Vivado's built in simulator.
* An FPGA toolchain, such as Vivado or Quartus, if you plan to synthesize onto real hardware.
* An FPGA dev board, only if you want a physical output instead of simulation.

### How It Works

1. Clock divider. The module divides the FPGA's input clock down to a 1 Hz enable pulse.
2. Counting logic. Always blocks implement the seconds, minutes, and hours counters, each incrementing on the 1 Hz enable.
3. Reset logic. Each counter rolls over and increments the next stage once it hits its max value (60 for seconds and minutes, 24 or 12 for hours).
4. Display logic. A BCD to 7 segment decoder module converts each counter's value into segment outputs.
5. Testbench. A testbench drives the clock and reset signals so you can verify counting and rollover behavior in simulation before synthesizing.

## Getting Started

### Prerequisites

* Knowledge of digital logic gates and circuits.
* For the logic gate version: circuit simulation software like Logisim or Multisim, or a breadboard and components for a physical build.
* For the Verilog version: a Verilog simulator and, optionally, an FPGA toolchain and dev board.

### Steps

1. Clone this repository.

```
git clone https://github.com/charbel-j-estephan/Clock-Using-Logic-Gates-.git
```

2. For the logic gate version, open the design files in your circuit simulation software or follow the schematic for a hardware build.
3. For the Verilog version, open the source files in your simulator, run the testbench, and check the waveform output for correct counting and rollover.
4. If you want physical hardware, synthesize the Verilog onto your FPGA board and wire up your display.

## Contributing

Contributions are always welcome. If you want to improve either implementation or suggest enhancements, fork the repository, create a new branch, and submit a pull request. You can also open an issue for feedback or questions.

## License

This project is licensed under the MIT License.

Disclaimer. This project is for educational purposes only and may not function effectively in practical scenarios.
