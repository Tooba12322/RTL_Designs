`timescale 1ns/1ps

interface cmd_if #(parameter ADDRW = 32, parameter BYTE_CNTw = 16, parameter DATAW = 256);
  
  logic req,wr;
  logic [BYTE_CNTw-1:0] byte_cnt;
  logic [ADDRW-1:0] start_addr;
  logic [DATAW-1:0] wdata;
  logic cmd_done,wr_done,req_ack;
  
  modport master (input cmd_done,wr_done,req_ack, output req,byte_cnt,start_addr,wr,wdata);
  modport slave (input req,byte_cnt,start_addr,wr,wdata, output cmd_done,req_ack,wr_done);
  
endinterface

interface ahb_if #(parameter ADDRW = 32, parameter DATAW = 256);
  
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
  parameter DATAW = 256;
  parameter BYTE_CNTw = 16;
  parameter DATA_BYTES = DATAW/8;
  
  input logic clk,rst;
  cmd_if in(.*); 
  ahb_if out(.*);
  
  logic hwrite_reg, hwrite_nxt;
  logic [DATAW-1:0] hwdata_reg, hrdata_reg, hwdata_nxt, hrdata_nxt;
  logic [ADDRW-1:0] haddr_reg, haddr_nxt;
  logic [2:0] hsize_reg, hburst_reg, hsize_nxt, hburst_nxt;
  logic [1:0] htrans_reg, htrans_nxt;
  logic [3:0] hprot;
  logic [3:0] seq_cnt, seq_cnt_nxt, total_seq_cnt, total_seq_cnt_nxt;
  logic hmastlock;
  logic hready, hresp;
  logic done,wr_done, req_ack;
  logic [BYTE_CNTw-1:0] byte_cnt, byte_cnt_nxt;
  logic [DATAW-1:0] wdata_reg, wdata_nxt;
  
  //state enum  
  typedef enum logic [1:0] {IDLE, START, FX_INCR, UN_INCR} state;
  state pr_state,nx_state;
  
  
  //Driving master output from flops
  always_comb out.haddr   = haddr_reg;
  always_comb out.hwdata  = wdata_reg;
  always_comb out.hwrite  = hwrite_reg;
  always_comb out.hsize   = hsize_reg;
  always_comb out.hburst  = hburst_reg;
  always_comb out.htrans  = htrans_reg;
  always_comb out.hmastlock= hmastlock;
  always_comb out.hprot   = hprot;
    
  
  assign in.cmd_done = done;
  assign in.req_ack = req_ack;
  assign in.wr_done = wr_done;
  
  assign hmastlock = '0;
  assign hprot = '0;
  assign wdata_nxt = (out.hwrite && out.htrans!='0) ? in.wdata : wdata_reg;
  assign hrdata_nxt = (out.htrans!='0 && out.hready && out.hresp) ? out.hrdata : hrdata_reg;
  
  always_ff @(posedge clk or negedge rst) begin
    if (!rst) wr_done <= '0;
    else if (out.hwrite && out.htrans!='0 && out.hready) wr_done <= '1;
    else wr_done <= '0;
  end
  
  always_ff @(posedge clk or negedge rst) begin
    if (!rst) done <= '0;
    else if (pr_state==FX_INCR && seq_cnt== total_seq_cnt-1 && out.hready && byte_cnt<=DATA_BYTES) done <= '1;
    else if (pr_state==UN_INCR && out.hready && byte_cnt<=DATA_BYTES && byte_cnt!='0) done <= '1;
    else if (out.hready && in.byte_cnt<=DATA_BYTES) done <= '1;
    else done <= '0;
  end
  
  always_ff @(posedge clk or negedge rst) begin
    if (!rst) hrdata_reg <= '0;
    else hrdata_reg <= hrdata_nxt;
  end
  
  always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
      haddr_reg   <= '0;
      wdata_reg   <= '0;
      hwdata_reg  <= '0;
      hwrite_reg  <= '0;
      hsize_reg   <= '0;
      hburst_reg  <= '0;
      htrans_reg  <= '0;
      seq_cnt     <= '0;
      byte_cnt    <= '0;
      total_seq_cnt<= '0;
      pr_state    <= IDLE;
    end
    else if (out.hready) begin //hready dependent flops
      pr_state    <= nx_state;
      haddr_reg   <= haddr_nxt;
      hwdata_reg  <= wdata_reg;
      hwrite_reg  <= hwrite_nxt;
      hsize_reg   <= hsize_nxt;
      hburst_reg  <= hburst_nxt;
      htrans_reg  <= htrans_nxt;
      seq_cnt     <= seq_cnt_nxt;
      byte_cnt    <= byte_cnt_nxt;
      total_seq_cnt<= total_seq_cnt_nxt;
      wdata_reg   <= wdata_nxt;
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
      byte_cnt_nxt= byte_cnt;
      seq_cnt_nxt = seq_cnt;
      total_seq_cnt_nxt = total_seq_cnt;
      req_ack     = '1; 
          
    case (pr_state) 
      IDLE : begin
              if (in.req) begin
                 nx_state     = START;
                 req_ack     = '0;
               end  
             end
      
      START : begin
                req_ack     = '0;
                haddr_nxt    = in.start_addr;
                hwrite_nxt   = in.wr;
                hwdata_nxt   = in.wdata;
                hsize_nxt    = 3'd2;
                htrans_nxt   = 2'd2;
                seq_cnt_nxt  = '0;
        
                if (in.byte_cnt%DATA_BYTES == '0 && in.byte_cnt!=512 && in.byte_cnt!=256 && in.byte_cnt!=128) begin
                  nx_state     = UN_INCR;
                  hburst_nxt   = 3'd1;
                  byte_cnt_nxt = in.byte_cnt - 16'd32;
                end
                else if  (in.byte_cnt>=512) begin
                  nx_state          = FX_INCR;
                  byte_cnt_nxt      = in.byte_cnt - 16'd512;
                  total_seq_cnt_nxt = 4'd15;
                  hburst_nxt        = 3'd7; 
                end
                else if  (in.byte_cnt>=256) begin
                  nx_state = FX_INCR;
                  byte_cnt_nxt = in.byte_cnt - 16'd256;
                  total_seq_cnt_nxt = 4'd7;
                  hburst_nxt   = 3'd5; 
                end
                else if  (in.byte_cnt>=128) begin
                  nx_state = FX_INCR;
                  byte_cnt_nxt = in.byte_cnt - 16'd128;
                  total_seq_cnt_nxt = 4'd3;
                  hburst_nxt   = 3'd3; 
                end
                else begin
                  nx_state = UN_INCR;
                  hburst_nxt   = 3'd1;
                  byte_cnt_nxt = (in.byte_cnt < DATA_BYTES) ? '0 : in.byte_cnt - 16'd32;
                end
              end
      
     FX_INCR : begin
                 if (seq_cnt == total_seq_cnt) begin
                   if (byte_cnt != 16'd0) begin
                     hsize_nxt    = 3'd2;
                     htrans_nxt   = 2'd2;
                     seq_cnt_nxt  = '0;
                     req_ack      = '0;
        
                     if  (byte_cnt%DATA_BYTES == '0 && byte_cnt!=512 && byte_cnt!=256 && byte_cnt!=128) begin
                       nx_state = UN_INCR;
                       hburst_nxt   = 3'd1;
                       byte_cnt_nxt = byte_cnt - 16'd32;
                     end
                     else if  (byte_cnt>=512) begin
                       nx_state     = FX_INCR;
                       byte_cnt_nxt = byte_cnt - 16'd512;
                       total_seq_cnt_nxt = 4'd15;
                       hburst_nxt   = 3'd7; 
                     end
                     else if  (byte_cnt>=256) begin
                       nx_state = FX_INCR;
                       byte_cnt_nxt = byte_cnt - 16'd256;
                       total_seq_cnt_nxt = 4'd7;
                       hburst_nxt   = 3'd5; 
                     end
                     else if  (byte_cnt>=128) begin
                       nx_state = FX_INCR;
                       byte_cnt_nxt = byte_cnt - 16'd128;
                       total_seq_cnt_nxt = 4'd3;
                       hburst_nxt   = 3'd3; 
                     end
                     else begin
                       nx_state = UN_INCR;
                       hburst_nxt   = 3'd1; 
                       byte_cnt_nxt = (byte_cnt < DATA_BYTES) ? '0 : byte_cnt - 16'd32;
                     end
                   end
                   
                   else if (in.req) begin
                     done         = '1;
                     req_ack      = '0;
                     haddr_nxt    = in.start_addr;
                     hwrite_nxt   = in.wr;
                     hwdata_nxt   = in.wdata;
                     hsize_nxt    = 3'd2;
                     htrans_nxt   = 2'd2;
                     seq_cnt_nxt  = '0;
        
                     if  (in.byte_cnt%DATA_BYTES == '0 && in.byte_cnt!=512 && in.byte_cnt!=256 && in.byte_cnt!=128) begin
                       nx_state = UN_INCR;
                       hburst_nxt   = 3'd1;
                       byte_cnt_nxt = in.byte_cnt - 16'd32;
                     end
                     else if  (in.byte_cnt>=512) begin
                       nx_state     = FX_INCR;
                       byte_cnt_nxt = in.byte_cnt - 16'd512;
                       total_seq_cnt_nxt = 4'd15;
                       hburst_nxt   = 3'd7; 
                     end
                     else if  (in.byte_cnt>=256) begin
                       nx_state = FX_INCR;
                       byte_cnt_nxt = in.byte_cnt - 16'd256;
                       total_seq_cnt_nxt = 4'd7;
                       hburst_nxt   = 3'd5; 
                     end
                     else if  (in.byte_cnt>=128) begin
                       nx_state = FX_INCR;
                       byte_cnt_nxt = in.byte_cnt - 16'd128;
                       total_seq_cnt_nxt = 4'd3;
                       hburst_nxt   = 3'd3; 
                     end
                     else begin
                       nx_state = UN_INCR;
                       hburst_nxt   = 3'd1;
                       byte_cnt_nxt = (in.byte_cnt < DATA_BYTES) ? '0 : in.byte_cnt - 16'd32;
                       req_ack       = (byte_cnt<=DATA_BYTES) ? '1 : '0;
                     end  
                   end
                   else begin 
                     
                     nx_state = IDLE;
                     htrans_nxt = '0;
                     seq_cnt_nxt = '0;
                   end
                 end
        
                 else begin
                   htrans_nxt   = 2'd3;
                   seq_cnt_nxt  = seq_cnt + 4'd1;
                   haddr_nxt    = haddr_reg + 32'd32; // consider byte addresible slave 
                   req_ack      = (seq_cnt==total_seq_cnt - 4'd1 && byte_cnt <= DATA_BYTES && out.hready) ? '1 : '0;
                 end   
               end
      
       UN_INCR : begin
                   if (byte_cnt == '0) begin
                     if (in.req) begin
                       
                       req_ack      = '0;
                       haddr_nxt    = in.start_addr;
                       hwrite_nxt   = in.wr;
                       hwdata_nxt   = in.wdata;
                       hsize_nxt    = 3'd2;
                       htrans_nxt   = 2'd2;
                       seq_cnt_nxt  = '0;
        
                       if  (in.byte_cnt%DATA_BYTES == '0 && in.byte_cnt!=512 && in.byte_cnt!=256 && in.byte_cnt!=128) begin
                         nx_state = UN_INCR;
                         hburst_nxt   = 3'd1;
                         byte_cnt_nxt = in.byte_cnt - 16'd32;
                       end
                       else if  (in.byte_cnt>=512) begin
                         nx_state     = FX_INCR;
                         byte_cnt_nxt = in.byte_cnt - 16'd512;
                         total_seq_cnt_nxt = 4'd15;
                         hburst_nxt   = 3'd7; 
                       end
                       else if  (in.byte_cnt>=256) begin
                         nx_state = FX_INCR;
                         byte_cnt_nxt = in.byte_cnt - 16'd256;
                         total_seq_cnt_nxt = 4'd7;
                         hburst_nxt   = 3'd5; 
                       end
                       else if  (in.byte_cnt>=128) begin
                         nx_state = FX_INCR;
                         byte_cnt_nxt = in.byte_cnt - 16'd128;
                         total_seq_cnt_nxt = 4'd3;
                         hburst_nxt   = 3'd3; 
                       end
                       else begin
                         nx_state = UN_INCR;
                         hburst_nxt   = 3'd1;
                         byte_cnt_nxt = (in.byte_cnt < DATA_BYTES) ? '0 : in.byte_cnt - 16'd32;
                         req_ack       = (byte_cnt<=DATA_BYTES) ? '1 : '0;
                       end  
                     end
                     else begin 
                      
                       nx_state = IDLE;
                       htrans_nxt = '0;
                       seq_cnt_nxt = '0;
                     end
                 end                   
                  
                 else begin
                     htrans_nxt    = (byte_cnt < DATA_BYTES) ? 2'd2 : 2'd3;
                     byte_cnt_nxt  = (byte_cnt < DATA_BYTES) ? '0 : byte_cnt - 16'd32;
                     haddr_nxt     = haddr_reg + 32'd32;
                     req_ack       = (byte_cnt<=DATA_BYTES) ? '1 : '0;
                 end
                   
               end
               
        endcase
      end

endmodule
