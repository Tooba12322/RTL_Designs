// UART transmitter implementation 
// Source : https://www.youtube.com/watch?v=hQrg5jIcIXE&list=PL-iIOnHwN7NUpkOWAQ9Fc7MMddai9vHvN&index=75

module transmitter (tx,tx_done,din,tick,tx_start,clk,rst);
  
  output logic tx,tx_done; 
  input logic tick,tx_start,clk,rst;
  input logic [1:0] din;

  logic [3:0] tick_cnt,tick_cnt_nxt; //counter to calculate number of ticks
  logic [1:0] dbits_cnt,dbits_cnt_nxt; //counter to calculate number of data bits transmitted
  logic [1:0] data_in, data_nxt;
  logic tx_reg,tx_nxt;
  logic parity_reg,parity_nxt;

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
    if (!rst) pr_state <= Idle;
    else pr_state <= nx_state;
  end   
  
  always_comb begin
      nx_state      = pr_state;
      dbits_cnt_nxt = dbits_cnt;
      data_nxt      = data_in;
      tx_nxt        = tx_reg;
      tick_cnt_nxt  = tick_cnt;
      tx_done       = '0;
      parity_nxt    = parity_reg;
    
    case (pr_state) 
      idle    : begin
                  if (tx_start == '1) begin
                    nx_state   = start;
                    data_nxt   = din;
                    parity_nxt = !(^din);
                  end
                end
        
      start   : begin
                  tx_nxt = '0;
                  if (tick=='1) begin
                    if (tick_cnt ==  4'd15) begin
                      nx_state = data;
                      tick_cnt_nxt = '0;
                    end
                    else tick_cnt_nxt = tick_cnt + 4'd1;
                  end
                end
        
      data    : begin
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
        
      parity  : begin
                  tx_nxt = parity_reg;
                  if (tick=='1) begin
                    if (tick_cnt ==  4'd15) begin
                      nx_state = stop;
                      tick_cnt_nxt = '0;
                    end
                    else tick_cnt_nxt = tick_cnt + 4'd1;
                  end
                 end
      
      stop    : begin
                  tx_nxt = '1;
                  if (tick_cnt ==  4'd15) begin
                    if (tick=='1) begin
                      nx_state = data;
                      tick_cnt_nxt = '0;
                      tx_done = '1;
                    end
                  end
                  else tick_cnt_nxt = tick_cnt + 4'd1;
                end
    endcase
  end
  
  assign tx = tx_reg;
  
endmodule
 
