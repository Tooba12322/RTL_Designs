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
      //reg_A[3] <= load ? SI_1 : Sum;
      //reg_A[2] <= reg_A[3];
      //reg_A[1] <= reg_A[2];
      //reg_A[0] <= reg_A[1];
      //Better coding style for same shift reg functionality
      reg_A <= load ? {SI_1,reg_A[3:1]} : {Sum,reg_A[3:1]}; 
    end
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) reg_B <= '0;
    else begin
      //reg_B[3] <= SI_2;
      //reg_B[2] <= reg_B[3];
      //reg_B[1] <= reg_B[2];
      //reg_B[0] <= reg_B[1];
      //Better coding style for same shift reg functionality
      reg_B <= {SI_2,reg_B[3:1]}; 
    end
  end
  
  //Either implement a separate register for storing sum or else result can be found in reg_A after load=0 
  always @(posedge clk or negedge rst) begin
    if (!rst) stored_sum <= '0;
    else begin
      //stored_sum[3] <= Sum;
      //stored_sum[2] <= stored_sum[3];
      //stored_sum[1] <= stored_sum[2];
      //stored_sum[0] <= stored_sum[1];
      //Better coding style for same shift reg functionality
      stored_sum <= {Sum,stored_sum[3:1]}; 
    end
  end
endmodule
