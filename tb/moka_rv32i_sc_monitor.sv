package moka_mon_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_rv32i_sc_pkg::*;
import moka_internal_tx_pkg::*;

class moka_rv32i_sc_monitor extends uvm_monitor;
    virtual moka_rv32i_sc_if vif;
    virtual moka_rv32i_sc_internal_if#(.DATA_WIDTH(32)) internal_vif;
    uvm_analysis_port #(moka_rv32i_sc_transaction) ap;
    uvm_analysis_port #(moka_rv32i_sc_internal_tx) ap_internal;

    `uvm_component_utils(moka_rv32i_sc_monitor)

    function new(string name = "moka_rv32i_sc_monitor", uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);
        ap_internal = new("ap_internal", this);
    endfunction

    function void build_phase(uvm_phase phase);
        `uvm_info("MONITOR", "Build phase entered", UVM_LOW)

        super.build_phase(phase);
        if (!uvm_config_db#(virtual moka_rv32i_sc_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not set!")
        end else begin
            `uvm_info("VIF", "Virtual interface set successfully", UVM_LOW)
        end

        if (!uvm_config_db#(virtual moka_rv32i_sc_internal_if#(.DATA_WIDTH(32)))::get(this, "", "internal_vif", internal_vif)) begin
            `uvm_fatal("NOVIF", "Virtual internal interface not set!")
        end else begin
            `uvm_info("VIF", "Virtual internal interface set successfully", UVM_LOW)
        end

        `uvm_info("MONITOR", "Build phase exited", UVM_LOW)
    endfunction

    task run_phase (uvm_phase phase);
        moka_rv32i_sc_transaction tx;
        moka_rv32i_sc_internal_tx  internal_tx;

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

            internal_tx = moka_rv32i_sc_internal_tx#(.DATA_WIDTH(32))::type_id::create("internal_tx");
            // pc
            internal_tx.pc_next = internal_vif.pc_next;
            internal_tx.pc = internal_vif.pc;
            internal_tx.PCPlus4 = internal_vif.PCPlus4;
            internal_tx.PCTarget = internal_vif.PCTarget;

            // instruction
            internal_tx.instr_mem_adr = internal_vif.instr_mem_adr;
            internal_tx.instruction = internal_vif.instruction;
            internal_tx.op = internal_vif.op;
            internal_tx.funct3 = internal_vif.funct3;
            internal_tx.funct7 = internal_vif.funct7;
            internal_tx.immediate = internal_vif.immediate;
            internal_tx.ImmExt = internal_vif.ImmExt;
            internal_tx.rs1 = internal_vif.rs1;
            internal_tx.rs2 = internal_vif.rs2;
            internal_tx.rd = internal_vif.rd;

            // register file
            internal_tx.RD1 = internal_vif.RD1;
            internal_tx.RD2 = internal_vif.RD2;
            internal_tx.WD3 = internal_vif.WD3;

            // ALU
            internal_tx.ALUResult = internal_vif.ALUResult;
            internal_tx.SrcB = internal_vif.SrcB;
            internal_tx.zero = internal_vif.zero;

            // data memory
            internal_tx.ReadData = internal_vif.ReadData;
            
            // control signals
            internal_tx.RegWrite = internal_vif.RegWrite;
            internal_tx.ImmSrc = internal_vif.ImmSrc;
            internal_tx.ALUSrc = internal_vif.ALUSrc;
            internal_tx.ALUControl = internal_vif.ALUControl;
            internal_tx.MemWrite = internal_vif.MemWrite;
            internal_tx.ResultSrc = internal_vif.ResultSrc;
            internal_tx.PCSrc = internal_vif.PCSrc;

            ap_internal.write(internal_tx);
            `uvm_info("MONITOR", $sformatf("Internal transaction contents: %s", internal_tx.convert2string()), UVM_HIGH)

        end

        `uvm_info("MONITOR", "Run phase exited", UVM_LOW)
    endtask
endclass

endpackage