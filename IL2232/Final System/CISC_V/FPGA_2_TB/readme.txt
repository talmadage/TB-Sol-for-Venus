
The TB consists of one ROM, one RAM, one seven-segment display module and the main testbench control/driver module. 
The IMEM is preloaded with coremark.mif, and the seven-segment display shows the processor instruction fetch count. 
Timing and pin constraints are defined in testbench_fpga.sdc and testbench_fpga.qsf. 
The current TB uses an Avalon interface and can be used directly for on-board testing of the RISC-V core. 
TODO: implement an Avalon ↔ bs-interface conversion module to replace the dtekv_top DUT inside dtekv_top_tb_top.
