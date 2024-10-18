
`timescale 1ns/1ps

interface cmd_if #(parameter ADDRW = 32, parameter BYTE_CNTw = 16);
  
  logic req,wr;
  logic [BYTE_CNTw-1:0] byte_cnt;
  logic [ADDRW-1:0] start_addr;
  logic done,req_ack;
  
  modport master (input done,req_ack, output req,byte_cnt,start_addr,wr);
  modport slave (input req,byte_cnt,start_addr,wr, output done,req_ack);
  
endinterface


module use_if (clk, rst);
  parameter ADDRW = 32;
  parameter BYTE_CNTw = 16;
  
  input clk,rst;
  cmd_if out(.*); 
  cmd_if in(.*); 
  
  logic [BYTE_CNTw-1:0] byte_out;
  logic [BYTE_CNTw-1:0] byte_reg,byte_nxt;
  logic [ADDRW-1:0] addr_reg,addr_nxt;
  
  
  always @(posedge clk or negedge rst) begin
    if (!rst) byte_reg     <= '0;
    else if (in.req) byte_reg <= in.byte_cnt;
    else byte_reg             <= byte_nxt;
  end
  
   always @(posedge clk or negedge rst) begin
     if (!rst) addr_reg     <= '0;
     else if (in.req) addr_reg <= in.start_addr;
     else if (out.req) addr_reg <= addr_nxt;
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst)            byte_out <= '0;
    else if (byte_reg>=512) byte_out <= 16'd512;
    else if (byte_reg>=256) byte_out <= 16'd256;
    else if (byte_reg>=128) byte_out <= 16'd128;
    else if (byte_reg>=64)  byte_out <= 16'd64;
    else if (byte_reg>=32)  byte_out <= 16'd32;
    else                    byte_out <= byte_reg;
  end
  
  always @(byte_reg) begin
    if      (byte_reg>=512) byte_nxt = byte_reg - 16'd512;
    else if (byte_reg>=256) byte_nxt = byte_reg - 16'd256;
    else if (byte_reg>=128) byte_nxt = byte_reg - 16'd128;
    else if (byte_reg>=64)  byte_nxt = byte_reg - 16'd64;
    else if (byte_reg>=32)  byte_nxt = byte_reg - 16'd32;
    else byte_nxt = '0;  
  end
  
  assign addr_nxt       = (out.req) ? addr_reg + byte_out : '0;
  assign out.byte_cnt   = byte_out;
  assign out.req        = (byte_out!='0) ? '1 : '0;
  assign out.wr         = in.wr;
  assign out.start_addr = addr_reg;
  assign in.req_ack     = out.req_ack;
  assign in.done        = (out.req && byte_reg=='0);
  
endmodule
 
