// Design a multiplier circuit that does multiplication of two 16-bit inputs by repeatative addition.


module MULT (Done,Out,In,Start,clk,rst);
  
  output logic [15:0] Out;
  output logic Done;
  
  input logic [15:0] In;
  input logic clk,rst,Start;
  
  logic ld_A,ld_B,clr_M,dec_B,add;
  logic [15:0] A,B,M;
  
  typedef enum logic [3:0] {S0 = 4'b0000,
    S1 = 4'b0001,
    S2 = 4'b0010,
    S3 = 4'b0100,
    S4 = 4'b1000 } state;
  state pr_state,nx_state;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) pr_state <= S0;
    else pr_state <= nx_state;
  end   
  
  always_comb begin
      nx_state = pr_state;
      Done     = '0;
      Out      = '0;
      ld_A     = '0;
      ld_B     = '0;
      clr_M    = '0;
      dec_B    = '0;
      add      = '0;
    case (pr_state) 
      S0 : begin
             if (Start=='1) nx_state = S1;
           end
      S1 : begin
             nx_state = S2;
             ld_A = '1;
           end
      S2 : begin
             nx_state = S3;
             ld_B = '1;
             clr_M = '1;
           end
      S3 : begin
             add = '1;
             dec_B = '1;
             if (B-16'd1 == '0) nx_state = S4;
           end
      S4 : begin
             if (Start=='1) nx_state = S1;
             else nx_state = S0;
             Done = '1;
           end
    endcase
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) A <= '0;
    else if (ld_A) A <= In;
  end 
  
  always @(posedge clk or negedge rst) begin
    if (!rst) B <= '0;
    else if (ld_B) B <= In;
    else if (dec_B) B <= B-16'd1;
  end 
  
  always @(posedge clk or negedge rst) begin
    if (!rst) M <= '0;
    else if (clr_M) M <= '0;
    else if (add) M <= M + A;
  end 
  
  always_comb Out = (Done == '1) ? M : '0;
  
endmodule
 
