module MUX_16x1_tb(A,B,C);
  input logic A;
  output logic [15:0] B;
  output logic [3:0]C;

  MUX_16x1 DUT(.Y(A),.In(B),.Sel(C));

initial
 begin
   $dumpfile("MUX_16x1.vcd");
   $dumpvars(0,MUX_16x1_tb);
   $monitor ($time,"  A=%b, B=%h, C=%d",A,B,C);
   
  #5 B=16'h674F; C=4'd5;
  #5 C=4'd12;
  #5 C=4'd8;
  #5 B=16'hA017; C=4'd0;
  #5 C=4'd5;
  #5 C=4'd3;
  #5 $finish;
  
 end
endmodule

Output : 
0  A=x, B=xxxx, C= x
                   5  A=0, B=674f, C= 5
                  10  A=0, B=674f, C=12
                  15  A=1, B=674f, C= 8
                  20  A=1, B=674f, C= 3
                  25  A=1, B=a017, C= 0
                  30  A=0, B=a017, C= 5
                  35  A=0, B=a017, C=10
                  40  A=1, B=a017, C=15
testbench.sv:21: $finish called at 45 (1s)
