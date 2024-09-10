// 4-bit Gray code counter

module gray_cnt(gr_cnt,clk,rst);
  
  output logic [3:0] gr_cnt;
  input logic clk,rst;
  
  logic [3:0] gr, bin, br_cnt;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) gr_cnt <= '0;
    else gr_cnt <= gr; // gray counter flop
  end
  
  assign bin = {gr_cnt[3],bin[3] ^ gr_cnt[2],bin[2] ^ gr_cnt[1],bin[1] ^ gr_cnt[0]};//gray to binary combo logic as feedback
  
  assign br_cnt = bin + 4'd1; //adding one to gray converted binary value
  
  assign gr = {br_cnt[3],br_cnt[3]^br_cnt[2],br_cnt[2]^br_cnt[1],br_cnt[1]^br_cnt[0]};// converted incremented binary to gray and fed to gr_cnt flop  
  
endmodule 
