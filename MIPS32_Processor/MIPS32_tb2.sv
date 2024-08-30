// Write the MIPS32 assembly language program and SV testbench
// Load value of memory location 120 into Reg R2
// Add 45 to R2 and store result in memory location 121
// ADDI R1,R0,120 - 28020078
// LW R2,0 (R1)   - 20220000
// OR R7,R7,R7    - 0CE77800
// ADDI R2,R2,45  - 2822005D
// OR R7,R7,R7    - 0CE77800
// SW R2,1 (R1)   - 24420001
// HLT            - FC000000

module MIPS32_tb2();
endmodule
