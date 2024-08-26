// Waveform : https://www.edaplayground.com/w/x/Tca

module MULT_tb ();
  
  logic [15:0] Out;
  logic Done;
  
  logic [15:0] In;
  logic clk,rst,Start;
  
  MULT DUT(.*);
  
  initial begin
    $dumpfile("Multiplier.vcd");
    $dumpvars(0,MULT_tb);
    $monitor($time, " A=%d, B=%d, Mult=%d",DUT.A,DUT.B,Out);
    
    clk = '0;
    rst = '0;
    Start = '0;
    #9 Start = '1;
    rst = '1;
    In = $urandom_range(16'd1,16'd10);
    
    #8  In = $urandom_range(16'd1,16'd5);
    Start = '0;
    
    #20 Start = '1;
    rst = '1;
    In = $urandom_range(16'd1,16'd15);
    
    #8  In = $urandom_range(16'd1,16'd5);
    Start = '0;
    
    #30 $finish;
  end
    
  always #2 clk = !clk;
  
endmodule

Output : 
0 A=    0, B=    0, Mult=    0
                  14 A=    6, B=    0, Mult=    0
                  18 A=    6, B=    2, Mult=    0
                  22 A=    6, B=    1, Mult=    0
                  26 A=    6, B=    0, Mult=   12
                  30 A=    6, B=    0, Mult=    0
                  42 A=    1, B=    0, Mult=    0
                  46 A=    1, B=    1, Mult=    0
                  50 A=    1, B=    0, Mult=    1
                  54 A=    1, B=    0, Mult=    0
testbench.sv:35: $finish called at 75 (1s)
