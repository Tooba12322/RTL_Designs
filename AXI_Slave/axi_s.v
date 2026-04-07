
// Description: 
//  This module implements an AXI4 slave interface with four read-write (RW) 
 //   registers and four read-only (RO) registers. The RW registers are writable 
//  via the AXI4 interface and accessible externally. The RO registers are 
//   read-only from the AXI4 interface and their values are driven during reset.

 // Features:
 //  - AXI4 protocol compliance
 //   - Individual access to RW and RO registers
 //   - Address decoding for up to 8 registers
 
// Register Map:
//   Address  | Register
 //   ---------|-----------------
 //   0x00     | RW Register 0
//   0x04     | RW Register 1
//   0x08     | RW Register 2
 //   0x0C     | RW Register 3
 //   0x10     | RO Register 0
 //   0x14     | RO Register 1
//   0x18     | RO Register 2
//   0x1C     | RO Register 3
 

module axi_s(
  input logic aclk,
  input logic arst_n,
  input logic [31:0]   awaddr,
  input logic          awvalid,
  output logic         awready,
  input logic [31:0]   wdata,
  input logic [3:0]    wstrb,
  input logic          wvalid,
  output logic         wready,
  output logic [1:0]   bresp,
  output logic         bvalid,
  input logic          bready,
  input logic [31:0]   araddr,
  input logic          arvalid,
  output logic         arready,
  output logic [31:0]  rdata,
  output logic [1:0]   rresp,
  output logic         rvalid,
  input logic          rready
);

  logic nwr, req, start;
  assign nwr = !hwrite;
  assign start = (htrans==2'd2 && !nwr) ? '1 : '0; 
  assign hresp = '1;
  always @(posedge aclk or negedge arst_n) begin
    if (!arst_n) req <= '0;
    else if (htrans==2'd2 || htrans==2'd3) req <= '1;
    else req <= '0;
  end 
  assign req_i = start || req;
  
  MEM mem(.clk(clk),.rst(rst),.req_i(req_i),.req_rnw_i(nwr),.req_addr_i(haddr),
          .req_wdata_i(hwdata),.req_ready_o(hready),.req_rdata_o(hrdata)); 
endmodule

// A memory interface

module MEM (
  input  logic      clk,
  input  logic      rst_n,

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
  
  always @(posedge clk or negedge rst_n) begin
    if (!arst_n) cnt <= '0;
    else cnt <= cnt + 4'd1;
  end   
  
  assign req_rdata_o = req_rdata; //Drive rdata when ready ,req and rnw are high
  
  assign req_ready_o = ((cnt%2) && (cnt%3)) || (cnt[2]=='1); //logic to generate ready out
  
  always_ff @(posedge clk or negedge rst_n) begin
    if (!arst_n) req_rdata <= '0;
    else if (req_i && req_rnw_i && req_ready_o) req_rdata <=  mem[req_addr_i];//read
  end  
  
  always_ff @(posedge clk or negedge rst_n) begin
    if (!arst_n) begin
      for (int i=0;i<16;i++) mem[i] <= '0;
    end
    else if (req_i && !req_rnw_i && req_ready_o) begin
      mem[req_addr_i] <= req_wdata_i;//write
    end
  end
  
endmodule
