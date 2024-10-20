// Waveform : https://www.edaplayground.com/w/x/Nbn

`timescale 1ns/1ps
module BR_gen_tb();
 
  logic tick;
  logic [10:0] br_div;
  logic clk,rst;
  
  BR_gen DUT(.*);
    
 initial
  begin
    $dumpfile("BR_gen.vcd");
    $dumpvars(0,BR_gen_tb);
    
    clk = '0;
    rst = '0;
    
    #7 @(posedge clk) rst = '1;
    br_div = 11'd650; // Baud rate generator generates a pulse after every 650 counts, refer waveform
    #100000 $finish;
  end
  
 always #5 clk = !clk;  
 
endmodule
