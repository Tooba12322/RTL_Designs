// UART receiver implementation 
// Source : https://www.youtube.com/watch?v=8M6rEm1EG4w&list=PL-iIOnHwN7NUpkOWAQ9Fc7MMddai9vHvN&index=73
`timescale 1ns/1ps

module receiver (parity_o,dout,rx_done,rx,tick,clk,rst);
  
  output logic rx_done,parity_o; // received all bits , assert parity as separate output
  output logic [2:0] dout;
  input logic rx,tick,clk,rst;

  logic [3:0] tick_cnt,tick_cnt_nxt; //counter to calculate number of ticks
  logic [1:0] dbits_cnt,dbits_cnt_nxt; //counter to calculate number of data bits received
  logic [2:0] data_out, data_out_nxt;
  logic parity_reg, parity_nxt;
  
  parameter DBITS = 3;
  typedef enum logic [2:0] {idle = 3'd0,start = 3'd1,data = 3'd2,parity = 3'd3,stop = 3'd4} state;
  state pr_state,nx_state;

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      dbits_cnt  <= '0;
      data_out   <= '0;
      tick_cnt   <= '0;
      parity_reg <= '0;
    end
    else begin
      dbits_cnt  <= dbits_cnt_nxt;
      data_out   <= data_out_nxt;
      tick_cnt   <= tick_cnt_nxt;
      parity_reg <= parity_nxt;
    end
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) pr_state <= idle;
    else pr_state <= nx_state;
  end   
  
  always @(*) begin
      nx_state      = pr_state;
      dbits_cnt_nxt = dbits_cnt;
      data_out_nxt  = data_out;
      tick_cnt_nxt  = tick_cnt;
      rx_done       = '0;
      parity_nxt    = parity_reg;
    
    case (pr_state) 
      idle    : begin // when rx input pin is low, means its an start bit
                  if (rx == '0) nx_state   = start;   
                end
        
      start   : begin // wait till mid of start bit, tick_cnt=7, why? pls refer to source video
                  if (tick=='1) begin
                    if (tick_cnt ==  4'd7) begin
                      nx_state = data;
                      tick_cnt_nxt = '0;
                    end
                    else tick_cnt_nxt = tick_cnt + 4'd1;
                  end
                end
        
      data    : begin // wait till mid of each data bit, tick_cnt=16, why? pls refer to source video, append each received bit to data_out reg
                  if (tick=='1) begin
                    if (tick_cnt ==  4'd15) begin
                      tick_cnt_nxt = '0;
                      data_out_nxt = {rx,data_out[2:1]};
                      if (dbits_cnt == DBITS - 1) nx_state = parity;
                      else dbits_cnt_nxt = dbits_cnt + 2'd1;
                    end
                    else tick_cnt_nxt = tick_cnt + 4'd1;
                  end
                end
        
      parity  : begin // // wait till mid of parity bit, tick_cnt=16, why? pls refer to source video, store parity bit
                  if (tick=='1) begin
                    if (tick_cnt ==  4'd15) begin
                      nx_state = stop;
                      tick_cnt_nxt = '0;
                      parity_nxt = rx;
                    end
                    else tick_cnt_nxt = tick_cnt + 4'd1;
                  end
                 end
      
      stop    : begin // wait till mid of stop bit, tick_cnt=16, why? pls refer to source video, drive done
                  if (tick=='1) begin
                    if (tick_cnt ==  4'd15) begin
                      nx_state = idle;
                      tick_cnt_nxt = '0;
                      rx_done = '1;
                    end
                    else tick_cnt_nxt = tick_cnt + 4'd1;
                  end
                end
    endcase
  end
  
  assign parity_o = parity_reg;
  assign dout     = data_out;
  
endmodule
 
