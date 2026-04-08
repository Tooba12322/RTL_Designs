
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
  input logic [3:0]    wstrb,
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
  
  logic nwr, ready;
  logic [31:0]  addr;
  assign nwr = (!(wvalid && wready)) || (rvalid && rready);

  MEM mem(.clk(aclk),.rst_n(arst_n),.req_i(req_i),.req_rnw_i(nwr),.req_addr_i(addr),
          .req_wdata_i(wdata),.req_ready_o(ready),.req_rdata_o(rdata)); 
  
  always @(posedge aclk or negedge arst_n) begin
    if (!arst_n) awready <= '0;
    else if (awvalid) awready <= ready;
  end

  always @(posedge aclk or negedge arst_n) begin
    if (!arst_n) awready <= '0;
    else if (arvalid) arready <= ready;
  end

  always @(posedge aclk or negedge arst_n) begin
    if (!arst_n) wready <= '0;
    else if (wvalid) wready <= ready;
  end

  always @(posedge clk or negedge rst) begin
    if (!rst) begin

      pr_state <= '0;
    end
    else if (pready_i) begin //pready dependent driven output
      pr_state <= nx_state;
      
    end
  end
  
  always_comb begin
      nx_state    = pr_state; //default case values
      psel_nxt    = psel;
      penable_nxt = penable;
      paddr_nxt   = paddr;
      pwrite_nxt  = pwrite;
      pwdata_nxt  = pwdata;
          
    case (pr_state) 
      IDLE : begin
               if (awvalid && awready)  nx_state = WRITE;
               else if (arvalid && arready)  nx_state = READ;
             end
      
      WRITE : begin //generating write transaction signals to be driven in next cycle when pready=1
                psel_nxt    = '1;
                pwrite_nxt  = '1;
                pwdata_nxt  = 32'hDEAD_CAFE + pwdata;
                nx_state    = ACCESS;
                paddr_nxt   = (event_a_i) ? 32'h1000_1000 : (event_b_i) ? 32'h2000_2000 : 32'h3000_3000;
                penable_nxt = (penable == 1 && pwdata_nxt!=pwdata && pready_i) ? '0 : '1; //penable to be low during setup phase only
              end
             
      READ : begin // wdata latched by slave when pready=1, check for next event
                 penable_nxt = '1;
                 if (pready_i) begin
                   if (event_a_i || event_b_i || event_c_i) nx_state = SETUP; 
                   else begin
                     nx_state = IDLE;
                     psel_nxt    ='0;
                   end
                 end
               end
      RESP : begin // wdata latched by slave when pready=1, check for next event
                 penable_nxt = '1;
                 if (pready_i) begin
                   if (event_a_i || event_b_i || event_c_i) nx_state = SETUP; 
                   else begin
                     nx_state = IDLE;
                     psel_nxt    ='0;
                   end
                 end
               end
      endcase
  end

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
    if (!rst_n) cnt <= '0;
    else cnt <= cnt + 4'd1;
  end   
  
  assign req_rdata_o = req_rdata; //Drive rdata when ready ,req and rnw are high
  
  assign req_ready_o = ((cnt%2) && (cnt%3)) || (cnt[2]=='1); //logic to generate ready out
  
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) req_rdata <= '0;
    else if (req_i && req_rnw_i && req_ready_o) req_rdata <=  mem[req_addr_i];//read
  end  
  
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (int i=0;i<16;i++) mem[i] <= '0;
    end
    else if (req_i && !req_rnw_i && req_ready_o) begin
      mem[req_addr_i] <= req_wdata_i;//write
    end
  end
  
endmodule
