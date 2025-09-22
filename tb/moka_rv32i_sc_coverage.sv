package moka_coverage_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_rv32i_sc_pkg::*;

class moka_rv32i_sc_coverage extends uvm_subscriber#(moka_rv32i_sc_transaction);
    `uvm_component_utils(moka_rv32i_sc_coverage)

    moka_rv32i_sc_transaction cov_trans;

    covergroup moka_rv32i_sc_cg;
        cp_rstn: coverpoint cov_trans.rstn {
            bins one = {1};
            bins zero = {1};
        }
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

endclass

endpackage