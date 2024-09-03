//Waveform : https://www.edaplayground.com/w/x/Be4

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

module MIPS32_tb1();
  logic clk_1,clk_2,rst;
  
  MIPS32 DUT(.*);
  
  initial
  begin
    $dumpfile("MIPS32.vcd");
    $dumpvars(0,MIPS32_tb1);
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

Output :
0  rst=0, clk_1=0, clk_2=0, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10  
                   2  rst=0, clk_1=1, clk_2=1, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10  
                   4  rst=0, clk_1=0, clk_2=0, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10  
                   6  rst=0, clk_1=1, clk_2=1, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10  
                   8  rst=0, clk_1=0, clk_2=0, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10  
                  10  rst=1, clk_1=1, clk_2=1, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10  
                  12  rst=1, clk_1=0, clk_2=0, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10  
                  14  rst=1, clk_1=1, clk_2=1, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10  
                  16  rst=1, clk_1=0, clk_2=0, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10  
                  18  rst=1, clk_1=1, clk_2=1, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10  
                  20  rst=1, clk_1=0, clk_2=0, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10  
                  22  rst=1, clk_1=1, clk_2=1, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10  
                  24  rst=1, clk_1=0, clk_2=0, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10  
                  26  rst=1, clk_1=1, clk_2=1, R1=        10, R2=         4, R3=         6, R4=         8, R5=        10  
                  28  rst=1, clk_1=0, clk_2=0, R1=        10, R2=         4, R3=         6, R4=         8, R5=        10  
                  30  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=         6, R4=         8, R5=        10  
                  32  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=         6, R4=         8, R5=        10  
                  34  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=         8, R5=        10  
                  36  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=         8, R5=        10  
                  38  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=         8, R5=        10  
                  40  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=         8, R5=        10  
                  42  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=         8, R5=        10  
                  44  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=         8, R5=        10  
                  46  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        10  
                  48  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        10  
                  50  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        10  
                  52  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        10  
                  54  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        10  
                  56  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        10  
                  58  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        10  
                  60  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        10  
                  62  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55  
                  64  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55  
                  
testbench.sv:33: $finish called at 70 (1s)
                 70  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55  
