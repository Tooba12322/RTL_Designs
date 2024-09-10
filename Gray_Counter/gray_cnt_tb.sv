// Waveform : https://www.edaplayground.com/w/x/Kfx

module gray_cnt_tb();
 
  logic [3:0] gr_cnt;
  logic clk,rst;
  
  gray_cnt DUT(.*);
    
 initial
  begin
    $dumpfile("gray_cnt.vcd");
    $dumpvars(0,gray_cnt_tb);
    
    clk = '0;
    rst = '0;
    
    #7 @(posedge clk) rst = '1;
    #100 $finish;
  end
  
 always #2 clk = !clk;  
 
endmodule
