//Structural modelling

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

module MUX_2x1(Y,In,Sel);
 output logic Y;
 input logic [1:0] In;
 input logic Sel;
 logic w1,w2;
 AND G1(w1,In[0],!Sel);
 AND G2(w2,In[1],Sel);
 OR G3(Y,w1,w2);
 endmodule

module MUX_4x1(Y,In,Sel);
  output logic Y;
  input logic [3:0] In;
  input logic [1:0] Sel;
  logic w1, w2;
  
  MUX_2x1 M1(w1, In[1:0], Sel[0]);
  MUX_2x1 M2(w2, In[3:2], Sel[0]);
  MUX_2x1 M3(Y, {w2,w1}, Sel[1]);

endmodule

module MUX_16x1(Y,In,Sel);
  output logic Y;
  input logic [15:0] In;
  input logic [3:0] Sel;
  logic w1, w2, w3, w4;
  
  MUX_4x1 M1(w1, In[3:0], Sel[1:0]);
  MUX_4x1 M2(w2, In[7:4], Sel[1:0]);
  MUX_4x1 M3(w3, In[11:8], Sel[1:0]);
  MUX_4x1 M4(w4, In[15:12], Sel[1:0]);
  MUX_4x1 M5(Y, {w4,w3,w2,w1}, Sel[3:2]);
  
endmodule


