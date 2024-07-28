module lfsr_tb();
  logic [3:0]Q;
  logic clk,rst;
 
  lfsr DUT(.*);
  
 initial
  begin
    $dumpfile("LFSR.vcd");
    $dumpvars(0,lfsr_tb);
    $monitor ($time,"  Rst=%b, Clk=%b, Q=%b  ",rst,clk,Q);
  
    clk = '0;
    rst = '0;
    
    #5 @(posedge clk) rst = '1;
  
    #40 $finish;
  end
  
 always #2 clk = !clk;  
  
endmodule

Waveform : https://www.edaplayground.com/w/x/XXP
