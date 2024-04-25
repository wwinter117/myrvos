#include "os.h"

void start_kernel(void)
{
	uart_init();
	uart_puts("Hello, RVOS!\n");

	page_init();

	trap_init();

    plic_init();

	sched_init();

	os_main();

	schedule();

	uart_puts("Would not go here!\n");
	while (1) {}; // stop here!
}

