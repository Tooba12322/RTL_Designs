
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
  input       logic        pready_i
  
);
  //next values to be flopped
  logic        psel, psel_nxt;
  logic        penable, penable_nxt;
  logic[31:0]  paddr, paddr_nxt;
  logic        pwrite, pwrite_nxt;
  logic[31:0]  pwdata, pwdata_nxt;
  
  //stae enum  
  typedef enum logic [1:0] {IDLE = 2'b00, 
    SETUP = 2'b01,
    ACCESS = 2'b10} state;
    state pr_state,nx_state;
  
  //Driving master output from flops
  always_comb psel_o    = psel;
  always_comb penable_o = penable;
  always_comb paddr_o   = paddr;
  always_comb pwrite_o  = pwrite;
  always_comb pwdata_o  = pwdata;

  //penable to be low during setup phase only
  always @(posedge clk or negedge rst) begin
    if (!rst) penable  <= '1;
    else penable  <= penable_nxt;
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      psel     <= '0;
      paddr    <= '0;
      pwrite   <= '0;
      pwdata   <= '0;
      pr_state <= '0;
    end
    else if (pready_i) begin //pready dependent driven output
      pr_state <= nx_state;
      psel     <= psel_nxt;
      paddr    <= paddr_nxt;
      pwrite   <= pwrite_nxt;
      pwdata   <= pwdata_nxt;
    end
  end
  
  always_comb begin
      nx_state    = pr_state; //default case values
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
      
      SETUP : begin //generating write transaction signals to be driven in next cycle when pready=1
                psel_nxt    = '1;
                pwrite_nxt  = '1;
                pwdata_nxt  = 32'hDEAD_CAFE + pwdata;
                nx_state    = ACCESS;
                paddr_nxt   = (event_a_i) ? 32'h1000_1000 : (event_b_i) ? 32'h2000_2000 : 32'h3000_3000;
                penable_nxt = (penable == 1 && pwdata_nxt!=pwdata && pready_i) ? '0 : '1; //penable to be low during setup phase only
              end
             
      ACCESS : begin // wdata latched by slave when pready=1, check for next event
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
