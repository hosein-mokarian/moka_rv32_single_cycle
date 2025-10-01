package moka_seq_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_rv32i_sc_pkg::*;
import moka_rv32i_sc_instr_pkg::*;

class moka_rv32i_sc_sequence extends uvm_sequence #(moka_rv32i_sc_transaction);
    rand int program_length = 10;
    rand int num_trans = 20;
    moka_rv32i_sc_instr_cls instr_obj;

    constraint num_trans_c {
        program_length inside {[10:100]};
        num_trans inside {[10:30]};
    }

    `uvm_object_utils(moka_rv32i_sc_sequence)

    function new(string name = "moka_rv32i_sc_sequence");
        super.new(name);
    endfunction

    task body;        
        logic [31:0] rand_instr;

        `uvm_info("SEQ", "body is started", UVM_LOW)

        repeat (1) // num_trans
        begin
            instr_obj = new();

            `uvm_info("SEQ", "Programing the instruction memory ...", UVM_LOW)
            `uvm_info("SEQ", $sformatf("program_length = %d", program_length), UVM_LOW)

            // Random code generation
            for (int i = 0; i < 1; i++) begin // program_length
                rand_instr = generate_random_instr();
                program_instr_memory(i * 4, rand_instr);
                `uvm_info("SEQ", $sformatf("rand_instr = 0x%08h", rand_instr), UVM_LOW)
                `uvm_info("SEQ", $sformatf("Progbar = %d%%", (i + 1) * 100 / program_length), UVM_LOW)
            end

            // Test simple NOP instruction
            // program_instr_memory(32'h00000000, 32'h00000013);

            `uvm_info("SEQ", "Programing the instruction memory is completed", UVM_LOW)

            `uvm_info("SEQ", "Execution the program ...", UVM_LOW)
            execute_program();
            #1000;
            `uvm_info("SEQ", "The program is executrd.", UVM_LOW)

        end
    endtask

    function bit generate_random_opcode(ref rv32i_opcode_e opcode);
        int weights[rv32i_opcode_e] = '{
            ADD:  30, ADDI: 25, SUB:  20,
            LW:   15, SW:   15, BEQ:  10,
            BNE:  10, LUI:   5, AUIPC: 5,
            default: 1
        };

        if ($urandom_range(100) < 70)
            opcode = ADD;
        else if ($urandom_range(100) < 90)
            opcode = ADDI;
        else
            opcode = rv32i_opcode_e'($urandom_range(0, 35));
            
        return 1;
    endfunction

    function bit generate_random_operands(
        rv32i_opcode_e opcode,
        ref logic [4:0] rd,
        ref logic [4:0] rs1, ref logic [4:0] rs2,
        ref logic [11:0] imm
    );
        if (opcode inside {SW, SB, SH, 
                          BEQ, BNE, BLT, 
                          BGE, BLTU, BGEU}) begin
            rd = 0;
        end else begin
            rd = $urandom_range(1, 31);
        end
        
        rs1 = $urandom_range(0, 31);
        rs2 = $urandom_range(0, 31);
        
        case (opcode)
            LW, SW: imm = $urandom_range(0, 255) & 12'hFFC; // Aligned
            BEQ, BNE: imm = $urandom_range(-100, 100) * 4;   // Branch offset
            default: imm = $urandom_range(0, 4095);
        endcase
        
        return 1;
    endfunction

    function logic [31:0] generate_random_instr();
        rv32i_opcode_e opcode;
        logic [4:0] rd, rs1, rs2;
        logic [11:0] imm;

        if (!generate_random_opcode(opcode)) begin
            opcode = ADDI;
        end
        if (!generate_random_operands(opcode, rd, rs1, rs2, imm)) begin
            rd = 0;
            rs1 = 0;
            rs2 = 0;
            imm = 0;
        end

        return instr_obj.generate_instr(opcode, rd, rs1, rs2, imm);
    endfunction

    task program_instr_memory(int address, int data);
        moka_rv32i_sc_transaction tx;
        tx = moka_rv32i_sc_transaction::type_id::create("tx");

        tx.address = address;
        tx.wr_data = data;
        tx.mem_we = 1;

        start_item(tx);
        // assert(tx.randomize());
        finish_item(tx);
    endtask

    task execute_program();
        moka_rv32i_sc_transaction tx;
        tx = moka_rv32i_sc_transaction::type_id::create("tx");

        tx.en = 1;
        tx.mem_we = 0;

        start_item(tx);
        // assert(tx.randomize());
        finish_item(tx);
    endtask

endclass

endpackage
