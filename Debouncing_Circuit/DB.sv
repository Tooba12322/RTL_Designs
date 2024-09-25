// Debouncing circuit implementation usin delayed detection with delay equals to 2-3msec

module DB (sw,db,clk,rst);
  
  output logic db;  //2-3msec delayed output
  input logic sw,clk,rst;

  logic [5:0] cnt; //counter to generate delay and timer tick
  logic tick;// tick high every 1msec, for 100MHz clk, means after every 100 clk edges
   
  typedef enum logic [2:0] {Zero = 3'd0,wait1_1 = 3'd1,wait1_2 = 3'd2,wait1_3 = 3'd3,
                            One = 3'd4, wait0_1 = 3'd5,wait0_2 = 3'd6,wait0_3 = 3'd7} state;
  state pr_state,nx_state;

  always @(posedge clk or negedge rst) begin
    if (!rst) cnt <= '0;
    else if (cnt == 6'd99) cnt <= '0;
    else cnt <= cnt + 6'd1;
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) pr_state <= Zero;
    else pr_state <= nx_state;
  end   
  
  always_comb begin
      nx_state = pr_state;
      
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
  assign tick = (cnt==6'd99) ? '1 : '0;
  assign db = (pr_state==One || pr_state==wait0_1 || pr_state==wait0_2 || pr_state==wait0_3);
endmodule
 
