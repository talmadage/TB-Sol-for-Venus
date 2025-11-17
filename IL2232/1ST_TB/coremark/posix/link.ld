ENTRY(_start)

MEMORY
{
    RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 2M
}

_estack = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS
{
    /* 放 _start 在最前面 */
    .text._start : AT(ORIGIN(RAM)) {
        KEEP(*(.text._start))
    } > RAM

    /* 其它 .text */
    .text : {
        *(.text*)
    } > RAM

    .rodata : {
        *(.rodata*)
    } > RAM

    .data : {
        _sdata = .;
        *(.data*)
        _edata = .;
    } > RAM

    .bss : {
        _sbss = .;
        *(.bss*)
        _ebss = .;
    } > RAM
    PROVIDE(_stack_top = _estack);
    PROVIDE(_heap_start = _ebss);
}
