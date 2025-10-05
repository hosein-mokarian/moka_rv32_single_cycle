package moka_internal_tx_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

class moka_rv32i_sc_internal_tx #(DATA_WIDTH = 32) extends uvm_sequence_item;
    // pc
    logic [DATA_WIDTH - 1 : 0] pc_next;
    logic [DATA_WIDTH - 1 : 0] pc;
    logic [DATA_WIDTH - 1 : 0] PCPlus4;
    logic [DATA_WIDTH - 1 : 0] PCTarget;

    // instruction
    logic [DATA_WIDTH - 1 : 0] instr_mem_adr;
    logic [DATA_WIDTH - 1 : 0] instruction;
    logic [6 : 0] op;
    logic [2 : 0] funct3;
    logic funct7;
    logic [DATA_WIDTH - 1 : 0] immediate;
    logic [DATA_WIDTH - 1 : 0] ImmExt;
    logic [4 : 0] rs1;
    logic [4 : 0] rs2;
    logic [4 : 0] rd;

    // register file
    logic [DATA_WIDTH - 1 : 0] RD1;
    logic [DATA_WIDTH - 1 : 0] RD2;
    logic [DATA_WIDTH - 1 : 0] WD3;

    // ALU
    logic [DATA_WIDTH - 1 : 0] ALUResult;
    logic [DATA_WIDTH - 1 : 0] SrcB;
    logic zero;

    // data memory
    logic [DATA_WIDTH - 1 : 0] ReadData;
    
    // control signals
    logic RegWrite;
    logic [2 : 0] ImmSrc;
    logic ALUSrc;
    logic [3 : 0] ALUControl;
    logic MemWrite;
    logic [1: 0] ResultSrc;
    logic PCSrc;

    `uvm_object_utils_begin(moka_rv32i_sc_internal_tx)
        `uvm_field_int(pc_next, UVM_ALL_ON)
        `uvm_field_int(pc, UVM_ALL_ON)
        `uvm_field_int(PCPlus4, UVM_ALL_ON)
        `uvm_field_int(PCTarget, UVM_ALL_ON)

        // instruction
        `uvm_field_int(instr_mem_adr, UVM_ALL_ON)
        `uvm_field_int(instruction, UVM_ALL_ON)
        `uvm_field_int(op, UVM_ALL_ON)
        `uvm_field_int(funct3, UVM_ALL_ON)
        `uvm_field_int(funct7, UVM_ALL_ON)
        `uvm_field_int(immediate, UVM_ALL_ON)
        `uvm_field_int(ImmExt, UVM_ALL_ON)
        `uvm_field_int(rs1, UVM_ALL_ON)
        `uvm_field_int(rs2, UVM_ALL_ON)
        `uvm_field_int(rd, UVM_ALL_ON)

        // register file
        `uvm_field_int(RD1, UVM_ALL_ON)
        `uvm_field_int(RD2, UVM_ALL_ON)
        `uvm_field_int(WD3, UVM_ALL_ON)

        // ALU
        `uvm_field_int(ALUResult, UVM_ALL_ON)
        `uvm_field_int(SrcB, UVM_ALL_ON)
        `uvm_field_int(zero, UVM_ALL_ON)

        // data memory
        `uvm_field_int(ReadData, UVM_ALL_ON)
        
        // control signals
        `uvm_field_int(RegWrite, UVM_ALL_ON)
        `uvm_field_int(ImmSrc, UVM_ALL_ON)
        `uvm_field_int(ALUSrc, UVM_ALL_ON)
        `uvm_field_int(ALUControl, UVM_ALL_ON)
        `uvm_field_int(MemWrite, UVM_ALL_ON)
        `uvm_field_int(ResultSrc, UVM_ALL_ON)
        `uvm_field_int(PCSrc, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "moka_rv32i_sc_internal_tx");
        super.new(name);
    endfunction
endclass

endpackage