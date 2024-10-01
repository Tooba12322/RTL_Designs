// Design a UART system with both transmission and reception functionality , to transmit/recieve data from/to fast running CPU 
// UART protocol implementation 
// Source : https://www.youtube.com/watch?v=Sz6_yH6XGWA&list=PL-iIOnHwN7NUpkOWAQ9Fc7MMddai9vHvN&index=69
`timescale 1ns/1ps

module UART_top (parity_o,dout,rx_done,tx_done,din,tx_start,br_div,clk,rst);
 
  output logic rx_done,tx_done; 
  output logic parity_o; // received all bits , assert parity as separate output
  output logic [2:0] dout;
  input logic rx,tx_start,clk,rst;
  input logic [2:0] din;
  
  logic [3:0] tick_cnt,tick_cnt_nxt; //counter to calculate number of ticks
  logic [1:0] dbits_cnt,dbits_cnt_nxt; //counter to calculate number of data bits received
  logic [2:0] data_out, data_out_nxt;
  logic parity_reg, parity_nxt;
  
  logic tick_i,tx_i;
  parameter DBITS = 3;
  
  BR_gen br_gen (.tick(tick_i),.rst(rst),.clk(clk),.br_div(br_div));
  transmitter TX(.tx(tx_i),.tx_done(tx_done),.din(din),.tick(tick_i),.tx_start(tx_start),.rst(rst),.clk(clk));
  receiver RX(.parity_o(parity_o),.dout(dout),.rx_done(rx_done),rx(tx_i),.tick(tick_i),.rst(rst),.clk(clk));
  
endmodule
 
