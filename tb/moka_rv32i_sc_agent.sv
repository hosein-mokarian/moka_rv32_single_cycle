package moka_agent_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_rv32i_sc_pkg::*;
import moka_drv_pkg::*;
import moka_mon_pkg::*;

class moka_rv32i_sc_agent extends uvm_agent;
    moka_rv32i_sc_driver driver;
    moka_rv32i_sc_monitor monitor;
    uvm_sequencer #(moka_rv32i_sc_transaction) sequencer;

    `uvm_component_utils(moka_rv32i_sc_agent)

    function new(string name = "moka_rv32i_sc_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        `uvm_info("AGENT", "Build phase entered", UVM_LOW)

        super.build_phase(phase);
        
        driver = moka_rv32i_sc_driver::type_id::create("driver", this);
        monitor = moka_rv32i_sc_monitor::type_id::create("monitor", this);
        sequencer = uvm_sequencer#(moka_rv32i_sc_transaction)::type_id::create("sequencer", this);

        `uvm_info("AGENT", "Build phase exited", UVM_LOW)
    endfunction

    function void connect_phase(uvm_phase phase);
        `uvm_info("AGENT", "Connect phase entered", UVM_LOW)

        super.connect_phase(phase);

        driver.seq_item_port.connect(sequencer.seq_item_export);

        `uvm_info("AGENT", "Connect phase entered", UVM_LOW)
    endfunction
endclass

endpackage