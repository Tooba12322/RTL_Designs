// Waveform :  

module pr_arb_tb ();
  
  logic S;
  logic M0,M1,M2,M3;
  logic [2:0] P0,P1,P2,P3;
  
  priority_arb  DUT(.*);
  
  initial begin
    $dumpfile("priority_arbiter.vcd");
    $dumpvars(0,pr_arb_tb);
    
    M0='0; M1='0; M2='0; M3='0;
    #5;
    repeat(50) begin
      M0=$random%2; M1=$random%2; M2=$random%2; M3=$random%2;
      P0=$urandom_range('0,3'd7); M1=$urandom_range('0,3'd7); 
      M2=$urandom_range('0,3'd7); M3=$urandom_range('0,3'd7);
      #3;
    end
    
    #10 $finish;
  end
    
endmodule
