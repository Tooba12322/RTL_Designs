// Design a fifo which has different data widths on the read and the write interface. 
// The write interface can send 4-bits per cycle whereas the read interface expects 32-bits per cycle.
// Along with the asymmetrical data widths the fifo should also support the ability for the read interface to issue a flush request. 
// This is needed whenever the write interface doesn't have the complete 32-bits of data but the read interface wants to read from fifo and thus can issue a flush.
// During a flush request the fifo should send all of the data written prior and on the cycle the flush request was seen. 
// Once all of the data is read the flush can be marked as completed. 
// Fifo should support the ability to write new data while the flush request is being serviced. 
// The fifo must be sized such that it is able to store 128-bits of data exactly.

// Interface Definition
// The interface to the fifo consists of the following ports:

// fifo_wr_valid_i -> Input to the module which signals that write data is valid
// fifo_wr_data_i -> The 4-bit write data input
// fifo_data_avail_o -> Output flag which tells that a read can be issued
// fifo_rd_valid_i -> Input to the module which signals 32-bit data is read
// fifo_rd_data_o -> 32-bit read data associated given as output
// fifo_flush_i -> Fifo flush input to the module
// fifo_flush_done_o -> Output signal which marks the flush as complete
// fifo_empty_o -> Fifo empty flag (fifo has no valid data)
// fifo_full_o -> Fifo full flag

// Interface Requirements
// The interface guarantees that the write request will never be seen whenever fifo has 128-bits of data
// The interface guarantees that the fifo_rd_valid_i will only be asserted if the fifo_data_avail_o signal is high.
// The fifo_rd_data_o should be sent on the same cycle as when the fifo_rd_valid_i is seen
// The interface guarantees that the flush request would only be asserted if the fifo isn’t empty
// The fifo_flush_i signal would remain asserted until the fifo_flush_done_o output is seen
// In case fifo has partial data (data less than 32-bits) during a flush request, 
// the specifications allow the fifo data to be padded with 0xC to form the complete 32-bits worth of data
// The data written on the same cycle as when the flush request was asserted should also be flushed before the fifo_flush_done_o signal is asserted. 
// This implies that the flush data should only consist of the data already stored in the fifo and the data written (if any) on the same cycle as the flush request was asserted.
// The fifo should allow any new data to be written into the fifo while the flush is being serviced. 
// The new data written one cycle after the flush request should not be given out as part of the flush request
// All the flops (if any) should be positive edge triggered with asynchronous resets

module fifo_flush (
  input   logic         clk,
  input   logic         reset,

  input   logic         fifo_wr_valid_i,
  input   logic [3:0]   fifo_wr_data_i,

  output  logic         fifo_data_avail_o,
  input   logic         fifo_rd_valid_i,
  output  logic [31:0]  fifo_rd_data_o,

  input   logic         fifo_flush_i,
  output  logic         fifo_flush_done_o,

  output  logic         fifo_empty_o,
  output  logic         fifo_full_o
);

  

endmodule
