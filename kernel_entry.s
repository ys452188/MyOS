//内核入口(aarch64格式)
.section .text
.global _start
_start:
    bl kmain       // 调用C函数
1:  b 1b           // 无限循环