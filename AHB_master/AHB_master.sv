`timescale 1ns/1ps

interface cmd_if #(parameter ADDRW = 32, parameter BYTE_CNTw = 16);
  
  logic req,wr;
  logic [BYTE_CNTw-1:0] byte_cnt;
  logic [ADDRW-1:0] start_addr;
  logic done,req_ack;
  
  modport master (input done,req_ack, output req,byte_cnt,start_addr,wr);
  modport slave (input req,byte_cnt,start_addr,wr, output done,req_ack);
  
endinterface

interface ahb_if #(parameter ADDRW = 32, parameter DATAW = 32);
  
  logic hwrite;
  logic [DATAW-1:0] hwdata, hrdata;
  logic [ADDRW-1:0] haddr;
  logic [2:0] hsize, hburst;
  logic [1:0] htrans;
  logic [3:0] hprot;
  logic hmastlock;
  logic hready, hresp;
  logic hresetn, hclk;
  
  modport master (input hresetn, hclk, hready, hresp, hrdata, output hwdata, haddr, hwrite, hsize, hburst, htrans, hprot, hmastlock);
  modport slave (input hwdata, haddr, hwrite, hsize, hburst, htrans, hprot, hmastlock, output hresetn, hclk, hready, hresp, hrdata);
  
endinterface

module ahb_m(clk, rst);
  
  parameter ADDRW = 32;
  parameter DATAW = 32;
  
  input logic clk,rst;
  cmd_if in(.*); 
  ahb_if out(.*);
  
  logic hwrite_reg, hwrite_nxt;
  logic [DATAW-1:0] hwdata_reg, hrdata_reg, hwdata_nxt, hrdata_nxt;
  logic [ADDRW-1:0] haddr_reg, haddr_nxt;
  logic [2:0] hsize_reg, hburst_reg, hsize_nxt, hburst_nxt;
  logic [1:0] htrans_reg, htrans_nxt;
  logic [3:0] hprot;
  logic hmastlock;
  logic hready, hresp;
  logic done;
  
  
  //state enum  
  typedef enum logic [2:0] {IDLE, START, INCR, INCR4, INCR8, INCR16, DONE} state;
  state pr_state,nx_state;
  
  
  //Driving master output from flops
  always_comb ahb_if.master.haddr   = haddr_reg;
  always_comb ahb_if.master.hwdata  = hwdata_reg;
  always_comb ahb_if.master.hwrite  = hwrite_reg;
  always_comb ahb_if.master.hsize   = hsize_reg;
  always_comb ahb_if.master.hburst  = hburst_reg;
  always_comb ahb_if.master.htrans  = htrans_reg;
  always_comb ahb_if.master.hmastlock= hmastlock;
  always_comb ahb_if.master.hprot   = hprot;
    
  assign hmastlock = '0;
  assign hprot = '0;
  assign cmd_if.master.done = done;

  //penable to be low during setup phase only
  always @(posedge clk or negedge rst) begin
    if (!rst) penable  <= '1;
    else penable  <= penable_nxt;
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      haddr_reg   <= '0;
      hwdata_reg  <= '0;
      hwrite_reg  <= '0;
      hsize_reg   <= '0;
      hburst_reg  <= '0;
      htrans_reg  <= '0;
    end
    else if (ahb_if.master.hready) begin //pready dependent driven output
      pr_state    <= nx_state;
      haddr_reg   <= haddr_nxt;
      hwdata_reg  <= hwdata_nxt;
      hwrite_reg  <= hwrite_nxt;
      hsize_reg   <= hsize_nxt;
      hburst_reg  <= hburst_nxt;
      htrans_reg  <= htrans_nxt;
    end
  end
  
  always_comb begin
      nx_state    = pr_state; //default case values
      haddr_nxt   = haddr_reg;
      hwdata_nxt  = hwdata_reg;
      hwrite_nxt  = hwrite_reg;
      hsize_nxt   = hsize_reg;
      hburst_nxt  = hburst_reg;
      htrans_nxt  = htrans_reg;
      done        = '0;
          
    case (pr_state) 
      IDLE : begin
               if (event_a_i || event_b_i || event_c_i) begin
                 nx_state = SETUP;
               end  
             end

endmodule
