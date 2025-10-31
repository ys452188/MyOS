//kernel.c —— 最小 AArch64 裸机 C 入口示例
#include <stdint.h>

/* 链接脚本中定义的符号 */
extern unsigned long _stack_top;
extern unsigned long _sbss;
extern unsigned long _ebss;
/* QEMU virt 虚拟机的 UART0 外设地址（PL011 控制器）
   若在其他平台运行，请修改此基址或移除相关代码 */
#define UART0_BASE 0x09000000UL
#define UART0_FR   (*(volatile uint32_t*)(UART0_BASE + 0x18)) // 状态寄存器
#define UART0_DR   (*(volatile uint32_t*)(UART0_BASE + 0x00)) // 数据寄存器
#define UART0_FR_TXFULL (1u << 5)  // TX FIFO 满标志位

//发送单个字符到 UART0
static void uart_putc(char c);
//串口输出字符串
static void uart_puts(const char *s);
//简单延时函数（忙等
static void delay(volatile unsigned long n);

/****内核入口函数******/
void kmain(void) {
    uart_puts("你好,内核!\n");
    /* 简单循环输出信息 */
    for (int i = 0; i < 5; ++i) {
        uart_puts("fu\n");
        delay(1000000);
        uart_puts("ck\n");
        delay(1000000);
    }
    /* 进入空闲循环，执行 WFI 降功耗 */
    while (1) {
        __asm__ volatile ("wfi");
    }
    return;
}


//发送单个字符到 UART0
static void uart_putc(char c) {
    // 等待发送 FIFO 有空位
    while (UART0_FR & UART0_FR_TXFULL) { }
    UART0_DR = (uint32_t)c;
}
//串口输出字符串
static void uart_puts(const char *s) {
    while (*s) {
        if (*s == '\n') uart_putc('\r'); // 转换为 CRLF
        uart_putc(*s++);
    }
}
//简单延时函数（忙等
static void delay(volatile unsigned long n) {
    while (n--) __asm__ volatile ("nop");
}