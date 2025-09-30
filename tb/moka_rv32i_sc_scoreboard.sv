package moka_scb_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_rv32i_sc_pkg::*;

class moka_rv32i_sc_scoreboard extends uvm_scoreboard;
    uvm_analysis_imp #(moka_rv32i_sc_transaction, moka_rv32i_sc_scoreboard) ap_imp;

    `uvm_component_utils(moka_rv32i_sc_scoreboard)

    function new(string name = "moka_rv32i_sc_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        ap_imp = new("ap_imp", this);
    endfunction

    function void write(moka_rv32i_sc_transaction tx);
        // analysis
        `uvm_info("SCB", $sformatf("Transaction contents: %s", tx.convert2string()), UVM_HIGH)
    endfunction

endclass

endpackage