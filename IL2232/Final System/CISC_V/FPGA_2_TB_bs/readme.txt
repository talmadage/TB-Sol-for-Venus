
The TB consists of one ROM, one RAM, one seven-segment display module, one bit-serial interface and the main testbench control/driver module. 
The IMEM is preloaded with coremark.mif, and the seven-segment display shows the processor instruction fetch count. 
Timing is defined in testbench_fpga.sdc. 
The current module dtekv_fpga2_top (TB+bs_interface) uses an bit-serial interface and can be used with the Cisc-V core using the top dtekv_tb_cisc_top. 
It compile on quartus but has not been implemented on FPGA because test on modelsim failed.
TODO: bs_interface doesn't works, need to change/correct the fsm
