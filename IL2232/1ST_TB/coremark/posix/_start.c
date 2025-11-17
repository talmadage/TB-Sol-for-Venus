extern unsigned int _stack_top;
extern void main(void);

void _start(void) __attribute__((naked, section(".text._start")));
void _start(void)
{
    asm volatile (
        "la sp, _stack_top\n" 
    );

    extern unsigned int _sbss, _ebss;
    for (unsigned int *p = &_sbss; p < &_ebss; p++)
        *p = 0;

    main();

    for(;;);
}
