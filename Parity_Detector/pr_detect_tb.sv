// Waveform : https://www.edaplayground.com/w/x/Wh2

module pr_detect_tb ();
  
  logic out;
  logic sr_in,clk,rst;
  
  pr_detect DUT(.*);
  
  initial begin
    $dumpfile("Parity_Detector.vcd");
    $dumpvars(0,pr_detect_tb);
    
    clk = '0;
    rst = '0;
    sr_in = '0;
    #17 sr_in = '1;
    rst = '1;
    
    repeat (35) begin
      sr_in = $random%3;
      #3;
    end
    
    #5 $finish;
  end
    
  always #2 clk = !clk;
  
endmodule
