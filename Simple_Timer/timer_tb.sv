// Waveform : 

module timer_tb ();
  logic time_out;
  logic preset,clk,rst;
  logic [7:0] preset_val;
  
  timer DUT(.*);
  
  initial begin
    $dumpfile("Timer.vcd");
    $dumpvars(0,timer_tb);
    
    clk = '0;
    rst = '0;
    preset = '0;
    #20 @(posedge clk);
    rst = '1;
    preset = '1;
    preset_val = $urandom_range(0,8'h0F);
    
    #3 preset = '0;
    
    #80 @(posedge clk); 
    preset = '1;
    preset_val = $urandom_range(0,8'h08);
    
    #3 preset = '0;
    
    #80 $finish;
  end
    
  always #2 clk = !clk;
  
endmodule


