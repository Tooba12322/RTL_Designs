// UART transmitter implementation 
// Source : https://www.youtube.com/watch?v=hQrg5jIcIXE&list=PL-iIOnHwN7NUpkOWAQ9Fc7MMddai9vHvN&index=75

module transmitter (tx,tx_done,din,tick,tx_start,clk,rst);
  
  output logic tx,tx_done; 
  input logic tick,tx_start,clk,rst;
  input logic [1:0] din;

  logic [3:0] tick_cnt,tick_cnt_nxt; //counter to calculate number of ticks
  logic [1:0] dbits_cnt,dbits_cnt_nxt; //counter to calculate number of data bits transmitted
  logic [1:0] data, data_nxt;
  logic tx_reg,tx_nxt;
   
  typedef enum logic [2:0] {Idle = 3'd0,start = 3'd1,data = 3'd2,parity = 3'd3,stop = 3'd4} state;
  state pr_state,nx_state;

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      dbits_cnt <= '0;
      data      <= '0;
      tx_reg    <= '1;
      tick_cnt  <= '0;
    end
    else begin
      dbits_cnt <= dbits_cnt_nxt;
      data      <= data_nxt;
      tx_reg    <= tx_nxt;
      tick_cnt  <= tick_cnt_nxt;
    end
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) pr_state <= Idle;
    else pr_state <= nx_state;
  end   
  
  always_comb begin
      nx_state      = pr_state;
      dbits_cnt_nxt = dbits_cnt;
      data_nxt      = data;
      tx_nxt        = tx_reg;
      tick_cnt_nxt  = tick_cnt;
      tx_done       = '0;
    
    case (pr_state) 
      Zero    : begin
                  if (sw == '1) nx_state = wait1_1;
                end
      wait1_1 : begin
                  if (sw == '1 && tick=='1) nx_state = wait1_2 ;
                end
      wait1_2 : begin
                  if (sw == '1 && tick=='1) nx_state = wait1_3 ;
                end
      wait1_3  : begin
                  if (sw == '1 && tick=='1) nx_state = One ;
                 end
      One    : begin
                  if (sw == '0 && tick=='1) nx_state = wait0_1;
                end
      wait0_1 : begin
                  if (sw == '0 && tick=='1) nx_state = wait0_2 ;
                end
      wait0_2 : begin
                  if (sw == '0 && tick=='1) nx_state = wait0_3 ;
                end
      wait0_3  : begin
                  if (sw == '0 && tick=='1) nx_state = Zero ;
                 end
      endcase
  end
  
  assign tx = tx_reg;
  
endmodule
 
