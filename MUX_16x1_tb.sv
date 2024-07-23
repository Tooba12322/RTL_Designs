module LUT_tb(A,B,C);
  input logic A;
  output logic [1:0] B;
  output logic C;

  MUX_2x1 DUT(.Y(A),.In(B),.Sel(C));

initial
 begin
   
   $monitor ($time,"  A=%b, B=%b, C=%b",A,B,C);
   
  #5 B=2'b01; C=1'b0;
  #5 B=2'b01; C=1'b1;
  #5 B=2'b10; C=1'b0;
  #5 B=2'b10; C=1'b1;
  #5 $finish;
  
 end
endmodule
