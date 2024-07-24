//Positive level trigerred D-latch 
module D_latch(Q,I,En);
 output logic Q;
 input logic I,En;
 always_comb Q = En ? I : Q;
endmodule

module SR_latch()

endmodule
