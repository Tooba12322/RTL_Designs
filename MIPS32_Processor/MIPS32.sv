// MIPS32 processor design

module MIPS32 (clk1,clk2,rst);
  input logic clk1,clk2,rst;
  
  logic halted, branched, cond;// Flops
  
  logic [31:0] Reg [31:0]; // Reg bank
  logic [31:0] I_Mem [511:0];// Instruction Memory
  logic [31:0] D_Mem [511:0];// Data Memory
  
  //General Purpose Registers
  logic [31:0] IR_1,PC,NPC_1,Imm,A,B_1,ALUOUT_1,LMD;
  logic [31:0] IR_2,NPC_2,B_2,ALUOUT_2;
  logic [31:0] IR_3,NPC_3,B_3,ALUOUT_3;
  
  logic [2:0] inst_type_1,inst_type_2,inst_type_3;
  
  //parameters for selecting ALU Operations
  parameter ADD   = 6'b0;
  parameter SUB   = 6'd1;
  parameter AND   = 6'd2;
  parameter OR    = 6'd3;
  parameter SLT   = 6'd4;
  parameter MUL   = 6'd5;
  parameter HLT   = 6'b1;
  parameter LW    = 6'd6;
  parameter SW    = 6'd7;
  parameter ADDI  = 6'd8;
  parameter SUBI  = 6'd9;
  parameter BEQZ  = 6'd10;
  parameter BNEQZ = 6'd11;
  
  
  //parameters for selecting instruction type
  parameter RR     = 3'b0;
  parameter RM     = 3'd1;
  parameter LOAD   = 3'd2;
  parameter STORE  = 3'd3;
  parameter BRANCH = 3'd4;
  parameter HLT    = 3'd7;
  
  //Instruction Fetch Stage
  
  always @(posedge clk_1 or negedge rst) begin
    if (!rst) begin
      NPC_1 <= '0;
      IR_1  <= '0;
      PC    <= '0;
      branched <= '0;
    end
    else if (halted == '0) begin
      if ((IR_3[31:26] == BEQZ && cond == '1) || 
          (IR_3[31:26] == BNEQZ && cond == '0)) begin
        NPC_1    <= ALUOUT_1 + 32'd1;
        PC       <= ALUOUT_1 + 32'd1;
        IR_1     <= I_Mem[ALUOUT_1];
        branched <= '1;
      end
      else begin
        NPC_1 <= PC + 32'd1;
        PC    <= PC + 32'd1;
        IR_1  <= I_Mem[PC];
      end
    end
  end
  
  //ID Stage
  always @(posedge clk_2 or negedge rst) begin
    if (!rst) begin
      A           <= '0;
      B_1         <= '0;
      Imm         <= '0;
      NPC_2       <= NPC_1;
      IR_2        <= IR_1;
      inst_type_1 <= '0;
    end
    else if (halted == '0) begin
      A     <= (IR_1[25:21] == '0) ? '0 : Reg[IR_1[25:21]];
      B_1   <= (IR_1[20:16] == '0) ? '0 : Reg[IR_1[20:16]];;
      Imm   <= {16{IR_1[15]},IR_1[15:0]};
      NPC_2 <= NPC_1;
      IR_2  <= IR_1;
      
      case (IR_1[31:26])
        ADD,SUB,AND,OR,MUL,SLT : inst_type_1 <= RR;
        ADDI,SUBI              : inst_type_1 <= RM;
        BEQZ,BNEQZ             : inst_type_1 <= BRANCH;
        LW                     : inst_type_1 <= LOAD;
        SW                     : inst_type_1 <= STORE;
        HLT                    : inst_type_1 <= HLT;
      endcase
    end
  end
  
  // IE Stage 
  always @(posedge clk_1 or negedge rst) begin
    if (!rst) begin
      ALUOUT           <= '0;
      cond             <= '0;
      B_2              <= '0;
      IR_3             <= '0;
      inst_type_2      <= '0;
    end
    else if (halted == '0) begin
      branched    <= '0;
      IR_3        <= IR_2;
      inst_type_2 <= inst_type_1;
      
      case (inst_type_1)
        RR :
          case(IR_2[31:26])
            ADD : ALUOUT <= A + B_1;
            SUB : ALUOUT <= A - B_1;
            AND : ALUOUT <= A && B_1;
            OR  : ALUOUT <= A || B_1;
            MUL : ALUOUT <= A * B_1;
            SLT : ALUOUT <= A < B_1;
          endcase
        
        RM :
          case(IR_2[31:26])
            ADDI : ALUOUT <= A + Imm;
            SUBI : ALUOUT <= A - Imm;
          endcase
        
        LOAD,STORE :
          ALUOUT <= A + Imm;
          B_2    <= B1;
        
        BRANCH :
          ALUOUT <= NPC_2 + Imm;
          cond   <= (A == '0) ? '1 : '0;
        
        HLT :
          ALUOUT <= 32'bx;
        
      endcase
    end
endmodule
