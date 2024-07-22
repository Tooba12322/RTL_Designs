//Structural modelling

module MUX_2x1(Y,In,Sel);
 output logic Y;
 input [1:0] In;
 input Sel;
  assign Y = In[Sel]; 
endmodule

module MUX_4x1(Y,In,Sel);
 output logic Y;
 input [3:0] In;
 input [1:0] Sel;
  assign Y = In[Sel]; 
endmodule

module MUX_16x1(Y,In,Sel);
 output logic Y;
 input [15:0] In;
 input [3:0] Sel;
  assign Y = In[Sel]; 
endmodule


