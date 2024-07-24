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


module SR_latch_tb(q,qb,s,r);
 input logic q,qb;
  output logic s,r;
 
  SR_latch_NAND DUT(.Q(q),.Qb(qb),.S(s),.R(r));
  
 initial
  begin
    $dumpfile("SR_latch.vcd");
    $dumpvars(0,SR_latch_tb);
    $monitor ($time," S=%b, R=%b, Q=%b, Qb=%b",s,r,q,qb);
  
 
  #5 s='0; r='1;
  #5 s='1; r='1;
  #5 s='1; r='0; 
    
  #5 $finish;
  end
  
endmodule

NAND_SR_latch output :
0 S=x, R=x, Q=x, Qb=x
                   5 S=0, R=1, Q=0, Qb=1
                  10 S=1, R=1, Q=0, Qb=1
                  15 S=1, R=0, Q=1, Qb=0
testbench.sv:18: $finish called at 20 (1s)

NOR SR latch output :
0 S=x, R=x, Q=x, Qb=x
                   5 S=0, R=1, Q=0, Qb=1
                  10 S=0, R=0, Q=0, Qb=1
                  15 S=1, R=0, Q=1, Qb=0
testbench.sv:18: $finish called at 20 (1s)




