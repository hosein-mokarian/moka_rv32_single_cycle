package moka_seq_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_rv32i_sc_pkg::*;
import moka_rv32i_sc_instr_pkg;

class moka_rv32i_sc_sequence extends uvm_sequence;
    rand int program_length = 10;
    rand int num_trans = 20;

    constraint num_trans_c {
        program_length inside {[10:100]};
        num_trans inside {[10:30]};
    }

    `uvm_object_utils(moka_rv32i_sc_sequence)

    task body;
        moka_rv32i_sc_instr_cls instr_obj;
        logic [31:0] rand_instr;

        repeat (num_trans)
        begin
            instr_obj = moka_rv32i_sc_instr_cls::type_id::create("instr_obj");

            `uvm_info("SEQ", "Programing the instruction memory ...", UVM_LOW)
            `uvm_info("SEQ", $sformatf("program_length = %d", program_length), UVM_LOW)

            for (int i = 0; i < program_length; i++) begin
                rand_instr = generate_random_instr();
                program_instr_memory(i * 4, rand_instr);
                `uvm_info("SEQ", $sformatf("Progbar = %d", i * 100 / program_length), UVM_LOW)
            end

            `uvm_info("SEQ", "Programing the instruction memory is completed", UVM_LOW)

            `uvm_info("SEQ", "Execution the program", UVM_LOW)
            #1000;
            `uvm_info("SEQ", "The program is executrd.", UVM_LOW)

        end
    endtask

    function bit generate_random_opcode(ref rv32i_opcode_e opcode);
        int weights[instr_lib::opcode_e] = '{
            instr_lib::ADD:  30, instr_lib::ADDI: 25, instr_lib::SUB:  20,
            instr_lib::LW:   15, instr_lib::SW:   15, instr_lib::BEQ:  10,
            instr_lib::BNE:  10, instr_lib::LUI:   5, instr_lib::AUIPC: 5,
            default: 1
        };

        if ($urandom_range(100) < 70)
            opcode = instr_lib::ADD;
        else if ($urandom_range(100) < 90)
            opcode = instr_lib::ADDI;
        else
            opcode = instr_lib::opcode_e'($urandom_range(0, 35));
            
        return 1;
    endfunction

    function bit generate_random_operands(
        rv32i_opcode_e opcode,
        ref logic [4:0] rd,
        ref logic [4:0] rs1, ref logic [4:0] rs2,
        ref logic [4:0] imm
    );
        if (opcode inside {instr_lib::SW, instr_lib::SB, instr_lib::SH, 
                          instr_lib::BEQ, instr_lib::BNE, instr_lib::BLT, 
                          instr_lib::BGE, instr_lib::BLTU, instr_lib::BGEU}) begin
            rd = 0;
        end else begin
            rd = $urandom_range(1, 31);
        end
        
        rs1 = $urandom_range(0, 31);
        rs2 = $urandom_range(0, 31);
        
        case (opcode)
            instr_lib::LW, instr_lib::SW: imm = $urandom_range(0, 255) & 12'hFFC; // Aligned
            instr_lib::BEQ, instr_lib::BNE: imm = $urandom_range(-100, 100) * 4;   // Branch offset
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

        return instr_gen.generate_instr(opcode, rd, rs1, rs2, imm);
    endfunction

    function void program_instr_memory(int address, int data);
        moka_rv32i_sc_transaction tx;
        tx = moka_rv32i_sc_transaction::type_id::create("tx");

        tx.address = address;
        tx.wr_data = data;
        tx.mem_we = 1;

        start_item(tx);
        assert(tx.randomize());
        finish_item(tx);
    endfunction

endclass

endpackage
