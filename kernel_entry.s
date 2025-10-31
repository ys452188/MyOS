/* start.S —— 最小 AArch64 启动汇编
 * 功能：
 * 1. 设置堆栈指针 SP
 * 2. 清除 .bss 段
 * 3. 调用 C 入口函数 boot_c_main()
 * 4. 若返回，则进入死循环等待
 * 本文件采用 GNU 汇编语法，适用于 clang / gcc 编译。
 */

    .section .text
    .global _start
    .type _start, %function

_start:
    /* 从链接脚本中获取栈顶地址符号 _stack_top */
    adr     x0, _stack_top   //取 _stack_top 的地址（相对地址）
    ldr     x0, [x0]         //从内存中读取栈顶的实际数值
    mov     sp, x0              // 设置栈指针 SP

    /* 清空 BSS 段（_sbss ~ _ebss）*/
    adr     x1, _sbss           // x1 = BSS 段起始地址
    adr     x2, _ebss           //x2 = BSS 段结束地址
1:  cmp     x1, x2              // 比较 x1 是否到达 x2
    b.ge    2f                  //若到达结束地址则跳出循环
    mov     w3, #0
    str     w3, [x1], #4        //将 0 写入内存，并使 x1 += 4
    b       1b                  // 继续循环
2:
    /* 调用 C 语言入口函数 kmain() */
    bl      kmain

/* 如果 C 函数返回，则进入死循环，等待中断 */
hang:
    wfi      //WFI等待中断（节能）
    b       hang
    
    .size _start, .-_start
    