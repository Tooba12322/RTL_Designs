
// APB Master

// TB should drive a cmd_i input decoded as:
//  - 2'b00 - No-op
//  - 2'b01 - Read from address 0xDEAD_CAFE
//  - 2'b10 - Increment the previously read data and store it to 0xDEAD_CAFF
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
    else if (pready_i && pr_state!=SETUP) cmd <= cmd_i;
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) penable  <= '1;
    else penable  <= penable_nxt;
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      psel     <= '0;
      paddr    <= '0;
      pwrite   <= '1;
      pwdata   <= '0;
      prdata   <= '0;
      pr_state <= '0;
    end
    else if (pready_i) begin
      pr_state <= nx_state;
      psel     <= psel_nxt;
      paddr    <= paddr_nxt;
      pwrite   <= pwrite_nxt;
      pwdata   <= pwdata_nxt;
      if (!pwrite && penable && prdata!=prdata_i) prdata <=  prdata_i;
    end
  end
  
  always_comb begin
      nx_state    = pr_state;
      psel_nxt    = psel;
      penable_nxt = penable;
      paddr_nxt   = paddr;
      pwrite_nxt  = pwrite;
      pwdata_nxt  = pwdata;
          
    case (pr_state) 
      IDLE : begin
               if (cmd_i == 2'b10 || cmd_i == 2'b01) begin
                 nx_state = SETUP;
               end  
            end
      
      SETUP : begin
                psel_nxt    = '1;
                penable_nxt = (penable == 1 && pready_i) ? '0 : '1; //penable to be low during setup phase only;
                pwrite_nxt  = (cmd == 2'b10) ? '1 : '0;
                pwdata_nxt  = (pwrite_nxt == '1) ? prdata_i + 32'd1 : '0;  
                nx_state    = ACCESS;
                paddr_nxt   =  32'hDEAD_CAFE + (pwrite_nxt == '1);
              end
             
      ACCESS : begin
                 penable_nxt = '1;
                 if (pready_i) begin
                   if (cmd_i != cmd) nx_state = SETUP; 
                   else begin
                     nx_state = IDLE;
                     psel_nxt    ='0;
                   end
                 end
               end
      endcase
  end
endmodule
