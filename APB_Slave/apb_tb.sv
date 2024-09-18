module apb (
  input         logic        clk,
  input         logic        rst,
  input         logic        psel_i,
  input         logic        penable_i,
  input         logic [3:0]  paddr_i,
  input         logic        pwrite_i,
  input         logic [31:0] pwdata_i,
  output        logic [31:0] prdata_o,
  output        logic        pready_o
);
