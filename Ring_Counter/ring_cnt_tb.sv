module ring_cnt_tb();
  logic [3:0]Q;
  logic clk,rst;
 
  ring_cnt DUT(.*);
  
 initial
  begin
    $dumpfile("Ring_Counter.vcd");
    $dumpvars(0,ring_cnt_tb);
    $monitor ($time,"  Rst=%b, Clk=%b, Q=%b  ",rst,clk,Q);
  
    clk = '0;
    rst = '0;
    
    #5 @(posedge clk) rst = '1;
  
    #50 $finish;
  end
  
 always #2 clk = !clk;  
  
endmodule

Waveform : https://www.edaplayground.com/w/x/7F9
