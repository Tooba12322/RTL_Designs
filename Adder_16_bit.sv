//16-bit ripple carry adder with flags - structural modeling
module AND(F,A,B);
 output logic F;
 input logic A,B;
 assign F = A && B;
endmodule

module OR(F,A,B);
 output logic F;
 input logic A,B;
 assign F = A || B;
endmodule

module XOR(F,A,B);
 output logic F;
 input logic A,B;
 assign F = A ^ B;
endmodule

module FA(Co,Sum,A,B,Cin);
 output logic Sum, Co;
 input logic A, B, Cin;
 logic w1,w2,w3;
  
  XOR G1(w1,A,B);
  XOR G2(Sum,w1,Cin);
  AND G3(w2,A,B);
  AND G4(w3,w1,Cin);
  OR G5(Co,w2,w3);
  
endmodule
  

module adder_4b(Co,Sum,A,B,Cin);
 output logic Sum[3:0];
 output logic Co;
  input logic A[3:0];
  input logic B[3:0]; 
  input logic Cin;
  logic c1,c2,c3;
  
  FA FA1(c1,Sum[0],A[0],B[0],Cin);
  FA FA2(c2,Sum[1],A[1],B[1],c1);
  FA FA3(c3,Sum[2],A[2],B[2],c2);
  FA FA4(Co,Sum[3],A[3],B[3],c3);
  
endmodule  

module adder_16b(Co,Sum,A,B,Cin);
  output logic Sum[15:0];
  output logic Co;
  input logic A[15:0];
  input logic B[15:0]; 
  input logic Cin;
  logic c1,c2,c3;
  
  adder_4b A1(c1,Sum[3:0],A[3:0],B[3:0],Cin);
  adder_4b A2(c2,Sum[7:4],A[7:4],B[7:4],c1);
  adder_4b A3(c3,Sum[11:8],A[11:8],B[11:8],c2);
  adder_4b A4(Co,Sum[15:12],A[15:12],B[15:12],c3);
  
endmodule
