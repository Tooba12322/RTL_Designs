// Waveform :  https://www.edaplayground.com/w/x/7L4

module rr_arb_tb ();
 
  logic S;
  logic [3:0] Gnt;
  logic [4:1] Req;
  logic clk,rst;
  
  rr_arb DUT(.*);
  
  initial begin
    $dumpfile("rr_arb.vcd");
    $dumpvars(0,rr_arb_tb);
    
    clk = '0;
    rst = '0;
    Req = '0;
    #7  rst = '1;
    
    repeat (2) begin
      for (int i=0;i<3;i++) begin
        Req = $urandom_range(4'h1,4'hF);
        #15;
      end
    end
    
    Req='0; // S should be unknown when no Req is there
    #15;
    
    repeat (2) begin
      for (int i=0;i<3;i++) begin
        Req = $urandom_range(4'h1,4'hF);
        #15;
      end
    end
    
    $finish;
  end
    
  always #2 clk = !clk;
  
endmodule
