package moka_drv_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_rv32i_sc_pkg::*;

class moka_rv32i_sc_driver extends uvm_driver #(moka_rv32i_sc_transaction);
    virtual moka_rv32i_sc_if vif;

    `uvm_component_utils(moka_rv32i_sc_driver)
    
    function new(string name = "moka_rv32i_sc_drivr", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        `uvm_info("DRIVER", "Build phase entered", UVM_LOW)

        super.build_phase(phase);

        if(!uvm_config_db#(virtual moka_rv32i_sc_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not set!")
        end else begin
            `uvm_info("VIF", "Virtual interface set successfully", UVM_LOW)
        end

        `uvm_info("DRIVER", "Build phase exited", UVM_LOW)
    endfunction

    task run_phase(uvm_phase phase);
        `uvm_info("DRIVER", "Run phase started", UVM_LOW)

        super.run_phase(phase);

        forever begin
            `uvm_info("DRIVER", "Waiting for sequence item...", UVM_HIGH)
             seq_item_port.get_next_item(req);

             `uvm_info("DRIVER", $sformatf("Received transaction: en=0x%01h", req.en), UVM_MEDIUM)
             `uvm_info("DRIVER", $sformatf("Received transaction: addr=0x%08h, data=0x%08h, we=0x%01h", req.address, req.wr_data, req.mem_we), UVM_MEDIUM)

             vif.en = req.en;
             vif.address = req.address;
             vif.wr_data = req.wr_data;
             vif.mem_we = req.mem_we;

             @(posedge vif.clk);

             seq_item_port.item_done();
        end

        `uvm_info("DRIVER", "Run phase exited", UVM_LOW)
    endtask

endclass

endpackage