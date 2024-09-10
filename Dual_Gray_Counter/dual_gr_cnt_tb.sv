// Waveform : https://www.edaplayground.com/w/x/NkP

module dual_gr_cnt_tb();
 
  logic [3:0] n_gr_cnt;
  logic [2:0] n_1_gr_cnt;
  logic clk,rst;
  
  dual_gr_cnt DUT(.*);
    
 initial
  begin
    $dumpfile("dual_gr_cnt.vcd");
    $dumpvars(0,dual_gr_cnt_tb);
    
    clk = '0;
    rst = '0;
    
    #7 @(posedge clk) rst = '1;
    #150 $finish;
  end
  
 always #2 clk = !clk;  
 
endmodule
