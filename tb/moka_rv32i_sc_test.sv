package moka_test_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_env_pkg::*;
import moka_seq_pkg::*;
// import momoka_coverage_pkg::*;

class moka_rv32i_sc_test extends uvm_test;
    moka_rv32i_sc_env env;
    // moka_rv32i_sc_coverage coverage;

    `uvm_object_utils(moka_rv32i_sc_test)

    function new(string name = "moka_rv32i_sc_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        env = moka_rv32i_sc_env::type_id::create("env", this);
        coverage = moka_rv32i_sc_coverage::type_id::create("coverage", this);
    endfunction

    task run_phase(uvm_phase phase);
        moka_rv32i_sc_sequence seq;

        `uvm_info("TEST", "Run phase entered", UVM_LOW)

        phase.raise_objection(this);
        seq = moka_rv32i_sc_sequence::type_id::create("seq", this);
        seq.start(env.agent.sequencer);
        phase.drop_objection(this);

        `uvm_info("TEST", $sformatf("Final coverage: %0.2f%%", coverage.get_coverage()), UVM_LOW)
    endtask
endclass

endpackage