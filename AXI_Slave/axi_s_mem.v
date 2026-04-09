
// Description: 
//  // Design and verify a AXI slave interface which utilises the memory interface.


module axi_s(
  input logic aclk,
  input logic arst_n,

  //Write addr channel
  input logic [31:0]   awaddr,
  input logic          awvalid,
  output logic         awready,

  //Write data channel
  input logic [31:0]   wdata,
  input logic          wvalid,
  output logic         wready,

  //Write response channel
  output logic [1:0]   bresp,
  output logic         bvalid,
  input logic          bready,

  //Read addr channel
  input logic [31:0]   araddr,
  input logic          arvalid,
  output logic         arready,

  //Read data channel
  output logic [31:0]  rdata,
  output logic [1:0]   rresp,
  output logic         rvalid,
  input logic          rready
);

  //state enum  
  typedef enum logic [1:0] {IDLE = 2'b00, 
    WRITE = 2'b01,
    READ = 2'b10,
    RESP = 2'b11} state;
    state pr_state,nx_state;
  
  logic rd_nwr, ready, req;
  logic [31:0]  addr;
  logic [31:0]  awaddr_nxt, awaddr_reg;
  logic [31:0]  araddr_nxt, araddr_reg;
  
  logic [31:0] wData, rData;
  
  always_comb begin
    addr = rd_nwr ? araddr_reg : awaddr_reg;
  end
  
  MEM mem(.clk(aclk),.rst_n(arst_n),.req_rnw_i(rd_nwr),.req_addr_i(addr),
          .req_wdata_i(wData),.req_ready_o(ready),.req_rdata_o(rData)); 

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      pr_state <= '0;
    end
    else begin 
      pr_state <= nx_state;
    end
  end
  
  always_comb begin
      nx_state    = pr_state; //default case values
      awaddr_nxt  = awaddr_reg;
      araddr_nxt  = araddr_reg;
      awready     = '0;
      arready     = '0;
      wready      = '0;
      wData       = '0;
      rd_nwr      = '0;
      bvalid      = '0;
      bresp       = '0;
    
    case (pr_state) 
      IDLE : begin
             if (awvalid) awready = ready;
             else if (arvalid) arready = ready;
             if (awvalid && awready)  begin
                nx_state = WRITE;
                awaddr_nxt = awaddr;
             end
             else if (arvalid && arready)  begin
                nx_state = READ;
                araddr_nxt = araddr;
             end
      
      WRITE : begin 
                wready = ready;
                rd_nwr = '0;
                if (wvalid && wready)  begin
                  wData       = wdata;
                  nx_state    = RESP;
                end
              end
             
      READ : begin 
                  rd_nwr = '1;
                 if (pready_i) begin
                   if (event_a_i || event_b_i || event_c_i) nx_state = SETUP; 
                   else begin
                     nx_state = IDLE;
                     psel_nxt    ='0;
                   end
                 end
               end
      RESP : begin 
                bvalid   = '1;
                bresp    = '0;
                if (bvalid && bready) nx_state = IDLE;
             end
      endcase
  end

endmodule

// A memory interface

module MEM (
  input  logic      clk,
  input  logic      rst_n,
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
    if (!rst_n) cnt <= '0;
    else cnt <= cnt + 4'd1;
  end   
  
  assign req_rdata_o = req_rdata; //Drive rdata when ready ,req and rnw are high
  
  assign req_ready_o = ((cnt%2) && (cnt%3)) || (cnt[2]=='1); //logic to generate ready out
  
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) req_rdata <= '0;
    else if (req_rnw_i && req_ready_o) req_rdata <=  mem[req_addr_i];//read
  end  
  
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (int i=0;i<16;i++) mem[i] <= '0;
    end
    else if (!req_rnw_i && req_ready_o) begin
      mem[req_addr_i] <= req_wdata_i;//write
    end
  end
  
endmodule
