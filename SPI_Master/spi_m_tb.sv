// Waveform : 
//mode-0 (cpol=0,cpha=0) https://www.edaplayground.com/w/x/WCx
//mode-1 (cpol=0,cpha=1)
//mode-2 (cpol=1,cpha=0)
//mode-3 (cpol=1,cpha=1)

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
    start    = '0;
    miso     = '0;
    din      = '0;
    dvsr     = '0;
    cpol     = '0;
    cpha     = '1;
    
    #7 @(posedge clk) rst = '1;

    #7 @(posedge clk) start = '1; din = 8'd100; dvsr = 16'd49; // for 100MHz system clk, and 1MHz sclk
    #3 @(posedge clk) start = '0;

    for (int i=0;i<15;i++) begin
      miso = $random%3 || $random%2;
      #550;
    end
   #10 $finish;
  end
  
 always #5 clk = !clk;  
 
endmodule
