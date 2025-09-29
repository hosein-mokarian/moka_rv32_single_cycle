package moka_drv_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_rv32i_sc_pkg::*;

class moka_rv32i_sc_driver extends uvm_driver #(moka_rv32i_sc_transaction);
    virtual moka_rv32i_sc_if vif;

    `uvm_object_utils(moka_rv32i_sc_driver)
    
    function new(string name = "moka_rv32i_sc_drivr", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        `uvm_info("DRIVER", "Build phase entered", UVM_LOW)
        if(!uvm_config_db#(virtual moka_rv32i_sc_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not set!")
        end else begin
            `uvm_info("VIF", "Virtual interface set successfully", UVM_LOW)
        end
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
             seq_item_port.get_next_item(req);
             vif.address = req.address;
             vif.wr_data = req.wr_data;
             vif.mem_we = req.mem_we;
             seq_item_port.item_done();
        end
    endtask

endclass

endpackage