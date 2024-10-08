// Waveform : 
//mode-0 (cpol=0,cpha=0) https://www.edaplayground.com/w/x/WCx
//mode-1 (cpol=0,cpha=1) https://www.edaplayground.com/w/x/5tz
//mode-2 (cpol=1,cpha=0) https://www.edaplayground.com/w/x/8yR
//mode-3 (cpol=1,cpha=1) https://www.edaplayground.com/w/x/F8J

https://www.edaplayground.com/w/x/DcW

`timescale 1ns/1ps
module spi_top_tb();
 
  logic done_s,done_m;
  logic [7:0] dout_s,dout_m;
  logic cpol,cpha,start,clk,rst;
  logic [7:0] din_m,din_s;
  logic [15:0] dvsr;

  spi_top DUT(.*);
    
 initial
  begin
    $dumpfile("spi_top.vcd");
    $dumpvars(0,spi_top_tb);
    
    rst      = '0;
    din_m    = '0;
    din_s    = '0;
    cpol     = '0;
    cpha     = '1;
    clk      = '0;
    start    = '0;
    dvsr     = '0;
    
    
    #7 @(posedge clk) rst = '1;

    #7 @(posedge clk) start = '1; din_m = 8'hA1; din_s = 8'hA6; dvsr = 16'd49; // for 100MHz system clk, and 1MHz sclk
    #3 @(posedge clk) start = '0;

   #12000 $finish;
  end
 
   always #5 clk = !clk; 
endmodule
