// Design a gray code counter that generates all 4-bit and 3-bit gray counts.
// n-bit and (n-1) bit gray counter, the (n-1)-bit Gray code is simply generated 
// by doing an exclusive-or operation on the two MSBs of the n-bit Gray code
// to generate the MSB for the (n-1)-bit Gray code.
// This is combined with the (n-2) LSBs of the n-bit Gray code counter to form the (n-1)-bit Gray code counter.

// 4-bit and 3-bit Gray code counter implementation

module dual_gr_cnt(n_1_gr_cnt,n_gr_cnt,clk,rst);
  
  output logic [3:0] n_gr_cnt;
  output logic [2:0] n_1_gr_cnt;
  input logic clk,rst;
  
  logic [3:0] gr, bin, br_cnt;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) n_gr_cnt <= '0;
    else n_gr_cnt <= gr; // N-bit gray counter flop
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) n_1_gr_cnt <= '0;
    else n_1_gr_cnt <= {gr[3] ^ gr[2],gr[1],gr[0]}; // N-1 bit gray counter flop
  end
  
  assign bin = {n_gr_cnt[3],bin[3] ^ n_gr_cnt[2],bin[2] ^ n_gr_cnt[1],bin[1] ^ n_gr_cnt[0]};//gray to binary combo logic as feedback
  
  assign br_cnt = bin + 4'd1; //adding one to gray converted binary value
  
  assign gr = {br_cnt[3],br_cnt[3]^br_cnt[2],br_cnt[2]^br_cnt[1],br_cnt[1]^br_cnt[0]};// converted incremented binary to gray and fed to gr_cnt flop  
  
endmodule 
