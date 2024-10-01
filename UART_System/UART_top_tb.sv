// Waveform : 
`timescale 1ns/1ps

module UART_top_tb();
 
  logic rx_done,tx_done; 
  logic parity_o; 
  logic [2:0] dout;
  logic rx,tx_start,clk,rst;
  logic [2:0] din;
  
  UART_top DUT(.*);
    
 initial
  begin
    $dumpfile("UART_top.vcd");
    $dumpvars(0,UART_top_tb);
    
    clk      = '0;
    rst      = '0;
    tick     = '0;
    
   #10 $finish;
  end
  
 always #5 clk = !clk;  
 
endmodule
