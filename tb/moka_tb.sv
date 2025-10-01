`timescale 1ns/1ps


module moka_tb;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import moka_test_pkg::*;

  localparam DATA_WIDTH = 32;

  bit clk = 0;
  always #5 clk = ~clk;

  moka_rv32i_sc_if vif(clk);
  moka_rv32i_sc_internal_if#(.DATA_WIDTH(DATA_WIDTH)) internal_vif(clk);

  moka_top #(
    .DATA_WIDTH(DATA_WIDTH)
  )
  dut (
    .rstn(vif.rstn),
    .en(vif.en),
    .clk(clk),
    .instr_mem_address(vif.address),
    .instr_mem_data(vif.wr_data),
    .instr_mem_we(vif.mem_we)
  );

  bind moka_top moka_rv32i_sc_internal_bind internal_monitor (
    .pc_next(pc_next),
    .pc(pc),
    .PCPlus4(PCPlus4),
    .PCTarget(PCTarget),

    // instruction
    .instr_mem_adr(instr_mem_adr),
    .instruction(instruction),
    .op(op),
    .funct3(funct3),
    .funct7(funct7),
    .immediate(immediate),
    .ImmExt(ImmExt),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),

    // register file
    .RD1(RD1),
    .RD2(RD2),
    .WD3(WD3),

    // ALU
    .ALUResult(ALUResult),
    .SrcB(SrcB),
    .zero(zero),

    // data memory
    .ReadData(ReadData),
    
    // control signals
    .RegWrite(RegWrite),
    .ImmSrc(ImmSrc),
    .ALUSrc(ALUSrc),
    .ALUControl(ALUControl),
    .MemWrite(MemWrite),
    .ResultSrc(ResultSrc),
    .PCSrc(PCSrc)
  );

  assign internal_vif.pc_next = dut.internal_monitor.pc_next;
  assign internal_vif.pc = dut.internal_monitor.pc;
  assign internal_vif.PCPlus4 = dut.internal_monitor.PCPlus4;
  assign internal_vif.PCTarget = dut.internal_monitor.PCTarget;

  // instruction
  assign internal_vif.instr_mem_adr = dut.internal_monitor.instr_mem_adr;
  assign internal_vif.instruction = dut.internal_monitor.instruction;
  assign internal_vif.op = dut.internal_monitor.op;
  assign internal_vif.funct3 = dut.internal_monitor.funct3;
  assign internal_vif.funct7 = dut.internal_monitor.funct7;
  assign internal_vif.immediate = dut.internal_monitor.immediate;
  assign internal_vif.ImmExt = dut.internal_monitor.ImmExt;
  assign internal_vif.rs1 = dut.internal_monitor.rs1;
  assign internal_vif.rs2 = dut.internal_monitor.rs2;
  assign internal_vif.rd = dut.internal_monitor.rd;

  // register file
  assign internal_vif.RD1 = dut.internal_monitor.RD1;
  assign internal_vif.RD2 = dut.internal_monitor.RD2;
  assign internal_vif.WD3 = dut.internal_monitor.WD3;

  // ALU
  assign internal_vif.ALUResult = dut.internal_monitor.ALUResult;
  assign internal_vif.SrcB = dut.internal_monitor.SrcB;
  assign internal_vif.zero = dut.internal_monitor.zero;

  // data memory
  assign internal_vif.ReadData = dut.internal_monitor.ReadData;
  
  // control signals
  assign internal_vif.RegWrite = dut.internal_monitor.RegWrite;
  assign internal_vif.ImmSrc = dut.internal_monitor.ImmSrc;
  assign internal_vif.ALUSrc = dut.internal_monitor.ALUSrc;
  assign internal_vif.ALUControl = dut.internal_monitor.ALUControl;
  assign internal_vif.MemWrite = dut.internal_monitor.MemWrite;
  assign internal_vif.ResultSrc = dut.internal_monitor.ResultSrc;
  assign internal_vif.PCSrc = dut.internal_monitor.PCSrc;

  initial begin
    uvm_config_db#(virtual moka_rv32i_sc_if)::set(null, "*", "vif", vif);
    uvm_config_db#(virtual moka_rv32i_sc_internal_if#(.DATA_WIDTH(DATA_WIDTH)))::set(null, "*", "internal_vif", internal_vif);
    run_test("moka_rv32i_sc_test");
  end

  initial begin
    vif.rstn = 0;
    vif.en = 0;
    vif.address = 32'b0;
    vif.wr_data = 32'hFFFFFFFF;
    vif.mem_we = 1;
    #20 vif.rstn = 1;
    // #10 vif.en = 1;
  end

  initial begin
    #50000;
    $finish;
  end

//  initial begin
//    $dumpfile("moka_rv32i_sc_tb.vcd");
//    $dumpvars(0, moka_rv32i_sc_tb);
//  end
  
endmodule