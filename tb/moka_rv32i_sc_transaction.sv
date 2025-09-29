package moka_rv32i_sc_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

class moka_rv32i_sc_transaction extends uvm_sequence_item;
    rand logic [31 : 0] address;
	logic [31 : 0] rd_data;
    rand logic [31 : 0] wr_data;
    logic mem_we;

    constraint valid_address {
        address[1:0] == 2'b00;
    }

    `uvm_object_utils_begin(moka_rv32i_sc_transaction)
        `uvm_field_int(address, UVM_ALL_ON)
        `uvm_field_int(wr_data, UVM_ALL_ON)
        `uvm_field_int(mem_we, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "moka_rv32i_sc_transaction");
        super.new(name);
    endfunction
endclass

endpackage
