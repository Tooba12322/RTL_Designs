// MIPS32 processor design

module MIPS32 (clk_1,clk_2,rst);
  input logic clk_1,clk_2,rst;
  
  logic halted, branched, cond;// Flops
  
  logic [31:0] Reg [31:0]; // Reg bank
  logic [31:0] I_Mem [511:0];// Instruction Memory
  logic [31:0] D_Mem [511:0];// Data Memory
  
  //General Purpose Registers
  logic [31:0] IR_1,PC,NPC_1,Imm,A,B_1,ALUOUT_1,LMD;
  logic [31:0] IR_2,NPC_2,B_2,ALUOUT_2;
  logic [31:0] IR_3,IR_4;
  
  logic [2:0] inst_type_1,inst_type_2,inst_type_3;
  
  //parameters for selecting ALU Operations
  parameter ADD   = 6'b0;
  parameter SUB   = 6'd1;
  parameter AND   = 6'd2;
  parameter OR    = 6'd3;
  parameter SLT   = 6'd4;
  parameter MUL   = 6'd5;
  parameter HLT   = 6'b1;
  parameter LW    = 6'd8;
  parameter SW    = 6'd9;
  parameter ADDI  = 6'hA;
  parameter SUBI  = 6'hB;
  parameter SLTI  = 6'hC;
  parameter BNEQZ = 6'hD;
  parameter BEQZ  = 6'hE;
  
  
  //parameters for selecting instruction type
  parameter RR     = 3'b0;
  parameter RM     = 3'd1;
  parameter LOAD   = 3'd2;
  parameter STORE  = 3'd3;
  parameter BRANCH = 3'd4;
  parameter HALT   = 3'd5;
  
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
      NPC_2       <= '0;
      IR_2        <= '0;
      inst_type_1 <= '0;
    end
    else if (halted == '0) begin
      A     <= (IR_1[25:21] == '0) ? '0 : Reg[IR_1[25:21]];
      B_1   <= (IR_1[20:16] == '0) ? '0 : Reg[IR_1[20:16]];;
      Imm   <= {{16{IR_1[15]}},{IR_1[15:0]}};
      NPC_2 <= NPC_1;
      IR_2  <= IR_1;
      
      case (IR_1[31:26])
        ADD,SUB,AND,OR,MUL,SLT : inst_type_1 <= RR;
        ADDI,SUBI,SLTI         : inst_type_1 <= RM;
        BEQZ,BNEQZ             : inst_type_1 <= BRANCH;
        LW                     : inst_type_1 <= LOAD;
        SW                     : inst_type_1 <= STORE;
        HLT                    : inst_type_1 <= HALT;
      endcase
    end
  end
  
  // IE Stage 
  always @(posedge clk_1 or negedge rst) begin
    if (!rst) begin
      ALUOUT_1         <= '0;
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
        RR         : begin
          case(IR_2[31:26])
            ADD : ALUOUT_1 <= A + B_1;
            SUB : ALUOUT_1 <= A - B_1;
            AND : ALUOUT_1 <= A && B_1;
            OR  : ALUOUT_1 <= A || B_1;
            MUL : ALUOUT_1 <= A * B_1;
            SLT : ALUOUT_1 <= A < B_1;
          endcase
        end
        
        RM         : begin
          case(IR_2[31:26])
            ADDI : ALUOUT_1 <= A + Imm;
            SUBI : ALUOUT_1 <= A - Imm;
            SLTI : ALUOUT_1 <= A < Imm;
          endcase
        end
        
        LOAD,STORE : begin
          ALUOUT_1 <= A + Imm;
          B_2      <= B_1;
        end
        
        BRANCH     : begin
          ALUOUT_1 <= NPC_2 + Imm;
          cond   <= (A == '0) ? '1 : '0;
        end
               
      endcase
    end
  end
    
    //MEM Stage
  always @(posedge clk_2 or negedge rst) begin
      if (!rst) begin
        inst_type_3 <= '0;
        IR_4        <= '0;
        ALUOUT_2    <= '0;
        LMD         <= '0;
      end
      else if (halted == '0) begin
        inst_type_3 <= inst_type_2;
        IR_4        <= IR_3;
        
        case (inst_type_2)
          RR,RM  : ALUOUT_2 <= ALUOUT_1;
          LOAD   : LMD      <= D_Mem[ALUOUT_1];
          STORE  : if (branched == '0) D_Mem[ALUOUT_1] <= B_2;
        endcase
      end
    end
    
    
    //WB Stage
    
   always @(posedge clk_1 or negedge rst) begin
     if (!rst) begin
       halted           <= '0;
     end
     else if (branched == '0) begin
        case (inst_type_3)
          RR     : Reg[IR_4[15:11]] <= ALUOUT_2;
          RM     : Reg[IR_4[20:16]] <= ALUOUT_2;
          LOAD   : Reg[IR_4[20:16]] <= LMD;
          HALT    : halted <= '1;
        endcase
      end
    end
    
endmodule
