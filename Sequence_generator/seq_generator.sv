//Design the following sequence generator module:

//0 → 1 → 1 → 1 → 2 → 2 → 3 → 4 → 5 → 7 → 9 → 12 → 16 → 21 → 28 → 37 → ...

//Assume the sequence goes on forever until the circuit is reset. All the flops should be positive edge triggered with asynchronous resets (if any).

module seq_generator (
  input   logic        clk,
  input   logic        reset,

  output  logic [31:0] seq_o
);

  logic [31:0] reg_0, reg_1;
  
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      seq_o <= '0;
      reg_0 <= '0;
      reg_1 <= 32'd1; 
    end
    else begin
      seq_o <= reg_0 + reg_1;
      reg_0 <= reg_1;
      reg_1 <= seq_o;
    end
  end

endmodule
