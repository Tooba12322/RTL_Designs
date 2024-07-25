// 4-bit serial adder
module serial_adder(Sum,Cy,SI_1,SI_2,load,clk,rst);
 output logic Sum,Cy;
 input logic SI_1,SI_2,load,clk,rst;
  logic [3:0] reg_A,reg_B,stored_sum;
  logic stored_cy;
  assign {Cy,Sum} = reg_A[0] + reg_B[0];
  
  always @(posedge clk or negedge rst) begin
    if (!rst) stored_cy <= '0;
    else stored_cy <= Cy;   
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) reg_A <= '0;
    else begin
      reg[3] <= load ? SI_1 : Sum;
      reg[2] <= reg[3];
      reg[1] <= reg[2];
      reg[0] <= reg[1];
    end
  end
endmodule



