package moka_test_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_env_pkg::*;
import moka_seq_pkg::*;

class moka_rv32i_sc_test extends uvm_test;
    moka_rv32i_sc_env env;

    `uvm_object_utils(moka_rv32i_sc_test)

    function new(string name = "moka_rv32i_sc_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        env = moka_rv32i_sc_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        moka_rv32i_sc_sequence seq;

        phase.raise_objection(this);
        seq = moka_rv32i_sc_sequence::type_id::create("seq", this);
        seq.start(env.agent.sequencer);
        phase.drop_objection(this);
    endtask
endclass

endpackage