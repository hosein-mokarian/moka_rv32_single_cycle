module program_counter
  #(parameter DATA_WIDTH = 32)
  (
    input rstn,
    input en,
    input clk,
    input [DATA_WIDTH - 1 : 0] pc_next,
    output reg [DATA_WIDTH - 1 : 0] pc
  );

  always @(posedge clk or negedge rstn)
  begin
    if (!rstn)
    begin
      pc <= 0;
    end
    else if (rstn && en)
    begin
      pc <= pc_next;
    end
  end

endmodule