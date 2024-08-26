// Waveform : https://www.edaplayground.com/w/x/MTh

module GCD_tb ();
  
  logic [15:0] Out;
  logic Done;
  
  logic [15:0] In;
  logic clk,rst,Start;
  
  GCD DUT(.*);
  
  initial begin
    $dumpfile("GCD.vcd");
    $dumpvars(0,GCD_tb);
    $monitor($time, " A=%d, B=%d, GCD=%d",DUT.A,DUT.B,Out);
    
    clk = '0;
    rst = '0;
    Start = '0;
    In = '0;
    
    #9 Start = '1;
    rst = '1;
    In = $urandom_range(16'd1,16'd10);
    
    #8  In = $urandom_range(16'd1,16'd5);
    Start = '0;
    
    #20 Start = '1;
    rst = '1;
    In = $urandom_range(16'd1,16'd6);
    
    #8  In = $urandom_range(16'd1,16'd5);
    //Start = '0;
    
    #30 $finish;
  end
    
  always #2 clk = !clk;
  
endmodule
