// Waveform : https://www.edaplayground.com/w/x/9TV

module Seq_Det_tb ();
  
  logic In,Out;
  
  logic clk,rst;
  
  Seq_Det  DUT(.*);
  
  initial begin
    $dumpfile("Seq_Det.vcd");
    $dumpvars(0,Seq_Det_tb);
    //$monitor($time, " rst=%b, clk=%b,  Light = %s",rst,clk,Out);   
    clk = '0;
    rst = '0;
    In = '0;
    #9 rst = '1;
    #3 In = '1;
    #25 In = '0;
    #11 In = '1;
    #25 In = '0;
    #20 $finish;
  end
    
  always #2 clk = !clk;
  
endmodule
