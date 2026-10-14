# UART Receiver in Verilog HDL

## Overview

This project implements a UART (Universal Asynchronous Receiver/Transmitter) Receiver using Verilog HDL. The receiver captures serial data, detects the start and stop bits, and reconstructs an 8-bit parallel data output.

The design was developed and tested using **Xilinx Vivado 2024.2** and synthesized for a **Xilinx Artix-7 FPGA**.

## Features

- UART serial data reception
- 8-bit data frame, LSB first
- Start bit detection and validation
- Stop bit processing
- Two-stage synchronizer for the asynchronous RX input
- Finite State Machine (FSM)-based control
- Parameterized clock frequency and baud rate
- Behavioral simulation using a Verilog testbench
- FPGA synthesis and resource utilization analysis

## UART Frame Format

| Field | Description |
|---|---|
| Start bit | Logic 0 |
| Data bits | 8 bits, LSB first |
| Stop bit | Logic 1 |

## Design Specifications

| Parameter | Value |
|---|---|
| HDL | Verilog |
| FPGA Family | Xilinx Artix-7 |
| Target Part | `xc7a35tcpg236-1` |
| Development Tool | Xilinx Vivado 2024.2 |
| Default Clock Frequency | 100 MHz |
| Default Baud Rate | 9600 |
| Data Width | 8 bits |
| Reception Order | LSB first |

## Module Interface

### `uart_rx`

| Signal | Direction | Width | Description |
|---|---|---|---|
| `clk` | Input | 1 bit | System clock |
| `rst` | Input | 1 bit | Active-high reset |
| `rx` | Input | 1 bit | UART serial input |
| `rx_data` | Output | 8 bits | Received parallel data |
| `rx_done` | Output | 1 bit | One-cycle pulse when reception completes |

## FSM Operation

The receiver uses four states:

1. **IDLE** – Waits for the start bit.
2. **START** – Validates the start bit near its midpoint.
3. **DATA** – Samples eight data bits, LSB first.
4. **STOP** – Processes the stop bit, updates `rx_data`, and asserts `rx_done`.

A two-stage synchronizer is used to help reduce metastability risk when sampling the asynchronous RX input.

## Simulation and Verification

The design was verified using a Verilog testbench in Vivado Simulator (XSim).

### Test Configuration

| Parameter | Test Value |
|---|---|
| Simulation clock frequency | 100 Hz |
| Simulation baud rate | 10 baud |
| Clocks per bit | 10 |
| Test byte | `8'hA5` |

Reduced parameter values were used to shorten simulation time. The RTL defaults remain 100 MHz and 9600 baud.

### Simulation Result

The receiver successfully reconstructed the test byte.

- Expected data: `A5`
- Received data: `A5`
- Status: **PASS**

```text
Sending UART byte: a5
PASS: Received data correctly: a5
ALL UART RX TESTS PASSED
```

### Screenshot 1: Simulation Test Results

This screenshot shows the successful testbench output confirming correct reception of `0xA5`.

# UART Receiver in Verilog HDL

## Overview

This project implements a UART (Universal Asynchronous Receiver/Transmitter) Receiver using Verilog HDL. The receiver captures serial data, detects the start and stop bits, and reconstructs an 8-bit parallel data output.

The design was developed and tested using **Xilinx Vivado 2024.2** and synthesized for a **Xilinx Artix-7 FPGA**.

## Features

- UART serial data reception
- 8-bit data frame, LSB first
- Start bit detection and validation
- Stop bit processing
- Two-stage synchronizer for the asynchronous RX input
- Finite State Machine (FSM)-based control
- Parameterized clock frequency and baud rate
- Behavioral simulation using a Verilog testbench
- FPGA synthesis and resource utilization analysis

## UART Frame Format

| Field | Description |
|---|---|
| Start bit | Logic 0 |
| Data bits | 8 bits, LSB first |
| Stop bit | Logic 1 |

## Design Specifications

| Parameter | Value |
|---|---|
| HDL | Verilog |
| FPGA Family | Xilinx Artix-7 |
| Target Part | `xc7a35tcpg236-1` |
| Development Tool | Xilinx Vivado 2024.2 |
| Default Clock Frequency | 100 MHz |
| Default Baud Rate | 9600 |
| Data Width | 8 bits |
| Reception Order | LSB first |

## Module Interface

### `uart_rx`

| Signal | Direction | Width | Description |
|---|---|---|---|
| `clk` | Input | 1 bit | System clock |
| `rst` | Input | 1 bit | Active-high reset |
| `rx` | Input | 1 bit | UART serial input |
| `rx_data` | Output | 8 bits | Received parallel data |
| `rx_done` | Output | 1 bit | One-cycle pulse when reception completes |

## FSM Operation

The receiver uses four states:

1. **IDLE** – Waits for the start bit.
2. **START** – Validates the start bit near its midpoint.
3. **DATA** – Samples eight data bits, LSB first.
4. **STOP** – Processes the stop bit, updates `rx_data`, and asserts `rx_done`.

A two-stage synchronizer is used to help reduce metastability risk when sampling the asynchronous RX input.

## Simulation and Verification

The design was verified using a Verilog testbench in Vivado Simulator (XSim).

### Test Configuration

