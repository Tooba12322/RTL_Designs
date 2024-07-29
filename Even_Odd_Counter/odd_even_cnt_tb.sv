module count_tb ();
  logic [15:0] Cnt;
  logic M,clk,rst;
  
  Odd_Even_Cnt DUT(.*);
  
  initial begin
    $dumpfile("Odd_Even_Cnt.vcd");
    $dumpvars(0,count_tb);
    $monitor ($time,"  rst=%b, clk=%b, Count=%d, Mode=%b ",rst,clk,Cnt,M);
    
    
    clk = '0;
    rst = '0;
    M = $random%2;
    #20 @(posedge clk)  rst = '1;
    for (int i=0; i<35 ; i++) begin
      @(posedge clk) M = $random%2;
      #5;
    end
    
    $finish;
  end
  
  always #5 clk = !clk;
endmodule


Waveform : https://www.edaplayground.com/w/x/FX7
