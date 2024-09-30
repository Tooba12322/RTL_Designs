// Waveform : 
`timescale 1ns/1ps
module transmitter_tb();
 
  logic tick;
  logic [10:0] br_div;
  logic clk,rst;
  
  transmitter DUT(.*);
    
 initial
  begin
    $dumpfile("transmitter.vcd");
    $dumpvars(0,transmitter_tb);
    
    clk = '0;
    rst = '0;
    
    #7 @(posedge clk) rst = '1;
    br_div = 11'd650;
    #100000 $finish;
  end
  
 always #5 clk = !clk;  
 
endmodule
