module LUT_tb(ram, A0, A1, A2, A3, CLK, RST);
 input logic ram[15:0];
 output logic A0, A1, A2, A3;
 output logic CLK, RST;
  logic ram_o; 
 logic addr;
 LUT DUT(.RAM(ram),.a0(A0),.a1(A1),.a2(A2),.a3(A3),.clk(CLK),.rst(RST));
  assign addr = {A3,A2,A1,A0};
 assign ram_o = ram[addr];
 initial
  begin
   
    $monitor ($time,"  CLK=%b, RST=%b, A3=%b, A2=%b, A1=%b, A0=%b,  RAM=%b",CLK,RST,A3,A2,A1,A0,ram_o);
  
  CLK = '0;
  RST = '0;
    {A3,A2,A1,A0} = 4'b0000;
  #5 {A3,A2,A1,A0} = 4'b0011;
  #5 RST = '1;
  
  #5 {A3,A2,A1,A0} = 4'b1010;
  #5 {A3,A2,A1,A0} = 4'b0111;
  #5 $finish;
  end
  
 always #2 CLK = !CLK; 
 
endmodule

Output :
0  CLK=0, RST=0, A3=0, A2=0, A1=0, A0=0,  RAM=0
                   2  CLK=1, RST=0, A3=0, A2=0, A1=0, A0=0,  RAM=0
                   4  CLK=0, RST=0, A3=0, A2=0, A1=0, A0=0,  RAM=0
                   5  CLK=0, RST=0, A3=0, A2=0, A1=1, A0=1,  RAM=0
                   6  CLK=1, RST=0, A3=0, A2=0, A1=1, A0=1,  RAM=0
                   8  CLK=0, RST=0, A3=0, A2=0, A1=1, A0=1,  RAM=0
                  10  CLK=1, RST=1, A3=0, A2=0, A1=1, A0=1,  RAM=1
                  12  CLK=0, RST=1, A3=0, A2=0, A1=1, A0=1,  RAM=1
                  14  CLK=1, RST=1, A3=0, A2=0, A1=1, A0=1,  RAM=1
                  15  CLK=1, RST=1, A3=1, A2=0, A1=1, A0=0,  RAM=0
                  16  CLK=0, RST=1, A3=1, A2=0, A1=1, A0=0,  RAM=0
                  18  CLK=1, RST=1, A3=1, A2=0, A1=1, A0=0,  RAM=1
                  20  CLK=0, RST=1, A3=0, A2=1, A1=1, A0=1,  RAM=1
                  22  CLK=1, RST=1, A3=0, A2=1, A1=1, A0=1,  RAM=0
                  24  CLK=0, RST=1, A3=0, A2=1, A1=1, A0=1,  RAM=0
testbench.sv:24: $finish called at 25 (1s)

Waveform : https://www.edaplayground.com/w/x/9xZ
