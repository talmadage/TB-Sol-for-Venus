# Main 50 MHz clock
create_clock -name {main_clk} -period 20.0 [get_ports {FPGA_CLK_50}]
# I/O delays
set_input_delay  2.0 -clock [get_clocks main_clk] [all_inputs]
set_output_delay 2.0 -clock [get_clocks main_clk] [all_outputs]