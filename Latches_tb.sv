module D_latch_tb(q,i,e); // D=I
 input logic q;
  output logic i,e;
 
  D_latch DUT(.Q(q),.En(e),.I(i));
  
 initial
  begin
    $dumpfile("D_latch.vcd");
    $dumpvars(0,D_latch_tb);
    $monitor ($time," I=%b, En=%b, Q=%b",i,e,q);
  
 
  #5 e='0; i='1;
  #5 e='1; i='1;
  #5 e='0; i='0;
  #5 e='1; i='0; 
    
  #5 $finish;
  end
  
endmodule

Output :
0 I=x, En=x, Q=x
                   5 I=1, En=0, Q=x
                  10 I=1, En=1, Q=1
                  15 I=0, En=0, Q=1
                  20 I=0, En=1, Q=0
testbench.sv:19: $finish called at 25 (1s)

Waveform :


module SR_latch_tb()

endmodule
