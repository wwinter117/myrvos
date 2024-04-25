#include "os.h"

#define INTERRUPT 1 << 31

extern void trap_vector(void);

void trap_init()
{
	/*
	 * set the trap-vector base-address for machine-mode
	 */
	w_mtvec((reg_t)trap_vector);
}

void external_interrupt_handler(){
    int irq = plic_claim();

    if (irq == UART0_IRQ){
        uart_isr();
    } else if (irq) {
        printf("unexpected interrupt irq = %d\n", irq);
    }

    if (irq) {
        plic_complete(irq);
    }
}

reg_t trap_handler(reg_t epc, reg_t cause)
{

    reg_t return_pc = epc;
    reg_t cause_code = cause & 0xfff;

    if (cause & 0x80000000) {
        /* Asynchronous trap - interrupt */
        switch (cause_code) {
            case 1:
                uart_puts("Supervisor software interruption!\n");
                break;
            case 3:
                uart_puts("Machine software interruption!\n");
                break;
            case 5:
                uart_puts("Supervisor timer interruption\n");
                break;
            case 7:
                uart_puts("Machine timer interruption!\n");
                break;
            case 9:
                uart_puts("Supervisor external interruption!\n");
                break;
            case 11:
                uart_puts("Machine external interruption!\n");
                external_interrupt_handler();
                break;
            default:
                uart_puts("unknown async exception!\n");
                break;
        }
    } else {
        /* Asynchronous trap - exception */
        switch (cause_code) {
            case 0:
                uart_puts("Instruction address misaligned!\n");
                break;
            case 1:
                uart_puts("Instruction access fault!\n");
                break;
            case 2:
                uart_puts("Illegal instruction!\n");
                break;
            case 3:
                uart_puts("Breakpoint!\n");
                break;
            case 4:
                uart_puts("Load address misaligned!\n");
                break;
            case 5:
                uart_puts("Load access fault!\n");
                break;
            case 6:
                uart_puts("Store address misaligned!\n");
                break;
            case 7:
                uart_puts("Store access fault!\n");
                break;
            case 8:
                uart_puts("Environment call from U-mode!\n");
                break;
            case 9:
                uart_puts("Environment call from S-mode!\n");
                break;
            case 11:
                uart_puts("Environment call from M-mode!\n");
                break;
            case 12:
                uart_puts("Instruction page fault!\n");
                break;
            case 13:
                uart_puts("Load page fault!\n");
                break;
            case 15:
                uart_puts("Store page fault\n");
//                return_pc += 4;
                break;
        }
        /* Synchronous trap - exception */
//		printf("Sync exceptions!, code = %d\n", cause_code);
//		panic("OOPS! What can I do!");
//		return_pc += 4;
    }
    return return_pc;
}

void trap_test()
{
	/*
	 * Synchronous exception code = 7
	 * Store/AMO access fault
	 */
	*(int *)0x00000000 = 100;
	/*
	 * Synchronous exception code = 5
	 * Load access fault
	 */
	//int a = *(int *)0x00000000;

	uart_puts("Yeah! I'm return back from trap!\n");
}

