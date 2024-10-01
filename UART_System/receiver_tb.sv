// Waveform : https://www.edaplayground.com/w/x/L4_
`timescale 1ns/1ps

module receiver_tb();
 
  logic rx_done,parity_o;
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
    rx       = '1; //idle
    
    #7 @(posedge clk) rst = '1;

   #15 @(posedge clk) rx = '0; //send start bit
    
   for (int i=0;i<17;i++) begin //wait for 16 ticks
      #3 @(posedge clk) tick = '1;
      #3 @(posedge clk) tick = '0;
      #162;
    end
   #3 @(posedge clk) rx = '1; //send data bit[0]

   for (int i=0;i<17;i++) begin
      #3 @(posedge clk) tick = '1;
      #3 @(posedge clk) tick = '0;
      #162;
    end
   #3 @(posedge clk) rx = '0; //send data bit[1]

   for (int i=0;i<17;i++) begin
      #3 @(posedge clk) tick = '1;
      #3 @(posedge clk) tick = '0;
      #162;
    end
   #3 @(posedge clk) rx = '0; //send data bit[2]

   for (int i=0;i<17;i++) begin
      #3 @(posedge clk) tick = '1;
      #3 @(posedge clk) tick = '0;
      #162;
    end
   #3 @(posedge clk) rx = '1; //send parity bit

   for (int i=0;i<17;i++) begin
      #3 @(posedge clk) tick = '1;
      #3 @(posedge clk) tick = '0;
      #162;
    end
   #3 @(posedge clk) rx = '1; //send stop bit
    
    for (int i=0;i<17;i++) begin
      #3 @(posedge clk) tick = '1;
      #3 @(posedge clk) tick = '0;
      #162;
    end
   #3 @(posedge clk) rx = '1; //idle
   
   #10 $finish;
  end
  
 always #5 clk = !clk;  
 
endmodule
