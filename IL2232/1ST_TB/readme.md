### Testbench in simulation for RISC-V core. 

Files added: dtekv_tb.sv, dtekv_top_tb_top.sv

Some modules in processor are modified (mainly add ports for debugging). 

#### Methodology:
Simulate the testbench in simulation tools (e.g. ModelSim), and compare the generated simulation log with the golden one. The core is verified if there are no content differences between two logs. 

#### Test Program:
We select *coremark* as our test program. The trimmed version of *coremark* could be found in the *coremark* folder under this directory. You may need a workable RISC-V toolchain and other build tools to compile it.

Build command for reference:

```
make PORT_DIR=barebones NO_LIBRT=1
```

#### TODO:

1. Add a UART controller to simulate coremark with message outputs.
2. Add a available timer to make coremark benchmark meaningful scores. (maybe optional)

