//Positive level trigerred D-latch 
module D_latch(Q,I,En);
 output logic Q;
 input logic I,En;
 always_comb Q = En ? I : Q;
endmodule

// NAND SR-latch 
module SR_latch_NAND(Q,Qb,S,R);
 output logic Q,Qb;
 input logic S,R;
  always_comb Qb = !(S && Q);
  always_comb Q = !(R && Qb);
endmodule

// NOR SR-latch 
module SR_latch_NAND(Q,Qb,S,R);
 output logic Q,Qb;
 input logic S,R;
 always_comb Qb = !(S || Q);
 always_comb Q = !(R || Qb);
endmodule

