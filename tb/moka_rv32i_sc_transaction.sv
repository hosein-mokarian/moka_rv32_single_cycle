package moka_rv32i_sc_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

class moka_rv32i_sc_transaction extends uvm_sequence_item;
    rand bit rstn;
    rand bit en;

    constraint valid_ops {
        rstn dist {1 := 50, 0 := 50};
        en dist {1 := 50, 0 := 50};
    }

    `uvm_object_utils_begin(moka_rv32i_sc_transaction)
        `uvm_field_int(rstn, UVM_ALL_ON)
        `uvm_field_int(en, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "moka_rv32i_sc_transaction");
        super.new(name);
    endfunction
endclass

// `include "moka_rv32i_sc_driver.sv"
// `include "moka_rv32i_sc_monitor.sv"

endpackage
