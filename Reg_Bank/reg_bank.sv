// 32x32 reg bank with two reads and one write per cycle

module reg_bank(sr1_data,sr2_data,dr_data,sr1_addr,sr2_addr,dr_addr,clk,rst);
  
  parameter reg_size = 32;
  parameter bank_size = 32;
  parameter addr = $clog2(bank_size);
  
  output logic [reg_size:0] sr1_data,sr2_data;
  input logic [reg_size:0] dr_data;
  input logic clk,rst;
  input logic [addr-1:0] sr1_addr,sr2_addr,dr_addr;
  logic [reg_size-1:0] reg_bank[bank_size-1:0];
  
  logic [reg_size:0] data1_reg,data2_reg;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      for (int i=0;i<bank_size;i++) reg_bank[i] <= '0;
    end
    else begin
      reg_bank[dr_addr] <= dr_data;//write
    end
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      data1_reg <= '0;
    end
    else begin
      data1_reg <= reg_bank[sr1_addr];//register sr1 data
    end
  end
  
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      data2_reg <= '0;
    end
    else begin
      data2_reg <= reg_bank[sr2_addr];//register sr2 data
    end
  end
  
  assign sr1_data = data1_reg;
  
  assign sr2_data = data2_reg;
  
endmodule
