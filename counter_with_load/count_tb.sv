module count_tb ();
  logic [15:0] Cnt;
  logic load,clk,rst;
  logic [15:0] load_val;
  
  Counter DUT(.*);
  
  initial begin
    $dumpfile("Counter.vcd");
    $dumpvars(0,count_tb);
    
    clk = '0;
    rst = '0;
    load = '0;
    #20 @(posedge clk)  rst = '1;
    
    #35 @(posedge clk); 
    load = '1;
    load_val = $urandom_range(0,16'hFFFF);
    
    #5 load = '0;
    #50 $finish;
  end
    
  always #2 clk = !clk;
  
endmodule

Waveform : https://www.edaplayground.com/w/x/4UH
