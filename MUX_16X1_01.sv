module MUX(Y,In,Sel);
 output logic Y;
 input [15:0] In;
 input [3:0] Sel;
  assign Y = In[Sel]; 
endmodule
