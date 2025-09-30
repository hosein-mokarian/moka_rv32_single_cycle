package moka_mon_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_rv32i_sc_pkg::*;

class moka_rv32i_sc_monitor extends uvm_monitor;
    virtual moka_rv32i_sc_if vif;
    uvm_analysis_port #(moka_rv32i_sc_transaction) ap;

    `uvm_component_utils(moka_rv32i_sc_monitor)

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

        `uvm_info("MONITOR", "Build phase exited", UVM_LOW)
    endfunction

    task run_phase (uvm_phase phase);
        moka_rv32i_sc_transaction tx;

        `uvm_info("MONITOR", "Run phase entered", UVM_LOW)

        super.run_phase(phase);

        forever begin
            @(posedge vif.clk);
            
            `uvm_info("MONITOR", $sformatf("Received vif: addr=0x%08h, data=0x%08h, we=0x%01h", vif.address, vif.wr_data, vif.mem_we), UVM_MEDIUM)

            tx = moka_rv32i_sc_transaction::type_id::create("tx");
            tx.address = vif.address;
            tx.rd_data = vif.rd_data;
            tx.wr_data = vif.wr_data;
            tx.mem_we = vif.mem_we;

            ap.write(tx);
        end

        `uvm_info("MONITOR", "Run phase exited", UVM_LOW)
    endtask
endclass

endpackage