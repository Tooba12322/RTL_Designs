//Waveform : https://www.edaplayground.com/w/x/Be4

// Write the MIPS32 assembly language program and SV testbench 
// Compute the factorial of a number stored at memory location 200
// store result at memory location 198
// ADDI R10,R0,200 - 280A00C8
// ADDI R2,R0,1    - 28020001
// OR R20,R20,R20  - 0E94A000
// LW R3, 0 (R10)  - 21430000
// OR R20,R20,R20  - 0E94A000
// Loop : MUL R2,R2,R3  - 14431000
// SUBI R3,R3,1    - 2C630001
// BNEQZ R3,Loop   - 00832800
// SW R2,-2 (R10)  - 2543FFFE
// HLT             - FC000000

module MIPS32_tb3();
  logic clk_1,clk_2,rst;
  
  MIPS32 DUT(.*);
  
  initial
  begin
    $dumpfile("MIPS32.vcd");
    $dumpvars(0,MIPS32_tb3);
    $monitor ($time,"  rst=%b, clk_1=%b, clk_2=%b, R1=%d, R2=%d, R3=%d, R4=%d, R5=%d  ",rst,clk_1,clk_2,DUT.Reg[1],DUT.Reg[2],DUT.Reg[3],DUT.Reg[4],DUT.Reg[5]);
  end
  
  initial begin
    clk_1 = '0;
    clk_2 = '0;
    rst = '0;
    
    #10  rst = '1;
    
    #60 $finish;
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

  end
  
    always   #2 clk_1 = !clk_1;  
    always   #2 clk_2 = !clk_2; 
   
endmodule

