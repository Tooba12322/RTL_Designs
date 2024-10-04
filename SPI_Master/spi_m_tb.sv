// Waveform : 

`timescale 1ns/1ps
module spi_m_tb();
 
  logic done,ready,sclk,mosi;
  logic [7:0] dout;
  logic miso,cpol,cpha,start,clk,rst;
  logic [7:0] din;
  logic [15:0] dvsr;
  
  spi_m DUT(.*);
    
 initial
  begin
    $dumpfile("spi_m.vcd");
    $dumpvars(0,spi_m_tb);
    
    clk      = '0;
    rst      = '0;
    tx_start = '0;
    tick     = '0;
    din      = '0;
    
    #7 @(posedge clk) rst = '1;

    #7 @(posedge clk) tx_start = '1; din = 3'd5;
    #3 @(posedge clk) tx_start = '0;
   
    for (int i=0;i<100;i++) begin
      #3 @(posedge clk) tick = '1;
      #3 @(posedge clk) tick = '0;
      #162;
    end
   #10 $finish;
  end
  
 always #5 clk = !clk;  
 
endmodule
