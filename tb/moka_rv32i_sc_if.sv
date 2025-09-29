interface moka_rv32i_sc_if(input clk);
    logic rstn;
    logic en;
    logic [31:0] address;
    logic [31:0] rd_data;
    logic [31:0] wr_data;
    logic mem_we;

    clocking driver_cb @(posedge clk);
        output address, wr_data, mem_we;
        input rstn, en, rd_data;
    endclocking

    clocking monitor_cb @(posedge clk);
        input rstn, en, address, rd_data, wr_data, mem_we;
    endclocking

    modport DRVER_PORT (clocking driver_cb, input clk);
    modport MONITOR_PORT (clocking monitor_cb, input clk);
endinterface