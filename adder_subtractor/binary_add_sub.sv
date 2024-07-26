// 4-bit adder subtractor
module binary_add_sub(Sum,Co,M,A,B);
 output logic Co;
  output logic [3:0]Sum;
 input logic M;
 input logic [3:0]A,B;
  logic Cin,c1,c2,c3;
  assign Cin = M;
  assign {c1,Sum[0]} = A[0] + (B[0] ^ M) + Cin;
  assign {c2,Sum[1]} = A[1] + (B[1] ^ M) + c1;
  assign {c3,Sum[2]} = A[2] + (B[2] ^ M) + c2;
  assign {Co,Sum[3]} = A[3] + (B[3] ^ M) + c3;
  
endmodule

