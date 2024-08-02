// Waveform : https://www.edaplayground.com/w/x/BsL

module m10_cnt_tb();
 
  logic clk,rst;
  logic [3:0] Cnt;
  
  M10_cnt DUT1(.*);
    
 initial
  begin
    $dumpfile("mod_10_counter.vcd");
    $dumpvars(0,m10_cnt_tb);
    
    clk = '0;
    rst = '0;
    
    #3 @(posedge clk) rst = '1;
    #100 $finish;
  end
  
 always #2 clk = !clk;  
 
endmodule


