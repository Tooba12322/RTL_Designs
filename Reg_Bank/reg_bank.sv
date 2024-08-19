Requirements:
Parameterization:

The register bank should be parameterized to allow flexible configuration of the number of registers and the width of each register.
Parameters:
NUM_REGS: Number of registers in the register bank.
REG_WIDTH: Width of each register (in bits).
Dual-Port Operation:

The register bank should support dual-port access:
Port A: Read/Write port
Port B: Read-only port
Read and Write Operations:

Port A should support both read and write operations. The write operation should be performed on the rising edge of the clock if the write_enable signal is asserted.
Port B should support read operations only.
Reset Functionality:

On an active-low reset signal, all registers should be initialized to zero.
Addressing:

Both ports should be able to address the entire register bank, based on the NUM_REGS parameter.
Output:

Provide a read_data_a output for the data read from Port A and a read_data_b output for the data read from Port B.

