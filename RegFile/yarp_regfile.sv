// Source : https://quicksilicon.in/course/riscv/module/yarp-regfile
// --------------------------------------------------------
// RISC-V: Register File
//
// Designing the register file for YARP core.
// The register file would implement the 32 architectural
// registers, each being XLEN wide. For YARP core each of
// the register would be 32-bit wide i.e. XLEN=32
// --------------------------------------------------------

// --------------------------------------------------------
// Register File
// --------------------------------------------------------

module yarp_regfile (
  input   logic          clk,
  input   logic          reset_n,

  // Source registers
  input   logic [4:0]    rs1_addr_i,
  input   logic [4:0]    rs2_addr_i,

  // Destination register
  input   logic [4:0]    rd_addr_i,
  input   logic          wr_en_i,
  input   logic [31:0]   wr_data_i,

  // Register Data
  output  logic [31:0]   rs1_data_o,
  output  logic [31:0]   rs2_data_o
);

  // --------------------------------------------------------
  // Implement register file as an 2D array
  // Register file should:
  // - Contain the 32 architectural registers
  // - Each register should be 32-bit wide
  // - Register X0 should always return 0
  // --------------------------------------------------------
  logic [31:0] [31:0] regfile;

  
  // Write to the register file should use the `rd_addr_i`
  // signal for the register file address and the `wr_en_i`
  // signal as the enable. Remember register X0 should be
  // hardwired to 0.
  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      for (int i=0;i<32;i++) regfile[i] <= '0;
    end
    else if (wr_en_i) begin
      regfile[rd_addr_i] <= (rd_addr_i==5'h0) ? 32'h0 : wr_data_i;//write
    end
  end

  // Read data should be returned on the same cycle
  // The `rs1_addr_i` and `rs2_addr_i` are the read addresses
  // for the two source registers respectively.
  
  assign rs1_data_o = regfile[rs1_addr_i];
  assign rs2_data_o = regfile[rs2_addr_i];
  
endmodule

