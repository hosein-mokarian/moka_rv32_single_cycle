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
            
            `uvm_info("MONITOR", $sformatf("Received vif: rstn=0x%01h , en=0x%01h", vif.rstn, vif.en), UVM_MEDIUM)
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

            // pc
            `uvm_info("MONITOR", $sformatf("pc=0x%08h", internal_vif.pc), UVM_LOW)
            `uvm_info("MONITOR", $sformatf("instr_mem_adr=0x%08h", internal_vif.instr_mem_adr), UVM_LOW)
            `uvm_info("MONITOR", $sformatf("instruction=0x%08h", internal_vif.instruction), UVM_LOW)

            // instruction
            `uvm_info("MONITOR", $sformatf("op=0x%08h", internal_vif.op), UVM_LOW)
            `uvm_info("MONITOR", $sformatf("funct3=0x%08h", internal_vif.funct3), UVM_LOW)
            `uvm_info("MONITOR", $sformatf("funct7=0x%08h", internal_vif.funct7), UVM_LOW)
            `uvm_info("MONITOR", $sformatf("immediate=0x%08h", internal_vif.immediate), UVM_LOW)
            `uvm_info("MONITOR", $sformatf("ImmExt=0x%08h", internal_vif.ImmExt), UVM_LOW)
            `uvm_info("MONITOR", $sformatf("rs1=0x%08h", internal_vif.rs1), UVM_LOW)
            `uvm_info("MONITOR", $sformatf("rs2=0x%08h", internal_vif.rs2), UVM_LOW)
            `uvm_info("MONITOR", $sformatf("rd=0x%08h", internal_vif.rd), UVM_LOW)

            // register file
            `uvm_info("MONITOR", $sformatf("RD1=0x%08h", internal_vif.RD1), UVM_LOW)
            `uvm_info("MONITOR", $sformatf("RD2=0x%08h", internal_vif.RD2), UVM_LOW)
            `uvm_info("MONITOR", $sformatf("WD3=0x%08h", internal_vif.WD3), UVM_LOW)

            // ALU
            `uvm_info("MONITOR", $sformatf("ALUResult=0x%08h", internal_vif.ALUResult), UVM_LOW)
            `uvm_info("MONITOR", $sformatf("SrcB=0x%08h", internal_vif.SrcB), UVM_LOW)
            `uvm_info("MONITOR", $sformatf("zero=0x%08h", internal_vif.zero), UVM_LOW)

            // data memory
            `uvm_info("MONITOR", $sformatf("ReadData=0x%08h", internal_vif.ReadData), UVM_LOW)
            
            // control signals
            `uvm_info("MONITOR", $sformatf("RegWrite=0x%08h", internal_vif.RegWrite), UVM_LOW)
            `uvm_info("MONITOR", $sformatf("ImmSrc=0x%08h", internal_vif.ImmSrc), UVM_LOW)
            `uvm_info("MONITOR", $sformatf("ALUSrc=0x%08h", internal_vif.ALUSrc), UVM_LOW)
            `uvm_info("MONITOR", $sformatf("ALUControl=0x%08h", internal_vif.ALUControl), UVM_LOW)
            `uvm_info("MONITOR", $sformatf("MemWrite=0x%08h", internal_vif.MemWrite), UVM_LOW)
            `uvm_info("MONITOR", $sformatf("ResultSrc=0x%08h", internal_vif.ResultSrc), UVM_LOW)
            `uvm_info("MONITOR", $sformatf("PCSrc=0x%08h", internal_vif.PCSrc), UVM_LOW)

            // `uvm_info("MONITOR", $sformatf("Internal transaction contents: %s", internal_tx.convert2string()), UVM_LOW)

        end

        `uvm_info("MONITOR", "Run phase exited", UVM_LOW)
    endtask
endclass

endpackage