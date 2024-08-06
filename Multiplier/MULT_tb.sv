// Waveform : 

module MULT_tb ();
  
  logic [15:0] Out;
  logic Done;
  
  logic [15:0] In;
  logic clk,rst,start;
  
  MULT DUT(.*);
  
  initial begin
    $dumpfile("Multiplier.vcd");
    $dumpvars(0,MULT_tb);
    $monitor($time, " A=%d, B=%d, Mult=%d",DUT.A,DUT.B,Out);
    
    clk = '0;
    rst = '0;
    start = '0;
    #9 start = '1;
    rst = '1;
    In = $urandom_range(16'd1,16'd10);
    
    #8  In = $urandom_range(16'd1,16'd5);
    start = '0;
    
    #20 start = '1;
    rst = '1;
    In = $urandom_range(16'd1,16'd15);
    
    #8  In = $urandom_range(16'd1,16'd5);
    start = '0;
    
    #30 $finish;
  end
    
  always #2 clk = !clk;
  
endmodule
