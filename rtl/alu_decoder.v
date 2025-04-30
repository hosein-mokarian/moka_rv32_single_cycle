module alu_decoder
  #(parameter DATA_WIDTH = 32)
  (
    input rstn,
    input en,
    input [2 : 0] ALUOp,
    input op_5,
    input [2 : 0] func3_2_0,
    input funct7_5,
    output [2 : 0] ALUControl
  );

  
  localparam OP_ADD = 3'b000;
  localparam OP_SUB = 3'b001;
  localparam OP_AND = 3'b010;
  localparam OP_OR  = 3'b011;


  always @(*)
  begin
    if (!rstn)
      ALUControl = 0;
    else if 
    begin
      case (ALUOp)
        3'b010:
        begin
          case (func3_2_0)
            3'b000:
            begin
              case ({op_5, funct7_5})
                2'b00:
                2'b01:
                2'b10:
                  ALUControl = OP_ADD;
                2'b11:
                  ALUControl = OP_SUB;
              endcase
            end
            3'b010: ALUControl = OP_SLT;
            3'b110: ALUControl = OR;
            3'b111: ALUControl = OP_AND;
          endcase
        end
      endcase
    end
  end

endmodule