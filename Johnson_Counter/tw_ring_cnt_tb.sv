module tw_ring_cnt_tb();
  logic [3:0]Q;
  logic clk,rst;
 
  tw_ring_cnt DUT(.*);
  
 initial
  begin
    $dumpfile("Johnson_Counter.vcd");
    $dumpvars(0,tw_ring_cnt_tb);
    $monitor ($time,"  Rst=%b, Clk=%b, Q=%b  ",rst,clk,Q);
  
    clk = '0;
    rst = '0;
    
    #5 @(posedge clk) rst = '1;
  
    #75 $finish;
  end
  
 always #2 clk = !clk;  
  
endmodule

Waveform : https://www.edaplayground.com/w/x/4Aj
