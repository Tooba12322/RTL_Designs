// Design a block which converts certain input events to APB transactions. 
// The design takes three different inputs and generates an APB transaction to a single slave.
// Whenever any input is asserted, an APB transaction is sent to an address reserved for the particular event. 
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

module events_to_apb (
  input   logic         clk,
  input   logic         reset,

  input   logic         event_a_i,
  input   logic         event_b_i,
  input   logic         event_c_i,

  output  logic         apb_psel_o,
  output  logic         apb_penable_o,
  output  logic [31:0]  apb_paddr_o,
  output  logic         apb_pwrite_o,
  output  logic [31:0]  apb_pwdata_o,
  input   logic         apb_pready_i

);
  
  

endmodule
