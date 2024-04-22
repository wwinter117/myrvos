/*
 * rvos.ld
 * Linker script for outputting to RVOS
 */
OUTPUT_ARCH("riscv")

ENTRY(_start)

MEMORY
{
	ram   (wxa!ri) : ORIGIN = 0x80000000, LENGTH = 128M
}

SECTIONS
{
	.text : {
		PROVIDE(text_start = .);
		*(.text .text.*)
		PROVIDE(text_end = .);
	} >ram

	.rodata : {
		PROVIDE(rodata_start = .);
		*(.rodata .rodata.*)
		PROVIDE(rodata_end = .);
	} >ram

	.data : {
		. = ALIGN(4096);
		PROVIDE(data_start = .);
		*(.sdata .sdata.*)
		*(.data .data.*)
		PROVIDE(data_end = .);
	} >ram

	.bss :{
		PROVIDE(bss_start = .);
		*(.sbss .sbss.*)
		*(.bss .bss.*)
		*(COMMON)
		PROVIDE(bss_end = .);
	} >ram

	PROVIDE(memory_start = ORIGIN(ram));
	PROVIDE(memory_end = ORIGIN(ram) + LENGTH(ram));

	PROVIDE(heap_start = bss_end);
	PROVIDE(heap_size = memory_end - heap_start);
}
