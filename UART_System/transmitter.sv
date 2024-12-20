// UART transmitter implementation 
// Source : https://www.youtube.com/watch?v=hQrg5jIcIXE&list=PL-iIOnHwN7NUpkOWAQ9Fc7MMddai9vHvN&index=75
// Here only 3 data bits are transferred, along with start,stop and parity bit
// tick signal is coming from baud rate generator and is different from clk

`timescale 1ns/1ps
module transmitter (tx,tx_done,din,tick,tx_start,clk,rst);
  
  output logic tx,tx_done; 
  input logic tick,tx_start,clk,rst;
  input logic [2:0] din;

  logic [3:0] tick_cnt,tick_cnt_nxt; //counter to calculate number of ticks
  logic [1:0] dbits_cnt,dbits_cnt_nxt; //counter to calculate number of data bits transmitted
  logic [2:0] data_in, data_nxt; // flop for storing data to be serially transferred on tx
  logic tx_reg,tx_nxt; // tx pin driver flop
  logic parity_reg,parity_nxt; //parity flop

  parameter DBITS = 3;
  typedef enum logic [2:0] {idle = 3'd0,start = 3'd1,data = 3'd2,parity = 3'd3,stop = 3'd4} state;
  state pr_state,nx_state;

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      dbits_cnt <= '0;
      data_in   <= '0;
      tx_reg    <= '1;
      tick_cnt  <= '0;
      parity_reg<= '0;
    end
    else begin
      dbits_cnt <= dbits_cnt_nxt;
      data_in   <= data_nxt;
      tx_reg    <= tx_nxt;
      tick_cnt  <= tick_cnt_nxt;
      parity_reg<= parity_nxt;
    end
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) pr_state <= idle;
    else pr_state <= nx_state;
  end   
  
  always @(*) begin
      nx_state      = pr_state; //default values
      dbits_cnt_nxt = dbits_cnt;
      data_nxt      = data_in;
      tx_nxt        = tx_reg;
      tick_cnt_nxt  = tick_cnt;
      tx_done       = '0;
      parity_nxt    = parity_reg;
    
    case (pr_state) 
      idle    : begin // if tx_start send the start bit 0 in next cycle, store din and its parity
                  if (tx_start == '1) begin
                    nx_state   = start;
                    data_nxt   = din;
                    parity_nxt = ^din;
                  end
                end
        
      start   : begin // keep tx line low for 16 ticks, why 16? pls check source video
                  tx_nxt = '0;
                  if (tick=='1) begin
                    if (tick_cnt ==  4'd15) begin
                      nx_state = data;
                      tick_cnt_nxt = '0;
                    end
                    else tick_cnt_nxt = tick_cnt + 4'd1;
                  end
                end
        
      data    : begin // transfer data bits each will be available at tx for 16 ticks
                  tx_nxt = data_in[0];
                  if (tick=='1) begin
                    if (tick_cnt ==  4'd15) begin
                      tick_cnt_nxt = '0;
                      data_nxt     = data_in >> 1;
                      if (dbits_cnt == DBITS - 1) nx_state = parity;
                      else dbits_cnt_nxt = dbits_cnt + 2'd1;
                    end
                    else tick_cnt_nxt = tick_cnt + 4'd1;
                  end
                end
        
      parity  : begin // transfer stored parity bit on tx for 16 ticks
                  tx_nxt = parity_reg;
                  if (tick=='1) begin
                    if (tick_cnt ==  4'd15) begin
                      nx_state = stop;
                      tick_cnt_nxt = '0;
                    end
                    else tick_cnt_nxt = tick_cnt + 4'd1;
                  end
                 end
      
      stop    : begin // transfer stop bit '1 on tx for 16 ticks, at end generate tx_done for one cycle
                  tx_nxt = '1;
                  if (tick=='1) begin
                    if (tick_cnt ==  4'd15) begin
                      nx_state = idle;
                      tick_cnt_nxt = '0;
                      tx_done = '1;
                    end
                    else tick_cnt_nxt = tick_cnt + 4'd1;
                  end
                end
    endcase
  end
  
  assign tx = tx_reg;
  
endmodule
 
