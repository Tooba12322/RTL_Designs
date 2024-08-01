module FF_tb();
 
  logic clk,rst;
  logic D;
  logic Qd;
  logic T;
  logic Qt;
  logic S,R;
  logic Qs;
  logic J,K;
  logic Qj;
  
  DFF DUT1(.*);
  TFF DUT2(.*);
  SRFF DUT3(.*);
  JKFF DUT4(.*);
  
 initial
  begin
    $dumpfile("Flip-Flops.vcd");
    $dumpvars(0,FF_tb);
    
    clk = '0;
    rst = '0;
    D = $random%2;
    T = $random%2;
    S = $random%2;
    R = $random%2;
    J = $random%2;
    K = $random%2;
    
    #3 @(posedge clk) rst = '1;
    
    for (int i=0; i<5 ; i++) begin
      @(posedge clk); 
      D = $random%2;
      T = $random%2;
      S = $random%2;
      R = $random%2;
      J = $random%2;
      K = $random%2;
      #5;
    end
    #40 $finish;
  end
  
 always #2 clk = !clk;  
 
endmodule

Waveform : https://www.edaplayground.com/w/x/8mu
