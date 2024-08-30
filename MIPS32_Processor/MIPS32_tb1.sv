// Write the MIPS32 assembly language program and SV testbench
// Intializa R1=10; R2=20; R3=30
// Add R1+R2+R3 and store result in R5
// ADDI R1,R0,10 - 2801000A
// ADDI R2,R0,20 - 28020014
// ADDI R3,R0,30 - 28030019
// OR R7,R7,R7   - 0CE77800
// OR R7,R7,R7   - 0CE77800
// ADD R4,R1,R2  - 00222000
// OR R7,R7,R7   - 0CE77800
// ADD R5,R4,R3  - 00832800
// HLT           - FC000000

module MIPS32_tb1();
endmodule
