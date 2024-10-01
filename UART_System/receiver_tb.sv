// Waveform : 
`timescale 1ns/1ps

module receiver_tb();
 
  logic rx_done,parity;
  logic [2:0] dout;
  logic rx,tick,clk,rst;
  
  receiver DUT(.*);
    
 initial
  begin
    $dumpfile("receiver.vcd");
    $dumpvars(0,receiver_tb);
    
    clk      = '0;
    rst      = '0;
    tick     = '0;
    rx       = '1;
    
    #7 @(posedge clk) rst = '1;

    #15 @(posedge clk) rx = '0;
    
    for (int i=0;i<17;i++) begin
      #3 @(posedge clk) tick = '1;
      #3 @(posedge clk) tick = '0;
      #162;
    end
    #3 @(posedge clk) rx = '1;

   for (int i=0;i<17;i++) begin
      #3 @(posedge clk) tick = '1;
      #3 @(posedge clk) tick = '0;
      #162;
    end
   #3 @(posedge clk) rx = '0;

   for (int i=0;i<17;i++) begin
      #3 @(posedge clk) tick = '1;
      #3 @(posedge clk) tick = '0;
      #162;
    end
    #3 @(posedge clk) rx = '1;

   for (int i=0;i<17;i++) begin
      #3 @(posedge clk) tick = '1;
      #3 @(posedge clk) tick = '0;
      #162;
    end
   #3 @(posedge clk) rx = '0;

   for (int i=0;i<17;i++) begin
      #3 @(posedge clk) tick = '1;
      #3 @(posedge clk) tick = '0;
      #162;
    end
    #3 @(posedge clk) rx = '1;
   
   #10 $finish;
  end
  
 always #5 clk = !clk;  
 
endmodule
