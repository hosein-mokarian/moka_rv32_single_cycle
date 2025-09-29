package moka_coverage_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_rv32i_sc_pkg::*;
import moka_rv32i_sc_instr_pkg::*;

class moka_rv32i_sc_coverage extends uvm_subscriber#(moka_rv32i_sc_transaction);
    `uvm_component_utils(moka_rv32i_sc_coverage)

    moka_rv32i_sc_transaction cov_trans;

    covergroup moka_rv32i_sc_cg;
        cp_opcode: coverpoint get_opcode(cov_trans.rd_data) {
            bins arithmetic[] = {[ADD, SUB, ADDI]};
            bins memory[]     = {[LB, LH, LW, LBU, LHU, SB, SH, SW]};
            bins branch[]     = {[BEQ, BNE, BLT, BGE, BLTU, BGEU]};
            bins jump[]       = {[LUI, AUIPC, JAL, JALR]};
        }

        cp_register_file: coverpoint get_rd(cov_trans.dat) {
            bins zero = { 0 };
            bins non_zero = {[1:31]};
        }

        opcode_x_register_file: cross cp_opcode, cp_register_file;
    endgroup

    function new(string name = "moka_rv32i_sc_coverage", uvm_component parent = null);
        super.new(name, parent);
        moka_rv32i_sc_cg = new();
    endfunction

    function void write(moka_rv32i_sc_transaction t);
        cov_trans = t;
        moka_rv32i_sc_cg.sample();
        `uvm_info("COV", $sformatf("Sampled %s: data=0x%0h", t.en ? "one" : "zero", t.rstn), UVM_LOW)
    endfunction

    function rv32i_opcode_e get_opcode(int data);
        return data[6:0];
    endfunction

    function logic [4:0] get_opcode(int data);
        return data[11:7];
    endfunction

    function real get_coverage();
        return moka_rv32i_sc_cg.get_coverage();
    endfunction

endclass

endpackage