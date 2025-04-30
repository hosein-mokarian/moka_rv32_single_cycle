run_simulation:
	clear
	iverilog -o singlecycle_tb.vvp stimulus.v moka.v
	vvp singlecycle_tb.vvp
	gtkwave singlecycle_results.vcd