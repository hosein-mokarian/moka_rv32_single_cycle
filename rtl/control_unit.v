module control_unit
  #(parameter DATA_WIDTH = 32)
  (
    input rstn,
    input en,
    input clk,
    input [6 : 0] op,
    input [2 : 0] funct3,
    input funct7,
    input zero,
    output reg RegWrite,
    output reg [2 : 0] ImmSrc,
    output reg ALUSrc,
    output reg [3 : 0] ALUControl,
    output reg MemWrite,
    output reg [1: 0] ResultSrc,
    output PCSrc
  );

  
  localparam JAL = 7'b1101111;
  localparam JALR = 7'b1100111;
  localparam BEQ = 7'b1100011;
  localparam BNE = 7'b1100011;
  localparam BLT = 7'b1100011;
  localparam BGE = 7'b1100011;
  localparam BLTU = 7'b1100011;
  localparam BGEU = 7'b1100011;
  localparam LB = 7'b0000011;
  localparam LH = 7'b0000011;
  localparam LW = 7'b0000011;
  localparam LBU = 7'b0000011;
  localparam LHU = 7'b0000011;
  localparam SB = 7'b0100011;
  localparam SH = 7'b0100011;
  localparam SW = 7'b0100011;
  localparam ADDI = 7'b0010011;
  localparam SLTI = 7'b0010011;
  localparam SLTIU = 7'b0010011;
  localparam XORI = 7'b0010011;
  localparam ORI = 7'b0010011;
  localparam ANDI = 7'b0010011;
  localparam SLLI = 7'b0010011;
  localparam SRLI = 7'b0010011;
  localparam SRAI = 7'b0010011;
  localparam ADD = 7'b0110011;
  localparam SUB = 7'b0110011;
  localparam SLL = 7'b0110011;
  localparam SLT = 7'b0110011;
  localparam SLTU = 7'b0110011;
  localparam XOR = 7'b0110011;
  localparam SRL = 7'b0110011;
  localparam SRA = 7'b0110011;
  localparam OR = 7'b0110011;
  localparam AND = 7'b0110011;
  localparam FENCE = 7'b0001111;
  localparam FENCE_TCO = 7'b0001111;
  localparam PUASE = 7'b0001111;
  localparam ECALL = 7'b1110011;
  localparam EBREAK = 7'b1110011;

  localparam LUI = 7'b0110111;

  localparam B_TYPE = 7'b1100011;
  localparam LOAD = 7'b0000011;
  localparam STORE = 7'b0100011;
  localparam I_TYPE = 7'b0010011;
  localparam R_TYPE = 7'b0110011;
  
  localparam OP_ADD = 4'b0000;
  localparam OP_SUB = 4'b0001;
  localparam OP_SLL = 4'b0010;
  localparam OP_SLT = 4'b0011;
  localparam OP_SLTU = 4'b0100;
  localparam OP_XOR = 4'b0101;
  localparam OP_SRL = 4'b0110;
  localparam OP_SRA = 4'b0111;
  localparam OP_OR  = 4'b1000;
  localparam OP_AND = 4'b1001;
  localparam OP_LUI = 4'b1010;


  reg Branch;
  reg Jump;

  reg [3 : 0] ALUOp;
  wire op_5;
  wire [2 : 0] func3_2_0;
  wire funct7_5;

  // assign ALUOp = (rstn && en) ? op[2 : 0] : 3'b000;
  assign op_5 = (rstn && en) ? op[5] : 1'b0;
  assign func3_2_0 = (rstn && en) ? funct3 : 3'b000;
  assign funct7_5 = (rstn && en) ? funct7 : 1'b0;


  // Main Decoder
  always @(*)
  begin
    if (!rstn)
    begin
    end
    else if (rstn && en)
    begin
      case (op)
        LW: // LOAD
        begin
          RegWrite = 1;
          ImmSrc = 3'b000;
          ALUSrc = 1;
          MemWrite = 0;
          ResultSrc = 2'b01;
          Branch = 0;
          ALUOp = 4'b0000;
          Jump = 0;
        end
        SW: // STORE
        begin
          RegWrite = 0;
          ImmSrc = 3'b001;
          ALUSrc = 1;
          MemWrite = 1;
          ResultSrc = 2'bxx;
          Branch = 0;
          ALUOp = 4'b0000;
          Jump = 0;
        end
        R_TYPE:
        begin
          RegWrite = 1;
          ImmSrc = 3'bxxx;
          ALUSrc = 0;
          MemWrite = 0;
          ResultSrc = 2'b00;
          Branch = 0;
          ALUOp = 4'b0010;
          Jump = 0;
        end
        BEQ: // B_TYPE
        begin
          RegWrite = 0;
          ImmSrc = 3'b010;
          ALUSrc = 0;
          MemWrite = 0;
          ResultSrc = 2'bxx;
          Branch = 1;
          ALUOp = 4'b0001;
          Jump = 0;
        end
        ADDI: // I_TYPE
        begin
          RegWrite = 1;
          ImmSrc = 3'b000;
          ALUSrc = 1;
          MemWrite = 0;
          ResultSrc = 2'b00;
          Branch = 0;
          ALUOp = 4'b0010;
          Jump = 0;
        end
        JAL:
        begin
          RegWrite = 1;
          ImmSrc = 3'b011;
          ALUSrc = 1'bx;
          MemWrite = 0;
          ResultSrc = 2'b10;
          Branch = 0;
          ALUOp = 4'bxxxx;
          Jump = 1;
        end
        JALR:
        begin
          RegWrite = 1;
          ImmSrc = 3'b011;
          ALUSrc = 1'bx;
          MemWrite = 0;
          ResultSrc = 2'b10;
          Branch = 0;
          ALUOp = 4'bxxxx;
          Jump = 1;
        end
        LUI:
        begin
          RegWrite = 1;
          ImmSrc = 3'b100;
          ALUSrc = 1;
          MemWrite = 0;
          ResultSrc = 2'b00;
          Branch = 0;
          ALUOp = 4'b0011;
          Jump = 0;
        end
      endcase
    end
  end


  assign PCSrc = (rstn && en) ? ((Branch & zero) | Jump) : 1'b0;


  // ALU Decoder
  always @(*)
  begin
    if (!rstn)
      ALUControl = 0;
    else if (rstn && en)
    begin
      case (ALUOp)
        4'b0000: ALUControl = OP_ADD;
        4'b0001: ALUControl = OP_SUB;
        4'b0010:
        begin
          case (func3_2_0)
            3'b000:
            begin
              case ({op_5, funct7_5})
                2'b00,
                2'b01,
                2'b10:
                  ALUControl = OP_ADD;
                2'b11:
                  ALUControl = OP_SUB;
              endcase
            end
            3'b001: ALUControl = OP_SLL;
            3'b010: ALUControl = OP_SLT;
            3'b011: ALUControl = OP_SLTU;
            3'b100: ALUControl = OP_XOR;
            3'b101:
            begin
              case ({op_5, funct7_5})
                2'b10: ALUControl = OP_SRL;
                2'b11: ALUControl = OP_SRA;
              endcase
            end
            3'b110: ALUControl = OP_OR;
            3'b111: ALUControl = OP_AND;
          endcase
        end
        4'b0011: ALUControl = OP_LUI;
      endcase
    end
  end

endmodule