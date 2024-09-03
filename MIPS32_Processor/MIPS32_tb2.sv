// Waveform : https://www.edaplayground.com/w/x/EiV

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
// Add 93 to R2 contents and store result in memory location 121
// ADDI R1,R0,120 - 28010078
// OR R7,R7,R7    - 0CE77800
// OR R7,R7,R7    - 0CE77800
// LW R2,0 (R1)   - 20220000
// OR R7,R7,R7    - 0CE77800
// OR R7,R7,R7    - 0CE77800
// OR R7,R7,R7    - 0CE77800
// ADDI R3,R2,93  - 2843005D
// OR R7,R7,R7    - 0CE77800
// OR R7,R7,R7    - 0CE77800
// OR R7,R7,R7    - 0CE77800
// SW R3,1 (R1)   - 24230001
// HLT            - FC000000

module MIPS32_tb2();
  logic clk_1,clk_2,rst;
  
  MIPS32 DUT(.*);
  
  initial
  begin
    $dumpfile("MIPS32.vcd");
    $dumpvars(0,MIPS32_tb2);
    $monitor ($time,"  rst=%b, clk_1=%b, clk_2=%b, R1=%d, R2=%d, R3=%d, R4=%d, R5=%d, Mem[121]=%d  ",rst,clk_1,clk_2,DUT.Reg[1],DUT.Reg[2],DUT.Reg[3],DUT.Reg[4],DUT.Reg[5],DUT.D_Mem[121]);
  end
  
  initial begin
    clk_1 = '0;
    clk_2 = '0;
    rst = '0;
    
    #10  rst = '1;
    
    #100 rst = '0;
    
    #20 rst = '1;
    
    #75 rst = '0;
    
    #5 $finish;
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

    #110;
      
    DUT.I_Mem[0] = 32'h28010078;
    DUT.I_Mem[1] = 32'h0CE77800;
    DUT.I_Mem[2] = 32'h0CE77800;
    DUT.I_Mem[3] = 32'h0CE77800;
    DUT.I_Mem[4] = 32'h20220000;
    DUT.I_Mem[5] = 32'h0CE77800;
    DUT.I_Mem[6] = 32'h0CE77800;
    DUT.I_Mem[7] = 32'h0CE77800;
    DUT.I_Mem[8] = 32'h2843005D;
    DUT.I_Mem[9] = 32'h0CE77800;
    DUT.I_Mem[10] = 32'h0CE77800;
    DUT.I_Mem[11] = 32'h0CE77800;
    DUT.I_Mem[12] = 32'h24230001;
    DUT.I_Mem[13] = 32'hFC000000;
  end
  
    always   #2 clk_1 = !clk_1;  
    always   #2 clk_2 = !clk_2; 
   
endmodule

