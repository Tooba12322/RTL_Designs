// Waveform : 

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
    repeat(10) begin
      In ='0;
      #3 In = '1;
      #5 In = '0;
      #1 In = '1;
    end
    
    repeat(10) begin
      In = $random%2;
    end
    
    #10 $finish;
  end
    
  always #2 clk = !clk;
  
endmodule
