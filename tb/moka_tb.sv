`timescale 1ns/1ps


module moka_tb;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import moka_test_pkg::*;

  localparam DATA_WIDTH = 8;

  bit clk = 0;
  always #5 clk = ~clk;

  moka_rv32i_sc_if vif(clk);

  moka_top #(
    .DATA_WIDTH(DATA_WIDTH)
  )
  dut (
    .rstn(vif.rstn),
    .en(vif.en),
    .clk(clk),
    .flash_data(vif.wr_data),
    .flash_memory(vif.mem_we)
  );

  initial begin
    uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", vif);
    run_test("fifo_test");
  end

  initial begin
    vif.rstn = 0;
    vif.en = 0;
    vif.address = 32'b0;
    vif.wr_data = 32'hFFFFFFFF;
    vif.mem_we = 1;
    #20 vif.rstn = 1;
    #10 vif.en = 1;
  end

  initial begin
    #50000;
    $finish;
  end

//  initial begin
//    $dumpfile("fifo_tb.vcd");
//    $dumpvars(0, fifo_tb);
//  end
  
endmodule