// 4-master-1-slave priority arbiter with Valid

module rr_arb(S,Req,Gnt,clk,rst);
  
  output logic S;
  output logic [3:0] Gnt;
  input logic [4:1] Req;
  input logic clk,rst;
  
  logic [1:0] Cnt;
  logic Clr_cnt;
  
  typedef enum logic [2:0] {S0 = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100} state;
    state pr_state,nx_state;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) pr_state <= S0;
    else pr_state <= nx_state;
  end 
  
   always @(posedge clk or negedge rst) begin
     if (!rst || Clr_cnt) Cnt <= '0;
    else Cnt <= Cnt + 2'd1;
  end   
  
  always_comb begin
      nx_state = pr_state;
    
    case (pr_state) 
      S0 : begin
             Clr_cnt = '1;
             if (Req[1]) nx_state = S1;
             else if (Req[2]) nx_state = S2;
             else if (Req[3]) nx_state = S3;
             else if (Req[4]) nx_state = S4;
           end
      S1 : begin
             if (Cnt == '1) begin
               if (Req[2]) begin
                 nx_state = S2;
                 Clr_cnt = '1;
               end
               else if (Req[3]) begin
                 nx_state = S3;
                 Clr_cnt = '1;
               end
               else if (Req[4]) begin
                 nx_state = S4;
                 Clr_cnt = '1;
               end
               else if (Req[1]) begin
                 Clr_cnt = '1;
               end
               else begin
                 Clr_cnt = '1;
                 nx_state = S0;
               end
             end
           end
      S2 : begin
             if (Cnt == '1) begin
               if (Req[3]) begin
                 nx_state = S3;
                 Clr_cnt = '1;
               end
               else if (Req[4]) begin
                 nx_state = S4;
                 Clr_cnt = '1;
               end
               else if (Req[1]) begin
                 nx_state = S1;
                 Clr_cnt = '1;
               end
               else if (Req[2]) begin
                 Clr_cnt = '1;
               end
               else begin
                 Clr_cnt = '1;
                 nx_state = S0;
               end
             end
           end
      S3 : begin
             if (Cnt == '1) begin
               if (Req[4]) begin
                 nx_state = S4;
                 Clr_cnt = '1;
               end
               else if (Req[1]) begin
                 nx_state = S1;
                 Clr_cnt = '1;
               end
               else if (Req[2]) begin
                 nx_state = S2;
                 Clr_cnt = '1;
               end
               else if (Req[3]) begin
                 Clr_cnt = '1;
               end
               else begin
                 Clr_cnt = '1;
                 nx_state = S0;
               end
             end
           end
      S4 : begin
             if (Cnt == '1) begin
               if (Req[1]) begin
                 nx_state = S1;
                 Clr_cnt = '1;
               end
               else if (Req[2]) begin
                 nx_state = S2;
                 Clr_cnt = '1;
               end
               else if (Req[3]) begin
                 nx_state = S3;
                 Clr_cnt = '1;
               end
               else if (Req[4]) begin
                 Clr_cnt = '1;
               end
               else begin
                 Clr_cnt = '1;
                 nx_state = S0;
               end
             end
           end
      endcase
  end
  
endmodule
