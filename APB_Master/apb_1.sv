
// APB Master

// Design a block which converts certain input events to APB transactions. 
// The design takes three different inputs and generates an APB transaction to a single slave.
// Whenever any input is asserted, an APB transaction is sent to an address reserved for the particular event.with priority of event a>b>c 
// All the flops are positive edge triggered with asynchronous resets.

// Interface Definition
// The block takes three single bit inputs:
// event_a_i
// event_b_i
// event_c_i

// The output APB transaction uses the following signals:
// apb_psel_o
// apb_penable_o
// apb_paddr_o[31:0]
// apb_pwrite_o
// apb_pwdata_o[31:0]
// apb_pready_i
// The APB transaction is generated whenever any of the input event is asserted. 
// The generated APB transactions is always an APB write transaction. Hence the interface doesn't contain the apb_prdata_i input.

module apb_1 (
  
  input   logic         event_a_i,
  input   logic         event_b_i,
  input   logic         event_c_i,

  input       logic        clk,
  input       logic        rst,

  output      logic        psel_o,
  output      logic        penable_o,
  output      logic[31:0]  paddr_o,
  output      logic        pwrite_o,
  output      logic[31:0]  pwdata_o,
  input       logic        pready_i,
  
);
  
  logic        psel, psel_nxt;
  logic        penable, penable_nxt;
  logic[31:0]  paddr, paddr_nxt;
  logic        pwrite, pwrite_nxt;
  logic[31:0]  pwdata, pwdata_nxt;
    
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
    if (!rst) begin
      psel     <= '0;
      penable  <= '1;
      paddr    <= '0;
      pwrite   <= '0;
      pwdata   <= '0;
      pr_state <= '0;
    end
    else if (pready_i) begin
      pr_state <= nx_state;
      psel     <= psel_nxt;
      penable  <= penable_nxt;
      paddr    <= paddr_nxt;
      pwrite   <= pwrite_nxt;
      pwdata   <= pwdata_nxt;
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
               if (event_a_i || event_b_i || event_c_i) begin
                 nx_state = SETUP;
               end  
             end
      
      SETUP : begin
                psel_nxt    = '1;
                penable_nxt = '0;
                pwrite_nxt  = '1;
                pwdata_nxt  = 32'hDEAD_CAFE + (event_b_i == '1) - (event_c_i == '1);
                nx_state    = ACCESS;
                paddr_nxt   = (event_a_i) ? 32'h0000_1000 : (event_b_i) ? 32'h0000_2000 : 32'h0000_3000;
              end
             
      ACCESS : begin
                 penable_nxt = '1;
                 if (pready_i) begin
                   if (event_a_i || event_b_i || event_c_i) nx_state = SETUP; 
                   else begin
                     nx_state = IDLE;
                     psel_nxt    ='0;
                   end
                 end
               end
      endcase
  end
endmodule
