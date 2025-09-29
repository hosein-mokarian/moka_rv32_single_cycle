package moka_rv32i_sc_instr_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

typedef enum { 
    LUI, AUIPC, JAL, JALR, 
    BEQ, BNE, BLT, BGE, BLTU, BGEU,
    LB, LH, LW, LBU, LHU, SB, SH, SW,
    ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI,
    ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
} rv32i_opcode_e;

class moka_rv32i_sc_instr_cls;

    function logic[31:0] generate_instr(
        rv32i_opcode_e opcode,
        logic [4:0] rd, 
        logic [4:0] rs1, logic [4:0] rs2,
        logic [11:0] imm
    );
        case (opcode)
            LUI:    return {imm, rd, 7'b0110111};
            AUIPC:  return {imm, rd, 7'b0010111};
            JAL:    return {{12{imm[11]}}, imm[11:0], rd, 7'b1101111};
            JALR:   return {imm, rs1, 3'b000, rd, 7'b1100111};
            
            BEQ:    return {{imm[11], imm[4:0], imm[10:5]}, rs2, rs1, 3'b000, {imm[11], imm[4:0]}, 7'b1100011};
            BNE:    return {{imm[11], imm[4:0], imm[10:5]}, rs2, rs1, 3'b001, {imm[11], imm[4:0]}, 7'b1100011};
            
            LW:     return {imm, rs1, 3'b010, rd, 7'b0000011};
            SW:     return {imm[11:5], rs2, rs1, 3'b010, imm[4:0], 7'b0100011};
            
            ADDI:   return {imm, rs1, 3'b000, rd, 7'b0010011};
            ADD:    return {7'b0000000, rs2, rs1, 3'b000, rd, 7'b0110011};
            SUB:    return {7'b0100000, rs2, rs1, 3'b000, rd, 7'b0110011};
            
            default: return 32'h00000013; // NOP (ADDI x0, x0, 0)
        endcase
    endfunction

endclass

endpackage