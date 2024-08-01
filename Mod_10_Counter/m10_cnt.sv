// Async mod-10 counter

module TFF (Qt,T,clk,rst,clr);
  input logic T,clk,rst,clr;
  output logic Qt;
  
  always @(negedge clk or negedge rst or negedge clr) begin
    if (!rst) Qt <= '0;
    else if (!clr) Qt <= '0;
    else Qt <= (T=='1) ? !Qt : Qt;
  end
endmodule

// Structural modelling
module M10_cnt (Cnt,clk,rst);
  input logic clk,rst;
  output logic [3:0] Cnt;
  
  logic Q1,Q2,Q3,Q4,clr;
  
  TFF FF1(Q1,'1,clk,rst,clr);
  TFF FF2(Q2,'1,Q1,rst,clr);
  TFF FF3(Q3,'1,Q2,rst,clr);
  TFF FF4(Q4,'1,Q3,rst,clr);
  
  assign Cnt = {Q4,Q3,Q2,Q1};
  
  assign clr = !(Q4 && Q2 && !Q1 && !Q3); // Depending on clr logic any mode counter can be designed
  //For exapmle for mod-6, clear logic would be 
endmodule





