
// Write the MIPS32 assembly language program and SV testbench
// Intializa R1=10; R2=20; R3=30
// Add R1+R2+R3 and store result in R5
// ADDI R1,R0,10 - 2801000A
// ADDI R2,R0,20 - 28020014
// ADDI R3,R0,25 - 28030019
// OR R7,R7,R7   - 0CE77800
// OR R7,R7,R7   - 0CE77800
// ADD R4,R1,R2  - 00222000
// OR R7,R7,R7   - 0CE77800
// ADD R5,R4,R3  - 00832800
// HLT           - FC000000


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
  logic clk_1,clk_2,rst;
  
  MIPS32 DUT(.*);
  
  initial
  begin
    $dumpfile("MIPS32.vcd");
    $dumpvars(0,MIPS32_tb2);
    $monitor ($time,"  rst=%b, clk_1=%b, clk_2=%b, R1=%d, R2=%d, R3=%d, R4=%d, R5=%d  ",rst,clk_1,clk_2,DUT.Reg[1],DUT.Reg[2],DUT.Reg[3],DUT.Reg[4],DUT.Reg[5]);
  end
  
  initial begin
    clk_1 = '0;
    clk_2 = '0;
    rst = '0;
    
    #10  rst = '1;
    
    #100 rst = '0;
    
    #10 rst = '1;
    
    #80 $finish;
  end
  
  initial begin
    for (int i='0; i<32; i++) begin
      DUT.Reg[i] = i+i;
    end
    
    for (int i='0; i<512; i++) begin
      DUT.D_Mem[i] = i;
    end
    
    DUT.I_Mem[0] = 32'h2801000A;
    DUT.I_Mem[1] = 32'h28020014;
    DUT.I_Mem[2] = 32'h28030019;
    DUT.I_Mem[3] = 32'h0CE77800;
    DUT.I_Mem[4] = 32'h0CE77800;
    DUT.I_Mem[5] = 32'h00222000;
    DUT.I_Mem[6] = 32'h0CE77800;
    DUT.I_Mem[7] = 32'h0CE77800;
    DUT.I_Mem[8] = 32'h0CE77800;
    DUT.I_Mem[9] = 32'h00832800;
    DUT.I_Mem[10] = 32'hFC000000;

    #120;
    
    DUT.I_Mem[0] = 32'h28020078;
    DUT.I_Mem[1] = 32'h20220000;
    DUT.I_Mem[2] = 32'h0CE77800;
    DUT.I_Mem[3] = 32'h2822005D;
    DUT.I_Mem[4] = 32'h0CE77800;
    DUT.I_Mem[5] = 32'h24420001;
    DUT.I_Mem[6] = 32'hFC000000;
  end
  
    always   #2 clk_1 = !clk_1;  
    always   #2 clk_2 = !clk_2; 
   
endmodule
