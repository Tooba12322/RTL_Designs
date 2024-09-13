// Design and verify a valid/ready based memory interface slave. 
// The interface should be able to generate the ready output after a random delay. Memory should be 16x32 bits wide.

// Interface Definition
// Valid/ready protocol must be honoured
// The module should have the following interface:

  // input       wire        clk,
  // input       wire        reset,
  // input       wire        req_i,        -> Valid request input remains asserted until ready is seen
  // input       wire        req_rnw_i,    -> Read-not-write (1-read, 0-write)
  // input       wire[3:0]   req_addr_i,   -> 4-bit Memory address
  // input       wire[31:0]  req_wdata_i,  -> 32-bit write data
  // output      wire        req_ready_o,  -> Ready output when request accepted
  // output      wire[31:0]  req_rdata_o   -> Read data from memory

  // Memory array
  // logic [15:0][31:0] mem;

// A memory interface

module MEM (
  input  logic      clk,
  input  logic      rst,

  input       logic       req_i,
  input       logic       req_rnw_i,    // 1 - read, 0 - write
  input       logic [3:0] req_addr_i,
  input       logic [31:0]req_wdata_i,
  output      logic       req_ready_o,
  output      logic [31:0]req_rdata_o
);
 
  logic [31:0] mem [15:0];
  logic [3:0] cnt;
  logic [31:0] req_rdata;
  logic       req_ready;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) cnt <= '0;
    else cnt <= cnt + 4'd1;
  end   
  
  assign req_rdata_o = (req_ready_o && req_i && req_rnw_i) ? req_rdata : '0;
  
  assign req_ready_o = (req_i) ? ((cnt%2) || (cnt%3)) : '0;
  
  always_ff @(posedge clk or negedge rst) begin
    if (!rst) req_rdata <= '0;
    else if (req_i && req_rnw_i) req_rdata <=  mem[req_addr_i];//read
  end  
  
  always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
      for (int i=0;i<16;i++) mem[i] <= '0;
    end
    else if (req_i && req_rnw_i && req_ready_o) begin
      mem[req_addr_i] <= req_wdata_i;//write
    end
  end
  
endmodule
