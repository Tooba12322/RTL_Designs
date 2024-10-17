// Command interface design, using it inside a module as master and slave interface


`timescale 1ns/1ps

interface cmd_if #(parameter ADDRW = 32, BYTE_CNTw = 16) (input logic clk, logic rst);
  
  logic req,wr;
  logic [BYTE_CNTw-1:0] byte_cnt;
  logic [ADDRW-1:0] start_addr;
  logic done,req_ack;
  
  modport master (input clk,rst,done,req_ack, output req,byte_cnt,start_addr,wr);
  modport slave (input req,byte_cnt,start_addr,wr,clk,rst, output done,req_ack);
  
endinterface


module use_if #(parameter ADDRW = 32, BYTE_CNTw = 16) 
    (cmd_if.master #(ADDRW , BYTE_CNTw) out ,
     cmd_if.slave #(ADDRW , BYTE_CNTw) in);
    
  logic [16:0] byte_out,byte_out_nxt;
  logic [16:0] byte_reg,byte_nxt;
  
  always @(posedge in.clk or negedge in.rst) begin
    if (!in.rst) byte_reg     <= '0;
    else if (in.req) byte_reg <= in.byte_cnt;
    else byte_reg             <= byte_nxt;
  end
  
  always @(posedge in.clk or negedge in.rst) begin
    if (!in.rst)            byte_out <= '0;
    else if (byte_reg>=512) byte_out <= 16'd512;
    else if (byte_reg>=256) byte_out <= 16'd256;
    else if (byte_reg>=128) byte_out <= 16'd128;
    else if (byte_reg>=64)  byte_out <= 16'd64;
    else if (byte_reg>=32)  byte_out <= 16'd32;
    else                    byte_out <= byte_reg;
  end
  
  always @(byte_out,byte_reg) begin
    if      (byte_out[9] && byte_reg>=512) byte_nxt = byte_reg - 16'd512;
    else if (byte_out[8] && byte_reg>=256) byte_nxt = byte_reg - 16'd256;
    else if (byte_out[7] && byte_reg>=128) byte_nxt = byte_reg - 16'd128;
    else if (byte_out[6] && byte_reg>=64)  byte_nxt = byte_reg - 16'd64;
    else if (byte_out[5] && byte_reg>=32)  byte_nxt = byte_reg - 16'd32;
    else byte_nxt = '0;  
  end
  
  assign out.byte_cnt   = byte_out;
  assign out.req        = (byte_reg!='0) ? '1 : '0;
  assign out.wr         = in.wr;
  assign out.start_addr = in.start_addr;
  assign in.reqack      = out.reqack;
  assign in.done        = (out.req && byte_reg=='0);
  
endmodule
 
