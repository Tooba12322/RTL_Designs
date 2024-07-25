// 4-bit serial adder
module serial_adder(Sum,Cy,SI_1,SI_2,load,clk,rst);
 output logic Sum,Cy;
 input logic SI_1,SI_2,load,clk,rst;
  logic [3:0] reg_A,reg_B,stored_sum;
  logic stored_cy;
  assign {Cy,Sum} = reg_A[0] + reg_B[0] + stored_cy;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) stored_cy <= '0;
    else stored_cy <= Cy;   
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) reg_A <= '0;
    else begin
      reg_A[3] <= load ? SI_1 : Sum;
      reg_A[2] <= reg_A[3];
      reg_A[1] <= reg_A[2];
      reg_A[0] <= reg_A[1];
    end
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) reg_B <= '0;
    else begin
      reg_B[3] <= SI_2;
      reg_B[2] <= reg_B[3];
      reg_B[1] <= reg_B[2];
      reg_B[0] <= reg_B[1];
    end
  end
endmodule




