ENTRY(_start)

SECTIONS {
    . = 0x00010000;      /* 加载地址 */
    .text : { *(.text*) }
    .data : { *(.data*) }
    .bss : { *(.bss*) }
}