Output :
   0  rst=0, clk_1=0, clk_2=0, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10, Mem[121]=       121  
                   2  rst=0, clk_1=1, clk_2=1, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10, Mem[121]=       121  
                   4  rst=0, clk_1=0, clk_2=0, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10, Mem[121]=       121  
                   6  rst=0, clk_1=1, clk_2=1, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10, Mem[121]=       121  
                   8  rst=0, clk_1=0, clk_2=0, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10, Mem[121]=       121  
                  10  rst=1, clk_1=1, clk_2=1, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10, Mem[121]=       121  
                  12  rst=1, clk_1=0, clk_2=0, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10, Mem[121]=       121  
                  14  rst=1, clk_1=1, clk_2=1, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10, Mem[121]=       121  
                  16  rst=1, clk_1=0, clk_2=0, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10, Mem[121]=       121  
                  18  rst=1, clk_1=1, clk_2=1, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10, Mem[121]=       121  
                  20  rst=1, clk_1=0, clk_2=0, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10, Mem[121]=       121  
                  22  rst=1, clk_1=1, clk_2=1, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10, Mem[121]=       121  
                  24  rst=1, clk_1=0, clk_2=0, R1=         2, R2=         4, R3=         6, R4=         8, R5=        10, Mem[121]=       121  
                  26  rst=1, clk_1=1, clk_2=1, R1=        10, R2=         4, R3=         6, R4=         8, R5=        10, Mem[121]=       121  
                  28  rst=1, clk_1=0, clk_2=0, R1=        10, R2=         4, R3=         6, R4=         8, R5=        10, Mem[121]=       121  
                  30  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=         6, R4=         8, R5=        10, Mem[121]=       121  
                  32  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=         6, R4=         8, R5=        10, Mem[121]=       121  
                  34  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=         8, R5=        10, Mem[121]=       121  
                  36  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=         8, R5=        10, Mem[121]=       121  
                  38  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=         8, R5=        10, Mem[121]=       121  
                  40  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=         8, R5=        10, Mem[121]=       121  
                  42  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=         8, R5=        10, Mem[121]=       121  
                  44  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=         8, R5=        10, Mem[121]=       121  
                  46  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        10, Mem[121]=       121  
                  48  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        10, Mem[121]=       121  
                  50  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        10, Mem[121]=       121  
                  52  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        10, Mem[121]=       121  
                  54  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        10, Mem[121]=       121  
                  56  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        10, Mem[121]=       121  
                  58  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        10, Mem[121]=       121  
                  60  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        10, Mem[121]=       121  
                  62  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                  64  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                  66  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                  68  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                  70  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                  72  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                  74  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                  76  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                  78  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                  80  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                  82  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                  84  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                  86  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                  88  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                  90  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                  92  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                  94  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                  96  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                  98  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 100  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 102  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 104  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 106  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 108  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 110  rst=0, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 112  rst=0, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 114  rst=0, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 116  rst=0, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 118  rst=0, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 120  rst=0, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 122  rst=0, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 124  rst=0, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 126  rst=0, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 128  rst=0, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 130  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 132  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 134  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 136  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 138  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 140  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 142  rst=1, clk_1=1, clk_2=1, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 144  rst=1, clk_1=0, clk_2=0, R1=        10, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 146  rst=1, clk_1=1, clk_2=1, R1=       120, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 148  rst=1, clk_1=0, clk_2=0, R1=       120, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 150  rst=1, clk_1=1, clk_2=1, R1=       120, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 152  rst=1, clk_1=0, clk_2=0, R1=       120, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 154  rst=1, clk_1=1, clk_2=1, R1=       120, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 156  rst=1, clk_1=0, clk_2=0, R1=       120, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 158  rst=1, clk_1=1, clk_2=1, R1=       120, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 160  rst=1, clk_1=0, clk_2=0, R1=       120, R2=        20, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 162  rst=1, clk_1=1, clk_2=1, R1=       120, R2=       120, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 164  rst=1, clk_1=0, clk_2=0, R1=       120, R2=       120, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 166  rst=1, clk_1=1, clk_2=1, R1=       120, R2=       120, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 168  rst=1, clk_1=0, clk_2=0, R1=       120, R2=       120, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 170  rst=1, clk_1=1, clk_2=1, R1=       120, R2=       120, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 172  rst=1, clk_1=0, clk_2=0, R1=       120, R2=       120, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 174  rst=1, clk_1=1, clk_2=1, R1=       120, R2=       120, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 176  rst=1, clk_1=0, clk_2=0, R1=       120, R2=       120, R3=        25, R4=        30, R5=        55, Mem[121]=       121  
                 178  rst=1, clk_1=1, clk_2=1, R1=       120, R2=       120, R3=       213, R4=        30, R5=        55, Mem[121]=       121  
                 180  rst=1, clk_1=0, clk_2=0, R1=       120, R2=       120, R3=       213, R4=        30, R5=        55, Mem[121]=       121  
                 182  rst=1, clk_1=1, clk_2=1, R1=       120, R2=       120, R3=       213, R4=        30, R5=        55, Mem[121]=       121  
                 184  rst=1, clk_1=0, clk_2=0, R1=       120, R2=       120, R3=       213, R4=        30, R5=        55, Mem[121]=       121  
                 186  rst=1, clk_1=1, clk_2=1, R1=       120, R2=       120, R3=       213, R4=        30, R5=        55, Mem[121]=       121  
                 188  rst=1, clk_1=0, clk_2=0, R1=       120, R2=       120, R3=       213, R4=        30, R5=        55, Mem[121]=       121  
                 190  rst=1, clk_1=1, clk_2=1, R1=       120, R2=       120, R3=       213, R4=        30, R5=        55, Mem[121]=       213  
                 192  rst=1, clk_1=0, clk_2=0, R1=       120, R2=       120, R3=       213, R4=        30, R5=        55, Mem[121]=       213  
                 194  rst=1, clk_1=1, clk_2=1, R1=       120, R2=       120, R3=       213, R4=        30, R5=        55, Mem[121]=       213  
                 196  rst=1, clk_1=0, clk_2=0, R1=       120, R2=       120, R3=       213, R4=        30, R5=        55, Mem[121]=       213  
                 198  rst=1, clk_1=1, clk_2=1, R1=       120, R2=       120, R3=       213, R4=        30, R5=        55, Mem[121]=       213  
                 200  rst=1, clk_1=0, clk_2=0, R1=       120, R2=       120, R3=       213, R4=        30, R5=        55, Mem[121]=       213  
                 202  rst=1, clk_1=1, clk_2=1, R1=       120, R2=       120, R3=       213, R4=        30, R5=        55, Mem[121]=       213  
                 204  rst=1, clk_1=0, clk_2=0, R1=       120, R2=       120, R3=       213, R4=        30, R5=        55, Mem[121]=       213  
                 205  rst=0, clk_1=0, clk_2=0, R1=       120, R2=       120, R3=       213, R4=        30, R5=        55, Mem[121]=       213  
                 206  rst=0, clk_1=1, clk_2=1, R1=       120, R2=       120, R3=       213, R4=        30, R5=        55, Mem[121]=       213  
                 208  rst=0, clk_1=0, clk_2=0, R1=       120, R2=       120, R3=       213, R4=        30, R5=        55, Mem[121]=       213  
testbench.sv:58: $finish called at 210 (1s)
                 210  rst=0, clk_1=1, clk_2=1, R1=       120, R2=       120, R3=       213, R4=        30, R5=        55, Mem[121]=       213 
