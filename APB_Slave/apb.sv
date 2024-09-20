
// Design and verify a APB slave interface which utilises the memory interface.
// APB Slave

module apb (
  input         logic        clk,
  input         logic        rst,
  input         logic        psel_i,
  input         logic        penable_i,
  input         logic [3:0]  paddr_i,
  input         logic        pwrite_i,
  input         logic [31:0] pwdata_i,
  output        logic [31:0] prdata_o,
  output        logic        pready_o
);
  logic nwr;
  assign nwr = !pwrite_i;
  MEM mem(.clk(clk),.rst(rst),.req_i(psel_i),.req_rnw_i(nwr),.req_addr_i(paddr_i),
          .req_wdata_i(pwdata_i),.req_ready_o(pready_o),.req_rdata_o(prdata_o)); 
endmodule

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
 
  logic [31:0] mem [15:0]; // 16X32 memory
  logic [3:0] cnt; // cnt to generate random ready out
  logic [31:0] req_rdata; //flop to store data read
  
  always @(posedge clk or negedge rst) begin
    if (!rst) cnt <= '0;
    else cnt <= cnt + 4'd1;
  end   
  
  assign req_rdata_o = (req_ready_o && req_i && req_rnw_i) ? req_rdata : '0; //Drive rdata when ready ,req and rnw are high
  
  assign req_ready_o = ((cnt%2) && (cnt%3)) || (cnt[2]=='1); //logic to generate ready out
  
  always_ff @(posedge clk or negedge rst) begin
    if (!rst) req_rdata <= '0;
    else if (req_i && req_rnw_i) req_rdata <=  mem[req_addr_i];//read
  end  
  
  always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
      for (int i=0;i<16;i++) mem[i] <= '0;
    end
    else if (req_i && !req_rnw_i && req_ready_o) begin
      mem[req_addr_i] <= req_wdata_i;//write
    end
  end
  
endmodule
