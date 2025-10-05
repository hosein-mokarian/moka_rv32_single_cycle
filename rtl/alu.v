module alu
  #(parameter DATA_WIDTH = 32)
  (
    input rstn,
    input en,
    input signed [DATA_WIDTH - 1 : 0] srca,
    input signed [DATA_WIDTH - 1 : 0] srcb,
    input [3 : 0] control,
    output zero,
    output reg signed [DATA_WIDTH - 1 : 0] y
  );


  localparam OP_ADD = 4'b0000;
  localparam OP_SUB = 4'b0001;
  localparam OP_SLL = 4'b0010;
  localparam OP_SLT = 4'b0011;
  localparam OP_SLTU = 4'b0100;
  localparam OP_XOR = 4'b0101;
  localparam OP_SRL = 4'b0110;
  localparam OP_SRA = 4'b0111;
  localparam OP_OR  = 4'b1000;
  localparam OP_AND = 4'b1001;
  localparam OP_LUI = 4'b1010;


  always @(*)
  begin
    if (!rstn)
    begin
      y = 0;
    end
    else if (rstn && en)
    begin
      case (control)
        OP_ADD: y = srca + srcb;
        OP_SUB: y = srca - srcb;
        OP_SLL: y = srca << srcb;
        OP_SLT: y = (srca < srcb) ? {{(DATA_WIDTH - 1){1'b0}}, 1'b1} : {DATA_WIDTH{1'b0}};
        OP_SLTU: y = (srca < srcb) ? {{(DATA_WIDTH - 1){1'b0}}, 1'b1} : {DATA_WIDTH{1'b0}};
        OP_XOR: y = srca ^ srcb;
        OP_SRL: y = srca >> srcb;
        OP_SRA: y = srca >>> srcb; // {srca[DATA_WIDTH - 1], srca[DATA_WIDTH - 2 : 0] >> srcb};
        OP_OR : y = srca | srcb;
        OP_AND: y = srca & srcb;
        OP_LUI: y = srcb << 12;
      endcase
    end
  end

  assign zero = (y == {DATA_WIDTH{1'b0}}) ? 1 : 0;

endmodule