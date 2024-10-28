
// Design and verify a AHB slave interface which utilises the memory interface.

module ahb_s(
  input logic clk,
  input logic rst,
  input logic hwrite,
  input logic [31:0] hwdata, 
  input logic [31:0] haddr,
  input logic [2:0] hsize, hburst,
  input logic [1:0] htrans,
  input logic [3:0] hprot,
  input logic hmastlock,
  output logic [31:0] hrdata,
  output logic hready, hresp
);
  logic nwr, req, receive;
  assign nwr = !hwrite;
  assign hresp = '1;
  always @(posedge clk or negedge rst) begin
    if (!rst) req <= '0;
    else if (htrans==2'd2 || htrans==2'd3) req <= '1;
    else req <= '0;
  end 
  
  MEM mem(.clk(clk),.rst(rst),.req_i(req),.req_rnw_i(nwr),.req_addr_i(haddr),
          .req_wdata_i(hwdata),.req_ready_o(hready),.req_rdata_o(hrdata)); 
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
