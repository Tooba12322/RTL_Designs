// Waveform : 
`timescale 1ns/1ps

module receiver_tb();
 
  logic tx,tx_done; 
  logic tick,tx_start,clk,rst;
  logic [2:0] din;
  
  receiver DUT(.*);
    
 initial
  begin
    $dumpfile("receiver.vcd");
    $dumpvars(0,receiver_tb);
    
    clk      = '0;
    rst      = '0;
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
