
//Waveform : 

// Write the MIPS32 assembly language program and SV testbench 
// Compute the factorial of a number stored at memory location 200
// store result at memory location 198
// ADDI R10,R0,200 - 280A00C8
// ADDI R2,R0,1    - 28020001
// OR R20,R20,R20  - 0E94A000
// LW R3, 0 (R10)  - 21430000
// OR R20,R20,R20  - 0E94A000
// OR R20,R20,R20  - 0E94A000
// OR R20,R20,R20  - 0E94A000
// Loop : MUL R2,R2,R3  - 14431000
// SUBI R3,R3,1    - 2C630001
// OR R20,R20,R20  - 0E94A000
// OR R20,R20,R20  - 0E94A000
// BNEQZ R3,Loop   - 3460FFFB
// OR R20,R20,R20  - 0E94A000
// OR R20,R20,R20  - 0E94A000
// SW R2,-2 (R10)  - 2542FFFE
// HLT             - FC000000

module MIPS32_tb3();
  logic clk_1,clk_2,rst;
  
  MIPS32 DUT(.*);
  
  initial
  begin
    $dumpfile("MIPS32.vcd");
    $dumpvars(0,MIPS32_tb3);
    $monitor ($time,"  rst=%b, clk_1=%b, clk_2=%b, R10=%d, R2=%d, R3=%d, D_Mem[200]=%d, D_Mem[198]=%d  ",rst,clk_1,clk_2,DUT.Reg[10],DUT.Reg[2],DUT.Reg[3],DUT.D_Mem[200],DUT.D_Mem[198]);
  end
  
  initial begin
    clk_1 = '0;
    clk_2 = '0;
    rst = '0;
    
    #10  rst = '1;
    
    #180 $finish;
  end
  
  initial begin
    for (int i='0; i<32; i++) begin
      DUT.Reg[i] = i+i;
    end

    for (int i='0; i<512; i++) begin
      DUT.D_Mem[i] = 5;
    end
   
    DUT.I_Mem[0] = 32'h280A00C8;
    DUT.I_Mem[1] = 32'h28020001;
    DUT.I_Mem[2] = 32'h0E94A000;
    DUT.I_Mem[3] = 32'h21430000;
    DUT.I_Mem[4] = 32'h0E94A000;
    DUT.I_Mem[5] = 32'h0E94A000;
    DUT.I_Mem[6] = 32'h0E94A000;
    DUT.I_Mem[7] = 32'h14431000;
    DUT.I_Mem[8] = 32'h2C630001;
    DUT.I_Mem[9] = 32'h0E94A000;
    DUT.I_Mem[10] = 32'h0E94A000;
    DUT.I_Mem[11] = 32'h3460FFFB;
    DUT.I_Mem[12] = 32'h0E94A000;
    DUT.I_Mem[13] = 32'h2542FFFE;
    DUT.I_Mem[14] = 32'hFC000000;

  end
  
    always   #2 clk_1 = !clk_1;  
    always   #2 clk_2 = !clk_2; 
   
endmodule
