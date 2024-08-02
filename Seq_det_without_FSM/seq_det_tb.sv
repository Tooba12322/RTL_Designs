
// Waveform : https://www.edaplayground.com/w/x/9Pz

module seq_det_tb();
 
  logic clk,rst;
  logic In;
  logic out;
  
  seq_det DUT(.*);
 
 logic [15:0] seq;
  
 initial
  begin
    $dumpfile("seq_det.vcd");
    $dumpvars(0,seq_det_tb);
    
    clk = '0;
    rst = '0;
    In = '0;
    seq = 16'hABCD;
    
    #3 @(posedge clk) rst = '1;
    
    for (int i='0;i<16;i++) begin
       @(posedge clk) In = $random%2;
    end
    
    for (int i='0;i<16;i++) begin
      @(posedge clk) In = seq[i];
    end
    
    for (int i='0;i<16;i++) begin
      @(posedge clk) In = $random%5;
    end
    
    #5 $finish;
  end
  
 always #2 clk = !clk;  
 
endmodule
