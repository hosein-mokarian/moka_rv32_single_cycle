interface moka_rv32i_sc_internal_if
#(parameter DATA_WIDTH = 32)
(input clk);
    // pc
    logic [DATA_WIDTH - 1 : 0] pc_next;
    logic [DATA_WIDTH - 1 : 0] pc;
    logic [DATA_WIDTH - 1 : 0] PCPlus4;
    logic [DATA_WIDTH - 1 : 0] PCTarget;

    // instruction
    logic [DATA_WIDTH - 1 : 0] instr_mem_adr;
    logic [DATA_WIDTH - 1 : 0] instruction;
    logic [6 : 0] op;
    logic [2 : 0] funct3;
    logic funct7;
    logic [DATA_WIDTH - 1 : 0] immediate;
    logic [DATA_WIDTH - 1 : 0] ImmExt;
    logic [4 : 0] rs1;
    logic [4 : 0] rs2;
    logic [4 : 0] rd;

    // register file
    logic [DATA_WIDTH - 1 : 0] RD1;
    logic [DATA_WIDTH - 1 : 0] RD2;
    logic [DATA_WIDTH - 1 : 0] WD3;

    // ALU
    logic [DATA_WIDTH - 1 : 0] ALUResult;
    logic [DATA_WIDTH - 1 : 0] SrcB;
    logic zero;

    // data memory
    logic [DATA_WIDTH - 1 : 0] ReadData;
    
    // control signals
    logic RegWrite;
    logic [1 : 0] ImmSrc;
    logic ALUSrc;
    logic [3 : 0] ALUControl;
    logic MemWrite;
    logic [1: 0] ResultSrc;
    logic PCSrc;
endinterface