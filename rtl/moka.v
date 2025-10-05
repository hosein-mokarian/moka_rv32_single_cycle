`include "program_counter.v"
`include "adder.v"
`include "instruction_memory.v"
`include "register_file.v"
`include "extended.v"
`include "mux.v"
// `include "alu_decoder.v"
`include "alu.v"
`include "data_memory.v"
`include "mux3.v"
`include "control_unit.v"


module moka_top
  #(parameter DATA_WIDTH = 32)
  (
    input rstn,
    input en,
    input clk,
    input [DATA_WIDTH - 1 : 0] instr_mem_address,
    input [DATA_WIDTH - 1 : 0] instr_mem_data,
    input instr_mem_we
  );


  parameter INST_MEM_CAPACITY = 1024;
  parameter DATA_MEM_CAPACITY = 10 * 1024;
  parameter NB_OF_REGS = 32;
  parameter ADDRESS_BIT_WIDTH = 5;

  // PC
  wire [DATA_WIDTH - 1 : 0] pc_next;
  wire [DATA_WIDTH - 1 : 0] pc;
  wire [DATA_WIDTH - 1 : 0] PCPlus4;
  wire [DATA_WIDTH - 1 : 0] PCTarget;

  // instruction
  wire [DATA_WIDTH - 1 : 0] instr_mem_adr;
  wire [DATA_WIDTH - 1 : 0] instruction;
  wire [6 : 0] op;
  wire [2 : 0] funct3;
  wire funct7;
  wire [DATA_WIDTH - 1 : 0] immediate;
  wire [DATA_WIDTH - 1 : 0] ImmExt;
  wire [4 : 0] rs1;
  wire [4 : 0] rs2;
  wire [4 : 0] rd;

  // register file
  wire [DATA_WIDTH - 1 : 0] RD1;
  wire [DATA_WIDTH - 1 : 0] RD2;
  wire [DATA_WIDTH - 1 : 0] WD3;

  // ALU
  wire [DATA_WIDTH - 1 : 0] ALUResult;
  wire [DATA_WIDTH - 1 : 0] SrcB;
  wire zero;

  // data memory
  wire [DATA_WIDTH - 1 : 0] ReadData;
  
  // control signals
  wire RegWrite;
  wire [2 : 0] ImmSrc;
  wire ALUSrc;
  wire [3 : 0] ALUControl;
  wire MemWrite;
  wire [1: 0] ResultSrc;
  wire PCSrc;


  mux2
  #(.DATA_WIDTH(DATA_WIDTH))
  MUX2_PC
  (
    .rstn(rstn),
    .en(en),
    .sel(PCSrc),
    .a(PCPlus4),
    .b(PCTarget),
    .y(pc_next)
  );


  program_counter
  #(.DATA_WIDTH(DATA_WIDTH))
  PC
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .pc_next(pc_next),
    .pc(pc)
  );


  adder
  #(.DATA_WIDTH(DATA_WIDTH))
  ADDER_1
  (
    .rstn(rstn),
    .en(en),
    .a(pc),
    .b('d1), // + 4 // todo
    .y(PCPlus4)
  );

  adder
  #(.DATA_WIDTH(DATA_WIDTH))
  ADDER_2
  (
    .rstn(rstn),
    .en(en),
    .a(pc),
    .b(ImmExt),
    .y(PCTarget)
  );

  mux2
  #(.DATA_WIDTH(DATA_WIDTH))
  MUX2_A_INS_MEM
  (
    .rstn(rstn),
    .en(1),
    .sel(instr_mem_we),
    .a(pc),
    .b(instr_mem_address),
    .y(instr_mem_adr)
  );


  instruction_memory
  #(.DATA_WIDTH(DATA_WIDTH),
    .MEM_CAPACITY(INST_MEM_CAPACITY))
  ins_mem
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .A(instr_mem_adr), // pc
    .WD(instr_mem_data),
    .WE(instr_mem_we),
    .read_data(instruction)
  );


  assign op = (rstn && en) ? instruction[6 : 0] : 7'b0;
  assign funct3 = (rstn && en) ? instruction[14 : 12] : 3'b0;
  assign funct7 = (rstn && en) ? instruction[30] : 1'b0;
  
  assign rs1 = (rstn && en) ? instruction[19 : 15] : 5'b00000;
  assign rs2 = (rstn && en) ? instruction[24 : 20] : 5'b00000;
  assign rd = (rstn && en) ? instruction[11 : 7] : 5'b00000;


  register_file
  #(.DATA_WIDTH(DATA_WIDTH),
    .NB_OF_REGS(NB_OF_REGS),
    .ADDRESS_BIT_WIDTH(ADDRESS_BIT_WIDTH))
  REG_FILE
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .A1(rs1),
    .A2(rs2),
    .A3(rd),
    .WD3(WD3),
    .WE3(RegWrite),
    .RD1(RD1),
    .RD2(RD2)
  );


  assign immediate = (rstn && en) ? {instruction[31 : 7], 7'b0} : {DATA_WIDTH{1'b0}};


  extended
  #(.DATA_WIDTH(DATA_WIDTH))
  EXT
  (
    .rstn(rstn),
    .en(en),
    .xin(immediate),
    .ImmSrc(ImmSrc),
    .y(ImmExt)
  );


  mux2
  #(.DATA_WIDTH(DATA_WIDTH))
  MUX2_srcb
  (
    .rstn(rstn),
    .en(en),
    .sel(ALUSrc),
    .a(RD2),
    .b(ImmExt),
    .y(SrcB)
  );


  // alu_decoder
  // #(.DATA_WIDTH(DATA_WIDTH))
  // (
  //   .rstn(rstn),
  //   .en(en),
  //   .ALUOp(ALUOp),
  //   .op_5(instruction[5]),
  //   .func3_2_0(instruction[14 : 12]), // todo
  //   .funct7_5(instruction[30]) // todo
  //   .ALUControl(ALUControl)
  // );


  alu
  #(.DATA_WIDTH(DATA_WIDTH))
  ALU
  (
    .rstn(rstn),
    .en(en),
    .srca(RD1),
    .srcb(SrcB),
    .control(ALUControl),
    .zero(zero),
    .y(ALUResult)
  );


  data_memory
  #(.DATA_WIDTH(DATA_WIDTH),
    .MEM_CAPACITY(DATA_MEM_CAPACITY))
  DATA_MEMORY
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .A(ALUResult),
    .WD(RD2),
    .WE(MemWrite),
    .RD(ReadData)
  );


  mux3
  #(.DATA_WIDTH(DATA_WIDTH))
  MUX2_Result
  (
    .rstn(rstn),
    .en(en),
    .sel(ResultSrc),
    .a(ALUResult),
    .b(ReadData),
    .c(PCPlus4),
    .y(WD3)
  );


  control_unit
  #(.DATA_WIDTH(DATA_WIDTH))
  CU
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .op(op),
    .funct3(funct3),
    .funct7(funct7),
    .zero(zero),
    .RegWrite(RegWrite),
    .ImmSrc(ImmSrc),
    .ALUSrc(ALUSrc),
    .ALUControl(ALUControl),
    .MemWrite(MemWrite),
    .ResultSrc(ResultSrc),
    .PCSrc(PCSrc)
  );

endmodule