# ⏱️ Digital Stopwatch using Verilog HDL

A synthesizable MM:SS digital stopwatch implemented in Verilog HDL, verified through behavioral simulation on Xilinx Vivado and Mentor ModelSim, and suitable for FPGA deployment.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Module Architecture](#module-architecture)
- [Signal Description](#signal-description)
- [File Structure](#file-structure)
- [Getting Started](#getting-started)
- [Simulation](#simulation)
- [RTL Schematic](#rtl-schematic)
- [Future Scope](#future-scope)
- [Author](#author)

---

## Overview

This project implements a **Digital Stopwatch** that counts elapsed time from `00:00` to `59:59` in MM:SS format using four BCD (Binary Coded Decimal) digit registers. The design uses synchronous sequential logic with enable-based start/stop control and a debounce sub-module for clean push-button input handling.

---

## Features

- ✅ MM:SS BCD counter (00:00 → 59:59) with automatic wrap-around
- ✅ Synchronous reset — clears all registers on the rising clock edge
- ✅ Debounced push-button inputs for start and stop
- ✅ Enable-based control — counter freezes on stop without resetting
- ✅ No unintended latches — clean RTL synthesis
- ✅ Verified on Xilinx Vivado (XSim) and Mentor ModelSim

---

## Module Architecture

The design consists of two cooperating Verilog modules:

### `stop_watch`
The top-level module. Accepts clock, reset, start, and stop inputs. Outputs four 4-bit BCD digit registers representing the current elapsed time.

### `debounce`
A counter-based debounce filter. Waits for the button signal to remain stable for `max_count = 10` clock cycles before updating the output, eliminating mechanical contact bounce.

---

## Signal Description

| Signal | Direction | Width | Description |
|--------|-----------|-------|-------------|
| `clk` | Input | 1-bit | System clock — counter advances on every posedge |
| `rst` | Input | 1-bit | Synchronous reset — clears all counters to 0 |
| `start` | Input | 1-bit | Raw start push-button (active high) |
| `stop` | Input | 1-bit | Raw stop push-button (active high) |
| `m1[3:0]` | Output | 4-bit | BCD tens digit of minutes (0–5) |
| `m0[3:0]` | Output | 4-bit | BCD units digit of minutes (0–9) |
| `s1[3:0]` | Output | 4-bit | BCD tens digit of seconds (0–5) |
| `s0[3:0]` | Output | 4-bit | BCD units digit of seconds (0–9) |

---


---

## Getting Started

### Prerequisites

- [Xilinx Vivado](https://www.xilinx.com/products/design-tools/vivado.html) (2020.x or later) — for synthesis and simulation
- [Mentor ModelSim](https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/model-sim.html) — for standalone HDL simulation (optional)

### Clone the Repository

```bash
git clone https://github.com/<your-username>/digital-stopwatch-verilog.git
cd digital-stopwatch-verilog
```

---

## Simulation

### Vivado (XSim)

1. Open Vivado and create a new RTL project.
2. Add `src/stop_watch.v` and `src/debounce.v` as design sources.
3. Add `tb/tbds.v` as a simulation source.
4. In the **Flow Navigator**, click **Run Simulation → Run Behavioral Simulation**.
5. Observe signals `clk`, `rst`, `start`, `stop`, `en`, `m1`, `m0`, `s1`, `s0` in the waveform window.

### ModelSim

```tcl
vlog src/stop_watch.v src/debounce.v tb/tbds.v
vsim tbds
add wave *
run -all
```

### Expected Testbench Behavior

| Time (ns) | Event | Expected Output |
|-----------|-------|-----------------|
| 0 – 100 | `rst = 1` | All outputs = 0 |
| 100 | `rst = 0` | Counter ready |
| 600 – 800 | `start = 1` | `en` goes high, `s0` increments |
| 950 – 1100 | `stop = 1` | `en` clears, counter freezes |

---

## RTL Schematic

After synthesis in Vivado, the RTL schematic reveals:

- **D Flip-Flop arrays** for each BCD register (`m1`, `m0`, `s1`, `s0`)
- **4-bit incrementers** for the +1 counting logic
- **Equality comparators** implementing the BCD carry conditions (`s0 == 9`, `s1 == 5`, etc.)
- **2-to-1 enable multiplexers** gating the counter increment path
- **Debounce cells** (d1, d2) as leaf modules connected to start/stop ports

The design synthesizes with **no unintended latches**, confirming complete case coverage in all `always` blocks.

---

## Future Scope

- 🔲 **FPGA Deployment** — Program onto Xilinx Basys 3 / Nexys A7 with 7-segment display output
- 🔲 **Lap Time Recording** — Capture current time on a secondary display while counting continues
- 🔲 **Millisecond Precision** — Add centiseconds BCD stage below `s0`
- 🔲 **Clock Divider** — Integrate a 100 MHz → 1 Hz frequency divider for real FPGA boards
- 🔲 **7-Segment Decoder** — Connect BCD outputs to a BCD-to-7-segment display module
- 🔲 **RTC Integration** — Combine with a real-time clock for time-of-day + elapsed-time display

---

## Author

**Gayatri Galidevara**
Digital System Design Laboratory

---

## License

This project is submitted as an academic laboratory report. Feel free to use it for educational purposes.

