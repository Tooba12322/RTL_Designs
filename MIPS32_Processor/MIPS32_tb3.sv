
//Waveform : https://www.edaplayground.com/w/x/K37

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
    
    #250 $finish;
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

Output :
0  rst=0, clk_1=0, clk_2=0, R10=        20, R2=         4, R3=         6, D_Mem[200]=         5, D_Mem[198]=         5  
                   2  rst=0, clk_1=1, clk_2=1, R10=        20, R2=         4, R3=         6, D_Mem[200]=         5, D_Mem[198]=         5  
                   4  rst=0, clk_1=0, clk_2=0, R10=        20, R2=         4, R3=         6, D_Mem[200]=         5, D_Mem[198]=         5  
                   6  rst=0, clk_1=1, clk_2=1, R10=        20, R2=         4, R3=         6, D_Mem[200]=         5, D_Mem[198]=         5  
                   8  rst=0, clk_1=0, clk_2=0, R10=        20, R2=         4, R3=         6, D_Mem[200]=         5, D_Mem[198]=         5  
                  10  rst=1, clk_1=1, clk_2=1, R10=        20, R2=         4, R3=         6, D_Mem[200]=         5, D_Mem[198]=         5  
                  12  rst=1, clk_1=0, clk_2=0, R10=        20, R2=         4, R3=         6, D_Mem[200]=         5, D_Mem[198]=         5  
                 
                  22  rst=1, clk_1=1, clk_2=1, R10=        20, R2=         4, R3=         6, D_Mem[200]=         5, D_Mem[198]=         5  
                  24  rst=1, clk_1=0, clk_2=0, R10=        20, R2=         4, R3=         6, D_Mem[200]=         5, D_Mem[198]=         5  
                  26  rst=1, clk_1=1, clk_2=1, R10=       200, R2=         4, R3=         6, D_Mem[200]=         5, D_Mem[198]=         5  
                  28  rst=1, clk_1=0, clk_2=0, R10=       200, R2=         4, R3=         6, D_Mem[200]=         5, D_Mem[198]=         5  
                  30  rst=1, clk_1=1, clk_2=1, R10=       200, R2=         1, R3=         6, D_Mem[200]=         5, D_Mem[198]=         5  
                 
                  36  rst=1, clk_1=0, clk_2=0, R10=       200, R2=         1, R3=         6, D_Mem[200]=         5, D_Mem[198]=         5  
                  38  rst=1, clk_1=1, clk_2=1, R10=       200, R2=         1, R3=         5, D_Mem[200]=         5, D_Mem[198]=         5  
                  40  rst=1, clk_1=0, clk_2=0, R10=       200, R2=         1, R3=         5, D_Mem[200]=         5, D_Mem[198]=         5  
                  
                  48  rst=1, clk_1=0, clk_2=0, R10=       200, R2=         1, R3=         5, D_Mem[200]=         5, D_Mem[198]=         5  
                  50  rst=1, clk_1=1, clk_2=1, R10=       200, R2=         1, R3=         5, D_Mem[200]=         5, D_Mem[198]=         5  
                  52  rst=1, clk_1=0, clk_2=0, R10=       200, R2=         1, R3=         5, D_Mem[200]=         5, D_Mem[198]=         5  
                  54  rst=1, clk_1=1, clk_2=1, R10=       200, R2=         5, R3=         5, D_Mem[200]=         5, D_Mem[198]=         5  
                  56  rst=1, clk_1=0, clk_2=0, R10=       200, R2=         5, R3=         5, D_Mem[200]=         5, D_Mem[198]=         5  
                  58  rst=1, clk_1=1, clk_2=1, R10=       200, R2=         5, R3=         4, D_Mem[200]=         5, D_Mem[198]=         5  
                  60  rst=1, clk_1=0, clk_2=0, R10=       200, R2=         5, R3=         4, D_Mem[200]=         5, D_Mem[198]=         5  
                 
                  76  rst=1, clk_1=0, clk_2=0, R10=       200, R2=         5, R3=         4, D_Mem[200]=         5, D_Mem[198]=         5  
                  78  rst=1, clk_1=1, clk_2=1, R10=       200, R2=         5, R3=         4, D_Mem[200]=         5, D_Mem[198]=         5  
                  80  rst=1, clk_1=0, clk_2=0, R10=       200, R2=         5, R3=         4, D_Mem[200]=         5, D_Mem[198]=         5  
                  82  rst=1, clk_1=1, clk_2=1, R10=       200, R2=        20, R3=         4, D_Mem[200]=         5, D_Mem[198]=         5  
                  84  rst=1, clk_1=0, clk_2=0, R10=       200, R2=        20, R3=         4, D_Mem[200]=         5, D_Mem[198]=         5  
                  86  rst=1, clk_1=1, clk_2=1, R10=       200, R2=        20, R3=         3, D_Mem[200]=         5, D_Mem[198]=         5  
                  88  rst=1, clk_1=0, clk_2=0, R10=       200, R2=        20, R3=         3, D_Mem[200]=         5, D_Mem[198]=         5  
                  
                  98  rst=1, clk_1=1, clk_2=1, R10=       200, R2=        20, R3=         3, D_Mem[200]=         5, D_Mem[198]=         5  
                 100  rst=1, clk_1=0, clk_2=0, R10=       200, R2=        20, R3=         3, D_Mem[200]=         5, D_Mem[198]=         5  
                 102  rst=1, clk_1=1, clk_2=1, R10=       200, R2=        20, R3=         3, D_Mem[200]=         5, D_Mem[198]=        20  
                 104  rst=1, clk_1=0, clk_2=0, R10=       200, R2=        20, R3=         3, D_Mem[200]=         5, D_Mem[198]=        20  
                 106  rst=1, clk_1=1, clk_2=1, R10=       200, R2=        20, R3=         3, D_Mem[200]=         5, D_Mem[198]=        20  
                 108  rst=1, clk_1=0, clk_2=0, R10=       200, R2=        20, R3=         3, D_Mem[200]=         5, D_Mem[198]=        20  
                 110  rst=1, clk_1=1, clk_2=1, R10=       200, R2=        60, R3=         3, D_Mem[200]=         5, D_Mem[198]=        20  
                 112  rst=1, clk_1=0, clk_2=0, R10=       200, R2=        60, R3=         3, D_Mem[200]=         5, D_Mem[198]=        20  
                 114  rst=1, clk_1=1, clk_2=1, R10=       200, R2=        60, R3=         2, D_Mem[200]=         5, D_Mem[198]=        20  
                 116  rst=1, clk_1=0, clk_2=0, R10=       200, R2=        60, R3=         2, D_Mem[200]=         5, D_Mem[198]=        20  
                 
                 126  rst=1, clk_1=1, clk_2=1, R10=       200, R2=        60, R3=         2, D_Mem[200]=         5, D_Mem[198]=        20  
                 128  rst=1, clk_1=0, clk_2=0, R10=       200, R2=        60, R3=         2, D_Mem[200]=         5, D_Mem[198]=        20  
                 130  rst=1, clk_1=1, clk_2=1, R10=       200, R2=        60, R3=         2, D_Mem[200]=         5, D_Mem[198]=        60  
                 132  rst=1, clk_1=0, clk_2=0, R10=       200, R2=        60, R3=         2, D_Mem[200]=         5, D_Mem[198]=        60  
                 134  rst=1, clk_1=1, clk_2=1, R10=       200, R2=        60, R3=         2, D_Mem[200]=         5, D_Mem[198]=        60  
                 136  rst=1, clk_1=0, clk_2=0, R10=       200, R2=        60, R3=         2, D_Mem[200]=         5, D_Mem[198]=        60  
                 138  rst=1, clk_1=1, clk_2=1, R10=       200, R2=       120, R3=         2, D_Mem[200]=         5, D_Mem[198]=        60  
                 140  rst=1, clk_1=0, clk_2=0, R10=       200, R2=       120, R3=         2, D_Mem[200]=         5, D_Mem[198]=        60  
                 142  rst=1, clk_1=1, clk_2=1, R10=       200, R2=       120, R3=         1, D_Mem[200]=         5, D_Mem[198]=        60  
                 144  rst=1, clk_1=0, clk_2=0, R10=       200, R2=       120, R3=         1, D_Mem[200]=         5, D_Mem[198]=        60  
                 
                 154  rst=1, clk_1=1, clk_2=1, R10=       200, R2=       120, R3=         1, D_Mem[200]=         5, D_Mem[198]=        60  
                 156  rst=1, clk_1=0, clk_2=0, R10=       200, R2=       120, R3=         1, D_Mem[200]=         5, D_Mem[198]=        60  
                 158  rst=1, clk_1=1, clk_2=1, R10=       200, R2=       120, R3=         1, D_Mem[200]=         5, D_Mem[198]=       120  
                 160  rst=1, clk_1=0, clk_2=0, R10=       200, R2=       120, R3=         1, D_Mem[200]=         5, D_Mem[198]=       120  
                 162  rst=1, clk_1=1, clk_2=1, R10=       200, R2=       120, R3=         1, D_Mem[200]=         5, D_Mem[198]=       120  
                 164  rst=1, clk_1=0, clk_2=0, R10=       200, R2=       120, R3=         1, D_Mem[200]=         5, D_Mem[198]=       120  
                 166  rst=1, clk_1=1, clk_2=1, R10=       200, R2=       120, R3=         1, D_Mem[200]=         5, D_Mem[198]=       120  
                 168  rst=1, clk_1=0, clk_2=0, R10=       200, R2=       120, R3=         1, D_Mem[200]=         5, D_Mem[198]=       120  
                 170  rst=1, clk_1=1, clk_2=1, R10=       200, R2=       120, R3=         0, D_Mem[200]=         5, D_Mem[198]=       120  
                 172  rst=1, clk_1=0, clk_2=0, R10=       200, R2=       120, R3=         0, D_Mem[200]=         5, D_Mem[198]=       120  
                
                 246  rst=1, clk_1=1, clk_2=1, R10=       200, R2=       120, R3=         0, D_Mem[200]=         5, D_Mem[198]=       120  
                 248  rst=1, clk_1=0, clk_2=0, R10=       200, R2=       120, R3=         0, D_Mem[200]=         5, D_Mem[198]=       120  
                 250  rst=1, clk_1=1, clk_2=1, R10=       200, R2=       120, R3=         0, D_Mem[200]=         5, D_Mem[198]=       120  
                 252  rst=1, clk_1=0, clk_2=0, R10=       200, R2=       120, R3=         0, D_Mem[200]=         5, D_Mem[198]=       120  
                 254  rst=1, clk_1=1, clk_2=1, R10=       200, R2=       120, R3=         0, D_Mem[200]=         5, D_Mem[198]=       120  
                 256  rst=1, clk_1=0, clk_2=0, R10=       200, R2=       120, R3=         0, D_Mem[200]=         5, D_Mem[198]=       120  
                 258  rst=1, clk_1=1, clk_2=1, R10=       200, R2=       120, R3=         0, D_Mem[200]=         5, D_Mem[198]=       120  
testbench.sv:43: $finish called at 260 (1s)
                 260  rst=1, clk_1=0, clk_2=0, R10=       200, R2=       120, R3=         0, D_Mem[200]=         5, D_Mem[198]=       120  
