// Waveform : 
`timescale 1ns/1ps

module UART_top_tb();
 
  logic rx_done,tx_done; 
  logic parity_o; 
  logic [2:0] dout;
  logic tx_start,clk,rst;
  logic [2:0] din;
  logic [10:0] br_div;
  
  UART_top DUT(.*);
    
 initial
  begin
    $dumpfile("UART_top.vcd");
    $dumpvars(0,UART_top_tb);
    
    clk      = '0;
    rst      = '0;
    #7 @(posedge clk) rst = '1;
    br_div = 11'd650;
    #100000 $finish;
    
  end
  
 always #5 clk = !clk;  
 
endmodule
