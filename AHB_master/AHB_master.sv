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
  logic done,req_ack;
  
  modport master (input done,req_ack, output req,byte_cnt,start_addr,wr);
  modport slave (input req,byte_cnt,start_addr,wr, output done,req_ack);
  
endinterface

module ahb_m();

endmodule
