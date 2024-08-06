// Design a circiut whose output is the GCD (Greatest Common Deviser) of two integers, using continuous subtraction algorithm


module GCD (Done,Out,In,Start,clk,rst);
  
  output logic [15:0] Out;
  output logic Done;
  
  input logic [15:0] In;
  input logic clk,rst,Start;
  
  logic ld_A,ld_B,Gr;
  logic [15:0] A,B;
  
  typedef enum logic [3:0] {S0 = 4'b0000,
    S1 = 4'b0001,
    S2 = 4'b0010,
    S3 = 4'b0100,
    S4 = 4'b1000} state;
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
      Gr       = '0;
    
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
           end
      S3 : begin
             if (A > B) Gr = '1;
             if (A == B) nx_state = S4;
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
    else if (Gr) A <= A - B;
  end 
  
  always @(posedge clk or negedge rst) begin
    if (!rst) B <= '0;
    else if (ld_B) B <= In;
    else if (!Gr && (B > A)) B <= B - A;
  end 
  
  always_comb Out = (Done == '1) ? A : '0;
  
endmodule
 