| Parameter | Test Value |
|---|---|
| Simulation clock frequency | 100 Hz |
| Simulation baud rate | 10 baud |
| Clocks per bit | 10 |
| Test byte | `8'hA5` |

Reduced parameter values were used to shorten simulation time. The RTL defaults remain 100 MHz and 9600 baud.

### Simulation Result

The receiver successfully reconstructed the test byte.

- Expected data: `A5`
- Received data: `A5`
- Status: **PASS**

```text
Sending UART byte: a5
PASS: Received data correctly: a5
ALL UART RX TESTS PASSED
```

### Screenshot 1: Simulation Test Results

This screenshot shows the successful testbench output confirming correct reception of `0xA5`.

<img width="1212" height="432" alt="image" src="https://github.com/user-attachments/assets/ef1be7c3-9d0c-4fc0-8e50-31af96a69473" />

## Waveform Analysis

The simulation waveform can be used to inspect the clock, reset, serial input, received data, and receive-completion pulse.

### Screenshot 2: UART Receiver Waveform

<img width="1587" height="501" alt="image" src="https://github.com/user-attachments/assets/819d24c2-ea14-44ad-bbde-7ec11c460691" />

## Synthesis Results

The design was synthesized using Xilinx Vivado 2024.2 for the target device `xc7a35tcpg236-1`.

| Resource | Used | Available | Utilization |
|---|---:|---:|---:|
| LUT | 49 | 20,800 | 0.24% |
| Flip-Flops (FF) | 56 | 41,600 | 0.13% |
| I/O | 12 | 106 | 11.32% |

### Screenshot 3: FPGA Resource Utilization

The report below documents the resource utilization reported by Vivado after synthesis.

<img width="936" height="327" alt="image" src="https://github.com/user-attachments/assets/de82feb1-d5e9-4ac2-8575-1be6227a0b4b" />

## Project Structure

```text
UART-Receiver-Verilog/
├── uart_rx.v
├── tb_uart_rx.v
├── README.md
└── screenshots/
    ├── uart_rx_simulation.png
    ├── uart_rx_waveform.png
    └── uart_rx_utilization.png
```

## How to Run

1. Open Xilinx Vivado 2024.2.
2. Create or open a project targeting `xc7a35tcpg236-1`.
3. Add `uart_rx.v` under **Design Sources**.
4. Add `tb_uart_rx.v` under **Simulation Sources**.
5. Set `tb_uart_rx` as the simulation top module.
6. Click **Run Behavioral Simulation**.
7. In the Tcl Console, enter `run 5 us` if additional simulation time is needed.
8. Confirm the output contains `ALL UART RX TESTS PASSED`.
9. Run synthesis and open the utilization report.

## Learning Outcomes

- UART serial communication fundamentals
- FSM-based RTL design
- Clock-cycle-based serial sampling
- Synchronization of asynchronous inputs
- Verilog testbench development
- Behavioral simulation and debugging
- FPGA synthesis and resource utilization analysis

## Author

**Kavin K K**

GitHub: [@kavinkk0509](https://github.com/kavinkk0509)

## License

This project is intended for educational and learning purposes. Add an open-source license if you intend to distribute the project under specific reuse terms.

## Waveform Analysis

The simulation waveform can be used to inspect the clock, reset, serial input, received data, and receive-completion pulse.

### Screenshot 2: UART Receiver Waveform

![UART Receiver Simulation Waveform](screenshots/uart_rx_waveform.png)

## Synthesis Results

The design was synthesized using Xilinx Vivado 2024.2 for the target device `xc7a35tcpg236-1`.

| Resource | Used | Available | Utilization |
|---|---:|---:|---:|
| LUT | 49 | 20,800 | 0.24% |
| Flip-Flops (FF) | 56 | 41,600 | 0.13% |
| I/O | 12 | 106 | 11.32% |

### Screenshot 3: FPGA Resource Utilization

The report below documents the resource utilization reported by Vivado after synthesis.

![UART Receiver Synthesis Utilization Report](screenshots/uart_rx_utilization.png)

## Project Structure

```text
UART-Receiver-Verilog/
├── uart_rx.v
├── tb_uart_rx.v
├── README.md
└── screenshots/
    ├── uart_rx_simulation.png
    ├── uart_rx_waveform.png
    └── uart_rx_utilization.png
```

## How to Run

1. Open Xilinx Vivado 2024.2.
2. Create or open a project targeting `xc7a35tcpg236-1`.
3. Add `uart_rx.v` under **Design Sources**.
4. Add `tb_uart_rx.v` under **Simulation Sources**.
5. Set `tb_uart_rx` as the simulation top module.
6. Click **Run Behavioral Simulation**.
7. In the Tcl Console, enter `run 5 us` if additional simulation time is needed.
8. Confirm the output contains `ALL UART RX TESTS PASSED`.
9. Run synthesis and open the utilization report.

## Learning Outcomes

- UART serial communication fundamentals
- FSM-based RTL design
- Clock-cycle-based serial sampling
- Synchronization of asynchronous inputs
- Verilog testbench development
- Behavioral simulation and debugging
- FPGA synthesis and resource utilization analysis

## Author

**Kavin K K**

GitHub: [@kavinkk0509](https://github.com/kavinkk0509)

## License

This project is intended for educational and learning purposes. Add an open-source license if you intend to distribute the project under specific reuse terms.
