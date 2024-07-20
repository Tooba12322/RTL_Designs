module LUT_tb(A,B,C,D,E,F,G,H);
output reg [15:0] A,B;
input wire [15:0] C;
input wire D,E,F,G,H;

  LUT DUT(.X(A),.Y(B),.Z(C),.Sign(D),.Zero(E),.OF(F),.Parity(G),.Carry(H));

initial
 begin
   
   $monitor ($time,"  A=%h,B=%h,C=%h,D=%b,E=%b,F=%b,G=%b,H=%b",A,B,C,  D,E,F,G,H);
   
  #5 A=16'hffff; B=16'hAAAA;
  #5 A=16'h5555; B=16'hAAAA;
  #5 A=16'hffff; B=16'hffff;
  #5 A=16'h3456; B=16'h0120;
  #5 $finish;
  
 end
endmodule
