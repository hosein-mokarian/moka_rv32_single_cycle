module moka_rv32i_sc_internal_bind
#(
    parameter DATA_WIDTH = 32
)
(
    input logic [DATA_WIDTH - 1 : 0] pc_next,
    input logic [DATA_WIDTH - 1 : 0] pc,
    input logic [DATA_WIDTH - 1 : 0] PCPlus4,
    input logic [DATA_WIDTH - 1 : 0] PCTarget,

    // instruction
    input logic [DATA_WIDTH - 1 : 0] instr_mem_adr,
    input logic [DATA_WIDTH - 1 : 0] instruction,
    input logic [6 : 0] op,
    input logic [2 : 0] funct3,
    input logic funct7,
    input logic [DATA_WIDTH - 1 : 0] immediate,
    input logic [DATA_WIDTH - 1 : 0] ImmExt,
    input logic [4 : 0] rs1,
    input logic [4 : 0] rs2,
    input logic [4 : 0] rd,

    // register file
    input logic [DATA_WIDTH - 1 : 0] RD1,
    input logic [DATA_WIDTH - 1 : 0] RD2,
    input logic [DATA_WIDTH - 1 : 0] WD3,

    // ALU
    input logic [DATA_WIDTH - 1 : 0] ALUResult,
    input logic [DATA_WIDTH - 1 : 0] SrcB,
    input logic zero,

    // data memory
    input logic [DATA_WIDTH - 1 : 0] ReadData,
    
    // control signals
    input logic RegWrite,
    input logic [1 : 0] ImmSrc,
    input logic ALUSrc,
    input logic [3 : 0] ALUControl,
    input logic MemWrite,
    input logic [1: 0] ResultSrc,
    input logic PCSrc
);
    
endmodule