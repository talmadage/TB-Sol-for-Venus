# ==================================================
# Timing Constraints for CiscV on DE0-Nano-SoC
# ==================================================

# Create base clock (50 MHz from board)
create_clock -name CLOCK_50 -period 20.000 [get_ports CLOCK_50]

# Create generated clock for 1 MHz (1000 ns period)
create_generated_clock -name clk_1mhz \
   -source [get_pins {clk_div|counter[0]}] \
   -divide_by 50 \
   [get_pins {clk_div|clk_reg}]

# Derive PLL clocks (if any)
derive_pll_clocks

# Calculate clock uncertainties
derive_clock_uncertainty

# Set input delays for GPIO inputs
set_input_delay -clock clk_1mhz -max 5.0 [get_ports {GPIO_0[0]}]
set_input_delay -clock clk_1mhz -min 0.0 [get_ports {GPIO_0[0]}]
set_input_delay -clock clk_1mhz -max 5.0 [get_ports {GPIO_0[1]}]
set_input_delay -clock clk_1mhz -min 0.0 [get_ports {GPIO_0[1]}]
set_input_delay -clock clk_1mhz -max 5.0 [get_ports {GPIO_0[2]}]
set_input_delay -clock clk_1mhz -min 0.0 [get_ports {GPIO_0[2]}]

# Set output delays for GPIO outputs
set_output_delay -clock clk_1mhz -max 5.0 [get_ports {GPIO_0[3]}]
set_output_delay -clock clk_1mhz -min 0.0 [get_ports {GPIO_0[3]}]
set_output_delay -clock clk_1mhz -max 5.0 [get_ports {GPIO_0[4]}]
set_output_delay -clock clk_1mhz -min 0.0 [get_ports {GPIO_0[4]}]
set_output_delay -clock clk_1mhz -max 5.0 [get_ports {GPIO_0[5]}]
set_output_delay -clock clk_1mhz -min 0.0 [get_ports {GPIO_0[5]}]
set_output_delay -clock clk_1mhz -max 5.0 [get_ports {GPIO_0[6]}]
set_output_delay -clock clk_1mhz -min 0.0 [get_ports {GPIO_0[6]}]
set_output_delay -clock clk_1mhz -max 5.0 [get_ports {GPIO_0[7]}]
set_output_delay -clock clk_1mhz -min 0.0 [get_ports {GPIO_0[7]}]
set_output_delay -clock clk_1mhz -max 5.0 [get_ports {GPIO_0[8]}]
set_output_delay -clock clk_1mhz -min 0.0 [get_ports {GPIO_0[8]}]
set_output_delay -clock clk_1mhz -max 5.0 [get_ports {GPIO_0[9]}]
set_output_delay -clock clk_1mhz -min 0.0 [get_ports {GPIO_0[9]}]

# Set false paths for reset
set_false_path -from [get_ports {KEY[0]}] -to [all_registers]

# LED outputs - non-critical timing
set_false_path -to [get_ports LED[*]]