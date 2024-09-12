
// APB Master

// TB should drive a cmd_i input decoded as:
//  - 2'b00 - No-op
//  - 2'b01 - Read from address 0xDEAD_CAFE
//  - 2'b10 - Increment the previously read data and store it to 0xDEAD_CAFE
//  - 2'b11 - Invalid 

module apb_2 (
  input       logic        clk,
  input       logic        rst,

  input       logic[1:0]   cmd_i,

  output      logic        psel_o,
  output      logic        penable_o,
  output      logic[31:0]  paddr_o,
  output      logic        pwrite_o,
  output      logic[31:0]  pwdata_o,
  input       logic        pready_i,
  input       logic[31:0]  prdata_i
);
  
  
  logic[1:0]   cmd;
  logic        psel, psel_nxt;
  logic        penable, penable_nxt;
  logic[31:0]  paddr, paddr_nxt;
  logic        pwrite, pwrite_nxt;
  logic[31:0]  pwdata, pwdata_nxt;
  logic[31:0]  prdata;
  
  
  typedef enum logic [1:0] {IDLE = 2'b00, 
    SETUP = 2'b01,
    ACCESS = 2'b10} state;
    state pr_state,nx_state;
  
  always_comb psel_o    = psel;
  always_comb penable_o = penable;
  always_comb paddr_o   = paddr;
  always_comb pwrite_o  = pwrite;
  always_comb pwdata_o  = pwdata;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) cmd <= '0;
    else      cmd <= cmd_i;
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      psel     <= '0;
      penable  <= '1;
      paddr    <= '0;
      pwrite   <= '0;
      pwdata   <= '0;
      prdata   <= '0;
    end
    else if (pready_i) begin
      psel     <= psel_nxt;
      penable  <= penable_nxt;
      paddr    <= paddr_nxt;
      pwrite   <= pwrite_nxt;
      pwdata   <= pwdata_nxt;
      prdata   <= (!pwrite && penable) ? prdata_i : '0;
    end
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) pr_state <= IDLE;
    else pr_state <= nx_state;
  end   
  
  always_comb begin
      nx_state = pr_state;
          
    case (pr_state) 
      IDLE : begin
              if (Cnt == '0) begin
                nx_state = GREEN;
                ld_Cnt = '1;
              end
              Out = "RED"; // keep RED till cnt becomes zero 
            end
      SETUP : begin
             if (Cnt == '0) begin
               nx_state = YELLOW;
               ld_Cnt = '1;
             end
             Out = "GREEN"; // keep GREEN till cnt becomes zero 
           end
      ACCESS : begin
              if (Cnt == '0) begin
                nx_state = RED;
                ld_Cnt = '1;
              end
              Out = "YELLOW"; // keep YELLOW till cnt becomes zero 
           end
      endcase
  end
endmodule
