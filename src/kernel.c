#include "../include/os.h"

/*
 * Following functions SHOULD be called ONLY ONE time here,
 * so just declared here ONCE and NOT included in file os.h.
 */
extern void uart_init(void);
extern void page_init(void);
extern void page_test(void);

void start_kernel(void)
{
	uart_init();
	uart_puts("Hello, RVOS!\n");

	page_init();
    page_test();

	while (1) {}; // stop here!
}

// 0101 0100 0000 0000   0000 0000 0000 0000    0101 0101 0000 0000   0000 0000 0000 0000
// 0101 0100
// 0101 0101