// 2-bit comparator
module comp_2b(Eq,Gt,Lt,A,B);
  output logic Eq,Gt,Lt;
  input logic [1:0]A,B;
  
  logic Eq_MSB; 
  assign Eq_MSB = !(A[1] ^ B[1]); // A and B have equal MSB bits
  
  assign  Eq = (A==B) ? '1 : '0; // A is equal to B
  assign  Gt = ((A[1] && !B[1]) || (Eq_MSB && A[0] && !B[0])) ? '1 : '0; // A>B
  assign  Lt = ((!A[1] && B[1]) || (Eq_MSB && !A[0] && B[0])) ? '1 : '0; // A<B
  
endmodule
