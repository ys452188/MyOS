//串口输出
#define UART0 0x101f1000
static volatile unsigned int * const UART0DR = (unsigned int *)UART0;
void urt0_log(const char *s) {
    while (*s) {
        *UART0DR = (unsigned int)(*s++);
    }
}
//内核的入口函数
void kmain(void) {
	urt0_log("Hello, MyOS!");
    //如果不加这一行，函数结束后 CPU 会继续执行内存中未知的指令，很快崩溃或重启。  
    while (1); // 死循环防止退出
}
