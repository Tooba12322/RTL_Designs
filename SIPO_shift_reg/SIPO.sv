// Design an 8-bit serial in parallel out shift register, which provides output every 8th clk, and takes in input serially every clk

module SIPO (parallel_out,sr_in,clk,rst);
  
  output logic [7:0] parallel_out;
  input logic sr_in,clk,rst;
  
  logic out;
  logic [7:0] Q;
  logic [2:0] cnt;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) Q <= '0;
    else Q <= {sr_in,Q[7:1]}; // 8 bit shift reg, with sr_in applied to MSB flop
  end   
  
  always @(posedge clk or negedge rst) begin
    if (!rst) cnt <= '0;
    else if (out) cnt <='1;
    else cnt <= cnt - 3'd1; // counter to produce output every 8th cycle
  end
    
  always @(posedge clk or negedge rst) begin
    if (!rst) out <= '0;
    else if (cnt - 3'd1 =='0) out <= '1;
    else out <= '0; // flop to indicate output generation pulse, redundant can be avoided
  end
  
  assign parallel_out = (out) ? Q : '0; 
  // another way to avoid out flop completely and produce output, assign parallel_out = (cnt=='1) ? Q : '0; 
  
endmodule
 
