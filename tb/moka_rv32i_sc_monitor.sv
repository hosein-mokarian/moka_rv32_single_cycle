package moka_mon_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_rv32i_sc_pkg::*;

class moka_rv32i_sc_monitor extends uvm_monitor;
    virtual moka_rv32i_sc_if vif;
    uvm_analysis_port #(moka_rv32i_sc_transaction) ap;

    `uvm_object_utils(moka_rv32i_sc_monitor)

    function new(string name = "moka_rv32i_sc_monitor", uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        `uvm_info("MONITOR", "Build phase entered", UVM_LOW)
        super.build_phase(phase);
        if (!uvm_config_db#(virtual moka_rv32i_sc_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not set!")
        end else begin
            `uvm_info("VIF", "Virtual interface set successfully", UVM_LOW)
        end
    endfunction

    task run_phase (uvm_phase phase);
        moka_rv32i_sc_transaction tx;
        `uvm_info("MON", "Monitor run_phase started", UVM_LOW)

        forever begin
            tx = moka_rv32i_sc_transaction::type_id::create("tx");
            tx.en = vif.en;
            ap.write(tx);
        end
    endtask
endclass

endpackage