// Flip Flop Designs

//DFF
module DFF (Qd,D,clk,rst);
  input logic D,clk,rst;
  output logic Qd;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) Qd <= '0;
    else Qd <= D;
  end
  
endmodule

//TFF
module TFF (Qt,T,clk,rst);
  input logic T,clk,rst;
  output logic Qt;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) Qt <= '0;
    else Qt <= (T=='1) ? !Qt : Qt;
    //another logic -  else Q <= T ^ Q;
  end
  
endmodule

//S-R FF
module SRFF (Qs,S,R,clk,rst);
  input logic S,R,clk,rst;
  output logic Qs;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) Qs <= '0;
    else Qs <= S || (!R && Qs);
  end
  
endmodule

//J-K FF
module JKFF (Qj,J,K,clk,rst);
  input logic J,K,clk,rst;
  output logic Qj;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) Qj <= '0;
    else Qj <= (J && !Qj) || (!K && Qj);
  end
  
endmodule




