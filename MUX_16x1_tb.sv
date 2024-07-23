module MUX_4x1_tb(A,B,C);
  input logic A;
  output logic [3:0] B;
  output logic [1:0]C;

  MUX_4x1 DUT(.Y(A),.In(B),.Sel(C));

initial
 begin
   
   $monitor ($time,"  A=%b, B=%b, C=%b",A,B,C);
   
  #5 B=4'b1001; C=2'b10;
  #5 B=4'b0111; C=2'b11;
  #5 B=4'b1101; C=2'b00;
  #5 B=4'b0110; C=2'b11;
  #5 B=4'b1001; C=2'b10;
  #5 B=4'b0101; C=2'b01;
  #5 B=4'b0001; C=2'b01;
  #5 B=4'b1111; C=2'b00;
  #5 $finish;
  
 end
endmodule
