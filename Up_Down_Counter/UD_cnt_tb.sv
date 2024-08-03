// Waveform : 

module ud_cnt_tb ();
  logic [7:0] Cnt;
  logic load,clk,rst;
  logic [7:0] load_val;
  
  UD_Cnt DUT(.*);
  
  initial begin
    $dumpfile("Up_Down_Counter.vcd");
    $dumpvars(0,ud_cnt_tb);
    
    clk = '0;
    rst = '0;
    load = '0;
    #20 @(posedge clk)  rst = '1;
    
    #30 @(posedge clk); 
    load = '1;
    load_val = $urandom_range(8'hF2,8'hFF);
    
    #5 load = '0;
    
    #60 @(posedge clk); 
    load = '1;
    load_val = $urandom_range(8'hF5,8'hFF);
    
    #5 load = '0;
    
    #80 $finish;
  end
    
  always #2 clk = !clk;
  
endmodule


