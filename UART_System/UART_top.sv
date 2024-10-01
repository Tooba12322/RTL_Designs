// Design a UART system with both transmission and reception functionality ,  to transmit/recieve data serially from/to CPU 
// UART protocol implementation 
// Source : https://www.youtube.com/watch?v=Sz6_yH6XGWA&list=PL-iIOnHwN7NUpkOWAQ9Fc7MMddai9vHvN&index=69
`timescale 1ns/1ps

module UART_top (parity_o,dout,rx_done,tx_done,din,tx_start,br_div,clk,rst);
 
  output logic rx_done,tx_done; 
  output logic parity_o; 
  output logic [2:0] dout;
  input logic tx_start,clk,rst;
  input logic [2:0] din;
  input logic [10:0] br_div;
  
  logic tick_i,tx_i;
  parameter DBITS = 3;
  
  BR_gen br_gen (.tick(tick_i),.rst(rst),.clk(clk),.br_div(br_div));
  transmitter TX(.tx(tx_i),.tx_done(tx_done),.din(din),.tick(tick_i),.tx_start(tx_start),.rst(rst),.clk(clk));
  receiver RX(.parity_o(parity_o),.dout(dout),.rx_done(rx_done),rx(tx_i),.tick(tick_i),.rst(rst),.clk(clk));
  
endmodule

/* top module for EDA playground
// Design a UART system with both transmission and reception functionality ,  to transmit/recieve data serially from/to CPU 
// UART protocol implementation 
// Source : https://www.youtube.com/watch?v=Sz6_yH6XGWA&list=PL-iIOnHwN7NUpkOWAQ9Fc7MMddai9vHvN&index=69
`timescale 1ns/1ps

module BR_gen(tick,br_div,clk,rst);
  
  output logic tick;
  input logic [10:0] br_div;
  input logic clk,rst;
  
  logic [10:0] br_cnt;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) br_cnt <= '0;
    else if (br_cnt == br_div) br_cnt <= '0;
    else br_cnt <= br_cnt + 11'd1;
  end
    
  assign tick = (br_cnt==11'd1) ? '1 : '0; 
  
endmodule 

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
                    end
                    else tick_cnt_nxt = tick_cnt + 4'd1;
                    if (tick_cnt ==  4'd7) tx_done = '1;
                  end
                end
    endcase
  end
  
  assign tx = tx_reg;
  
endmodule

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
  
  assign parity_o = (rx_done) ?  parity_reg : '0;
  assign dout     = (rx_done) ?  data_out : '0;
  
endmodule


module UART_top (parity_o,dout,rx_done,tx_done,din,tx_start,br_div,clk,rst);
 
  output logic rx_done,tx_done; 
  output logic parity_o; 
  output logic [2:0] dout;
  input logic tx_start,clk,rst;
  input logic [2:0] din;
  input logic [10:0] br_div;
  
  logic tick_i,tx_i;
  parameter DBITS = 3;
  
  BR_gen br_gen (.tick(tick_i),.rst(rst),.clk(clk),.br_div(br_div));
  transmitter TX(.tx(tx_i),.tx_done(tx_done),.din(din),.tick(tick_i),.tx_start(tx_start),.rst(rst),.clk(clk));
  receiver RX(.parity_o(parity_o),.dout(dout),.rx_done(rx_done),.rx(tx_i),.tick(tick_i),.rst(rst),.clk(clk));
  
endmodule
 */
 
