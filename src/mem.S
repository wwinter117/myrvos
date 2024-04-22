.section .rodata
.global HEAP_START
HEAP_START: .word heap_start

.global HEAP_SIZE
HEAP_SIZE: .word heap_size

.global TEXT_START
TEXT_START: .word text_start

.global TEXT_END
TEXT_END: .word text_end

.global DATA_START
DATA_START: .word data_start

.global DATA_END
DATA_END: .word data_end

.global RODATA_START
RODATA_START: .word rodata_start

.global RODATA_END
RODATA_END: .word rodata_end

.global BSS_START
BSS_START: .word bss_start

.global BSS_END
BSS_END: .word bss_end
