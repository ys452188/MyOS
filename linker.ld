/* linker.ld —— AArch64 最小内核链接脚本
 * 功能：
 *   1. 指定程序入口 _start
 *   2. 定义各段的加载地址
 *   3. 提供 _sbss、_ebss、_stack_top 等符号
 */

ENTRY(_start)
OUTPUT_ARCH(aarch64)

SECTIONS
{
  /*代码加载起始地址（根据平台修改）
  - 0x80000树莓派或简单裸机示例
  - 0x40080000QEMU virt 常用
  */
  . = 0x40080000;

  .text : {
    *(.text*)
    *(.rodata*)
    _etext = .;
  }
  .data : {
    *(.data*)
    _edata = .;
  }
  /*BSS段不包含在镜像中*/
  .bss (NOLOAD) : {
    _sbss = .;
    *(.bss*)
    *(COMMON)
    _ebss = .;
  }

  /* 栈区，定义 _stack_top 符号并写入一个实际地址值 */
  .stack_top : {
    PROVIDE(_stack_top = (_ebss + 0x4000));  /* 栈大小约 16KB */
    LONG(_stack_top)
  }
  /* 丢弃不必要的段 */
  /DISCARD/ : { *(.note*) *(.comment*) }
}
