//16bit odd/even counter depending on mode bit

module Odd_Even_Cnt(Cnt,M,clk,rst);
  output logic [15:0] Cnt;
  input logic M,clk,rst;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      Cnt <= M ? 16'd0 : 16'd1; //Mode=1(Even counter), else Odd
    end
    else begin
      Cnt <= (Cnt%2==M) ? Cnt + 16'd1 : Cnt + 16'd2;
    end
  end
endmodule
